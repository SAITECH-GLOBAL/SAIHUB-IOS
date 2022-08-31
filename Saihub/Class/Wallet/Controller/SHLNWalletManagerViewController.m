//
//  SHLNWalletManagerViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/23.
//

#import "SHLNWalletManagerViewController.h"
#import "SHLNWalletSetPassWordViewController.h"
#import "SHLNExportWalltViewController.h"
#import "SHCompleteView.h"
#import "SHVerifyPasswordController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface SHLNWalletManagerViewController ()
@property (nonatomic, strong) UILabel *walletNameTipsLabel;
@property (nonatomic, strong) UILabel *walletNameValueLabel;
@property (nonatomic, strong) UIButton *walletNameChangeButton;
@property (nonatomic, strong) UIView *walletNameLineView;

@property (nonatomic, strong) UILabel *hostUrlTipsLabel;
@property (nonatomic, strong) UITextField *hostUrlTf;
@property (nonatomic, strong) UIView *hostUrlLineView;

@property (nonatomic, strong) UILabel *setPassWordLabel;
@property (nonatomic, strong) UILabel *faceIdLabel;
@property (nonatomic,strong) UISwitch *setPassWordSwitchButton;
@property (nonatomic,strong) UISwitch *faceIdLabelSwitchButton;


@property (nonatomic, strong) UIButton *exportButton;
@property (nonatomic, strong) UIButton *deletButton;
@end

@implementation SHLNWalletManagerViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"Lightning_Settings");
    
//    [self.rightButton setTitle:GCLocalizedString(@"Save") forState:UIControlStateNormal];
//    [self.rightButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
//    self.rightButton.hidden = YES;
//    [self.rightButton setTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.walletNameTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(22*FitHeight);
    [self.walletNameTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.walletNameValueLabel.sd_layout.leftEqualToView(self.walletNameTipsLabel).topSpaceToView(self.walletNameTipsLabel, 0).rightSpaceToView(self.view, 20*FitWidth).heightIs(46*FitHeight);
    self.walletNameChangeButton.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(self.walletNameValueLabel).widthIs(kWIDTH).heightIs(40*FitHeight);

    self.walletNameLineView.sd_layout.leftEqualToView(self.walletNameValueLabel).rightEqualToView(self.walletNameValueLabel).topSpaceToView(self.walletNameValueLabel, 0).heightIs(1);
   
    self.hostUrlTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.walletNameLineView, 24*FitHeight).heightIs(22*FitHeight);
    [self.hostUrlTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.hostUrlTf.sd_layout.leftEqualToView(self.hostUrlTipsLabel).topSpaceToView(self.hostUrlTipsLabel, 0).rightSpaceToView(self.view, 20*FitWidth).heightIs(46*FitHeight);
    self.hostUrlLineView.sd_layout.leftEqualToView(self.walletNameLineView).rightEqualToView(self.walletNameLineView).topSpaceToView(self.hostUrlTf, 0).heightIs(1);
    
    self.setPassWordLabel.sd_layout.leftEqualToView(self.hostUrlLineView).topSpaceToView(self.hostUrlLineView, 24*FitHeight).heightIs(22*FitHeight);
    [self.setPassWordLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.setPassWordSwitchButton.sd_layout.rightEqualToView(self.hostUrlLineView).centerYEqualToView(self.setPassWordLabel).widthIs(32*FitWidth).heightIs(20*FitHeight);
    
    self.faceIdLabel.sd_layout.leftEqualToView(self.hostUrlLineView).topSpaceToView(self.setPassWordLabel, 24*FitHeight).heightIs(22*FitHeight);
    [self.faceIdLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.faceIdLabelSwitchButton.sd_layout.rightEqualToView(self.hostUrlLineView).centerYEqualToView(self.faceIdLabel).widthIs(32*FitWidth).heightIs(20*FitHeight);
    
    self.exportButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.hostUrlLineView, 191*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.exportButton setBackgroundImage:[UIImage gradientImageWithBounds:self.exportButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    self.exportButton.enabled = YES;
    
    self.deletButton.sd_layout.centerXEqualToView(self.exportButton).topSpaceToView(self.exportButton, 0).widthIs(335*FitWidth).heightIs(52*FitHeight);
}
#pragma mark 按钮事件
-(void)exportButtonAction:(UIButton *)btn
{
    SHLNExportWalltViewController *LNExportWalltViewController = [SHLNExportWalltViewController new];
    LNExportWalltViewController.address = [NSString stringWithFormat:@"lndhub://%@:%@@%@",[SHKeyStorage shared].currentLNWalletModel.UserAccount,[SHKeyStorage shared].currentLNWalletModel.UserPassWord,[SHKeyStorage shared].currentLNWalletModel.hostUrl];
    [self.navigationController pushViewController:LNExportWalltViewController animated:YES];
}
-(void)deletButtonAction:(UIButton *)btn
{
    MJWeakSelf;
    SHAlertView *alertView = [[SHAlertView alloc]initWithTitle:GCLocalizedString(@"dialog_delete_confirm_title") alert:GCLocalizedString(@"Please_backup_first") sureTitle:GCLocalizedString(@"Yes") sureBlock:^(NSString * _Nonnull str) {
        [weakSelf deleatWalletAction];
    } cancelTitle:GCLocalizedString(@"No") cancelBlock:^(NSString * _Nonnull str) {
        
    }];
    alertView.subTitleLabel.textColor = SHTheme.errorTipsRedColor;
    alertView.clooseButton.hidden = YES;
    [KeyWindow addSubview:alertView];
}
-(void)deleatWalletAction
{
    [[SHKeyStorage shared] deleteLNWalletWithModel:[SHKeyStorage shared].currentLNWalletModel];
    
    if (IsEmpty([SHKeyStorage shared].currentLNWalletModel) && [SHKeyStorage shared].currentWalletModel) {//有本地钱包
        [self changehdTolnWalletAction];
    }
    SHCompleteView *completeView = [[SHCompleteView alloc]init];
    completeView.completeViewType = CompleteViewSucceseType;
    completeView.completeBlock = ^{
        if (IsEmpty([SHKeyStorage shared].currentWalletModel)) {
            KAppSetting.unlockedPassWord = @"";
            KAppSetting.isOpenFaceID = @"";
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    [completeView presentInView:self.view];
}
-(void)changehdTolnWalletAction
{
    [SHKeyStorage shared].currentWalletModel = [SHKeyStorage shared].currentWalletModel;
}
//-(void)rightButtonAction:(UIButton *)btn
//{
//    [MBProgressHUD showSuccess:GCLocalizedString(@"Saved") toView:self.view];
//    [[SHKeyStorage shared] updateModelBlock:^{
//        [SHKeyStorage shared].currentLNWalletModel.WalletName = self.walletNameValueLabel.text;
//    }];
//}
- (void)setPassWordSwitchButtonCLick:(UISwitch *)switchButton {
    if (switchButton.on) {
        [self.navigationController pushViewController:[SHLNWalletSetPassWordViewController new] animated:YES];
        
    }else
    {
        SHVerifyPasswordController *verifyPwdVc = [[SHVerifyPasswordController alloc]init];
        verifyPwdVc.controllerType = SHVerifyPasswordControllerTypeOther;
        verifyPwdVc.verifyPasswordBlock = ^{
            [[SHKeyStorage shared] updateModelBlock:^{
                [SHKeyStorage shared].currentLNWalletModel.walletPassWord = @"";
                [SHKeyStorage shared].currentLNWalletModel.isOpenFaceId = NO;
            }];
            [self loadData];
        };
        [self.navigationController pushViewController:verifyPwdVc animated:YES];
    }
}
- (void)faceIdLabelSwitchButtonCLick:(UISwitch *)switchButton {
    [self pushVerifyPasswordControllerWithButton:switchButton];
}
-(void)walletNameChangeButtonAction:(UIButton *)btn
{
    SHAlertView *alertView = [[SHAlertView alloc]initChangeWalletNameWithTitle:GCLocalizedString(@"wallet_name") alert:self.walletNameValueLabel.text sureTitle:GCLocalizedString(@"Yes") sureBlock:^(NSString * _Nonnull str) {
        if (!IsEmpty(str)) {
            self.walletNameValueLabel.text = str;
            [MBProgressHUD showSuccess:GCLocalizedString(@"Saved") toView:self.view];
            [[SHKeyStorage shared] updateModelBlock:^{
                [SHKeyStorage shared].currentLNWalletModel.WalletName = self.walletNameValueLabel.text;
            }];
//            self.rightButton.hidden = NO;
        }
    } cancelTitle:GCLocalizedString(@"No") cancelBlock:^(NSString * _Nonnull str) {
        
    }];
    alertView.subTitleLabel.textColor = SHTheme.errorTipsRedColor;
    alertView.clooseButton.hidden = YES;
    [KeyWindow addSubview:alertView];
}
#pragma mark 加载数据
-(void)loadData
{
    self.walletNameValueLabel.text = [SHKeyStorage shared].currentLNWalletModel.WalletName;
    self.hostUrlTf.text = [SHKeyStorage shared].currentLNWalletModel.hostUrl;
    self.setPassWordSwitchButton.on = !IsEmpty([SHKeyStorage shared].currentLNWalletModel.walletPassWord);
    self.faceIdLabelSwitchButton.on = [SHKeyStorage shared].currentLNWalletModel.isOpenFaceId;
    self.faceIdLabelSwitchButton.thumbTintColor = self.setPassWordSwitchButton.on?SHTheme.appWhightColor:SHTheme.switchDisableColor;

}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
//    self.rightButton.hidden = NO;
}
#pragma mark -- 开启关闭touchID
- (void)pushVerifyPasswordControllerWithButton:(UISwitch *)sender {
    
    if (sender.isOn == YES) { // 此时开启
        if (!self.setPassWordSwitchButton.on) {
            SHLNWalletSetPassWordViewController *LNWalletSetPassWordViewController = [SHLNWalletSetPassWordViewController new];
            LNWalletSetPassWordViewController.setPassWordBlock = ^{
            };
            [self.navigationController pushViewController:LNWalletSetPassWordViewController animated:YES];

            return;
        }
        [self openFaceidAction];

    } else {
        [[SHKeyStorage shared] updateModelBlock:^{
            [SHKeyStorage shared].currentLNWalletModel.isOpenFaceId = NO;
        }];
    }
    [self loadData];
}
-(void)openFaceidAction
{
    SHVerifyPasswordController *verifyPwdVc = [[SHVerifyPasswordController alloc]init];
    verifyPwdVc.controllerType = SHVerifyPasswordControllerTypeOther;
    verifyPwdVc.verifyPasswordBlock = ^{
        [SHTouchOrFaceUtil selectTouchIdOrFaceIdWithSucessedBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                [[SHKeyStorage shared] updateModelBlock:^{
                    [SHKeyStorage shared].currentLNWalletModel.isOpenFaceId = YES;
                }];
                [self loadData];
            }
        } WithSelectPassWordBlock:^{
            
        } WithErrorBlock:^(NSError * _Nonnull error) {
            if (error.code == LAErrorAuthenticationFailed) {
                [MBProgressHUD showError:GCLocalizedString(@"biometric_not_recognized") toView:self.view];
            } else if (error.code == LAErrorBiometryLockout) {
                [MBProgressHUD showError:GCLocalizedString(@"input_error_pwd_locked") toView:self.view];
            }
        } withBtn:nil];
    };
    [self.navigationController pushViewController:verifyPwdVc animated:YES];
}
#pragma mark 懒加载
-(UILabel *)walletNameTipsLabel
{
    if (_walletNameTipsLabel == nil) {
        _walletNameTipsLabel = [[UILabel alloc]init];
        _walletNameTipsLabel.font = kCustomMontserratMediumFont(14);
        _walletNameTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _walletNameTipsLabel.text = GCLocalizedString(@"wallet_name");
        [self.view addSubview:_walletNameTipsLabel];
    }
    return _walletNameTipsLabel;
}
-(UILabel *)walletNameValueLabel
{
    if (_walletNameValueLabel == nil) {
        _walletNameValueLabel = [[UILabel alloc]init];
        _walletNameValueLabel.font = kCustomMontserratMediumFont(14);
        _walletNameValueLabel.textColor = SHTheme.setPasswordTipsColor;
        [self.view addSubview:_walletNameValueLabel];
    }
    return _walletNameValueLabel;
}
-(UIButton *)walletNameChangeButton
{
    if (_walletNameChangeButton == nil) {
        _walletNameChangeButton = [[UIButton alloc]init];
        [_walletNameChangeButton setImage:[UIImage imageNamed:@"setWalletPass_walletNameChangeButton"] forState:UIControlStateNormal];
        _walletNameChangeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_walletNameChangeButton addTarget:self action:@selector(walletNameChangeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_walletNameChangeButton];
    }
    return _walletNameChangeButton;
}
- (UIView *)walletNameLineView
{
    if (_walletNameLineView == nil) {
        _walletNameLineView = [[UIView alloc]init];
        _walletNameLineView.backgroundColor = SHTheme.appBlackColor;
        _walletNameLineView.alpha = 0.12;
        [self.view addSubview:_walletNameLineView];
    }
    return _walletNameLineView;
}
-(UILabel *)hostUrlTipsLabel
{
    if (_hostUrlTipsLabel == nil) {
        _hostUrlTipsLabel = [[UILabel alloc]init];
        _hostUrlTipsLabel.font = kCustomMontserratMediumFont(14);
        _hostUrlTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _hostUrlTipsLabel.text = GCLocalizedString(@"Host");
        [self.view addSubview:_hostUrlTipsLabel];
    }
    return _hostUrlTipsLabel;
}
-(UITextField *)hostUrlTf
{
    if (_hostUrlTf == nil) {
        _hostUrlTf = [[UITextField alloc]init];
        _hostUrlTf.tintColor = SHTheme.agreeButtonColor;
        _hostUrlTf.placeholder = GCLocalizedString(@"");
        _hostUrlTf.enabled = NO;
        [_hostUrlTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_hostUrlTf];
    }
    return _hostUrlTf;
}
- (UIView *)hostUrlLineView
{
    if (_hostUrlLineView == nil) {
        _hostUrlLineView = [[UIView alloc]init];
        _hostUrlLineView.backgroundColor = SHTheme.appBlackColor;
        _hostUrlLineView.alpha = 0.12;
        [self.view addSubview:_hostUrlLineView];
    }
    return _hostUrlLineView;
}

-(UIButton *)exportButton
{
    if (_exportButton == nil) {
        _exportButton = [[UIButton alloc]init];
        _exportButton.layer.cornerRadius = 26*FitHeight;
        _exportButton.layer.masksToBounds = YES;
        _exportButton.enabled = NO;
        [_exportButton setTitle:GCLocalizedString(@"Export") forState:UIControlStateNormal];
        [_exportButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _exportButton.titleLabel.font = kMediunFont(14);
        [_exportButton addTarget:self action:@selector(exportButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_exportButton];
    }
    return _exportButton;
}
-(UIButton *)deletButton
{
    if (_deletButton == nil) {
        _deletButton = [[UIButton alloc]init];
        [_deletButton setTitle:GCLocalizedString(@"Delete") forState:UIControlStateNormal];
        [_deletButton setTitleColor:SHTheme.errorTipsRedColor forState:UIControlStateNormal];
        _deletButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_deletButton addTarget:self action:@selector(deletButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deletButton];
    }
    return _deletButton;
}
-(UILabel *)setPassWordLabel
{
    if (_setPassWordLabel == nil) {
        _setPassWordLabel = [[UILabel alloc]init];
        _setPassWordLabel.font = kCustomMontserratMediumFont(14);
        _setPassWordLabel.textColor = SHTheme.setPasswordTipsColor;
        _setPassWordLabel.text = GCLocalizedString(@"set_password");
        [self.view addSubview:_setPassWordLabel];
    }
    return _setPassWordLabel;
}
-(UILabel *)faceIdLabel
{
    if (_faceIdLabel == nil) {
        _faceIdLabel = [[UILabel alloc]init];
        _faceIdLabel.font = kCustomMontserratMediumFont(14);
        _faceIdLabel.textColor = SHTheme.setPasswordTipsColor;
        _faceIdLabel.text = GCLocalizedString(@"touch_id");
        [self.view addSubview:_faceIdLabel];
    }
    return _faceIdLabel;
}
- (UISwitch *)setPassWordSwitchButton {
    if (_setPassWordSwitchButton == nil) {
        _setPassWordSwitchButton = [[UISwitch alloc]init];
        _setPassWordSwitchButton.on = YES;
        _setPassWordSwitchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
        _setPassWordSwitchButton.thumbTintColor = SHTheme.appWhightColor;
        _setPassWordSwitchButton.onTintColor = SHTheme.switchOnColor;
        [_setPassWordSwitchButton addTarget:self action:@selector(setPassWordSwitchButtonCLick:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_setPassWordSwitchButton];
    }
    return _setPassWordSwitchButton;
}
- (UISwitch *)faceIdLabelSwitchButton {
    if (_faceIdLabelSwitchButton == nil) {
        _faceIdLabelSwitchButton = [[UISwitch alloc]init];
        _faceIdLabelSwitchButton.on = YES;
        _faceIdLabelSwitchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
        _faceIdLabelSwitchButton.thumbTintColor = SHTheme.appWhightColor;
        _faceIdLabelSwitchButton.onTintColor = SHTheme.switchOnColor;
        [_faceIdLabelSwitchButton addTarget:self action:@selector(faceIdLabelSwitchButtonCLick:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_faceIdLabelSwitchButton];
    }
    return _faceIdLabelSwitchButton;
}
@end
