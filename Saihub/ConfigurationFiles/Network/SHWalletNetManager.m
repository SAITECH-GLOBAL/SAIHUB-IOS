//
//  SHWalletNetManager.m
//  TokenOne
//
//  Created by 周松 on 2020/10/14.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHWalletNetManager.h"
#import "NetWorkTool.h"
#import "SHBaseModel.h"
#import "BTHDAccount.h"
#import "BTAddressManager.h"
#import "NSDictionary+Fromat.h"

static id _walletNetManager;

@implementation SHWalletNetManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _walletNetManager = [[SHWalletNetManager alloc]init];
    });
    return _walletNetManager;
}

#pragma mark -- 上报地址
- (void)postAddressArray:(NSArray <SHPostAddressModel *> *)array {
    NSMutableArray *arrayM = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(SHPostAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *address = obj.address;
        
        [arrayM addObject:@{@"address" : address ,@"coin" : obj.coin,@"type" : @"0"}];
    }];
    
    NSDictionary *para = @{@"json" : [arrayM jsonStringEncoded]};
    [[NetWorkTool shareNetworkTool] requestHttpWithPath:@"/rest/address/add/v2" withMethodType:Post withParams:para result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        //如果成功,删除本地存储的上报地址
        if ([responseModel.data.result isEqual:@1]) {
            [[SHKeyStorage shared] removeArray:array];
        }
    }];
}

- (NSURLSessionDataTask *)getBtcBalanceWithAddresses:(NSString *)addresses timestamp:(NSInteger)walletTimestamp result:(void (^)(NSInteger code, NSString * _Nonnull message))resultBlock {
    
    // 如果当前时间 > 本地存储的时间 不请求数据,直接使用之前缓存的数据
    if ([NSString getNowTimeTimestamp] < walletTimestamp) {
        if (resultBlock) {
            resultBlock(0 , @"");
        }
        return nil;
    }
    
    return [[NetWorkTool shareNetworkTool] requestHttpWithPath:@"/rest/asset/balance/btc" withMethodType:Get withParams:@{@"address": addresses} result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        
        if ([SHKeyStorage shared].currentWalletModel.isInvalidated == YES) {
                
            if (resultBlock) {
                resultBlock(code, message);
            }
            return;
        }
        
        [[SHKeyStorage shared] updateModelBlock:^{
            [SHKeyStorage shared].currentWalletModel.lastRequestTimestamp = [NSString getNowTimeTimestamp] + 60;
        }];

        if (code == 0) {
            NSDictionary *dict = (NSDictionary *)responseModel.data.result;
                        
            __block NSString *balance = @"0";
                        
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                RLMResults *results = [[SHKeyStorage shared].currentWalletModel.subAddressList objectsWhere:[NSString stringWithFormat:@"address = '%@'",key]];
                
                if (results.count > 0) {
                    SHWalletSubAddressModel *subAddressModel = results.firstObject;
                    
                    [[SHKeyStorage shared] updateModelBlock:^{
                        subAddressModel.balance = [NSString stringWithFormat:@"%@",obj[@"final_balance"]];
                    }];
                    
                    balance = [subAddressModel.balance to_addingWithStr:balance];
                }
                
                RLMResults *changeResult = [[SHKeyStorage shared].currentWalletModel.changeAddressList objectsWhere:[NSString stringWithFormat:@"address = '%@'",key]];
                if (changeResult.count > 0) {
                    SHWalletSubAddressModel *subAddressModel = changeResult.firstObject;
                    
                    [[SHKeyStorage shared] updateModelBlock:^{
                        subAddressModel.balance = [NSString stringWithFormat:@"%@",obj[@"final_balance"]];
                    }];
                    
                    balance = [subAddressModel.balance to_addingWithStr:balance];

                }
                
            }];
            
            if (dict.allKeys.count != 0) {
                [[SHKeyStorage shared] updateModelBlock:^{
                    [SHKeyStorage shared].currentWalletModel.tokenList.firstObject.balance = balance;
                }];
            }
            
        }
        
        if (resultBlock) {
            resultBlock(code, message);
        }
    }];
}

- (NSURLSessionDataTask *)getBtcUsdtBalanceWithAddress:(NSString *)address result:(void(^)(NSString *__nullable balance, NSInteger code, NSString *message))resultBlock {
    NSDictionary *para = @{@"address" : address,@"propertyId" : @(31)};
    return [[NetWorkTool shareNetworkTool] requestHttpWithPath:@"/rest/asset/omni/rpc/balance" withMethodType:Get withParams:para result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        
        NSString *balance = @"";
        
        NSInteger resultCode = -1;
        
        if (code == 0) {
            NSDictionary *dict = responseModel.data.result;
            if ([dict.allKeys containsObject:@"balance"]) {
                balance = dict[@"balance"];
                resultCode = 0;
            }
        }
        
        if (resultBlock) {
            
            resultBlock(balance, resultCode, message);
        }
    }];
}
#pragma mark -- 发送广播
- (void)sendBroadcastWithSignPara:(NSDictionary *)para result:(void(^)(NSString *__nullable hash, NSInteger code, NSString *message))resultBlock {
    
    [[NetWorkTool shareNetworkTool] requestHttpWithPath:@"/rest/broadcast/send/v1" withMethodType:Post withParams:para result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        if (responseModel.data.result) { //如果有值说明成功
            if (resultBlock) resultBlock (responseModel.data.result,0,@"");
        } else {
            if (resultBlock) resultBlock (@"",responseModel.data.status,responseModel.data.message);
        }
    }];
}
#pragma mark -- 获取BTC gasPrice
- (void)getGasPriceSuccess:(SuccessdBlock)success fail:(FailBlock)fail {
    NSString *type = @"2";
   
    NSMutableDictionary *dict = @{@"type" : type}.mutableCopy;
    [[NetWorkTool shareNetworkTool] requestHttpWithPath:@"/rest/asset/get/gasPrice" withMethodType:Get withParams:dict result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        if (code == 0) {
            if (success) {
                success(responseModel);
            }
        }else
        {
            if (fail) fail (code,message);
        }
    }];
}
#pragma -- mark -- 查询btc 账户下 utxo
- (void)getBtcUtxoWithArray:(NSArray <NSString *> *)addresses succes:(void(^)(id result))success fail:(FailBlock)fail {
    NSString *add = [addresses componentsJoinedByString:@","];
    NSString *url = [NSString stringWithFormat:@"%@/unspent?active=%@",@"https://blockchain.info",add];
    
    [self btcRequestHttpWithPath:url withMethodType:Get withParams:nil success:^(id responseObjc) {
        if (responseObjc) {
            if (responseObjc) {
                success(responseObjc);
            } else {
                if (fail) fail(1100,@"错误");
            }
        } else {
            if (fail) fail(1100,@"错误");
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fail) fail(errorCode,errorMessage);
    }];
}
- (NSURLSessionDataTask *)btcRequestHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(NSMutableDictionary *)params success:(void(^)(id responseObjc))successBlok fail:(void(^)(NSInteger errorCode,NSString *errorMessage))failBlock {
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    securityPolicy.validatesDomainName = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager setSecurityPolicy:securityPolicy];
    
    if (method == Get) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;
        //设置响应数据格式
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/json", @"application/json",  @"text/javascript", @"application/javascript", @"text/plain",  @"text/html", nil]];
        __block NSMutableString *url = [NSMutableString stringWithString:path];
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [url appendFormat:@"&%@", [NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        return [manager GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlok) {
                successBlok(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败 -- %@",error);
            if (failBlock) failBlock(error.code,error.localizedDescription);
        }];
    } else if (method == Post) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //响应
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;
        //设置响应数据格式
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/json", @"application/json",  @"text/javascript", @"application/javascript", @"text/plain",  @"text/html", nil]];

        return [manager POST:path parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlok) {
                successBlok([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failBlock) failBlock(error.code,error.localizedDescription);
        }];
    } else if (method == FormData) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;
        //设置响应数据格式
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/json", @"application/json",  @"text/javascript", @"application/javascript", @"text/plain",  @"text/html", nil]];
        NSArray *address = params[@"addr"];
        return [manager POST:path parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [address enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [formData appendPartWithFormData:[obj dataUsingEncoding:NSUTF8StringEncoding] name:@"addr"];
            }];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlok) {
                successBlok([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failBlock) failBlock(error.code,error.localizedDescription);
        }];
    }
    return nil;
}
///生成私钥导入btc交易对象
- (void)creatBtcPrivateKeyTransactionWithToAddress:(NSString *)toAddress FromeAddress:(NSString *)fromeAddress withValue:(uint64_t)value withOmniValue:(NSString *)omnivalue withomniId:(NSString *)omniId sat:(NSString *)sat bytes:(int64_t)bytes PrivateKey:(NSString *)privateKey isSegwit:(BOOL)segwit transactionCallBack:(void (^)(NSError * _Nonnull, BTCTransaction * _Nonnull, uint64_t))transactionCallBack {
    //预估的矿工费
    int64_t fee = [[NSString formStringWithValue:[sat to_multiplyingWithStr:[NSString stringWithFormat:@"%llu",bytes]] count:6] longLongValue];
    [[SHWalletNetManager shared]segwitQueryBtcUnspentUtxoWithAddress:fromeAddress succes:^(NSArray *array) {
        [[SHWalletNetManager shared]createTransactionFrom:fromeAddress to:toAddress amount:value fee:fee omniId:omniId omniValue:omnivalue utxos:array segwit:segwit transactionCallBack:^(NSError * _Nonnull error, BTCTransaction * _Nonnull transaction) {
            //生成交易对象 -> 获取实际需要的transaction -> 签名
            if (transaction == nil) {
                if (transactionCallBack) {
                    transactionCallBack(error,nil,0);
                }
                return;
            }
            uint64_t realBytes = 0;
            if (segwit == NO) { //普通
                realBytes = transaction.inputs.count *148 + transaction.outputs.count *34 + 10;
            } else { //隔离见证
                //原始
                uint64_t original = transaction.inputs.count *210 + transaction.outputs.count * 34 + 12;
                //剥离
                uint64_t off = original - transaction.inputs.count * 134 -2;
                //实际 向上取整
                double diff = (double)(transaction.inputs.count * 134) / 4;
                realBytes = off + ceil(diff);
            }
            //计算的矿工费
            uint64_t totalFee = [[NSString formStringWithValue:[sat to_multiplyingWithStr:[NSString stringWithFormat:@"%llu",realBytes]] count:6] longLongValue];
            [[SHWalletNetManager shared] createTransactionFrom:fromeAddress to:toAddress amount:value fee:totalFee omniId:omniId omniValue:omnivalue utxos:array segwit:segwit transactionCallBack:^(NSError * _Nonnull error, BTCTransaction * _Nonnull transaction) {
                if (transactionCallBack) {
                    transactionCallBack(error,transaction,realBytes);
                }
            }];
        }];
        
    } fail:^(NSInteger errorCode, NSString * _Nonnull errorMessage) {
        [MBProgressHUD showError:errorMessage toView:nil];
        NSError *error;
        if (transactionCallBack) {
            transactionCallBack(error,nil,0);
        }
    }];

}

///助记词生成导入btc交易对象
- (void)createBtcMnemonicTransactionWithToAddress:(NSString *)toAddress withValue:(uint64_t)value pathType:(PathType)pathType sat:(NSString *)sat bytes:(uint64_t)bytes password:(NSString *)password transactionCallBack:(void (^)(NSError * _Nonnull, BTTx * _Nonnull, uint64_t realBytes))transactionCallBack {
    NSError *error;
    int64_t fee = [[NSString formStringWithValue:[sat to_multiplyingWithStr:[NSString stringWithFormat:@"%llu",bytes]] count:6] longLongValue];
    BTHDAccount *hdAccount = [[BTHDAccount alloc] initWithSeedId:[SHKeyStorage shared].currentWalletModel.hdAccountId];
    BTTx *tx = [hdAccount newTxForVirtualTradingToAddresses:toAddress withAmount:value pathType:pathType dynamicFeeBase:fee password:password andError:&error];
    NSLog(@"旧的签名 -- %@--%lld",[NSString hexWithData:tx.toData],fee);
    if (tx == nil) {
        if (transactionCallBack) {
            transactionCallBack(error,nil,0);
        }
        return;
    }
    //生成交易对象 -> 获取实际需要的transaction -> 签名
    uint64_t realBytes = 0;
    if (pathType == EXTERNAL_ROOT_PATH) { //普通
        realBytes = tx.ins.count *148 + tx.outs.count *34 + 10;
    } else { //隔离见证
        //原始
        uint64_t original = tx.ins.count *210 + tx.outs.count * 34 + 12;
        //剥离
        uint64_t off = original - tx.ins.count * 134 -2;
        double diff = (double)(tx.ins.count * 134) / 4;
        //实际 向上取整
        realBytes = off + ceil(diff);
    }
    int64_t realTotalFee = [[NSString formStringWithValue:[sat to_multiplyingWithStr:[NSString stringWithFormat:@"%llu",realBytes]] count:6] longLongValue];
    
    //重新生成交易对象...
    NSMutableArray *addressArray = [NSMutableArray array];
    for (NSInteger countIndex = 0; countIndex < [SHKeyStorage shared].currentWalletModel.subAddressList.count; countIndex ++) {
        SHWalletSubAddressModel *subAddressModel = [[SHKeyStorage shared].currentWalletModel.subAddressList objectAtIndex:countIndex];
        [addressArray addObject:subAddressModel.address];
        if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypeMnemonic ||[SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey ) {
            SHWalletSubAddressModel *internalAddressModel = [[SHKeyStorage shared].currentWalletModel.changeAddressList objectAtIndex:countIndex];
            [addressArray addObject:internalAddressModel.address];
        }
    }
    
    BTHDAccount *realAccount = [[BTHDAccount alloc] initWithSeedId:[SHKeyStorage shared].currentWalletModel.hdAccountId];
    BTTx *realTx = [realAccount newTxToAddress:toAddress withAmount:value pathType:pathType dynamicFeeBase:realTotalFee password:password andError:&error];
    NSLog(@"新的签名 == %@ == %lld",[NSString hexWithData:realTx.toData],realTotalFee);
    if (transactionCallBack) {
        transactionCallBack(error,realTx,realBytes);
    }
}
///助记词生成导入btc bc1地址交易对象
- (void)createBtcMnemonicBc1TransactionWithToAddress:(NSString *)toAddress withValue:(uint64_t)value withOuts:(NSArray *)outs pathType:(PathType)pathType sat:(NSString *)sat bytes:(uint64_t)bytes password:(NSString *)password transactionCallBack:(void (^)(NSError * _Nonnull, BTTx * _Nonnull, uint64_t realBytes))transactionCallBack {
    NSError *error;
    int64_t fee = [[NSString formStringWithValue:[sat to_multiplyingWithStr:[NSString stringWithFormat:@"%llu",bytes]] count:6] longLongValue];
    BTHDAccount *hdAccount = [[BTHDAccount alloc] initWithSeedId:[SHKeyStorage shared].currentWalletModel.hdAccountId];
//    BTTx *tx = [hdAccount newTxForVirtualTradingToAddresses:toAddress withAmount:value pathType:pathType dynamicFeeBase:fee password:password andError:&error];
    BTTx *tx = [hdAccount newTxForVirtualTradingBc1ToAddresses:toAddress withAmount:value withOuts:outs andChangeAddress:[[SHKeyStorage shared].currentWalletModel.changeAddressList[0] address] pathType:pathType dynamicFeeBase:fee password:password andError:&error];

    NSLog(@"旧的签名 -- %@--%lld",[NSString hexWithData:tx.toData],fee);
    if (tx == nil) {
        if (transactionCallBack) {
            transactionCallBack(error,nil,0);
        }
        return;
    }
    //生成交易对象 -> 获取实际需要的transaction -> 签名
    uint64_t realBytes = 0;
    if (pathType == EXTERNAL_ROOT_PATH) { //普通
        realBytes = tx.ins.count *148 + tx.outs.count *34 + 10;
    } else { //隔离见证
        //原始
        uint64_t original = tx.ins.count *210 + tx.outs.count * 34 + 12;
        //剥离
        uint64_t off = original - tx.ins.count * 134 -2;
        double diff = (double)(tx.ins.count * 134) / 4;
        //实际 向上取整
        realBytes = off + ceil(diff);
    }
    int64_t realTotalFee = [[NSString formStringWithValue:[sat to_multiplyingWithStr:[NSString stringWithFormat:@"%llu",realBytes]] count:6] longLongValue];
    
    //重新生成交易对象...
    NSMutableArray *addressArray = [NSMutableArray array];
    for (NSInteger countIndex = 0; countIndex < [SHKeyStorage shared].currentWalletModel.subAddressList.count; countIndex ++) {
        SHWalletSubAddressModel *subAddressModel = [[SHKeyStorage shared].currentWalletModel.subAddressList objectAtIndex:countIndex];
        [addressArray addObject:subAddressModel.address];
        if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypeMnemonic ||[SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey ) {
            SHWalletSubAddressModel *internalAddressModel = [[SHKeyStorage shared].currentWalletModel.changeAddressList objectAtIndex:countIndex];
            [addressArray addObject:internalAddressModel.address];
        }
    }
    
    BTHDAccount *realAccount = [[BTHDAccount alloc] initWithSeedId:[SHKeyStorage shared].currentWalletModel.hdAccountId];
//    BTTx *realTx = [realAccount newTxToAddress:toAddress withAmount:value pathType:pathType dynamicFeeBase:realTotalFee password:password andError:&error];
    
    BTTx *realTx = [realAccount newTxForVirtualTradingBc1ToAddresses:toAddress withAmount:value withOuts:outs andChangeAddress:[[SHKeyStorage shared].currentWalletModel.changeAddressList[0] address] pathType:pathType dynamicFeeBase:realTotalFee password:password andError:&error];

    
    NSLog(@"新的签名 == %@ == %lld",[NSString hexWithData:realTx.toData],realTotalFee);
    if (transactionCallBack) {
        transactionCallBack(error,realTx,realBytes);
    }
}
#pragma mark -- 获取btcUTXOForsegwit
- (void)segwitQueryBtcUnspentUtxoWithAddress:(NSString *)address succes:(void (^)(NSArray *array))success fail:(FailBlock)fail {
    NSString *url = [NSString stringWithFormat:@"%@/addrs/%@?unspentOnly=1&includeScript=1",@"https://api.blockcypher.com/v1/btc/main",address];
    [self btcRequestHttpWithPath:url withMethodType:Get withParams:nil success:^(id responseObjc) {
        NSDictionary *dic = responseObjc;
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            NSArray *txrefs = dic[@"txrefs"];
            if (txrefs) {
                NSMutableArray *result = [NSMutableArray array];
                for (NSDictionary *item in txrefs) {
                    BTCTransactionOutput* txout = [[BTCTransactionOutput alloc] init];
                    txout.value = [item[@"value"] longLongValue];
                    txout.script = [[BTCScript alloc] initWithData:BTCDataFromHex(item[@"script"])];
                    txout.index = [item[@"tx_output_n"] intValue];
                    txout.confirmations = [item[@"confirmations"] unsignedIntegerValue];
                    txout.transactionHash = (BTCReversedData(BTCDataFromHex(item[@"tx_hash"])));
                    txout.blockHeight = [item[@"block_height"] integerValue];
                    [result addObject:txout];
                }
                if (success) success(result);

            } else {
                if (success) success(@[]);
            }
        } else {
            if (success) success(@[]);
        }
    } fail:^(NSInteger errorCode, NSString *errorMessage) {
        if (fail) fail(errorCode,errorMessage);
    }];
}
#pragma mark -- 获取btcUTXO
- (void)queryBtcUnspentUtxoWithAddress:(NSMutableArray *)array WithblockchairUtxos:(NSMutableArray *)blockchairUtxos succes:(void (^)(id _Nonnull))success fail:(FailBlock)fail {
    NSString *addressesStr = [array componentsJoinedByString:@","];
    [[NetWorkTool shareNetworkTool]requestHttpWithPath:@"/rest/asset/utxo" withMethodType:Get withParams:@{@"address" : addressesStr} result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        if (code == 0) {
            NSArray *utxoArr = responseModel.data.result;
            for (NSDictionary *utxoJson in utxoArr) {
                if (!utxoJson) {
                    continue;
                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:utxoJson[@"amount"] forKey:@"value"];
                [dic setValue:utxoJson[@"address"] forKey:@"address"];
                [dic setValue:utxoJson[@"vout"] forKey:@"index"];
                [dic setValue:utxoJson[@"txId"] forKey:@"transaction_hash"];
                [blockchairUtxos addObject:dic];
            }
            if (!IsEmpty(blockchairUtxos)) {
                [[SHWalletNetManager shared] saveBtcTransactionsWithBlockchair:blockchairUtxos succes:^(id _Nonnull result) {
                    if (success) success(result);
                }];
                return;
            }
        }else
        {
            [MBProgressHUD showError:message toView:nil];
        }
    }];
}
#pragma mark -- 获取btcUTXO
- (void)queryBtcUnspentUtxoBc1WithAddress:(NSMutableArray *)array WithblockchairUtxos:(NSMutableArray *)blockchairUtxos succes:(outsBackResponseBlock)success fail:(FailBlock)fail {
    NSString *addressesStr = [array componentsJoinedByString:@","];
    [[NetWorkTool shareNetworkTool]requestHttpWithPath:@"/rest/asset/utxo" withMethodType:Get withParams:@{@"address" : addressesStr} result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        if (code == 0) {
            NSArray *utxoArr = responseModel.data.result;
            for (NSDictionary *utxoJson in utxoArr) {
                if (!utxoJson) {
                    continue;
                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:utxoJson[@"amount"] forKey:@"value"];
                [dic setValue:utxoJson[@"address"] forKey:@"address"];
                [dic setValue:utxoJson[@"vout"] forKey:@"index"];
                [dic setValue:utxoJson[@"txId"] forKey:@"transaction_hash"];
                [blockchairUtxos addObject:dic];
            }
            if (!IsEmpty(blockchairUtxos)) {
                [[SHWalletNetManager shared] saveBtcTransactionsBc1WithBlockchair:blockchairUtxos succes:^(NSArray *outs) {
                    if (success) success(outs);
                }];
                return;
            }
        }else
        {
            [MBProgressHUD showError:message toView:nil];
        }
    }];
}
#pragma mark - 构造交易
- (void)createTransactionFrom:(NSString *)fromAddress
                           to:(NSString *)toAddress
                       amount:(BTCAmount)amount
                          fee:(BTCAmount)fee
                       omniId:(NSString *)omniId
                    omniValue:(NSString *)omniValue
                        utxos:(NSArray *)utxos
                       segwit:(BOOL)segwit
          transactionCallBack:(void(^)(NSError *error, BTCTransaction *transaction))transactionCallBack {
    NSError* error = nil;
    
    if (!utxos) {
        if (transactionCallBack) {
            transactionCallBack(error, nil);
        }
        return;
    }
    
    if (utxos.count == 0) {
        if (transactionCallBack) {
            transactionCallBack([NSError errorWithDomain:@"com.seal.BTCDemo.errorDomain" code:100 userInfo:@{NSLocalizedDescriptionKey: @"No free outputs to spend"}], nil);
        }
        return;
    }
    
    BTCAddress *from = [BTCAddress addressWithString:fromAddress];
    BTCAddress *to = [BTCAddress addressWithString:toAddress];
    
    // Find enough outputs to spend the total amount.
    BTCAmount totalAmount = amount + fee;
    if (amount < TX_MIN_OUTPUT_AMOUNT) {
        NSError*error = [NSError errorWithDomain:ERROR_DOMAIN code:ERR_TX_DUST_OUT_CODE userInfo:nil];
        if (transactionCallBack) {
            transactionCallBack(error, nil);
        }
        return;
    }
    // Sort utxo in order of
    utxos = [utxos sortedArrayUsingComparator:^(BTCTransactionOutput *obj1, BTCTransactionOutput *obj2) {
        if (obj1.value > obj2.value) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    NSMutableArray* txouts = [[NSMutableArray alloc] init];
    long total = 0;
    
    for (BTCTransactionOutput* txout in utxos) {
        [txouts addObject:txout];
        total += txout.value;
        if (total >= (totalAmount)) {
            break;
        }
    }
    
    if (total < totalAmount) {
        if (transactionCallBack) {
            transactionCallBack(error, nil);
        }
        return;
    }
    
    // Create a new transaction
    BTCTransaction *tx = [[BTCTransaction alloc] init];
    if (segwit) {
        tx.version = 2;
    }
    tx.fee = fee;
    BTCAmount spentCoins = 0;
    
    // Add all outputs as inputs
    
    for (BTCTransactionOutput *txout in txouts) {
        BTCTransactionInput *txin = [[BTCTransactionInput alloc] init];
        txin.isSegwit = segwit;
        txin.previousHash = txout.transactionHash;
        txin.previousIndex = txout.index;
        txin.signatureScript = txout.script;
//        txin.sequence = 4294967295;
        txin.value = txout.value;
        
        [tx addInput:txin];
        spentCoins += txout.value;
    }
    
    
    if (omniId != nil) {
        //构造omni交易
        BTCScript *omniScript = [[BTCScript alloc] init];
        [omniScript appendOpcode:OP_RETURN];
        long long omniAmount = [NSString numberValueString:omniValue decimal:@"8" isPositive:YES].longLongValue;
        NSString *omniHex = [NSString stringWithFormat:@"6f6d6e69%016x%016llx", [omniId intValue], omniAmount];
        [omniScript appendData:BTCDataFromHex(omniHex)];
        BTCTransactionOutput *omniOutput = [[BTCTransactionOutput alloc] initWithValue:0 script:omniScript];
        [tx addOutput:omniOutput];
    }
    
    // Add required outputs - payment and change
    BTCTransactionOutput* paymentOutput = [[BTCTransactionOutput alloc] initWithValue:amount address:to];
    [tx addOutput:paymentOutput];


    BTCTransactionOutput* changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - totalAmount) address:from];
    // Idea: deterministically-randomly choose which output goes first to improve privacy.
    if (changeOutput.value > 0) {
        [tx addOutput:changeOutput];
    }
    
    if (transactionCallBack) {
        transactionCallBack(nil, tx);
    }
}
-(void)saveBtcTransactionsWithBlockchair:(NSArray *)blockchairUtxos succes:(void (^)(id _Nonnull))success
{

    __block NSUInteger beginIndex = 0;
    __block NSUInteger endIndex = blockchairUtxos.count > 1 ? 1 : blockchairUtxos.count;
    __block uint32_t blockCount = 0;
    NSMutableArray *utxoAddresses = [NSMutableArray array];
    __block TxResponseBlock nextPageBlock = ^(NSArray *txs, uint32_t blockCount) {
        BTHDAccount *hdAccount = [[BTHDAccount alloc] initWithSeedId:[SHKeyStorage shared].currentWalletModel.hdAccountId];
        NSArray * txsArray = [[BTAddressManager instance] compressTxsForApi:txs andAddressArr:utxoAddresses];
        [hdAccount initTxs:txsArray];
        
        if (endIndex < blockchairUtxos.count) {
            beginIndex = endIndex;
            endIndex = beginIndex + 1 < blockchairUtxos.count ? beginIndex + 1 : blockchairUtxos.count;
            [[SHWalletNetManager shared]getUnspentTransactionsForBlockchair:blockchairUtxos beginIndex:beginIndex endIndex:endIndex blockCount:blockCount utxoAddresses:utxoAddresses callback:nextPageBlock];
        }else
        {
            if (success) success(GCLocalizedString(@""));
        }
    };
    [[SHWalletNetManager shared]getUnspentTransactionsForBlockchair:blockchairUtxos beginIndex:beginIndex endIndex:endIndex blockCount:blockCount utxoAddresses:utxoAddresses callback:nextPageBlock];

}
-(void)saveBtcTransactionsBc1WithBlockchair:(NSArray *)blockchairUtxos succes:(outsBackResponseBlock)success
{

    __block NSUInteger beginIndex = 0;
    __block NSUInteger endIndex = blockchairUtxos.count > 1 ? 1 : blockchairUtxos.count;
    __block uint32_t blockCount = 0;
    __block NSMutableArray *backOutArray = [NSMutableArray new];

    NSMutableArray *utxoAddresses = [NSMutableArray array];
    __block TxResponseBlock nextPageBlock = ^(NSArray *txs, uint32_t blockCount) {
        BTHDAccount *hdAccount = [[BTHDAccount alloc] initWithSeedId:[SHKeyStorage shared].currentWalletModel.hdAccountId];
        NSArray * txsArray = [[BTAddressManager instance] compressTxsForApi:txs andAddressArr:utxoAddresses];
        [hdAccount initTxs:txsArray];
        for (BTTx *tx  in txsArray) {
            [backOutArray addObjectsFromArray:tx.outs];
        }
        if (endIndex < blockchairUtxos.count) {
            beginIndex = endIndex;
            endIndex = beginIndex + 1 < blockchairUtxos.count ? beginIndex + 1 : blockchairUtxos.count;
            [[SHWalletNetManager shared]getUnspentTransactionsBc1ForBlockchair:blockchairUtxos beginIndex:beginIndex endIndex:endIndex blockCount:blockCount utxoAddresses:utxoAddresses callback:nextPageBlock];
        }else
        {
            if (success) success(backOutArray);
        }
    };
    [[SHWalletNetManager shared]getUnspentTransactionsBc1ForBlockchair:blockchairUtxos beginIndex:beginIndex endIndex:endIndex blockCount:blockCount utxoAddresses:utxoAddresses callback:nextPageBlock];

}

- (void)getUnspentTransactionsForBlockchair:(NSArray *)blockchairUtxos beginIndex:(NSUInteger)beginIndex endIndex:(NSUInteger)endIndex blockCount:(uint32_t)blockCount utxoAddresses:(NSMutableArray *)utxoAddresses callback:(TxResponseBlock)callback{
    NSMutableArray *txHashArr = [NSMutableArray array];
    NSString *txHashStr = @"";
    for (NSUInteger i = beginIndex; i < endIndex; i++) {
        NSDictionary *utxo = blockchairUtxos[i];
        if (!utxo || ![utxo.allKeys containsObject:@"transaction_hash"] || ![utxo.allKeys containsObject:@"address"]) {
            continue;
        }
        NSString *txHash = [utxo objectForKey:@"transaction_hash"];
        if (!txHash || txHash.length == 0) {
            continue;
        }
        NSString *address = [utxo objectForKey:@"address"];
        if (!address || address.length == 0) {
            continue;
        }
        if (![txHashArr containsObject:txHash]) {
            [txHashArr addObject:txHash];
            if (txHashStr.length == 0) {
                txHashStr = txHash;
            } else {
                txHashStr = [NSString stringWithFormat:@"%@,%@", txHashStr, txHash];
            }
        }
        if (![utxoAddresses containsObject:address]) {
            [utxoAddresses addObject:address];
        }
    }
    NSMutableArray *txs = [NSMutableArray new];
    if (txHashStr.length == 0) {
        if (callback) {
            callback(txs, blockCount);
            return ;
        }
    }
    //"blockchair/bitcoin/dashboards/transactions/%@"
    if (IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:txHashStr])) {
        NSString *url = [NSString stringWithFormat:@"%@/blockchair/bitcoin/dashboards/transactions/%@",@"http://bc1.bithernet.com",txHashStr];
        [self requestBtcHttpWithPath:url withMethodType:Get withParams:nil success:^(id  _Nullable responseObject) {
            NSDictionary *txsJson = responseObject[@"data"];
            if (!txsJson || txsJson.count == 0) {
                if (callback) {
                    callback(txs, blockCount);
                    return ;
                }
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:txsJson options:0 error:0];
            NSString *txsJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:txsJsonStr forKey:txHashStr];
            NSMutableArray *txs = [NSMutableArray new];
            uint32_t bcount = blockCount;
            for (NSString *txHash in txHashArr) {
                if (![txsJson.allKeys containsObject:txHash]) {
                    continue;
                }
                NSDictionary *txDic = [txsJson objectForKey:txHash];
                if (!txDic) {
                    continue;
                }
                if (![[txDic allKeys] containsObject:@"transaction"]) {
                    continue;
                }
                NSDictionary *transactionDic = [txDic objectForKey:@"transaction"];
                if (!transactionDic || transactionDic.count == 0) {
                    continue;
                }
                int height = [transactionDic getIntFromDict:@"block_id" andDefault:-1];
                if (height > blockCount) {
                    bcount = height;
                }
                BTTx *tx = [[BTTx alloc] initWithBlockchairTxDict:txDic transactionJson:transactionDic];
                [txs addObject:tx];
            }
            if (callback) {
                callback(txs, bcount);
            }
        } fail:^(NSInteger errorCode, NSString *errorMessage) {
            if (callback) {
                callback(nil,0);
            }
        }];
    }else
    {
        NSData *jsonData = [[[NSUserDefaults standardUserDefaults]objectForKey:txHashStr] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSDictionary *txsJson = dic;
        if (!txsJson || txsJson.count == 0) {
            if (callback) {
                callback(txs, blockCount);
                return ;
            }
        }
        NSMutableArray *txs = [NSMutableArray new];
        uint32_t bcount = blockCount;
        for (NSString *txHash in txHashArr) {
            if (![txsJson.allKeys containsObject:txHash]) {
                continue;
            }
            NSDictionary *txDic = [txsJson objectForKey:txHash];
            if (!txDic) {
                continue;
            }
            if (![[txDic allKeys] containsObject:@"transaction"]) {
                continue;
            }
            NSDictionary *transactionDic = [txDic objectForKey:@"transaction"];
            if (!transactionDic || transactionDic.count == 0) {
                continue;
            }
            int height = [transactionDic getIntFromDict:@"block_id" andDefault:-1];
            if (height > blockCount) {
                bcount = height;
            }
            BTTx *tx = [[BTTx alloc] initWithBlockchairTxDict:txDic transactionJson:transactionDic];
            [txs addObject:tx];
        }
        if (callback) {
            callback(txs, bcount);
        }
    }
}
- (void)getUnspentTransactionsBc1ForBlockchair:(NSArray *)blockchairUtxos beginIndex:(NSUInteger)beginIndex endIndex:(NSUInteger)endIndex blockCount:(uint32_t)blockCount utxoAddresses:(NSMutableArray *)utxoAddresses callback:(TxResponseBlock)callback{
    NSMutableArray *txHashArr = [NSMutableArray array];
    NSString *txHashStr = @"";
    for (NSUInteger i = beginIndex; i < endIndex; i++) {
        NSDictionary *utxo = blockchairUtxos[i];
        if (!utxo || ![utxo.allKeys containsObject:@"transaction_hash"] || ![utxo.allKeys containsObject:@"address"]) {
            continue;
        }
        NSString *txHash = [utxo objectForKey:@"transaction_hash"];
        if (!txHash || txHash.length == 0) {
            continue;
        }
        NSString *address = [utxo objectForKey:@"address"];
        if (!address || address.length == 0) {
            continue;
        }
        if (![txHashArr containsObject:txHash]) {
            [txHashArr addObject:txHash];
            if (txHashStr.length == 0) {
                txHashStr = txHash;
            } else {
                txHashStr = [NSString stringWithFormat:@"%@,%@", txHashStr, txHash];
            }
        }
        if (![utxoAddresses containsObject:address]) {
            [utxoAddresses addObject:address];
        }
    }
    NSMutableArray *txs = [NSMutableArray new];
    if (txHashStr.length == 0) {
        if (callback) {
            callback(txs, blockCount);
            return ;
        }
    }
    //"blockchair/bitcoin/dashboards/transactions/%@"
    if (IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:txHashStr])) {
        NSString *url = [NSString stringWithFormat:@"%@/blockchair/bitcoin/dashboards/transactions/%@",@"http://bc1.bithernet.com",txHashStr];
        [self requestBtcHttpWithPath:url withMethodType:Get withParams:nil success:^(id  _Nullable responseObject) {
            NSDictionary *txsJson = responseObject[@"data"];
            if (!txsJson || txsJson.count == 0) {
                if (callback) {
                    callback(txs, blockCount);
                    return ;
                }
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:txsJson options:0 error:0];
            NSString *txsJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:txsJsonStr forKey:txHashStr];
            NSMutableArray *txs = [NSMutableArray new];
            uint32_t bcount = blockCount;
            for (NSString *txHash in txHashArr) {
                if (![txsJson.allKeys containsObject:txHash]) {
                    continue;
                }
                NSDictionary *txDic = [txsJson objectForKey:txHash];
                if (!txDic) {
                    continue;
                }
                if (![[txDic allKeys] containsObject:@"transaction"]) {
                    continue;
                }
                NSDictionary *transactionDic = [txDic objectForKey:@"transaction"];
                if (!transactionDic || transactionDic.count == 0) {
                    continue;
                }
                NSArray *outPuts = [txDic objectForKey:@"outputs"];
                NSMutableArray *outPutsArray = [NSMutableArray new];
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:txDic];
                [mutDic removeObjectForKey:@"outputs"];
                for (NSDictionary *dic in outPuts) {
                    if ([[dic[@"recipient"] substringToIndex:3]isEqualToString:@"bc1"]) {
                        [outPutsArray addObject:dic];
                    }
                }
                [mutDic setObject:outPutsArray forKey:@"outputs"];
                int height = [transactionDic getIntFromDict:@"block_id" andDefault:-1];
                if (height > blockCount) {
                    bcount = height;
                }
                BTTx *tx = [[BTTx alloc] initWithBlockchairTxDict:mutDic transactionJson:transactionDic];
                [txs addObject:tx];
            }
            if (callback) {
                callback(txs, bcount);
            }
        } fail:^(NSInteger errorCode, NSString *errorMessage) {
            if (callback) {
                callback(nil,0);
            }
        }];

    }else
    {
        NSData *jsonData = [[[NSUserDefaults standardUserDefaults]objectForKey:txHashStr] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSDictionary *txsJson = dic;
        if (!txsJson || txsJson.count == 0) {
            if (callback) {
                callback(txs, blockCount);
                return ;
            }
        }
        NSMutableArray *txs = [NSMutableArray new];
        uint32_t bcount = blockCount;
        for (NSString *txHash in txHashArr) {
            if (![txsJson.allKeys containsObject:txHash]) {
                continue;
            }
            NSDictionary *txDic = [txsJson objectForKey:txHash];
            if (!txDic) {
                continue;
            }
            if (![[txDic allKeys] containsObject:@"transaction"]) {
                continue;
            }
            NSDictionary *transactionDic = [txDic objectForKey:@"transaction"];
            if (!transactionDic || transactionDic.count == 0) {
                continue;
            }
            NSArray *outPuts = [txDic objectForKey:@"outputs"];
            NSMutableArray *outPutsArray = [NSMutableArray new];
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:txDic];
            [mutDic removeObjectForKey:@"outputs"];
            for (NSDictionary *dic in outPuts) {
                if ([[dic[@"recipient"] substringToIndex:3]isEqualToString:@"bc1"]) {
                    [outPutsArray addObject:dic];
                }
            }
            [mutDic setObject:outPutsArray forKey:@"outputs"];
            int height = [transactionDic getIntFromDict:@"block_id" andDefault:-1];
            if (height > blockCount) {
                bcount = height;
            }
            BTTx *tx = [[BTTx alloc] initWithBlockchairTxDict:mutDic transactionJson:transactionDic];
            [txs addObject:tx];
        }
        if (callback) {
            callback(txs, bcount);
        }
    }
}
- (NSURLSessionDataTask *)requestBtcHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(NSMutableDictionary *)params success:(void(^)(id  _Nullable responseObject))successBlok fail:(void(^)(NSInteger errorCode,NSString *errorMessage))failBlock {
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    securityPolicy.validatesDomainName = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setSecurityPolicy:securityPolicy];
    //响应
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    //设置响应数据格式
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    if (method == Get) {
        __block NSMutableString *url = [NSMutableString stringWithString:path];
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [url appendFormat:@"&%@", [NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        return [manager GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (successBlok) {
                 successBlok(responseObject);
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"失败 -- %@",error);
             if (failBlock) failBlock(error.code,error.localizedDescription);
         }];
    }
    return nil;
}
#pragma mark - 签名交易
- (void)signTransaction:(BTCTransaction *)tx
                 btcKey:(BTCKey *)key
                 segwit:(BOOL)segwit
    transactionCallBack:(void(^)(NSError *error, BTCTransaction *transaction))transactionCallBack {
    if (!key) {
        if (transactionCallBack) {
            transactionCallBack([NSError errorWithDomain:@"com.seal.BTCDemo.errorDomain" code:100 userInfo:@{NSLocalizedDescriptionKey: @"error account"}], nil);
        }
        return;
    }
    NSError *error;
    // Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
    for (int i = 0; i < tx.inputs.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this
        // example we already know that we use a single private key.
        BTCTransactionInput *txin = tx.inputs[i];
        
        BTCSignatureHashType hashtype = BTCSignatureHashTypeAll;
        
        NSData *hash;
        if (segwit) {
            NSString *scriptHex = [NSString stringWithFormat:@"1976a914%@88ac",BTCHash160(key.publicKey).hex];
            BTCScript *scriptCode = [[BTCScript alloc] initWithHex:scriptHex];
            hash = [tx signatureHashForScript:scriptCode forSegWit:segwit inputIndex:i hashType:hashtype error:&error];
        } else {
            BTCScript *txoutScript = txin.signatureScript;
            hash = [tx signatureHashForScript:txoutScript forSegWit:segwit inputIndex:i hashType:hashtype error:&error];
        }
        
        if (!hash) {
            if (transactionCallBack) {
                transactionCallBack(error, nil);
            }
            return;
        }
        NSData *signature = [key signatureForHash:hash hashType:hashtype];
        if (segwit) {
            txin.witnessData = [[[BTCScript new] appendData:signature] appendData:key.publicKey];
            txin.signatureScript = [[BTCScript new] appendScript:key.witnessRedeemScript];
        } else {
            BTCScript *signatureScript = [[[BTCScript new] appendData:signature] appendData:key.publicKey];
            txin.signatureScript = signatureScript;
        }
    }
    if (transactionCallBack) {
        transactionCallBack(nil, tx);
    }
}
#pragma mark -- 发送广播
- (void)sendBroadcastWithSignPara:(NSDictionary *)para succes:(void (^)(NSString * _Nonnull))success fail:(FailBlock)fail {
    [[NetWorkTool shareNetworkTool] requestHttpWithPath:@"/rest/asset/broadcast/send/v1" withMethodType:Post withParams:para result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        if (code == 0) {
            if (responseModel.data.result) { //如果有值说明成功
                if (success) success(responseModel.data.result);
            } else {
                if (fail) fail (code,responseModel.data.message);
            }
        }else
        {
            if (fail) fail (code,message);
        }
            
    }];
}
@end
