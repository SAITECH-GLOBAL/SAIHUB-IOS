//
//  SHKeyStorage.m
//  Saihub
//
//  Created by macbook on 2022/2/16.
//

#import "SHKeyStorage.h"
#import "SHSocketNetworkAPI.h"
#import "SHWebSocketManager.h"
#import "SHWalletChainConfigModel.h"
#import "SHFileManage.h"
#import "SHPostAddressModel.h"
#import "SHPushListModel.h"
#import "AppDelegate.h"
#import "SHPushManager.h"
#import "SHBtcCreatOrImportWalletManage.h"

@interface SHKeyStorage () <SHSocketNetworkingResponseProtocol>

///发起订阅
@property (nonatomic,strong) SHSocketNetworkAPI *socketAPI;

///取消订阅
@property (nonatomic,strong) SHSocketNetworkAPI *cancelAPI;

@property (nonatomic, copy, readwrite) NSString *btcRate;

@property (nonatomic, copy, readwrite) NSString *usdtRate;

@end

static id _keyStorage;

@implementation SHKeyStorage

- (SHSocketNetworkAPI *)socketAPI {
    if (_socketAPI == nil) {
        _socketAPI = [[SHSocketNetworkAPI alloc]init];
        _socketAPI.ws_type = @"transferList";
        _socketAPI.identifier = @"SHKeyStorage-transferList";
    }
    return _socketAPI;
}

- (SHSocketNetworkAPI *)cancelAPI {
    if (_cancelAPI == nil) {
        _cancelAPI = [[SHSocketNetworkAPI alloc]init];
        _cancelAPI.delegate = self;
        _cancelAPI.identifier = @"SHKeyStorage-transferList-cancel";
    }
    return _cancelAPI;
}

- (RLMRealm *)realm {
    return [RLMRealm defaultRealm];
}
@dynamic isLNWallet;
- (void)setIsLNWallet:(BOOL)isLNWallet {
    if (self.isLNWallet &&!isLNWallet) {
        [SHFileManage savePreferencesData:@(isLNWallet) forKey:kIsLNWalletKey];
        [[CTMediator sharedInstance] mediator_changeHDWalletController:[SHKeyStorage shared].lnWalletVc];

    }else if (!self.isLNWallet &&isLNWallet)
    {
        [SHFileManage savePreferencesData:@(isLNWallet) forKey:kIsLNWalletKey];
        [[CTMediator sharedInstance] mediator_changeCloudWalletController:[SHKeyStorage shared].hdWalletVc];
    }
    [SHFileManage savePreferencesData:@(isLNWallet) forKey:kIsLNWalletKey];

}

- (BOOL)isLNWallet {
    return [[SHFileManage readPreferencesDataForKey:kIsLNWalletKey] boolValue];
}
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _keyStorage = [[SHKeyStorage alloc]init];
    });
    return _keyStorage;
}

- (instancetype)init {
    if (self = [super init]) {

        [RACObserve([SHWebSocketManager sharedManager], isOpen) subscribeNext:^(id _Nullable x) {
            if ([x boolValue] == YES) {
                [self reconnetSendSocket];
            }
        }];
    }
    return self;
}

- (void)initializeData {
    // 只为了初始化
}

#pragma mark--  1.0 创建单个钱包
- (void)createWalletsWithWalletModel:(SHWalletModel *)walletModel {
    
    NSArray<SHWalletChainConfigModel *> *configArray = [NSArray modelArrayWithClass:[SHWalletChainConfigModel class] json:[SHFileManage loadLocalResourceName:@"walletConfig.json"]];
    
    // 上报地址数组
    NSMutableArray *addressM = [NSMutableArray array];
    
    NSMutableArray *postArray = [NSMutableArray array];
    
    SHWalletChainConfigModel *configModel = configArray[walletModel.walletType];
    
    walletModel.isCurrent = YES;
    // 默认是第0个
    walletModel.address = walletModel.subAddressList[0].address;
    
    // 自动添加一个主币
    SHWalletTokenModel *tokenModel = [[SHWalletTokenModel alloc] init];
    tokenModel.contractAddr = configModel.tokenList[0].address;
    tokenModel.tokenFull = configModel.tokenList[0].tokenFullName;
    tokenModel.tokenShort = configModel.tokenList[0].tokenName;
    tokenModel.isPrimaryToken = YES;
    tokenModel.places = configModel.tokenList[0].places;
    tokenModel.imageData = UIImagePNGRepresentation([UIImage imageNamed:configModel.tokenList[0].tokenImageName]);
    [walletModel.tokenList insertObject:tokenModel atIndex:0];
    
    // usdt代币添加
    SHWalletTokenModel *usdtTokenModel = [[SHWalletTokenModel alloc] init];
    usdtTokenModel.contractAddr = configModel.tokenList[1].address;
    usdtTokenModel.tokenFull = configModel.tokenList[1].tokenFullName;
    usdtTokenModel.tokenShort = configModel.tokenList[1].tokenName;
    usdtTokenModel.isPrimaryToken = NO;
    usdtTokenModel.places = configModel.tokenList[1].places;
    usdtTokenModel.imageData = UIImagePNGRepresentation([UIImage imageNamed:configModel.tokenList[1].tokenImageName]);
    [walletModel.tokenList insertObject:usdtTokenModel atIndex:1];
    
    // 子地址
    for (NSInteger index = 0; index < walletModel.subAddressList.count; index ++ ) {
        SHWalletSubAddressModel *subAddressModel = [walletModel.subAddressList objectAtIndex:index];
        // 上报地址
        SHPostAddressModel *addressModel = [[SHPostAddressModel alloc] init];
        addressModel.address = subAddressModel.address;
        addressModel.coin = configModel.postCoin;
        [self addModel:addressModel];
        [addressM addObject:addressModel.address];
        [postArray addObject:addressModel];
    }
    
    // 找零地址
    for (NSInteger index = 0; index < walletModel.changeAddressList.count; index ++) {
        SHWalletSubAddressModel *subAddressModel = [walletModel.changeAddressList objectAtIndex:index];
        // 上报地址
        SHPostAddressModel *addressModel = [[SHPostAddressModel alloc] init];
        addressModel.address = subAddressModel.address;
        addressModel.coin = configModel.postCoin;
        [self addModel:addressModel];
        [addressM addObject:addressModel.address];
        [postArray addObject:addressModel];
    }
    
    walletModel.subAddressStr = [addressM componentsJoinedByString:@","];
    
    [self.realm transactionWithBlock:^{
        [self.realm addObject:walletModel];
    }];
    
    self.currentWalletModel = walletModel;
        
    // 发送订阅
    self.socketAPI.sendPara = @{
        @"ws_type" : @"transferList",
        @"coin" : configModel.subCoin,
        @"address" : [addressM componentsJoinedByString:@","],
        @"sub" : @"1"
    }.mutableCopy;
    
    self.socketAPI.handleType = SocketQuerySubscribeType;
    [[SHWebSocketManager sharedManager] querySubscribeDataWithApi:self.socketAPI];

    // 上报地址请求接口
    [[SHWalletNetManager shared] postAddressArray:postArray];
}
/// 创建单个LN钱包
- (void)createLNWalletsWithWalletModel:(SHLNWalletModel *)walletModel
{
    walletModel.isCurrent = YES;

    [self.realm transactionWithBlock:^{
        [self.realm addObject:walletModel];
    }];
    self.currentLNWalletModel = walletModel;
}
#pragma mark -- 1.1 更新操作
- (void)updateModelBlock:(void (^)(void))block {
    [self.realm transactionWithBlock:block];
}

#pragma mark -- 1.2 添加模型
- (void)addModel:(RLMObject *)model {
    [self updateModelBlock:^{
        [self.realm addObject:model];
    }];
}

#pragma mark -- 1.3 删除钱包
- (void)deleteWalletWithModel:(SHWalletModel *)model {
    
    NSArray<SHWalletChainConfigModel *> *configArray = [NSArray modelArrayWithClass:[SHWalletChainConfigModel class] json:[SHFileManage loadLocalResourceName:@"WalletChainConfig.json"]];

    SHWalletChainConfigModel *configModel = configArray[model.walletType];
    
    // 取消订阅
    self.cancelAPI.sendPara = @{
        @"ws_type" : @"transferList",
        @"coin" : configModel.subCoin,
        @"address" : model.subAddressStr,
        @"sub" : @"2"
    }.mutableCopy;
    self.cancelAPI.handleType = SocketUnsubscribeType;
    [[SHWebSocketManager sharedManager] querySubscribeDataWithApi:self.cancelAPI];

    // 删除模型
    [self updateModelBlock:^{
        [self.realm deleteObject:model];
    }];

    // 根据时间倒序排序
    RLMResults *timeResult = [[SHWalletModel allObjects] sortedResultsUsingKeyPath:@"createTimestamp" ascending:NO];

    if (timeResult.count > 0) {
        SHWalletModel *walletModel = (SHWalletModel *)timeResult.firstObject;
        self.currentWalletModel = walletModel;
    } else {
        // 当前已没有钱包
        self.currentWalletModel = nil;
    }
}
/// 删除LN钱包
- (void)deleteLNWalletWithModel:(SHLNWalletModel *)model
{
    // 删除模型
    [self updateModelBlock:^{
        [self.realm deleteObject:model];
    }];

    // 根据时间倒序排序
    RLMResults *timeResult = [[SHLNWalletModel allObjects] sortedResultsUsingKeyPath:@"createTimestamp" ascending:NO];

    if (timeResult.count > 0) {
        SHLNWalletModel *walletModel = (SHLNWalletModel *)timeResult.firstObject;
        self.currentLNWalletModel = walletModel;
    } else {
        // 当前已没有钱包
        self.currentLNWalletModel = nil;
    }
}
#pragma mark -- 1.4 查询钱包
- (NSArray<SHWalletModel *> *)queryWalletWithType:(SHWalletType)type {
    NSMutableArray *arrayM = [NSMutableArray array];
    RLMResults<SHWalletModel *> *wallets = [SHWalletModel objectsWhere:[NSString stringWithFormat:@"walletType=%zd",type]];
    for (SHWalletModel *model in wallets) {
        [arrayM addObject:model];
    }
    return arrayM;
}
#pragma mark -- 1.4.1 查询全部可转账的本地钱包
- (NSArray<SHWalletModel *> *)queryWalletCanTransfer {
    NSMutableArray *arrayM = [NSMutableArray array];
    RLMResults<SHWalletModel *> *wallets = [SHWalletModel allObjects];
    for (SHWalletModel *model in wallets) {
        if (model.importType == SHWalletImportTypeAddress||(model.importType == SHWalletImportTypePublicKey && IsEmpty(model.zpubJsonString)&&IsEmpty(model.zpubList))) {
        }else
        {
            [arrayM addObject:model];
        }
    }
    return arrayM;
}
#pragma mark -- 1.5 删除集合
- (void)removeArray:(NSArray <RLMObject *> *) array {
    [self updateModelBlock:^{
        [self.realm deleteObjects:array];
    }];
}

#pragma mark -- 1.6 判重操作
- (BOOL)checkWalletExistWithContent:(NSString *)content importType:(SHWalletImportType)importType {
    NSString *predicate = @"";
    
    if (importType == SHWalletImportTypeMnemonic) {
        predicate = [NSString stringWithFormat:@"mnemonic = '%@'", content];
    } else if (importType == SHWalletImportTypePrivateKey) {
        predicate = [NSString stringWithFormat:@"privateKey = '%@'", content];
    } else if (importType == SHWalletImportTypeAddress) {
        predicate = [NSString stringWithFormat:@"address CONTAINS[c] '%@'", content];
    } else if (importType == SHWalletImportTypePublicKey) {
        predicate = [NSString stringWithFormat:@"publicKey = '%@'",content];
    }
    
    return [SHWalletModel objectsWhere:predicate].count > 0;
}

#pragma mark -- 2.0 set & get 方法
@dynamic currentWalletModel;
- (void)setCurrentWalletModel:(SHWalletModel *)currentWalletModel {
    SHWalletModel *oldModel = [self currentWalletModel];
    if (![currentWalletModel isEqualToObject:oldModel]) { //如果钱包模型相同,则不需要更新
        [self.realm transactionWithBlock:^{
            currentWalletModel.isCurrent = YES;
            oldModel.isCurrent = NO;
        }];
    }
    [SHKeyStorage shared].isLNWallet = NO;
    [SHBtcCreatOrImportWalletManage changeBtcHdWalletWithModel:currentWalletModel];
}

- (SHWalletModel *)currentWalletModel {
    RLMResults *result = [SHWalletModel objectsWhere:@"isCurrent = true"];
    return result.firstObject; // 注意 : 当前选中,有且仅有一个
}
@dynamic currentLNWalletModel;
- (void)setCurrentLNWalletModel:(SHLNWalletModel *)currentLNWalletModel {
    SHLNWalletModel *oldModel = [self currentLNWalletModel];
    if (![currentLNWalletModel isEqualToObject:oldModel]) { //如果钱包模型相同,则不需要更新
        [self.realm transactionWithBlock:^{
            currentLNWalletModel.isCurrent = YES;
            oldModel.isCurrent = NO;
        }];
    }
    [SHKeyStorage shared].isLNWallet = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTokenKey" object:nil];

//    [SHBtcCreatOrImportWalletManage changeBtcHdWalletWithModel:currentLNWalletModel];
}

-(SHLNWalletModel *)currentLNWalletModel
{
    RLMResults *result = [SHLNWalletModel objectsWhere:@"isCurrent = true"];
    return result.firstObject; // 注意 : 当前选中,有且仅有一个
}

- (NSString *)btcRate {
    NSDictionary *dict = [SHFileManage readPreferencesDataForKey:kRateDictKey];
    if (dict == nil) {
        return @"0";
    }
    
    NSString *rateKey = [NSString stringWithFormat:@"btc%@",KAppSetting.currencyKey];
    if (![dict.allKeys containsObject:rateKey]) {
        return @"0";
    }
    
    return dict[rateKey];
}

- (NSString *)usdtRate {
    NSDictionary *dict = [SHFileManage readPreferencesDataForKey:kRateDictKey];
    if (dict == nil) {
        return @"0";
    }
    
    NSString *rateKey = [NSString stringWithFormat:@"usdt%@",KAppSetting.currencyKey];
    if (![dict.allKeys containsObject:rateKey]) {
        return @"0";
    }
    
    return dict[rateKey];
}


#pragma mark -- 3.0 断线重连socket
- (void)reconnetSendSocket {
    // BTC 地址
    NSMutableArray *btcAddressM = [NSMutableArray array];
    NSArray <SHWalletModel *> *btcArray = [self queryWalletWithType:SHWalletTypeBTC];
    [btcArray enumerateObjectsUsingBlock:^(SHWalletModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSInteger index = 0; index < obj.subAddressList.count; index ++ ) {
            SHWalletSubAddressModel *subAddressModel = [obj.subAddressList objectAtIndex:index];
            [btcAddressM addObject:subAddressModel.address];
        }
    }];
    
    self.socketAPI.sendPara = @{
        @"ws_type":@"transferList",
        @"coin" : @"BTC",
        @"address":[btcAddressM componentsJoinedByString:@","],
        @"sub":@"1"
    }.mutableCopy;
    self.socketAPI.handleType = SocketQuerySubscribeType;
    self.socketAPI.delegate = self;
    [[SHWebSocketManager sharedManager] querySubscribeDataWithApi:self.socketAPI];

}

#pragma mark -- 3.1 接收到ws数据
- (void)socketDidRecievedResponse:(id)response {
    NSDictionary *dataDict = (NSDictionary *)response[@"data"];
    if (dataDict == nil) {
        return;
    }
        
    //存储
    SHPushListModel *pushModel = [[SHPushListModel alloc]init];
    pushModel = [SHPushListModel modelWithJSON:dataDict];
    pushModel.identify = @"transferPush";
    pushModel.status = SHTransactionStatusSuccess;

    NSString *title = @"";
    NSString *content = @"";
    NSString *coin = pushModel.contractName ? pushModel.contractName : pushModel.coin;
    
    NSInteger decimal = 0;
    
    if ([dataDict[@"coin"] isEqual:@"BTC"] || [dataDict[@"coin"] isEqual:@"OMNI_USDT"]) {
        decimal = 8;
    }
    
    if ([coin isEqual:@"OMNI_USDT"]) {
        coin = @"USDT";
    }
    pushModel.coin = coin;
    
    // 默认转入
    if ([dataDict[@"type"]integerValue] == 1) { // 转入
        title = [NSString stringWithFormat:@"%@ %@ %@",coin,[NSString formStringWithValue:dataDict[@"amount"] count:decimal],GCLocalizedString(@"receive_success")];
        NSArray *addressArray = [[NSString stringWithFormat:@"%@",dataDict[@"fromAddress"]] componentsSeparatedByString:@","];
        NSArray *toAddressArray = [[NSString stringWithFormat:@"%@",dataDict[@"toAddress"]] componentsSeparatedByString:@","];
        if ([dataDict[@"coin"] isEqual:@"BTC"]) {
            content = [NSString stringWithFormat:@"%@：%@",GCLocalizedString(@"from_address"),toAddressArray[0]];
        } else {
            content = [NSString stringWithFormat:@"%@：%@",GCLocalizedString(@"to_address"),addressArray[0]];
        }
    } else if ([dataDict[@"type"] integerValue] == 2) { //转出
        title = [NSString stringWithFormat:@"%@ %@ %@",coin,[NSString formStringWithValue:dataDict[@"amount"] count:decimal],[dataDict[@"status"] integerValue] == 2 ? GCLocalizedString(@"transfer_failed") : GCLocalizedString(@"transfer_success")];
        NSArray *addressArray = [[NSString stringWithFormat:@"%@",dataDict[@"toAddress"]] componentsSeparatedByString:@","];
        NSArray *fromAddressArray = [[NSString stringWithFormat:@"%@",dataDict[@"fromAddress"]] componentsSeparatedByString:@","];
        if ([dataDict[@"coin"] isEqual:@"BTC"]) { //BTC情况
            content = [NSString stringWithFormat:@"%@：%@",GCLocalizedString(@"to_address"),fromAddressArray[0]];
        } else { //其余情况
            content = [NSString stringWithFormat:@"%@：%@",GCLocalizedString(@"from_address"),addressArray[0]];
        }
    }
    pushModel.title = title;
    pushModel.body = content;
    
    [[SHPushManager sharedSHPushManager]SHAddLocalNotificationPushWithTitle:title content:content model:pushModel];

}

@end
