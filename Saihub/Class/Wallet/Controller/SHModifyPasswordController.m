//
//  SHModifyPasswordController.m
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import "SHModifyPasswordController.h"
#import "SHTextFieldView.h"
#import "SHForgetPwdPopController.h"
#import "SHCompleteView.h"
#import "SHPasswordStrength.h"
#import "SHVerifyMnemonicController.h"

@interface SHModifyPasswordController () <TGTextFieldDelegate>

@property (nonatomic, weak) SHTextFieldView *oldTextFieldView;

@property (nonatomic, weak) SHTextFieldView *setTextFieldView;

@property (nonatomic, weak) UILabel *setPwdLabel;

@property (nonatomic, weak) SHTextFieldView *sureTextFieldView;

@property (nonatomic, weak) SHPasswordStrength *passwordStrengthView;

@property (nonatomic, weak) UIButton *sureButton;

/// 旧密码错误提示
@property (nonatomic, strong) UILabel *oldTipLabel;

/// 确认密码错误提示
@property (nonatomic, strong) UILabel *sureTipLabel;

@end

@implementation SHModifyPasswordController

- (UILabel *)oldTipLabel {
    if (_oldTipLabel == nil) {
        _oldTipLabel = [[UILabel alloc]init];
        _oldTipLabel.font = kCustomMontserratRegularFont(12);
        _oldTipLabel.textColor = SHTheme.errorTipsRedColor;
        [self.view addSubview:_oldTipLabel];
    }
    return _oldTipLabel;
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

    self.titleLabel.text = GCLocalizedString(@"modify_password");
    
    // 旧密码
    UILabel *oldPwdLabel = [[UILabel alloc]init];
    oldPwdLabel.text = GCLocalizedString(@"old_password");
    oldPwdLabel.textColor = SHTheme.setPasswordTipsColor;
    oldPwdLabel.font = kCustomMontserratMediumFont(14);
    [self.view addSubview:oldPwdLabel];
    [oldPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
    }];
    
    SHTextFieldView *oldTextFieldView = [[SHTextFieldView alloc]init];
    self.oldTextFieldView = oldTextFieldView;
    oldTextFieldView.textField.placeholder = GCLocalizedString(@"enter_old_pwd");
    oldTextFieldView.textField.TGTextFieldDelegate = self;
    oldTextFieldView.textField.tg_placeholderColor = SHTheme.pageUnselectColor;
    [self.view addSubview:oldTextFieldView];
    [oldTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(oldPwdLabel.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    
    [self.oldTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldTextFieldView);
        make.top.equalTo(oldTextFieldView.mas_bottom).offset(8);
    }];
        
    // 新密码
    UILabel *newPwdLabel = [[UILabel alloc]init];
    self.setPwdLabel = newPwdLabel;
    newPwdLabel.text = GCLocalizedString(@"new_password");
    newPwdLabel.textColor = SHTheme.setPasswordTipsColor;
    newPwdLabel.font = kCustomMontserratMediumFont(14);
    [self.view addSubview:newPwdLabel];
    [newPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(oldTextFieldView.mas_bottom).offset(24).priorityMedium();
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
        
    // 密码强度等级
    SHPasswordStrength *passwordStrengthView = [[SHPasswordStrength alloc]init];
    self.passwordStrengthView = passwordStrengthView;
    passwordStrengthView.passwordStrengthType = SHPasswordStrengthNormalType;
    [self.view addSubview:passwordStrengthView];
    [passwordStrengthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(newPwdLabel);
    }];

    // 确认密码
    UILabel *surePwdLabel = [[UILabel alloc]init];
    surePwdLabel.text = GCLocalizedString(@"new_password");
    surePwdLabel.textColor = SHTheme.setPasswordTipsColor;
    surePwdLabel.font = kCustomMontserratMediumFont(14);
    [self.view addSubview:surePwdLabel];
    [surePwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 );
        make.top.equalTo(newTextFieldView.mas_bottom).offset(8).priorityMedium();
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
        make.top.equalTo(surePwdLabel.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    
    // 错误提示
    [self.sureTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sureTextFieldView);
        make.top.equalTo(sureTextFieldView.mas_bottom).offset(8);
    }];

    // 忘记密码
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetButton setTitle:GCLocalizedString(@"forget_password") forState:UIControlStateNormal];
    [forgetButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
    forgetButton.titleLabel.font = kCustomMontserratMediumFont(14);
    [forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-22);
        make.top.equalTo(sureTextFieldView.mas_bottom).offset(16);
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
        make.top.mas_equalTo(forgetButton.mas_bottom).offset(42);
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

#pragma mark -- 忘记密码
- (void)forgetButtonClick {
    MJWeakSelf
    SHForgetPwdPopController *forgetPwdPopVc = [[SHForgetPwdPopController alloc]init];
    forgetPwdPopVc.pushResetPwdBlock = ^{
        SHVerifyMnemonicController *verifyVc = [[SHVerifyMnemonicController alloc]init];
        [weakSelf.navigationController pushViewController:verifyVc animated:YES];
    };
    [self presentPanModal:forgetPwdPopVc];
}

#pragma mark -- 确认
- (void)sureButtonClick {
    
    if (![NSString validePasswordFormat:self.oldTextFieldView.textField.text]) {
        
        self.oldTextFieldView.viewType = SHTextFieldViewTypeError;
        
        self.oldTipLabel.text = GCLocalizedString(@"error_pwd_style");
        
        [self.setPwdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.oldTextFieldView.mas_bottom).offset(50);
        }];
        
        return;
    }
    
    if (![NSString validePasswordFormat:self.setTextFieldView.textField.text]) {
        self.sureTextFieldView.viewType = SHTextFieldViewTypeError;
        
        self.sureTipLabel.text = GCLocalizedString(@"error_pwd_style");
                
        return;
    }
    
    if ([self.setTextFieldView.textField.text isEqualToString:self.sureTextFieldView.textField.text] == NO) {
        
        self.sureTextFieldView.viewType = SHTextFieldViewTypeError;
        
        self.sureTipLabel.text = GCLocalizedString(@"pwd_not_match");
        
        return;
    }
    
    if (![self.oldTextFieldView.textField.text isEqual:[SHKeyStorage shared].currentWalletModel.password]) {
        
        self.oldTextFieldView.viewType = SHTextFieldViewTypeError;
        
        self.oldTipLabel.text = GCLocalizedString(@"wrong_passwrod");
        
        [self.setPwdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.oldTextFieldView.mas_bottom).offset(50);
        }];
        return;
    }
    
    [[SHKeyStorage shared] updateModelBlock:^{
        [SHKeyStorage shared].currentWalletModel.password = self.setTextFieldView.textField.text;
    }];
    
    MJWeakSelf
    SHCompleteView *completeView = [[SHCompleteView alloc]init];
    completeView.completeViewType = CompleteViewSucceseType;
    completeView.completeBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [completeView presentInView:self.view];
}

#pragma mark -- 取消
- (void)cancelButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 监听输入
- (void)editingTextField:(TGTextField *)textField text:(NSString *)str {
    if (IsEmpty(self.oldTextFieldView.textField.text) || IsEmpty(self.setTextFieldView.textField.text) || IsEmpty(self.sureTextFieldView.textField.text)) {
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.sureButton.userInteractionEnabled = NO;
    } else {
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionLeftToRight] forState:UIControlStateNormal];
        self.sureButton.userInteractionEnabled = YES;
    }
    
    if (self.oldTextFieldView.textField == textField) {
        self.oldTextFieldView.clearButton.hidden = IsEmpty(str);
    } else if (self.setTextFieldView.textField == textField) {
        self.setTextFieldView.clearButton.hidden = IsEmpty(str);
        self.passwordStrengthView.passwordStrengthType = [NSString judgePasswordStrength:str];
    } else if (self.sureTextFieldView.textField == textField) {
        self.sureTextFieldView.clearButton.hidden = IsEmpty(str);
    }
    
    if (self.oldTextFieldView.viewType == SHTextFieldViewTypeError || self.sureTextFieldView.viewType == SHTextFieldViewTypeError) {
        [self resetTextFiledState];
    }
}

/// 重置输入框状态
- (void)resetTextFiledState {
    self.oldTipLabel.text = @"";
    self.oldTextFieldView.viewType = SHTextFieldViewTypeNormal;
    [self.setPwdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oldTextFieldView.mas_bottom).offset(24);
    }];
    
    self.sureTipLabel.text = @"";
    self.sureTextFieldView.viewType = SHTextFieldViewTypeNormal;
}


@end
