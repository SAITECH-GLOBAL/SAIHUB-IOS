//
//  SHSetWalletPassWordViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/18.
//

#import "SHSetWalletPassWordViewController.h"
#import "SHPasswordStrength.h"
#import "SHSelectMnemonicViewController.h"
#import "SHImPortWalletViewController.h"
@interface SHSetWalletPassWordViewController ()
@property (nonatomic, strong) UILabel *walletNameTipsLabel;
@property (nonatomic, strong) UILabel *walletNameValueLabel;
@property (nonatomic, strong) UILabel *setPassTipsLabel;
@property (nonatomic, strong) TGTextField *setPassTf;
@property (nonatomic, strong) UIButton *setSeeOrHidderButton;
@property (nonatomic, strong) UIView *setPassLineView;
@property (nonatomic, strong) TGTextField *resetPassTf;
@property (nonatomic, strong) UIButton *resetSeeOrHidderButton;
@property (nonatomic, strong) UIView *resetPassLineView;
@property (nonatomic, strong) UILabel *adressTypeLabel;

@property (nonatomic, strong) UIButton *nativeSegWitButton;
@property (nonatomic, strong) UILabel *nativeSegWitTipsLabel;
@property (nonatomic, strong) UIImageView *nativeSegWitImageView;
@property (nonatomic, strong) UIButton *nestedSegWitButton;
@property (nonatomic, strong) UILabel *nestedSegWitTipsLabel;
@property (nonatomic, strong) UIImageView *nestedSegWitImageView;
@property (nonatomic, strong) UIButton *agreeSelectButton;
@property (nonatomic, strong) UILabel *agreeLabel;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UIButton *importButton;
@property (nonatomic, strong) SHPasswordStrength *passwordStrengthView;

@property (nonatomic, strong) UILabel *errorTipsLabel;

@end

@implementation SHSetWalletPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"add_wallet");
    [self layoutScale];
    // Do any additional setup after loading the view.
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.walletNameTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 24*FitHeight).heightIs(22*FitHeight);
    [self.walletNameTipsLabel setSingleLineAutoResizeWithMaxWidth:350*FitWidth];
    self.walletNameValueLabel.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(self.walletNameTipsLabel).heightIs(22*FitHeight);
    [self.walletNameValueLabel setSingleLineAutoResizeWithMaxWidth:350*FitWidth];
    self.setPassTipsLabel.sd_layout.leftEqualToView(self.walletNameTipsLabel).topSpaceToView(self.walletNameTipsLabel, 24*FitHeight).heightIs(22*FitHeight);
    [self.setPassTipsLabel setSingleLineAutoResizeWithMaxWidth:350*FitWidth];
//    self.thirdIntensityView.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(self.setPassTipsLabel).widthIs(16*FitWidth).heightIs(4*FitHeight);
//    self.secondIntensityView.sd_layout.rightSpaceToView(self.thirdIntensityView, 4*FitWidth).centerYEqualToView(self.setPassTipsLabel).widthIs(16*FitWidth).heightIs(4*FitHeight);
//    self.firstIntensityView.sd_layout.rightSpaceToView(self.secondIntensityView, 4*FitWidth).centerYEqualToView(self.setPassTipsLabel).widthIs(16*FitWidth).heightIs(4*FitHeight);
//    self.intensityTipsLabel.sd_layout.rightSpaceToView(self.firstIntensityView, 4*FitWidth).centerYEqualToView(self.setPassTipsLabel).heightIs(14*FitHeight);
//    [self.intensityTipsLabel setSingleLineAutoResizeWithMaxWidth:100];
    self.passwordStrengthView.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(self.setPassTipsLabel).widthIs(300*FitWidth).heightIs(14*FitHeight);
    

    self.setPassTf.sd_layout.leftEqualToView(self.setPassTipsLabel).topSpaceToView(self.setPassTipsLabel, 1*FitHeight).widthIs(300*FitWidth).heightIs(45*FitHeight);
    self.setSeeOrHidderButton.sd_layout.centerYEqualToView(self.setPassTf).rightSpaceToView(self.view, 20*FitWidth).widthIs(20*FitWidth).heightEqualToWidth();
    self.setPassLineView.sd_layout.leftEqualToView(self.setPassTipsLabel).rightEqualToView(self.setSeeOrHidderButton).topSpaceToView(self.setPassTf, 1*FitHeight).heightIs(1);
    self.resetPassTf.sd_layout.leftEqualToView(self.setPassLineView).topSpaceToView(self.setPassLineView, 15*FitHeight).widthIs(300*FitWidth).heightIs(45*FitHeight);
    self.resetSeeOrHidderButton.sd_layout.centerYEqualToView(self.resetPassTf).rightEqualToView(self.setPassLineView).widthIs(20*FitWidth).heightEqualToWidth();
    self.resetPassLineView.sd_layout.leftEqualToView(self.setPassLineView).rightEqualToView(self.setPassLineView).topSpaceToView(self.resetPassTf, 1*FitHeight).heightIs(1);
    self.errorTipsLabel.sd_layout.leftEqualToView(self.resetPassLineView).topSpaceToView(self.resetPassLineView, 8*FitHeight).heightIs(18*FitHeight);
    [self.errorTipsLabel setSingleLineAutoResizeWithMaxWidth:335*FitWidth];
    self.adressTypeLabel.sd_layout.leftEqualToView(self.resetPassLineView).topSpaceToView(self.resetPassLineView, 24*FitHeight).heightIs(22*FitHeight);
    [self.adressTypeLabel setSingleLineAutoResizeWithMaxWidth:300*FitWidth];
    self.nativeSegWitButton.sd_layout.leftEqualToView(self.adressTypeLabel).topSpaceToView(self.adressTypeLabel, 20*FitHeight).widthIs(335*FitHeight).heightIs(60*FitHeight);
    self.nativeSegWitTipsLabel.sd_layout.leftSpaceToView(self.nativeSegWitButton, 16*FitWidth).centerYEqualToView(self.nativeSegWitButton).heightIs(22*FitHeight);
    [self.nativeSegWitTipsLabel setSingleLineAutoResizeWithMaxWidth:300*FitWidth];
    self.nativeSegWitImageView.sd_layout.rightSpaceToView(self.nativeSegWitButton, 16*FitWidth).centerYEqualToView(self.nativeSegWitButton).widthIs(20*FitWidth).heightEqualToWidth();
    
    self.nestedSegWitButton.sd_layout.leftEqualToView(self.adressTypeLabel).topSpaceToView(self.nativeSegWitButton, 16*FitHeight).widthIs(335*FitHeight).heightIs(60*FitHeight);
    self.nestedSegWitTipsLabel.sd_layout.leftSpaceToView(self.nestedSegWitButton, 16*FitWidth).centerYEqualToView(self.nestedSegWitButton).heightIs(22*FitHeight);
    [self.nestedSegWitTipsLabel setSingleLineAutoResizeWithMaxWidth:300*FitWidth];
    self.nestedSegWitImageView.sd_layout.rightSpaceToView(self.nestedSegWitButton, 16*FitWidth).centerYEqualToView(self.nestedSegWitButton).widthIs(20*FitWidth).heightEqualToWidth();
    
    self.agreeLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.nestedSegWitButton, 42*FitHeight).heightIs(22*FitHeight);
    [self.agreeLabel setSingleLineAutoResizeWithMaxWidth:350*FitWidth];
    self.agreeSelectButton.sd_layout.rightSpaceToView(self.agreeLabel, 7*FitWidth).centerYEqualToView(self.agreeLabel).widthIs(20*FitWidth).heightEqualToWidth();
    self.createButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.agreeSelectButton, 25*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    self.importButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.createButton, 0).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.createButton setBackgroundImage:[UIImage gradientImageWithBounds:self.createButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    self.passwordStrengthView.passwordStrengthType = SHPasswordStrengthNormalType;

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
-(void)nativeSegWitButtonAction:(UIButton *)btn
{
    self.nativeSegWitButton.layer.borderWidth = 1;
    self.nativeSegWitButton.selected = YES;
    self.nativeSegWitTipsLabel.textColor = SHTheme.agreeButtonColor;
    self.nativeSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_select"];
    
    self.nestedSegWitButton.layer.borderWidth = 0;
    self.nestedSegWitButton.selected = NO;
    self.nestedSegWitTipsLabel.textColor = SHTheme.agreeTipsLabelColor;
    self.nestedSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
    
    [self layoutStartButtonColor];

}
-(void)nestedSegWitButtonAction:(UIButton *)btn
{
    self.nestedSegWitButton.layer.borderWidth = 1;
    self.nestedSegWitButton.selected = YES;
    self.nestedSegWitTipsLabel.textColor = SHTheme.agreeButtonColor;
    self.nestedSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_select"];
    
    self.nativeSegWitButton.layer.borderWidth = 0;
    self.nativeSegWitButton.selected = NO;
    self.nativeSegWitTipsLabel.textColor = SHTheme.agreeTipsLabelColor;
    self.nativeSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
    
    [self layoutStartButtonColor];

}
-(void)agreeSelectButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self layoutStartButtonColor];
}
-(void)createButtonAction:(UIButton *)btn
{
    if (![self.setPassTf.text isEqualToString:self.resetPassTf.text]) {
        self.setPassLineView.backgroundColor = SHTheme.errorTipsRedColor;
        self.resetPassLineView.backgroundColor = SHTheme.errorTipsRedColor;
        self.setPassLineView.alpha = 1;
        self.resetPassLineView.alpha = 1;
        self.errorTipsLabel.hidden = NO;
        [MBProgressHUD showError:GCLocalizedString(@"pwd_repeat_tip") toView:self.view];
        return;
    }
    if (self.setPassTf.text.length <8) {
        [MBProgressHUD showError:GCLocalizedString(@"pwd_tip") toView:self.view];
        return;
    }
    SHSelectMnemonicViewController *selectMnemonicViewController = [[SHSelectMnemonicViewController alloc]init];
    selectMnemonicViewController.passWord = self.setPassTf.text;
    selectMnemonicViewController.adressType = self.nativeSegWitButton.selected?1:2;
    selectMnemonicViewController.selectedNestedSegWitButton = self.nestedSegWitButton.selected;
    selectMnemonicViewController.walletName = self.walletNameValueLabel.text;
    [self.navigationController pushViewController:selectMnemonicViewController animated:YES];
}
-(void)importButtonAction:(UIButton *)btn
{
    SHImPortWalletViewController *imPortWalletViewController = [SHImPortWalletViewController new];
    imPortWalletViewController.walletName = [NSString stringWithFormat:@"BTC-%@",[self randomStringWithLength:4]];
    [self.navigationController pushViewController:imPortWalletViewController animated:YES];
}
- (void)tapGesture :(UITapGestureRecognizer *)tap
{
    switch (KAppSetting.language) {
        case SHApplicationLanguageEn:
        {
            SHPublicWebViewController *publicWebViewController = [[SHPublicWebViewController alloc]init];
            publicWebViewController.url = @"https://app.sai.tech/service/terms_en.html";
            [self.navigationController pushViewController:publicWebViewController animated:YES];
        }
            break;
        case SHApplicationLanguageZhHans:
        {
            SHPublicWebViewController *publicWebViewController = [[SHPublicWebViewController alloc]init];
            publicWebViewController.url = @"https://app.sai.tech/service/terms_zh.html";
            [self.navigationController pushViewController:publicWebViewController animated:YES];
        }
            break;
        case SHApplicationLanguageZhHant:
        {
            SHPublicWebViewController *publicWebViewController = [[SHPublicWebViewController alloc]init];
            publicWebViewController.url = @"https://app.sai.tech/service/terms_zh_HK.html";
            [self.navigationController pushViewController:publicWebViewController animated:YES];
        }
            break;
        case SHApplicationLanguageRussian:
        {
            SHPublicWebViewController *publicWebViewController = [[SHPublicWebViewController alloc]init];
            publicWebViewController.url = @"https://app.sai.tech/service/terms_ru.html";
            [self.navigationController pushViewController:publicWebViewController animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
//    if ([textField isEqual:self.remarkNameTf] && textField.text.length >=30) {
//        textField.text = [textField.text substringToIndex:30];
//    }
    self.setPassLineView.backgroundColor = SHTheme.appBlackColor;
    self.resetPassLineView.backgroundColor = SHTheme.appBlackColor;
    self.setPassLineView.alpha = 0.12;
    self.resetPassLineView.alpha = 0.12;
    self.errorTipsLabel.hidden = YES;
    if ([textField isEqual:self.setPassTf]) {
        self.passwordStrengthView.passwordStrengthType = [NSString judgePasswordStrength:textField.text];
    }
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.setPassTf.text)&&!IsEmpty(self.resetPassTf.text)&&(self.nativeSegWitButton.selected||self.nestedSegWitButton.selected)&&self.agreeSelectButton.selected) {
        [self.createButton setBackgroundImage:[UIImage gradientImageWithBounds:self.createButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.createButton.enabled = YES;
    }else
    {
        [self.createButton setBackgroundImage:[UIImage gradientImageWithBounds:self.createButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.createButton.enabled = NO;
    }
}
-(NSString *)randomStringWithLength:(NSInteger)len {
     NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
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
        _walletNameValueLabel.font = kCustomMontserratMediumFont(20);
        _walletNameValueLabel.textColor = SHTheme.walletNameLabelColor;
        _walletNameValueLabel.text = [NSString stringWithFormat:@"BTC-%@",[self randomStringWithLength:4]];
        [self.view addSubview:_walletNameValueLabel];
    }
    return _walletNameValueLabel;
}
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
-(UILabel *)adressTypeLabel
{
    if (_adressTypeLabel == nil) {
        _adressTypeLabel = [[UILabel alloc]init];
        _adressTypeLabel.font = kCustomMontserratMediumFont(14);
        _adressTypeLabel.textColor = SHTheme.setPasswordTipsColor;
        _adressTypeLabel.text = GCLocalizedString(@"Address Type");
        [self.view addSubview:_adressTypeLabel];
    }
    return _adressTypeLabel;
}
-(UILabel *)nestedSegWitTipsLabel
{
    if (_nestedSegWitTipsLabel == nil) {
        _nestedSegWitTipsLabel = [[UILabel alloc]init];
        _nestedSegWitTipsLabel.font = kCustomMontserratRegularFont(14);
        _nestedSegWitTipsLabel.textColor = SHTheme.agreeTipsLabelColor;
        _nestedSegWitTipsLabel.text = GCLocalizedString(@"nested_segWit");
        [self.nestedSegWitButton addSubview:_nestedSegWitTipsLabel];
    }
    return _nestedSegWitTipsLabel;
}
-(UILabel *)nativeSegWitTipsLabel
{
    if (_nativeSegWitTipsLabel == nil) {
        _nativeSegWitTipsLabel = [[UILabel alloc]init];
        _nativeSegWitTipsLabel.font = kCustomMontserratRegularFont(14);
        _nativeSegWitTipsLabel.textColor = SHTheme.agreeTipsLabelColor;
        _nativeSegWitTipsLabel.text = GCLocalizedString(@"native_segWit");
        [self.nativeSegWitButton addSubview:_nativeSegWitTipsLabel];
    }
    return _nativeSegWitTipsLabel;
}
-(UILabel *)agreeLabel
{
    if (_agreeLabel == nil) {
        _agreeLabel = [[UILabel alloc]init];
        _agreeLabel.font = kCustomMontserratRegularFont(12);
        _agreeLabel.textColor = SHTheme.agreeTipsLabelColor;
        _agreeLabel.userInteractionEnabled = YES;
        NSMutableAttributedString * content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",GCLocalizedString(@"privacy_tip"),GCLocalizedString(@"privacy_service")]];
        [content addAttribute:NSForegroundColorAttributeName value:SHTheme.agreeTipsLabelColor range:[[content string] rangeOfString:GCLocalizedString(@"privacy_service")]];
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[[content string] rangeOfString:GCLocalizedString(@"privacy_service")]];
        //设置高亮色和点击事件
        [content setTextHighlightRange:[[content string] rangeOfString:GCLocalizedString(@"privacy_service")] color:SHTheme.agreeButtonColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"24234");
        }];
        _agreeLabel.attributedText = content;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [_agreeLabel addGestureRecognizer:tap];
        [self.view addSubview:_agreeLabel];
    }
    return _agreeLabel;
}

-(TGTextField *)setPassTf
{
    if (_setPassTf == nil) {
        _setPassTf = [[TGTextField alloc]init];
        _setPassTf.tintColor = SHTheme.agreeButtonColor;
        _setPassTf.placeholder = GCLocalizedString(@"pwd_tip_0");
        _setPassTf.font = kCustomMontserratRegularFont(14);
        _setPassTf.clearButtonMode = UITextFieldViewModeAlways;
        _setPassTf.secureTextEntry = YES;
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
        _resetPassTf.clearButtonMode = UITextFieldViewModeAlways;
        _resetPassTf.secureTextEntry = YES;
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
-(UIButton *)nativeSegWitButton
{
    if (_nativeSegWitButton == nil) {
        _nativeSegWitButton = [[UIButton alloc]init];
        _nativeSegWitButton.backgroundColor = SHTheme.addressTypeCellBackColor;
        _nativeSegWitButton.layer.cornerRadius = 8;
        _nativeSegWitButton.layer.borderColor = SHTheme.agreeButtonColor.CGColor;
        _nativeSegWitButton.layer.borderWidth = 0;
        _nativeSegWitButton.layer.masksToBounds = YES;
        [_nativeSegWitButton addTarget:self action:@selector(nativeSegWitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nativeSegWitButton];
    }
    return _nativeSegWitButton;
}
-(UIButton *)nestedSegWitButton
{
    if (_nestedSegWitButton == nil) {
        _nestedSegWitButton = [[UIButton alloc]init];
        _nestedSegWitButton.backgroundColor = SHTheme.addressTypeCellBackColor;
        _nestedSegWitButton.layer.cornerRadius = 8;
        _nestedSegWitButton.layer.borderColor = SHTheme.agreeButtonColor.CGColor;
        _nestedSegWitButton.layer.borderWidth = 0;
        _nestedSegWitButton.layer.masksToBounds = YES;
        [_nestedSegWitButton addTarget:self action:@selector(nestedSegWitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nestedSegWitButton];
    }
    return _nestedSegWitButton;
}
-(UIButton *)agreeSelectButton
{
    if (_agreeSelectButton == nil) {
        _agreeSelectButton = [[UIButton alloc]init];
        [_agreeSelectButton setImage:[UIImage imageNamed:@"agreeMentVc_selectButton_black_normal"] forState:UIControlStateNormal];
        [_agreeSelectButton setImage:[UIImage imageNamed:@"agreeMentVc_selectButton_select"] forState:UIControlStateSelected];
        [_agreeSelectButton addTarget:self action:@selector(agreeSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_agreeSelectButton];
    }
    return _agreeSelectButton;
}
-(UIButton *)createButton
{
    if (_createButton == nil) {
        _createButton = [[UIButton alloc]init];
        _createButton.layer.cornerRadius = 26*FitHeight;
        _createButton.layer.masksToBounds = YES;
        _createButton.enabled = NO;
        [_createButton setTitle:GCLocalizedString(@"Create") forState:UIControlStateNormal];
        [_createButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _createButton.titleLabel.font = kMediunFont(14);
        [_createButton addTarget:self action:@selector(createButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_createButton];
    }
    return _createButton;
}
-(UIButton *)importButton
{
    if (_importButton == nil) {
        _importButton = [[UIButton alloc]init];
        [_importButton setTitle:GCLocalizedString(@"import_wallet") forState:UIControlStateNormal];
        [_importButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _importButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_importButton addTarget:self action:@selector(importButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_importButton];
    }
    return _importButton;
}
-(UIImageView *)nativeSegWitImageView
{
    if (_nativeSegWitImageView == nil) {
        _nativeSegWitImageView = [[UIImageView alloc]init];
        _nativeSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
        [self.nativeSegWitButton addSubview:_nativeSegWitImageView];
    }
    return _nativeSegWitImageView;
}
-(UIImageView *)nestedSegWitImageView
{
    if (_nestedSegWitImageView == nil) {
        _nestedSegWitImageView = [[UIImageView alloc]init];
        _nestedSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
        [self.nestedSegWitButton addSubview:_nestedSegWitImageView];
    }
    return _nestedSegWitImageView;
}
-(SHPasswordStrength *)passwordStrengthView
{
    if (_passwordStrengthView == nil) {
        _passwordStrengthView = [[SHPasswordStrength alloc]init];
        [self.view addSubview:_passwordStrengthView];
    }
    return _passwordStrengthView;
}
-(UILabel *)errorTipsLabel
{
    if (_errorTipsLabel == nil) {
        _errorTipsLabel = [[UILabel alloc]init];
        _errorTipsLabel.font = kCustomMontserratRegularFont(12);
        _errorTipsLabel.textColor = SHTheme.errorTipsRedColor;
        _errorTipsLabel.text = GCLocalizedString(@"passphrase_repeat_tip");
        _errorTipsLabel.hidden = YES;
        [self.view addSubview:_errorTipsLabel];
    }
    return _errorTipsLabel;
}
@end
