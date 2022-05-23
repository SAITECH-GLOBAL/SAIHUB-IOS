//
//  SHTransferSucceseViewController.m
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHTransferSucceseViewController.h"
#import "SHTransferValidationTopView.h"
#import "SHWalletController.h"

@interface SHTransferSucceseViewController ()
@property (nonatomic, strong) SHTransferValidationTopView *transferValidationTopView;
@property (nonatomic, strong) UIImageView *transferSucceseImageView;
@property (nonatomic, strong) UIButton *continueButton;

@end

@implementation SHTransferSucceseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"Details");
    // Do any additional setup after loading the view.
    [self layoutScale];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RateChangeAction:) name:RateChangePushNoticeKey object:nil];

}
- (void)RateChangeAction:(NSNotification *)notification {
    [self.transferValidationTopView loadFeeLabelValue];
}

#pragma mark 布局页面
-(void)layoutScale
{
    self.transferValidationTopView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.navBar, 0).heightIs(166*FitHeight);
    [self.transferValidationTopView layoutScale];
    self.transferSucceseImageView.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.transferValidationTopView, 64*FitHeight).widthIs(132*FitWidth).heightIs(93*FitHeight);
    self.continueButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.transferSucceseImageView, 67*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    self.transferValidationTopView.isPrimaryToken = self.isPrimaryToken;
    self.transferValidationTopView.transferInfoModel = self.transferInfoModel;

}
-(void)setTransferInfoModel:(SHTransferInfoModel *)transferInfoModel
{
    _transferInfoModel = transferInfoModel;
}
#pragma mark 按钮事件
-(void)continueButtonAction:(UIButton *)btn
{
    // 转账成功刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:kTransferSuccessKey object:nil];
    [self popBackWithClassArray:@[[SHTransactionRecordTotalController class]]];
}
-(void)popViewController
{
    // 转账成功刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:kTransferSuccessKey object:nil];
    [self popBackWithClassArray:@[[SHTransactionRecordTotalController class]]];
}
#pragma mark 懒加载
-(UIButton *)continueButton
{
    if (_continueButton == nil) {
        _continueButton = [[UIButton alloc]init];
        _continueButton.layer.cornerRadius = 26*FitHeight;
        _continueButton.layer.masksToBounds = YES;
        [_continueButton setTitle:GCLocalizedString(@"Next") forState:UIControlStateNormal];
        [_continueButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _continueButton.titleLabel.font = kMediunFont(14);
        [_continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_continueButton];
    }
    return _continueButton;
}
-(UIImageView *)transferSucceseImageView
{
    if (_transferSucceseImageView == nil) {
        _transferSucceseImageView = [[UIImageView alloc]init];
        _transferSucceseImageView.image = [UIImage imageNamed:@"transferSucceseVc_transferSucceseImageView"];
        [self.view addSubview:_transferSucceseImageView];
    }
    return _transferSucceseImageView;
}
-(SHTransferValidationTopView *)transferValidationTopView
{
    if (_transferValidationTopView == nil) {
        _transferValidationTopView = [[SHTransferValidationTopView alloc]init];
        [self.view addSubview:_transferValidationTopView];
    }
    return _transferValidationTopView;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RateChangePushNoticeKey object:nil];
}
@end
