//
//  SHSelectMnemonicViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/23.
//

#import "SHSelectMnemonicViewController.h"
#import "SHBtcWallet.h"
#import "BTHDAccount.h"
#import "SHBtcCreatOrImportWalletManage.h"
#import "BTHDAccountAddressProvider.h"
#import "SHShowMnemonicViewController.h"
@interface SHSelectMnemonicViewController ()
@property (nonatomic, strong) UILabel *topTipsLabel;
@property (nonatomic, strong) UILabel *detailTipsLabel;
@property (nonatomic, strong) UILabel *lengthTipsLabel;

@property (nonatomic, strong) UIButton *twelveSelectButton;
@property (nonatomic, strong) UILabel *twelveSelectTipsLabel;
@property (nonatomic, strong) UIImageView *twelveSelectImageView;
@property (nonatomic, strong) UIButton *twentyFourSelectButton;
@property (nonatomic, strong) UILabel *twentyFourSelectTipsLabel;
@property (nonatomic, strong) UIImageView *twentyFourSelectImageView;

@property (nonatomic, strong) UIButton *continueButton;
@end

@implementation SHSelectMnemonicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.topTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).rightSpaceToView(self.view, 20*FitWidth).autoHeightRatio(0);
    self.detailTipsLabel.sd_layout.leftEqualToView(self.topTipsLabel).topSpaceToView(self.topTipsLabel, 8*FitHeight).rightEqualToView(self.topTipsLabel).autoHeightRatio(0);
    self.lengthTipsLabel.sd_layout.leftEqualToView(self.topTipsLabel).topSpaceToView(self.detailTipsLabel, 24*FitHeight).heightIs(22*FitHeight);
    [self.lengthTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.twelveSelectButton.sd_layout.leftEqualToView(self.lengthTipsLabel).topSpaceToView(self.lengthTipsLabel, 16*FitHeight).widthIs(155*FitWidth).heightIs(60*FitHeight);
    self.twelveSelectTipsLabel.sd_layout.leftSpaceToView(self.twelveSelectButton, 16*FitWidth).centerYEqualToView(self.twelveSelectButton).heightIs(20*FitHeight);
    [self.twelveSelectTipsLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.twelveSelectImageView.sd_layout.rightSpaceToView(self.twelveSelectButton, 15*FitWidth).centerYEqualToView(self.twelveSelectButton).widthIs(20*FitWidth).heightEqualToWidth();
    self.twentyFourSelectButton.sd_layout.rightEqualToView(self.detailTipsLabel).topSpaceToView(self.lengthTipsLabel, 16*FitHeight).widthIs(155*FitWidth).heightIs(60*FitHeight);
    self.twentyFourSelectTipsLabel.sd_layout.leftSpaceToView(self.twentyFourSelectButton, 16*FitWidth).centerYEqualToView(self.twentyFourSelectButton).heightIs(20*FitHeight);
    [self.twentyFourSelectTipsLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.twentyFourSelectImageView.sd_layout.rightSpaceToView(self.twentyFourSelectButton, 15*FitWidth).centerYEqualToView(self.twentyFourSelectButton).widthIs(20*FitWidth).heightEqualToWidth();
    self.continueButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.twelveSelectButton, 80*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 按钮事件
-(void)twelveSelectButtonAction:(UIButton *)btn
{
    self.twelveSelectButton.layer.borderWidth = 1;
    self.twelveSelectButton.selected = YES;
    self.twelveSelectTipsLabel.textColor = SHTheme.agreeButtonColor;
    self.twelveSelectImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_select"];
    
    self.twentyFourSelectButton.layer.borderWidth = 0;
    self.twentyFourSelectButton.selected = NO;
    self.twentyFourSelectTipsLabel.textColor = SHTheme.walletNameLabelColor;
    self.twentyFourSelectImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
    
    [self layoutStartButtonColor];

}
-(void)twentyFourSelectButtonAction:(UIButton *)btn
{
    self.twentyFourSelectButton.layer.borderWidth = 1;
    self.twentyFourSelectButton.selected = YES;
    self.twentyFourSelectTipsLabel.textColor = SHTheme.agreeButtonColor;
    self.twentyFourSelectImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_select"];
    
    self.twelveSelectButton.layer.borderWidth = 0;
    self.twelveSelectButton.selected = NO;
    self.twelveSelectTipsLabel.textColor = SHTheme.walletNameLabelColor;
    self.twelveSelectImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
    
    [self layoutStartButtonColor];

}
-(void)continueButtonAction:(UIButton *)btn
{
    XRandom *xrandom = [[XRandom alloc] initWithDelegate:nil];
    NSData *seed = [xrandom randomWithSize:self.twelveSelectButton.selected?16:32];
    NSError *error = nil;
    SHShowMnemonicViewController *showMnemonicViewController = [[SHShowMnemonicViewController alloc]init];
    showMnemonicViewController.mnemonicArray = [[SHCreatOrImportManage creatBTCMnemonicWithEntropy:seed error:&error] componentsSeparatedByString:@" "];
    showMnemonicViewController.passWord = self.passWord;
    showMnemonicViewController.selectedNestedSegWitButton = self.selectedNestedSegWitButton;
    showMnemonicViewController.walletName = self.walletName;
    [self.navigationController pushViewController:showMnemonicViewController animated:YES];

}
#pragma mark 第三方方法
-(void)layoutStartButtonColor
{
    if (self.twelveSelectButton.selected||self.twentyFourSelectButton.selected) {
        [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.continueButton.enabled = YES;
    }else
    {
        [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.continueButton.enabled = NO;
    }
}
#pragma mark 懒加载
-(UILabel *)topTipsLabel
{
    if (_topTipsLabel == nil) {
        _topTipsLabel = [[UILabel alloc]init];
        _topTipsLabel.font = kCustomMontserratMediumFont(24);
        _topTipsLabel.text = GCLocalizedString(@"phrase_tip_0");
        _topTipsLabel.textColor = SHTheme.appTopBlackColor;
        [self.view addSubview:_topTipsLabel];
    }
    return _topTipsLabel;
}
-(UILabel *)detailTipsLabel
{
    if (_detailTipsLabel == nil) {
        _detailTipsLabel = [[UILabel alloc]init];
        _detailTipsLabel.font = kCustomMontserratMediumFont(14);
        _detailTipsLabel.text = GCLocalizedString(@"phrase_tip_1");
        _detailTipsLabel.textColor = SHTheme.appBlackColor;
        [self.view addSubview:_detailTipsLabel];
    }
    return _detailTipsLabel;
}
-(UILabel *)lengthTipsLabel
{
    if (_lengthTipsLabel == nil) {
        _lengthTipsLabel = [[UILabel alloc]init];
        _lengthTipsLabel.font = kCustomMontserratMediumFont(14);
        _lengthTipsLabel.textColor = SHTheme.appBlackColor;
        _lengthTipsLabel.text = GCLocalizedString(@"phrase_select_tip");
        [self.view addSubview:_lengthTipsLabel];
    }
    return _lengthTipsLabel;
}
-(UIButton *)twelveSelectButton
{
    if (_twelveSelectButton == nil) {
        _twelveSelectButton = [[UIButton alloc]init];
        _twelveSelectButton.backgroundColor = SHTheme.addressTypeCellBackColor;
        _twelveSelectButton.layer.cornerRadius = 8;
        _twelveSelectButton.layer.masksToBounds = YES;
        _twelveSelectButton.layer.borderColor = SHTheme.agreeButtonColor.CGColor;
        _twelveSelectButton.layer.borderWidth = 0;
        [_twelveSelectButton addTarget:self action:@selector(twelveSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_twelveSelectButton];
    }
    return _twelveSelectButton;
}
-(UIButton *)twentyFourSelectButton
{
    if (_twentyFourSelectButton == nil) {
        _twentyFourSelectButton = [[UIButton alloc]init];
        _twentyFourSelectButton.backgroundColor = SHTheme.addressTypeCellBackColor;
        _twentyFourSelectButton.layer.cornerRadius = 8;
        _twentyFourSelectButton.layer.masksToBounds = YES;
        _twentyFourSelectButton.layer.borderColor = SHTheme.agreeButtonColor.CGColor;
        _twentyFourSelectButton.layer.borderWidth = 0;
        [_twentyFourSelectButton addTarget:self action:@selector(twentyFourSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_twentyFourSelectButton];
    }
    return _twentyFourSelectButton;
}
-(UILabel *)twentyFourSelectTipsLabel
{
    if (_twentyFourSelectTipsLabel == nil) {
        _twentyFourSelectTipsLabel = [[UILabel alloc]init];
        _twentyFourSelectTipsLabel.font = kCustomMontserratMediumFont(14);
        _twentyFourSelectTipsLabel.textColor = SHTheme.walletNameLabelColor;
        _twentyFourSelectTipsLabel.text = GCLocalizedString(@"24");
        [self.twentyFourSelectButton addSubview:_twentyFourSelectTipsLabel];
    }
    return _twentyFourSelectTipsLabel;
}
-(UILabel *)twelveSelectTipsLabel
{
    if (_twelveSelectTipsLabel == nil) {
        _twelveSelectTipsLabel = [[UILabel alloc]init];
        _twelveSelectTipsLabel.font = kCustomMontserratMediumFont(14);
        _twelveSelectTipsLabel.textColor = SHTheme.walletNameLabelColor;
        _twelveSelectTipsLabel.text = GCLocalizedString(@"12");
        [self.twelveSelectButton addSubview:_twelveSelectTipsLabel];
    }
    return _twelveSelectTipsLabel;
}
-(UIImageView *)twelveSelectImageView
{
    if (_twelveSelectImageView == nil) {
        _twelveSelectImageView = [[UIImageView alloc]init];
        _twelveSelectImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
        [self.twelveSelectButton addSubview:_twelveSelectImageView];
    }
    return _twelveSelectImageView;
}
-(UIImageView *)twentyFourSelectImageView
{
    if (_twentyFourSelectImageView == nil) {
        _twentyFourSelectImageView = [[UIImageView alloc]init];
        _twentyFourSelectImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
        [self.twentyFourSelectButton addSubview:_twentyFourSelectImageView];
    }
    return _twentyFourSelectImageView;
}
-(UIButton *)continueButton
{
    if (_continueButton == nil) {
        _continueButton = [[UIButton alloc]init];
        _continueButton.layer.cornerRadius = 26*FitHeight;
        _continueButton.layer.masksToBounds = YES;
        _continueButton.enabled = NO;
        [_continueButton setTitle:GCLocalizedString(@"continue_desc") forState:UIControlStateNormal];
        [_continueButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _continueButton.titleLabel.font = kMediunFont(14);
        [_continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_continueButton];
    }
    return _continueButton;
}
@end
