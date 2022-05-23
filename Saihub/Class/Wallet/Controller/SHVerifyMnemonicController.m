//
//  SHVerifyMnemonicController.m
//  Saihub
//
//  Created by 周松 on 2022/3/1.
//

#import "SHVerifyMnemonicController.h"
#import "SHTextFieldView.h"
#import "SHPasswordStrength.h"
#import "SHWalletManagerController.h"


@interface SHVerifyMnemonicController () <TGTextFieldDelegate>

@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, weak) SHTextFieldView *setTextFieldView;

@property (nonatomic, weak) SHTextFieldView *sureTextFieldView;

@property (nonatomic, weak) SHPasswordStrength *passwordStrengthView;

@property (nonatomic, weak) UIButton *sureButton;

@property (nonatomic, strong) UILabel *setTipLabel;

@property (nonatomic, strong) UILabel *sureTipLabel;


@end

@implementation SHVerifyMnemonicController

- (UILabel *)setTipLabel {
    if (_setTipLabel == nil) {
        _setTipLabel = [[UILabel alloc]init];
        _setTipLabel.font = kCustomMontserratRegularFont(12);
        _setTipLabel.textColor = SHTheme.errorTipsRedColor;
        [self.view addSubview:_setTipLabel];
    }
    return _setTipLabel;
}

- (UILabel *)sureTipLabel {
    if (_sureTipLabel == nil) {
        _sureTipLabel = [[UILabel alloc]init];
        _sureTipLabel.textColor = SHTheme.errorTipsRedColor;
        _sureTipLabel.font = kCustomMontserratRegularFont(12);
        [self.view addSubview:_sureTipLabel];
    }
    return _sureTipLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = GCLocalizedString(@"reset_password");
    
    [self setSubviews];
}

- (void)setSubviews {
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = GCLocalizedString(@"mnemonic_private_key");
    titleLabel.textColor = SHTheme.setPasswordTipsColor;
    titleLabel.font = kCustomMontserratMediumFont(14);
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
    }];
    
    UIView *borderView = [[UIView alloc]init];
    borderView.backgroundColor = SHTheme.addressTypeCellBackColor;
    borderView.layer.borderColor = SHTheme.buttonForMnemonicSelectBackColor.CGColor;
    borderView.layer.borderWidth = 1;
    borderView.layer.cornerRadius = 8;
    [self.view addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.top.equalTo(titleLabel.mas_bottom).offset(16);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(156);
    }];
    
    UITextView *textView = [[UITextView alloc]init];
    textView.tintColor = SHTheme.agreeButtonColor;
    self.textView = textView;
    textView.placeholder = GCLocalizedString(@"reset_pwd_input_hint");
    textView.placeholderColor = SHTheme.pageUnselectColor;
    textView.font = kCustomMontserratRegularFont(14);
    textView.textColor = SHTheme.appBlackColor;
    textView.backgroundColor = SHTheme.addressTypeCellBackColor;
    [borderView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(borderView.mas_top).offset(3);
        make.right.mas_equalTo(-12);
        make.bottom.equalTo(borderView.mas_bottom).offset(-3);
    }];
    
    // 新密码
    UILabel *newPwdLabel = [[UILabel alloc]init];
    newPwdLabel.text = GCLocalizedString(@"new_password");
    newPwdLabel.textColor = SHTheme.setPasswordTipsColor;
    newPwdLabel.font = kCustomMontserratMediumFont(14);
    [self.view addSubview:newPwdLabel];
    [newPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(textView.mas_bottom).offset(24);
    }];
    
    SHTextFieldView *newTextFieldView = [[SHTextFieldView alloc]init];
    self.setTextFieldView = newTextFieldView;
    newTextFieldView.textField.placeholder = GCLocalizedString(@"enter_new_password");
    newTextFieldView.textField.TGTextFieldDelegate = self;
    newTextFieldView.textField.tg_placeholderColor = SHTheme.pageUnselectColor;
    [self.view addSubview:newTextFieldView];
    [newTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 );
        make.right.mas_equalTo(-20 );
        make.top.equalTo(newPwdLabel.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    
    [self.setTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newTextFieldView.mas_bottom).offset(8);
        make.left.equalTo(newTextFieldView);
    }];
    
    // 密码强度等级
    SHPasswordStrength *passwordStrengthView = [[SHPasswordStrength alloc]init];
    self.passwordStrengthView = passwordStrengthView;
    passwordStrengthView.passwordStrengthType = SHPasswordStrengthNormalType;
    [self.view addSubview:passwordStrengthView];
    [passwordStrengthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(newPwdLabel);
    }];

    SHTextFieldView *sureTextFieldView = [[SHTextFieldView alloc]init];
    self.sureTextFieldView = sureTextFieldView;
    sureTextFieldView.textField.placeholder = GCLocalizedString(@"repeat_password");
    sureTextFieldView.textField.TGTextFieldDelegate = self;
    sureTextFieldView.textField.tg_placeholderColor = SHTheme.pageUnselectColor;
    [self.view addSubview:sureTextFieldView];
    [sureTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(newTextFieldView.mas_bottom).offset(8).priorityMedium();
        make.height.mas_equalTo(46);
    }];
    
    [self.sureTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sureTextFieldView);
        make.top.equalTo(sureTextFieldView.mas_bottom).offset(8);
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
        make.top.mas_equalTo(sureTextFieldView.mas_bottom).offset(80);
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
    if (![self.textView.text isEqualToString:[SHKeyStorage shared].currentWalletModel.mnemonic] && ![self.textView.text isEqualToString:[SHKeyStorage shared].currentWalletModel.privateKey]) {
        [MBProgressHUD showError:GCLocalizedString(@"please_enter_right_phrase_or_privatekey") toView:self.view];
        return;
    }
    
    if (![NSString validePasswordFormat:self.setTextFieldView.textField.text]) {
        self.setTipLabel.text = GCLocalizedString(@"error_pwd_style");
        
        self.setTextFieldView.viewType = SHTextFieldViewTypeError;
        
        [self.sureTextFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.setTextFieldView.mas_bottom).offset(30);
        }];
        return;
    }
    
    if (![NSString validePasswordFormat:self.sureTextFieldView.textField.text]) {
        
        self.sureTipLabel.text = GCLocalizedString(@"error_pwd_style");
        
        self.sureTextFieldView.viewType = SHTextFieldViewTypeError;
        
        return;
    }
    
    if ([self.setTextFieldView.textField.text isEqualToString:self.sureTextFieldView.textField.text] == NO) {
        self.sureTipLabel.text = GCLocalizedString(@"pwd_not_match");
        
        self.sureTextFieldView.viewType = SHTextFieldViewTypeError;

        return;
    }
    
    if ([self.textView.text isEqualToString:[SHKeyStorage shared].currentWalletModel.mnemonic]) { // 助记词
        [[SHKeyStorage shared] updateModelBlock:^{
            [SHKeyStorage shared].currentWalletModel.mnemonic = self.textView.text;
            [SHKeyStorage shared].currentWalletModel.password = self.setTextFieldView.textField.text;
        }];
    } else {
        [[SHKeyStorage shared] updateModelBlock:^{ // 私钥
            [SHKeyStorage shared].currentWalletModel.privateKey = self.textView.text;
            [SHKeyStorage shared].currentWalletModel.password = self.setTextFieldView.textField.text;
        }];
    }
    
    [MBProgressHUD showSuccess:GCLocalizedString(@"pwd_reset_success") toView:KeyWindow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SHWalletManagerController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    });
}

#pragma mark -- 取消
- (void)cancelButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 监听输入
- (void)editingTextField:(TGTextField *)textField text:(NSString *)str {
    if (IsEmpty(self.textView.text) || IsEmpty(self.setTextFieldView.textField.text) || IsEmpty(self.sureTextFieldView.textField.text)) {
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.sureButton.userInteractionEnabled = NO;
    } else {
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionLeftToRight] forState:UIControlStateNormal];
        self.sureButton.userInteractionEnabled = YES;
    }
    
    if (self.setTextFieldView.textField == textField) {
        self.setTextFieldView.clearButton.hidden = IsEmpty(str);
        self.passwordStrengthView.passwordStrengthType = [NSString judgePasswordStrength:str];
    } else if (self.sureTextFieldView.textField == textField) {
        self.sureTextFieldView.clearButton.hidden = IsEmpty(str);
    }
    
    if (self.setTextFieldView.viewType == SHTextFieldViewTypeError || self.sureTextFieldView.viewType == SHTextFieldViewTypeError) {
        [self resetTextFiledState];
    }
}

/// 重置输入框状态
- (void)resetTextFiledState {
    self.setTipLabel.text = @"";
    self.setTextFieldView.viewType = SHTextFieldViewTypeNormal;
    [self.sureTextFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setTextFieldView.mas_bottom).offset(8);
    }];
    self.sureTipLabel.text = @"";
    self.sureTextFieldView.viewType = SHTextFieldViewTypeNormal;
}



@end
