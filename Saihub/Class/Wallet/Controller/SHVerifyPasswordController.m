//
//  SHVerifyPasswordController.m
//  Saihub
//
//  Created by 周松 on 2022/3/3.
//

#import "SHVerifyPasswordController.h"
#import "SHTextFieldView.h"
#import "SHExportPrivateKeyController.h"
#import "SHCompleteView.h"

@interface SHVerifyPasswordController () <TGTextFieldDelegate>

@property (nonatomic, weak) UIButton *sureButton;

@property (nonatomic, weak) SHTextFieldView *textFieldView;

@property (nonatomic, strong) UILabel *setTipLabel;

@end

@implementation SHVerifyPasswordController

- (UILabel *)setTipLabel {
    if (_setTipLabel == nil) {
        _setTipLabel = [[UILabel alloc]init];
        _setTipLabel.font = kCustomMontserratRegularFont(12);
        _setTipLabel.textColor = SHTheme.errorTipsRedColor;
        [self.view addSubview:_setTipLabel];
    }
    return _setTipLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = GCLocalizedString(@"verify_pwd_address_export_key_hint1");
    titleLabel.textColor = SHTheme.walletTextColor;
    titleLabel.font = kCustomMontserratMediumFont(24);
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
    }];
    
    UILabel *desLabel = [[UILabel alloc]init];
    desLabel.text = GCLocalizedString(@"verify_pwd_address_export_key_hint2");
    desLabel.textColor = SHTheme.appBlackColor;
    desLabel.font = kCustomMontserratRegularFont(14);
    desLabel.numberOfLines = 0;
    [self.view addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
    }];
    
    UILabel *verifyTitleLabel = [[UILabel alloc]init];
    verifyTitleLabel.text = GCLocalizedString(@"verify_password");
    verifyTitleLabel.textColor = SHTheme.setPasswordTipsColor;
    verifyTitleLabel.font = kCustomMontserratMediumFont(14);
    [self.view addSubview:verifyTitleLabel];
    [verifyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
    }];
    
    SHTextFieldView *textFieldView = [[SHTextFieldView alloc]init];
    self.textFieldView = textFieldView;
    textFieldView.textField.placeholder = GCLocalizedString(@"enter_password");
    textFieldView.textField.tg_placeholderColor = SHTheme.pageUnselectColor;
    textFieldView.textField.font = kCustomMontserratRegularFont(14);
    textFieldView.textField.textColor = SHTheme.walletTextColor;
    textFieldView.textField.TGTextFieldDelegate = self;
    [self.view addSubview:textFieldView];
    [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(46);
        
        if (self.controllerType == SHVerifyPasswordControllerTypeExport) {
            make.top.equalTo(desLabel.mas_bottom).offset(16);
        } else {
            make.top.equalTo(verifyTitleLabel.mas_bottom).offset(0);
        }
    }];
    
    if (self.controllerType == SHVerifyPasswordControllerTypeExport) {
        verifyTitleLabel.hidden = YES;
    } else {
        titleLabel.hidden = YES;
        desLabel.hidden = YES;
    }
    
    [self.setTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textFieldView);
        make.top.equalTo(textFieldView.mas_bottom).offset(8);
    }];
    
    // 确认
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureButton = sureButton;
    [sureButton setTitle:GCLocalizedString(@"Confirm") forState:UIControlStateNormal];
    [sureButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
    sureButton.titleLabel.font = kCustomMontserratMediumFont(14);
    sureButton.layer.cornerRadius = 26*FitWidth;
    sureButton.layer.masksToBounds = YES;
    [self.view addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(52 *FitWidth);
        make.top.mas_equalTo(textFieldView.mas_bottom).offset(80);
    }];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view layoutIfNeeded];
    [sureButton setBackgroundImage:[UIImage gradientImageWithBounds:sureButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    sureButton.userInteractionEnabled = NO;

    // 取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:GCLocalizedString(@"Cancel") forState:UIControlStateNormal];
    [cancelButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font = kCustomMontserratMediumFont(14);
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(sureButton.mas_bottom).offset(16);
    }];
    
}

#pragma mark -- 确认
- (void)sureButtonClick {
    MJWeakSelf
    
    if (self.textFieldView.textField.text.length < 8 || self.textFieldView.textField.text.length > 20) {
//        [MBProgressHUD showError:GCLocalizedString(@"请输入8-20位密码") toView:self.view];
        self.setTipLabel.text = GCLocalizedString(@"error_pwd_style");
        self.textFieldView.viewType = SHTextFieldViewTypeError;
        return;
    }

    if (![self.textFieldView.textField.text isEqualToString:[SHKeyStorage shared].currentWalletModel.password]) {
        self.setTipLabel.text = GCLocalizedString(@"wrong_passwrod");
        self.textFieldView.viewType = SHTextFieldViewTypeError;
        return;
    }
    
    if (self.controllerType == SHVerifyPasswordControllerDelete) {
        [[SHKeyStorage shared] deleteWalletWithModel:[SHKeyStorage shared].currentWalletModel];

        SHCompleteView *completeView = [[SHCompleteView alloc]init];
        completeView.completeViewType = CompleteViewSucceseType;
        completeView.completeBlock = ^{
            if (IsEmpty([SHKeyStorage shared].currentWalletModel)) {
                KAppSetting.unlockedPassWord = @"";
                KAppSetting.isOpenFaceID = @"";
            }
            [[CTMediator sharedInstance].topViewController.navigationController popToRootViewControllerAnimated:YES];
        };
        [completeView presentInView:self.view];

        return;
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    
    if (self.verifyPasswordBlock) {
        self.verifyPasswordBlock();
    }
    
}

#pragma mark -- 取消
- (void)cancelButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 输入监听
- (void)editingTextField:(TGTextField *)textField text:(NSString *)str {
    if (str.length < 8 || str.length > 20) {
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.sureButton.userInteractionEnabled = NO;
    } else {
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionLeftToRight] forState:UIControlStateNormal];
        self.sureButton.userInteractionEnabled = YES;
    }
    
    self.textFieldView.clearButton.hidden = IsEmpty(str);
    self.setTipLabel.text = @"";
    self.textFieldView.viewType = SHTextFieldViewTypeNormal;
}

@end
