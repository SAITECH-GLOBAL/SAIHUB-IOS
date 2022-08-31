//
//  SHLNWalletSetPassWordViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/23.
//

#import "SHLNWalletSetPassWordViewController.h"

@interface SHLNWalletSetPassWordViewController ()
@property (nonatomic, strong) UILabel *setPassTipsLabel;
@property (nonatomic, strong) TGTextField *setPassTf;
@property (nonatomic, strong) UIButton *setSeeOrHidderButton;
@property (nonatomic, strong) UIView *setPassLineView;
@property (nonatomic, strong) TGTextField *resetPassTf;
@property (nonatomic, strong) UIButton *resetSeeOrHidderButton;
@property (nonatomic, strong) UIView *resetPassLineView;
@property (nonatomic, strong) UILabel *errorTipsLabel;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation SHLNWalletSetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.setPassTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(22*FitHeight);
    [self.setPassTipsLabel setSingleLineAutoResizeWithMaxWidth:350*FitWidth];
    
    
    
    self.setPassTf.sd_layout.leftEqualToView(self.setPassTipsLabel).topSpaceToView(self.setPassTipsLabel, 1*FitHeight).widthIs(300*FitWidth).heightIs(45*FitHeight);
    self.setSeeOrHidderButton.sd_layout.centerYEqualToView(self.setPassTf).rightSpaceToView(self.view, 20*FitWidth).widthIs(20*FitWidth).heightEqualToWidth();
    self.setPassLineView.sd_layout.leftEqualToView(self.setPassTipsLabel).rightEqualToView(self.setSeeOrHidderButton).topSpaceToView(self.setPassTf, 1*FitHeight).heightIs(1);
    self.resetPassTf.sd_layout.leftEqualToView(self.setPassLineView).topSpaceToView(self.setPassLineView, 15*FitHeight).widthIs(300*FitWidth).heightIs(45*FitHeight);
    self.resetSeeOrHidderButton.sd_layout.centerYEqualToView(self.resetPassTf).rightEqualToView(self.setPassLineView).widthIs(20*FitWidth).heightEqualToWidth();
    self.resetPassLineView.sd_layout.leftEqualToView(self.setPassLineView).rightEqualToView(self.setPassLineView).topSpaceToView(self.resetPassTf, 1*FitHeight).heightIs(1);
    self.errorTipsLabel.sd_layout.leftEqualToView(self.resetPassLineView).topSpaceToView(self.resetPassLineView, 8*FitHeight).heightIs(18*FitHeight);
    [self.errorTipsLabel setSingleLineAutoResizeWithMaxWidth:335*FitWidth];

    self.confirmButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.resetPassLineView, 80*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    self.cancelButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.confirmButton, 0).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    
}

#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
    //    if ([textField isEqual:self.remarkNameTf] && textField.text.length >=30) {
    //        textField.text = [textField.text substringToIndex:30];
    //    }
    if ([textField isEqual:self.setPassTf]||[textField isEqual:self.resetPassTf]) {
        self.setPassLineView.backgroundColor = SHTheme.appBlackColor;
        self.resetPassLineView.backgroundColor = SHTheme.appBlackColor;
        self.setPassLineView.alpha = 0.12;
        self.resetPassLineView.alpha = 0.12;
        self.errorTipsLabel.hidden = YES;
    }
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.setPassTf.text)&&!IsEmpty(self.resetPassTf.text)) {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = YES;
        
    }else
    {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = NO;
    }
}
#pragma mark 按钮事件
-(void)setSeeOrHidderButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.setPassTf.secureTextEntry = !self.setPassTf.secureTextEntry;
}
-(void)resetSeeOrHidderButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.resetPassTf.secureTextEntry = !self.resetPassTf.secureTextEntry;
}
-(void)confirmButtonAction:(UIButton *)btn
{
    if (![self.setPassTf.text isEqualToString:self.resetPassTf.text]) {
        self.setPassLineView.backgroundColor = SHTheme.errorTipsRedColor;
        self.resetPassLineView.backgroundColor = SHTheme.errorTipsRedColor;
        self.setPassLineView.alpha = 1;
        self.resetPassLineView.alpha = 1;
        self.errorTipsLabel.hidden = NO;
        self.errorTipsLabel.text = GCLocalizedString(@"pwd_repeat_tip");
        return;
    }
    if (self.setPassTf.text.length <8) {
        self.setPassLineView.backgroundColor = SHTheme.errorTipsRedColor;
        self.resetPassLineView.backgroundColor = SHTheme.errorTipsRedColor;
        self.setPassLineView.alpha = 1;
        self.resetPassLineView.alpha = 1;
        self.errorTipsLabel.hidden = NO;
        self.errorTipsLabel.text = GCLocalizedString(@"pwd_tip");
        return;
    }
    [self.setPassTf resignFirstResponder];
    [self.resetPassTf resignFirstResponder];
    
    [[SHKeyStorage shared] updateModelBlock:^{
        [SHKeyStorage shared].currentLNWalletModel.walletPassWord = self.setPassTf.text;
    }];
    [self popViewController];
    if (self.setPassWordBlock) {
        self.setPassWordBlock();
    }


}
-(void)cancelButtonAction:(UIButton *)btn
{
    [self popViewController];
}

#pragma mark 懒加载
-(UILabel *)setPassTipsLabel
{
    if (_setPassTipsLabel == nil) {
        _setPassTipsLabel = [[UILabel alloc]init];
        _setPassTipsLabel.font = kCustomMontserratMediumFont(14);
        _setPassTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _setPassTipsLabel.text = GCLocalizedString(@"set_password");
        [self.view addSubview:_setPassTipsLabel];
    }
    return _setPassTipsLabel;
}
-(TGTextField *)setPassTf
{
    if (_setPassTf == nil) {
        _setPassTf = [[TGTextField alloc]init];
        _setPassTf.tintColor = SHTheme.agreeButtonColor;
        _setPassTf.placeholder = GCLocalizedString(@"pwd_tip_0");
        _setPassTf.font = kCustomMontserratRegularFont(14);
        _setPassTf.secureTextEntry = YES;
        _setPassTf.clearButtonMode = UITextFieldViewModeAlways;
        [_setPassTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_setPassTf];
    }
    return _setPassTf;
}
-(TGTextField *)resetPassTf
{
    if (_resetPassTf == nil) {
        _resetPassTf = [[TGTextField alloc]init];
        _resetPassTf.tintColor = SHTheme.agreeButtonColor;
        _resetPassTf.placeholder = GCLocalizedString(@"pwd_tip_1");
        _resetPassTf.font = kCustomMontserratRegularFont(14);
        _resetPassTf.secureTextEntry = YES;
        _resetPassTf.clearButtonMode = UITextFieldViewModeAlways;
        [_resetPassTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_resetPassTf];
    }
    return _resetPassTf;
}
- (UIView *)setPassLineView
{
    if (_setPassLineView == nil) {
        _setPassLineView = [[UIView alloc]init];
        _setPassLineView.backgroundColor = SHTheme.appBlackColor;
        _setPassLineView.alpha = 0.12;
        [self.view addSubview:_setPassLineView];
    }
    return _setPassLineView;
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
-(UIButton *)setSeeOrHidderButton
{
    if (_setSeeOrHidderButton == nil) {
        _setSeeOrHidderButton = [[UIButton alloc]init];
        [_setSeeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_on"] forState:UIControlStateNormal];
        [_setSeeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_off"] forState:UIControlStateSelected];
        [_setSeeOrHidderButton addTarget:self action:@selector(setSeeOrHidderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_setSeeOrHidderButton];
    }
    return _setSeeOrHidderButton;
}
-(UIButton *)resetSeeOrHidderButton
{
    if (_resetSeeOrHidderButton == nil) {
        _resetSeeOrHidderButton = [[UIButton alloc]init];
        [_resetSeeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_on"] forState:UIControlStateNormal];
        [_resetSeeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_off"] forState:UIControlStateSelected];
        [_resetSeeOrHidderButton addTarget:self action:@selector(resetSeeOrHidderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_resetSeeOrHidderButton];
    }
    return _resetSeeOrHidderButton;
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
-(UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitle:GCLocalizedString(@"Cancel") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}
-(UILabel *)errorTipsLabel
{
    if (_errorTipsLabel == nil) {
        _errorTipsLabel = [[UILabel alloc]init];
        _errorTipsLabel.font = kCustomMontserratRegularFont(12);
        _errorTipsLabel.textColor = SHTheme.errorTipsRedColor;
        _errorTipsLabel.text = GCLocalizedString(@"pwd_repeat_tip");
        _errorTipsLabel.hidden = YES;
        [self.view addSubview:_errorTipsLabel];
    }
    return _errorTipsLabel;
}
@end
