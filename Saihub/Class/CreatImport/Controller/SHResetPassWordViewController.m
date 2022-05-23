//
//  SHResetPassWordViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/18.
//

#import "SHResetPassWordViewController.h"
@interface SHResetPassWordViewController ()
@property (nonatomic, strong) UILabel *resetPassTipsLabel;
@property (nonatomic, strong) TGTextField *resetPassTf;
@property (nonatomic, strong) UIButton *seeOrHidderButton;
@property (nonatomic, strong) UIView *resetPassLineView;
@property (nonatomic, strong) UILabel *resetPassErrorTips;
@property (nonatomic, strong) UILabel *firstUnlockPassLabel;
@property (nonatomic, strong) SHpassWordView *firstUnlockTf;
@property (nonatomic, strong) UILabel *secondUnlockPassLabel;
@property (nonatomic, strong) SHpassWordView *secondUnlockTf;
@property (nonatomic, strong) UILabel *noMatchTipsLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancleButton;

@end

@implementation SHResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"Reset");
    [self layoutScale];
    // Do any additional setup after loading the view.
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.resetPassTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 16*FitHeight).heightIs(22*FitHeight);
    [self.resetPassTipsLabel setSingleLineAutoResizeWithMaxWidth:350*FitWidth];
    self.resetPassTf.sd_layout.leftEqualToView(self.resetPassTipsLabel).topSpaceToView(self.resetPassTipsLabel, 1*FitHeight).widthIs(300*FitWidth).heightIs(45*FitHeight);
    self.seeOrHidderButton.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(self.resetPassTf).widthIs(20*FitWidth).heightIs(20*FitHeight);
    self.resetPassLineView.sd_layout.leftEqualToView(self.resetPassTf).rightEqualToView(self.seeOrHidderButton).topSpaceToView(self.resetPassTf, 1*FitHeight).heightIs(1);
    self.resetPassErrorTips.sd_layout.leftEqualToView(self.resetPassLineView).topSpaceToView(self.resetPassLineView, 8*FitHeight).rightEqualToView(self.resetPassLineView).heightIs(18*FitHeight);
    self.firstUnlockPassLabel.sd_layout.leftEqualToView(self.resetPassLineView).rightEqualToView(self.resetPassLineView).topSpaceToView(self.resetPassLineView, 38*FitHeight).heightIs(22*FitHeight);
    self.firstUnlockTf.sd_layout.leftEqualToView(self.view).topSpaceToView(self.firstUnlockPassLabel, 8*FitHeight).rightEqualToView(self.view).heightIs(ceil(40*FitHeight));
    self.secondUnlockPassLabel.sd_layout.leftEqualToView(self.firstUnlockPassLabel).topSpaceToView(self.firstUnlockTf, 12*FitHeight).heightIs(22*FitHeight);
    [self.secondUnlockPassLabel setSingleLineAutoResizeWithMaxWidth:350*FitWidth];
    self.secondUnlockTf.sd_layout.leftEqualToView(self.view).topSpaceToView(self.secondUnlockPassLabel, 8*FitHeight).rightEqualToView(self.view).heightIs(ceil(40*FitHeight));
    self.noMatchTipsLabel.sd_layout.leftEqualToView(self.resetPassLineView).topSpaceToView(self.secondUnlockTf, 8*FitHeight).rightEqualToView(self.resetPassLineView).heightIs(22*FitHeight);

    self.confirmButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.secondUnlockTf, 37*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    self.cancleButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.confirmButton, 0).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
    self.resetPassLineView.backgroundColor = SHTheme.appBlackColor;
    self.resetPassErrorTips.hidden = YES;
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.resetPassTf.text)&&self.firstUnlockTf.pswTF.text.length == 6&&self.secondUnlockTf.pswTF.text.length == 6&&[self.firstUnlockTf.pswTF.text isEqualToString:self.secondUnlockTf.pswTF.text]) {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = YES;
    }else
    {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = NO;
    }
}
-(void)compareTfPassWord
{
    if (self.firstUnlockTf.pswTF.text.length == 6&&self.secondUnlockTf.pswTF.text.length == 6) {
        if ([self.firstUnlockTf.pswTF.text isEqualToString:self.secondUnlockTf.pswTF.text]) {
            self.noMatchTipsLabel.hidden = YES;
        }else
        {
            self.noMatchTipsLabel.hidden = NO;
        }
    }else
    {
        self.noMatchTipsLabel.hidden = YES;
    }
}
-(void)compareResetPassWord
{
    BOOL haveSamePassWord = NO;
    RLMResults<SHWalletModel *> *wallets = [SHWalletModel allObjects];
    for (SHWalletModel *subModel in wallets) {
        if ([subModel.password isEqualToString:self.resetPassTf.text]) {
            haveSamePassWord = YES;
        }
    }
    if (haveSamePassWord) {
        self.resetPassLineView.backgroundColor = SHTheme.appBlackColor;
        self.resetPassErrorTips.hidden = YES;
    }else
    {
        self.resetPassLineView.backgroundColor = SHTheme.errorTipsRedColor;
        self.resetPassErrorTips.hidden = NO;
    }
}
#pragma mark 按钮事件
-(void)seeOrHidderButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.resetPassTf.secureTextEntry = !self.resetPassTf.secureTextEntry;

}
-(void)confirmButtonAction:(UIButton *)btn
{
    [self compareResetPassWord];
    BOOL haveSamePassWord = NO;
    RLMResults<SHWalletModel *> *wallets = [SHWalletModel allObjects];
    for (SHWalletModel *subModel in wallets) {
        if ([subModel.password isEqualToString:self.resetPassTf.text]) {
            haveSamePassWord = YES;
        }
    }
    if (haveSamePassWord) {
        [MBProgressHUD showSuccess:GCLocalizedString(@"Reset_successfully") toView:nil];
        KAppSetting.unlockedPassWord = self.firstUnlockTf.pswTF.text;
        [self popViewController];
    }
}
-(void)cancleButtonAction:(UIButton *)btn
{
    [self popViewController];
}
#pragma mark 懒加载
-(UILabel *)resetPassTipsLabel
{
    if (_resetPassTipsLabel == nil) {
        _resetPassTipsLabel = [[UILabel alloc]init];
        _resetPassTipsLabel.font = kCustomMontserratMediumFont(14);
        _resetPassTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _resetPassTipsLabel.text = GCLocalizedString(@"reset_password");
        [self.view addSubview:_resetPassTipsLabel];
    }
    return _resetPassTipsLabel;
}
-(TGTextField *)resetPassTf
{
    if (_resetPassTf == nil) {
        _resetPassTf = [[TGTextField alloc]init];
        _resetPassTf.tintColor = SHTheme.agreeButtonColor;
        _resetPassTf.placeholder = GCLocalizedString(@"reset_hint");
        _resetPassTf.font = kCustomMontserratRegularFont(14);
        _resetPassTf.clearButtonMode = UITextFieldViewModeAlways;
        _resetPassTf.secureTextEntry = YES;
        [_resetPassTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_resetPassTf];
    }
    return _resetPassTf;
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
-(UILabel *)firstUnlockPassLabel
{
    if (_firstUnlockPassLabel == nil) {
        _firstUnlockPassLabel = [[UILabel alloc]init];
        _firstUnlockPassLabel.font = kCustomMontserratMediumFont(14);
        _firstUnlockPassLabel.textColor = SHTheme.setPasswordTipsColor;
        _firstUnlockPassLabel.text = GCLocalizedString(@"reset_password_0");
        [self.view addSubview:_firstUnlockPassLabel];
    }
    return _firstUnlockPassLabel;
}
-(SHpassWordView *)firstUnlockTf
{
    MJWeakSelf;
    if (_firstUnlockTf == nil) {
        _firstUnlockTf = [[SHpassWordView alloc]init];
        _firstUnlockTf.leftMargin = 20*FitWidth;
        _firstUnlockTf.Itemspacing = 19*FitWidth;
        _firstUnlockTf.ItemWidth = 40*FitWidth;
        _firstUnlockTf.ItemHeight = 40*FitWidth;
        _firstUnlockTf.itemCount = 6;
        _firstUnlockTf.isShowPassWord = @"2";
        [_firstUnlockTf initUI];
        _firstUnlockTf.valueChangeBtnBlock = ^(NSString * _Nonnull textValue) {
            if (textValue.length == 6) {
                [weakSelf compareTfPassWord];
                [weakSelf layoutStartButtonColor];
            }else
            {
                weakSelf.noMatchTipsLabel.hidden = YES;
            }
        };
        [self.view addSubview:_firstUnlockTf];
    }
    return _firstUnlockTf;
}
-(UILabel *)secondUnlockPassLabel
{
    if (_secondUnlockPassLabel == nil) {
        _secondUnlockPassLabel = [[UILabel alloc]init];
        _secondUnlockPassLabel.font = kCustomMontserratMediumFont(14);
        _secondUnlockPassLabel.textColor = SHTheme.setPasswordTipsColor;
        _secondUnlockPassLabel.text = GCLocalizedString(@"reset_password_1");
        [self.view addSubview:_secondUnlockPassLabel];
    }
    return _secondUnlockPassLabel;
}
-(SHpassWordView *)secondUnlockTf
{
    MJWeakSelf;
    if (_secondUnlockTf == nil) {
        _secondUnlockTf = [[SHpassWordView alloc]init];
        _secondUnlockTf.leftMargin = 20*FitWidth;
        _secondUnlockTf.Itemspacing = 19*FitWidth;
        _secondUnlockTf.ItemWidth = 40*FitWidth;
        _secondUnlockTf.ItemHeight = 40*FitWidth;
        _secondUnlockTf.itemCount = 6;
        _secondUnlockTf.isShowPassWord = @"2";
        [_secondUnlockTf initUI];
        _secondUnlockTf.valueChangeBtnBlock = ^(NSString * _Nonnull textValue) {
            if (textValue.length == 6) {
                [weakSelf compareTfPassWord];
                [weakSelf layoutStartButtonColor];
            }else
            {
                weakSelf.noMatchTipsLabel.hidden = YES;
            }
        };
        [self.view addSubview:_secondUnlockTf];
    }
    return _secondUnlockTf;
}
-(UILabel *)noMatchTipsLabel
{
    if (_noMatchTipsLabel == nil) {
        _noMatchTipsLabel = [[UILabel alloc]init];
        _noMatchTipsLabel.font = kCustomMontserratRegularFont(14);
        _noMatchTipsLabel.textColor = SHTheme.errorTipsRedColor;
        _noMatchTipsLabel.hidden = YES;
        _noMatchTipsLabel.text = GCLocalizedString(@"the_two_passwords_do_not_match");
        [self.view addSubview:_noMatchTipsLabel];
    }
    return _noMatchTipsLabel;
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
-(UIButton *)cancleButton
{
    if (_cancleButton == nil) {
        _cancleButton = [[UIButton alloc]init];
        _cancleButton.backgroundColor = [UIColor clearColor];
        [_cancleButton setTitle:GCLocalizedString(@"Cancel") forState:UIControlStateNormal];
        [_cancleButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = kMediunFont(14);
        [_cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancleButton];
    }
    return _cancleButton;
}

@end
