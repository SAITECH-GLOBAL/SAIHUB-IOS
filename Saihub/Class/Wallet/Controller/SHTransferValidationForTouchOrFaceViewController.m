//
//  SHTransferValidationForTouchOrFaceViewController.m
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHTransferValidationForTouchOrFaceViewController.h"
#import "SHTransferValidationTopView.h"
#import "SHTransferValidationForPassWordViewController.h"
#import "SHTransferSucceseViewController.h"
#import "SHTransactionListModel.h"
@interface SHTransferValidationForTouchOrFaceViewController ()
@property (nonatomic, strong) UIButton *bottomCheckButton;
@property (nonatomic, strong) SHTransferValidationTopView *transferValidationTopView;
@end

@implementation SHTransferValidationForTouchOrFaceViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self ToSetgestures];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"Details");
    [self.rightButton setTitle:GCLocalizedString(@"Use_Password") forState:UIControlStateNormal];
    [self.rightButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = kCustomMontserratRegularFont(14);
    [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self layoutScale];
    [self getfaceOrTouchType];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RateChangeAction:) name:RateChangePushNoticeKey object:nil];
    // Do any additional setup after loading the view.
}
- (void)RateChangeAction:(NSNotification *)notification {
    [self.transferValidationTopView loadFeeLabelValue];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.transferValidationTopView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.navBar, 0).heightIs(166*FitHeight);
    self.bottomCheckButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.transferValidationTopView, 164*FitHeight).widthIs(259*FitWidth).heightEqualToWidth();
    [self.transferValidationTopView layoutScale];
    self.transferValidationTopView.isPrimaryToken = self.isPrimaryToken;
    self.transferValidationTopView.transferInfoModel = self.transferInfoModel;
}
-(void)setTransferInfoModel:(SHTransferInfoModel *)transferInfoModel
{
    _transferInfoModel = transferInfoModel;
}
#pragma mark 按钮事件
-(void)rightButtonAction:(UIButton *)btn
{

    if ([SHKeyStorage shared].currentWalletModel.isNoSecret) {
        BOOL havePassWordVc = NO;
        for (UIViewController *subController in self.navigationController.viewControllers) {
            if ([[SHTransferValidationForPassWordViewController class] isEqual:[subController class]]) {
                havePassWordVc = YES;
            }
        }
        if (havePassWordVc) {
            [self popViewController];
        }else
        {
            SHTransferValidationForPassWordViewController *transferValidationForPassWordViewController = [[SHTransferValidationForPassWordViewController alloc]init];
            transferValidationForPassWordViewController.tokenModel = self.tokenModel;
            transferValidationForPassWordViewController.transferInfoModel = self.transferInfoModel;
            transferValidationForPassWordViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
            transferValidationForPassWordViewController.bc1Hex = self.bc1Hex;
            [self.navigationController pushViewController:transferValidationForPassWordViewController animated:YES];
        }
    }else
    {
        [self popViewController];
    }

}
-(void)bottomCheckButtonAction:(UIButton *)btn
{

    [self ToSetgestures];
}
-(void)getfaceOrTouchType
{
    MJWeakSelf;
    [SHTouchOrFaceUtil GetTouchIdOrFaceIdTypeWithFaceIdTypeBlock:^{
        [self.bottomCheckButton setImage:[UIImage imageNamed:@"faceOrtouchVc_checkImageView_face"] forState:UIControlStateNormal];
        
    } WithTouchIdTypeBlock:^{
        [self.bottomCheckButton setImage:[UIImage imageNamed:@"faceOrtouchVc_checkImageView_touch"] forState:UIControlStateNormal];
    } WithValidationBackBlock:^{
        [weakSelf getfaceOrTouchType];
    }];
}
-(void)ToSetgestures
{
    MJWeakSelf;
    [SHTouchOrFaceUtil selectTouchIdOrFaceIdWithSucessedBlock:^(BOOL isSuccess) {
        if (IsEmpty(self.bc1Hex)) {
            [weakSelf btcRecommendCreatSign];
        }else
        {
            NSMutableDictionary *sendPara = [NSMutableDictionary dictionary];
            [sendPara setValue:self.bc1Hex forKey:@"transaction"];
            [sendPara setValue:@(2) forKey:@"coinType"];
            [weakSelf sendTransactionWithPara:sendPara];
        }
    } WithSelectPassWordBlock:^{
        [weakSelf ToSetgestures];
    } WithErrorBlock:^(NSError * _Nonnull error) {
    }withBtn:nil];
}
#pragma mark 交易
#pragma mark -- 2.2 推荐矿工费生成签名
- (void)btcRecommendCreatSign {
    __block NSString *sign = @"";
    MJWeakSelf
    
    if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePrivateKey || self.isPrimaryToken == NO) { //私钥导入
        BTCKey *btcKey = [[BTCKey alloc] initWithWIF:[SHKeyStorage shared].currentWalletModel.privateKey];
        [[SHWalletNetManager shared] signTransaction:self.transferInfoModel.transaction btcKey:btcKey segwit:YES transactionCallBack:^(NSError * _Nonnull error, BTCTransaction * _Nonnull transaction) {
            //            if (segwit) {
            sign = transaction.hexWithWitness;
            //            } else {
            //                sign = transaction.hex;
            //            }
            if (sign.length == 0) {
                //                if ([self.delegate respondsToSelector:@selector(createTransactionFailWithMessage:)]) {
                //                    [self.delegate createTransactionFailWithMessage:GCLocalizedString(@"签名失败")];
                //                }
                return;
            }
            NSMutableDictionary *sendPara = [NSMutableDictionary dictionary];
            [sendPara setValue:sign forKey:@"transaction"];
            [sendPara setValue:@(2) forKey:@"coinType"];
            
            [weakSelf sendTransactionWithPara:sendPara];
        }];
    } else { //助记词
        sign = [NSString hexWithData:self.transferInfoModel.tx.toData];
        if (sign.length == 0) {
            //            if ([self.delegate respondsToSelector:@selector(createTransactionFailWithMessage:)]) {
            //                [self.delegate createTransactionFailWithMessage:GCLocalizedString(@"签名失败")];
            //            }
            return;
        }
        NSMutableDictionary *sendPara = [NSMutableDictionary dictionary];
        [sendPara setValue:sign forKey:@"transaction"];
        [sendPara setValue:@(2) forKey:@"coinType"];
        
        [self sendTransactionWithPara:sendPara];
    }
}
#pragma mark -- 4.0 发送交易
- (void)sendTransactionWithPara:(NSDictionary *)para {
        
    MJWeakSelf
    [[SHWalletNetManager shared] sendBroadcastWithSignPara:para succes:^(NSString * _Nonnull hash) {
        //        [weakSelf storageLocalModelWithDict:@{t_hash : hash}];
        if (!IsEmpty(hash)) {
            SHTransferSucceseViewController *transferSucceseViewController = [[SHTransferSucceseViewController alloc]init];
            transferSucceseViewController.transferInfoModel = self.transferInfoModel;
            transferSucceseViewController.isPrimaryToken = self.isPrimaryToken;
            [self.navigationController pushViewController:transferSucceseViewController animated:YES];
            //存储模型
            SHTransactionListModel *model = [[SHTransactionListModel alloc]init];
            model.amount = self.transferInfoModel.valueString;
            model.fromAddress = [SHKeyStorage shared].currentWalletModel.address;
            model.toAddress = self.transferInfoModel.addressString;
            model.t_hash = hash;
            model.timestamp = [NSString getTimestampFromTime];
            model.status = SHTransactionStatusPending;
            model.type = 2;
            [[SHKeyStorage shared] updateModelBlock:^{
                [self.tokenModel.pendingList insertObject:model atIndex:0];
            }];
        }
    } fail:^(NSInteger errorCode, NSString * _Nonnull errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
#pragma mark 懒加载
-(UIButton *)bottomCheckButton
{
    if (_bottomCheckButton == nil) {
        _bottomCheckButton = [[UIButton alloc]init];
        [_bottomCheckButton addTarget:self action:@selector(bottomCheckButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomCheckButton];
    }
    return _bottomCheckButton;
}
-(SHTransferValidationTopView *)transferValidationTopView
{
    if (_transferValidationTopView == nil) {
        _transferValidationTopView = [[SHTransferValidationTopView alloc]init];
        [self.view addSubview:_transferValidationTopView];
    }
    return _transferValidationTopView;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RateChangePushNoticeKey object:nil];
}
@end
