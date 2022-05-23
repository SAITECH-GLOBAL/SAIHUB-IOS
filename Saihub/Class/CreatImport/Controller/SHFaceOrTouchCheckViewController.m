//
//  SHFaceOrTouchCheckViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/18.
//

#import "SHFaceOrTouchCheckViewController.h"

@interface SHFaceOrTouchCheckViewController ()
@property (nonatomic, strong) UIImageView *topIconImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UIButton *passwordLogButton;
@property (nonatomic, strong) UIButton *bottomCheckButton;

@end

@implementation SHFaceOrTouchCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    [self layoutScale];
    [self getfaceOrTouchType];
    // Do any additional setup after loading the view.
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.topIconImageView.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.navBar, 57*FitHeight).widthIs(83*FitWidth).heightEqualToWidth();
    self.appNameLabel.sd_layout.centerXEqualToView(self.topIconImageView).topSpaceToView(self.topIconImageView, 8*FitHeight).heightIs(32*FitHeight);
    [self.appNameLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.bottomCheckButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.appNameLabel, 140*FitHeight).widthIs(259*FitHeight).heightEqualToWidth();
    self.passwordLogButton.sd_layout.rightSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.view, kStatusBarHeight + 24*FitHeight).widthIs(120*FitWidth).heightIs(35*FitHeight);
    [self ToSetgestures];
}
#pragma mark 按钮事件
-(void)passwordLogButtonAction:(UIButton *)btn
{
    [self.navigationController pushViewController:[SHPassWordCheckViewController new] animated:YES];
}
-(void)bottomCheckButtonAction:(UIButton *)btn
{
    [self ToSetgestures];
}
-(void)getfaceOrTouchType
{
    MJWeakSelf;
    [SHTouchOrFaceUtil GetTouchIdOrFaceIdTypeWithFaceIdTypeBlock:^{
        [self.bottomCheckButton setImage:[UIImage imageNamed:@"faceOrtouchVc_checkImageView_face"] forState:UIControlStateNormal];

    } WithTouchIdTypeBlock:^{
        [self.bottomCheckButton setImage:[UIImage imageNamed:@"faceOrtouchVc_checkImageView_touch"] forState:UIControlStateNormal];
    } WithValidationBackBlock:^{
        [weakSelf getfaceOrTouchType];
    }];
}
-(void)ToSetgestures
{
    MJWeakSelf;
    [SHTouchOrFaceUtil selectTouchIdOrFaceIdWithSucessedBlock:^(BOOL isSuccess) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        SHTabBarController *mianVc = [[SHTabBarController alloc]init];
        delegate.window.rootViewController = mianVc;
        [delegate.window makeKeyAndVisible];
    } WithSelectPassWordBlock:^{
        [weakSelf ToSetgestures];
    } WithErrorBlock:^(NSError * _Nonnull error) {
    }withBtn:nil];
}
#pragma mark 懒加载
-(UIImageView *)topIconImageView
{
    if (_topIconImageView == nil) {
        _topIconImageView = [[UIImageView alloc]init];
        _topIconImageView.image = [UIImage imageNamed:@"openVc_logo_color"];
        [self.view addSubview:_topIconImageView];
    }
    return _topIconImageView;
}
-(UILabel *)appNameLabel
{
    if (_appNameLabel == nil) {
        _appNameLabel = [[UILabel alloc]init];
        _appNameLabel.font = kCustomMontserratMediumFont(24);
        _appNameLabel.textColor = SHTheme.appBlackColor;
        _appNameLabel.text = GCLocalizedString(@"SAIHUB");
        [self.view addSubview:_appNameLabel];
    }
    return _appNameLabel;
}
-(UIButton *)bottomCheckButton
{
    if (_bottomCheckButton == nil) {
        _bottomCheckButton = [[UIButton alloc]init];
        [_bottomCheckButton addTarget:self action:@selector(bottomCheckButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomCheckButton];
    }
    return _bottomCheckButton;
}
-(UIButton *)passwordLogButton
{
    if (_passwordLogButton == nil) {
        _passwordLogButton = [[UIButton alloc]init];

        [_passwordLogButton setTitle:GCLocalizedString(@"login_password") forState:UIControlStateNormal];
        [_passwordLogButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _passwordLogButton.titleLabel.font = kMediunFont(14);
        _passwordLogButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_passwordLogButton addTarget:self action:@selector(passwordLogButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_passwordLogButton];
    }
    return _passwordLogButton;
}
@end
