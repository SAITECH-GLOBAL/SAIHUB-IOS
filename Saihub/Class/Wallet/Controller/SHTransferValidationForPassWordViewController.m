//
//  SHTransferValidationForPassWordViewController.m
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHTransferValidationForPassWordViewController.h"
#import "SHTransferValidationTopView.h"
#import "SHResetPassWordViewController.h"
#import "SHTransferSucceseViewController.h"
#import "SHVerifyPasswordController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "SHTransferValidationForTouchOrFaceViewController.h"
@interface SHTransferValidationForPassWordViewController ()
@property (nonatomic, strong) SHTransferValidationTopView *transferValidationTopView;
//@property (nonatomic, strong) SHpassWordView *passWordTf;
@property (nonatomic, strong) TGTextField *resetPassTf;
@property (nonatomic, strong) UIButton *seeOrHidderButton;
@property (nonatomic, strong) UIView *resetPassLineView;
@property (nonatomic, assign) NSInteger errorNumber;
@property (nonatomic, assign) NSInteger firstErrorTime;
@property (nonatomic, strong) UILabel *resetPassErrorTips;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation SHTransferValidationForPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorNumber = 0;
    self.firstErrorTime = 0;
    self.titleLabel.text = GCLocalizedString(@"Details");
    [self.rightButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = kCustomMontserratRegularFont(14);
    [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self layoutScale];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RateChangeAction:) name:RateChangePushNoticeKey object:nil];
    // Do any additional setup after loading the view.
    [self getfaceOrTouchType];
}
-(void)getfaceOrTouchType
{
    MJWeakSelf;
    [SHTouchOrFaceUtil GetTouchIdOrFaceIdTypeWithFaceIdTypeBlock:^{
        [self.rightButton setTitle:GCLocalizedString(@"Face_Pay") forState:UIControlStateNormal];

    } WithTouchIdTypeBlock:^{
        [self.rightButton setTitle:GCLocalizedString(@"Fingerprint_Pay") forState:UIControlStateNormal];
    } WithValidationBackBlock:^{
        [weakSelf getfaceOrTouchType];
    }];
}
- (void)RateChangeAction:(NSNotification *)notification {
    [self.transferValidationTopView loadFeeLabelValue];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.transferValidationTopView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.navBar, 0).heightIs(166*FitHeight);
    [self.transferValidationTopView layoutScale];
    self.resetPassTf.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.transferValidationTopView, 32*FitHeight).widthIs(300*FitWidth).heightIs(45*FitHeight);
    self.seeOrHidderButton.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(self.resetPassTf).widthIs(20*FitWidth).heightIs(20*FitHeight);
    self.resetPassLineView.sd_layout.leftEqualToView(self.resetPassTf).rightEqualToView(self.seeOrHidderButton).topSpaceToView(self.resetPassTf, 1*FitHeight).heightIs(1);
    self.resetPassErrorTips.sd_layout.leftEqualToView(self.resetPassLineView).topSpaceToView(self.resetPassLineView, 0*FitHeight).rightEqualToView(self.resetPassLineView).heightIs(22*FitHeight);
    self.confirmButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.resetPassLineView, 134*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    self.transferValidationTopView.isPrimaryToken = self.isPrimaryToken;
    self.transferValidationTopView.transferInfoModel = self.transferInfoModel;

}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
    self.resetPassLineView.backgroundColor = SHTheme.appBlackColor;
    self.resetPassErrorTips.hidden = YES;
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.resetPassTf.text)) {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = YES;
    }else
    {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = NO;
    }
}
#pragma mark 按钮事件
-(void)rightButtonAction:(UIButton *)btn
{
    BOOL haveFaceOrTouchWordVc = NO;
    for (UIViewController *subController in self.navigationController.viewControllers) {
        if ([[SHTransferValidationForTouchOrFaceViewController class] isEqual:[subController class]]) {
            haveFaceOrTouchWordVc = YES;
        }
    }
    if ([SHKeyStorage shared].currentWalletModel.isNoSecret) {
        if (haveFaceOrTouchWordVc) {
            [self popViewController];
        }else
        {
            SHTransferValidationForTouchOrFaceViewController *transferValidationForTouchOrFaceViewController = [[SHTransferValidationForTouchOrFaceViewController alloc]init];
            transferValidationForTouchOrFaceViewController.tokenModel = self.tokenModel;
            transferValidationForTouchOrFaceViewController.transferInfoModel = self.transferInfoModel;
            transferValidationForTouchOrFaceViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
            transferValidationForTouchOrFaceViewController.bc1Hex = self.bc1Hex;
            [self.navigationController pushViewController:transferValidationForTouchOrFaceViewController animated:YES];
        }
    }else{
        SHVerifyPasswordController *verifyPwdVc = [[SHVerifyPasswordController alloc]init];
                verifyPwdVc.controllerType = SHVerifyPasswordControllerTypeOther;
                verifyPwdVc.verifyPasswordBlock = ^{
                    [[SHKeyStorage shared] updateModelBlock:^{
                        [SHKeyStorage shared].currentWalletModel.isNoSecret = YES;
                    }];
                    SHTransferValidationForTouchOrFaceViewController *transferValidationForTouchOrFaceViewController = [[SHTransferValidationForTouchOrFaceViewController alloc]init];
                    transferValidationForTouchOrFaceViewController.tokenModel = self.tokenModel;
                    transferValidationForTouchOrFaceViewController.transferInfoModel = self.transferInfoModel;
                    transferValidationForTouchOrFaceViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                    transferValidationForTouchOrFaceViewController.bc1Hex = self.bc1Hex;
                    [self.navigationController pushViewController:transferValidationForTouchOrFaceViewController animated:YES];
                };
                [self.navigationController pushViewController:verifyPwdVc animated:YES];
    }
   
}
-(void)setTransferInfoModel:(SHTransferInfoModel *)transferInfoModel
{
    _transferInfoModel = transferInfoModel;
}
-(void)seeOrHidderButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.resetPassTf.secureTextEntry = !self.resetPassTf.secureTextEntry;

}
-(void)confirmButtonAction:(UIButton *)btn
{
    self.confirmButton.enabled = NO;
    if (![[SHKeyStorage shared].currentWalletModel.password isEqualToString:self.resetPassTf.text]) {
        self.confirmButton.enabled = YES;
        self.resetPassErrorTips.hidden = NO;
        self.resetPassLineView.backgroundColor = SHTheme.errorTipsRedColor;
        return;
    }
    if (IsEmpty(self.bc1Hex)) {
        [self btcRecommendCreatSign];
    }else
    {
        NSMutableDictionary *sendPara = [NSMutableDictionary dictionary];
        [sendPara setValue:self.bc1Hex forKey:@"transaction"];
        [sendPara setValue:@(2) forKey:@"coinType"];
        [self sendTransactionWithPara:sendPara];
    }
}
#pragma mark 交易
#pragma mark -- 2.2 推荐矿工费生成签名
- (void)btcRecommendCreatSign {
    __block NSString *sign = @"";
    MJWeakSelf
    if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePrivateKey || self.isPrimaryToken == NO) { //私钥导入
        BTCKey *btcKey = [[BTCKey alloc] initWithWIF:[SHKeyStorage shared].currentWalletModel.subAddressList[0].privateKey];
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
                self.confirmButton.enabled = YES;
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
            self.confirmButton.enabled = YES;
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
        self.confirmButton.enabled = YES;
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
        self.confirmButton.enabled = YES;
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
#pragma mark 懒加载
-(TGTextField *)resetPassTf
{
    if (_resetPassTf == nil) {
        _resetPassTf = [[TGTextField alloc]init];
        _resetPassTf.tintColor = SHTheme.agreeButtonColor;
        _resetPassTf.placeholder = GCLocalizedString(@"set_passphrase_hint_0");
        _resetPassTf.font = kCustomMontserratRegularFont(14);
        _resetPassTf.clearButtonMode = UITextFieldViewModeAlways;
        _resetPassTf.secureTextEntry = YES;
        [_resetPassTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_resetPassTf];
    }
    return _resetPassTf;
}
-(UILabel *)resetPassErrorTips
{
    if (_resetPassErrorTips == nil) {
        _resetPassErrorTips = [[UILabel alloc]init];
        _resetPassErrorTips.font = kCustomMontserratRegularFont(14);
        _resetPassErrorTips.textColor = SHTheme.errorTipsRedColor;
        _resetPassErrorTips.hidden = YES;
        _resetPassErrorTips.text = GCLocalizedString(@"password_error_try_again");
        [self.view addSubview:_resetPassErrorTips];
    }
    return _resetPassErrorTips;
}
-(UIButton *)seeOrHidderButton
{
    if (_seeOrHidderButton == nil) {
        _seeOrHidderButton = [[UIButton alloc]init];
        [_seeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_on"] forState:UIControlStateNormal];
        [_seeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_off"] forState:UIControlStateSelected];
        [_seeOrHidderButton addTarget:self action:@selector(seeOrHidderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_seeOrHidderButton];
    }
    return _seeOrHidderButton;
}
- (UIView *)resetPassLineView
{
    if (_resetPassLineView == nil) {
        _resetPassLineView = [[UIView alloc]init];
        _resetPassLineView.backgroundColor = SHTheme.appBlackColor;
        _resetPassLineView.alpha = 0.12;
        [self.view addSubview:_resetPassLineView];
    }
    return _resetPassLineView;
}
-(SHTransferValidationTopView *)transferValidationTopView
{
    if (_transferValidationTopView == nil) {
        _transferValidationTopView = [[SHTransferValidationTopView alloc]init];
        [self.view addSubview:_transferValidationTopView];
    }
    return _transferValidationTopView;
}
-(UIButton *)confirmButton
{
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc]init];
        _confirmButton.layer.cornerRadius = 26*FitHeight;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.enabled = NO;
        [_confirmButton setTitle:GCLocalizedString(@"Confirm") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = kMediunFont(14);
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RateChangePushNoticeKey object:nil];
}
@end
