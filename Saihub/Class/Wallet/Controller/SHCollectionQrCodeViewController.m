//
//  SHCollectionQrCodeViewController.m
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHCollectionQrCodeViewController.h"

@interface SHCollectionQrCodeViewController ()
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIView *qrBackView;
@property (nonatomic, strong) UIImageView *qrImageView;
@property (nonatomic, strong) UIButton *continueButton;

@end

@implementation SHCollectionQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"Send");
    [self layoutScale];
    // Do any additional setup after loading the view.
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.tipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).rightSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).autoHeightRatio(0);
    self.qrBackView.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.tipsLabel, 24*FitHeight).widthIs(241*FitWidth).heightEqualToWidth();
    self.qrImageView.sd_layout.centerXEqualToView(self.qrBackView).centerYEqualToView(self.qrBackView).widthIs(193*FitWidth).heightEqualToWidth();
    self.continueButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.qrBackView, 80*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 按钮事件
-(void)continueButtonAction:(UIButton *)btn
{
    
}
#pragma mark 懒加载
-(UILabel *)tipsLabel
{
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.font = kCustomMontserratRegularFont(14);
        _tipsLabel.textColor = SHTheme.appBlackColor;
        _tipsLabel.text = GCLocalizedString(@"multi_sign_tip");
        [self.view addSubview:_tipsLabel];
    }
    return _tipsLabel;
}
- (UIView *)qrBackView
{
    if (_qrBackView == nil) {
        _qrBackView = [[UIView alloc]init];
        _qrBackView.layer.cornerRadius = 8;
        _qrBackView.layer.masksToBounds = YES;
        _qrBackView.backgroundColor = SHTheme.addressTypeCellBackColor;
        [self.view addSubview:_qrBackView];
    }
    return _qrBackView;
}
-(UIImageView *)qrImageView
{
    if (_qrImageView == nil) {
        _qrImageView = [[UIImageView alloc]init];
        _qrImageView.backgroundColor = SHTheme.appBlackColor;
        [self.qrBackView addSubview:_qrImageView];
    }
    return _qrImageView;
}
-(UIButton *)continueButton
{
    if (_continueButton == nil) {
        _continueButton = [[UIButton alloc]init];
        _continueButton.layer.cornerRadius = 26*FitHeight;
        _continueButton.layer.masksToBounds = YES;
        [_continueButton setTitle:GCLocalizedString(@"scan_signed") forState:UIControlStateNormal];
        [_continueButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _continueButton.titleLabel.font = kMediunFont(14);
        [_continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_continueButton];
    }
    return _continueButton;
}

@end
