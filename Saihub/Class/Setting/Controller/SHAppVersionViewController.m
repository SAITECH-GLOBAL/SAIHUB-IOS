//
//  SHAppVersionViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHAppVersionViewController.h"

@interface SHAppVersionViewController ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *appVersionLabel;
@property (nonatomic, strong) UIButton *checkUpdataButton;
@end

@implementation SHAppVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = GCLocalizedString(@"app_version");
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.iconImageView.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.navBar, 40*FitHeight).widthIs(208*FitWidth).heightIs(80*FitHeight);
    self.appNameLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.iconImageView, 16*FitWidth).heightIs(22*FitHeight);
    [self.appNameLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.appVersionLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.appNameLabel, 2*FitHeight).heightIs(22*FitHeight);
    [self.appVersionLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
//    self.checkUpdataButton.sd_layout.centerXEqualToView(self.view).bottomSpaceToView(self.view, 38*FitHeight + SafeAreaBottomHeight).widthIs(164*FitWidth).heightIs(52*FitHeight);
}
#pragma mark 按钮事件
-(void)checkUpdataButtonAction:(UIButton *)btn
{
//        SHAlertView *alertView = [[SHAlertView alloc]initWithTitle:GCLocalizedString(@"Update App") alert:GCLocalizedString(@"Please update the app to the latest version to use it") sureTitle:GCLocalizedString(@"Reset") sureBlock:^(NSString * _Nonnull str) {
//
//        } cancelTitle:@"" cancelBlock:^(NSString * _Nonnull str) {
//
//        }];
//    alertView.clooseButton.hidden = YES;
//        [KeyWindow addSubview:alertView];
}
#pragma mark 懒加载
-(UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image  = [UIImage imageNamed:@"AppVersionVc_iconImageView"];
        [self.view addSubview:_iconImageView];
    }
    return _iconImageView;
}
-(UILabel *)appNameLabel
{
    if (_appNameLabel == nil) {
        _appNameLabel = [[UILabel alloc]init];
        _appNameLabel.font = kCustomMontserratRegularFont(14);
        _appNameLabel.textColor = SHTheme.setPasswordTipsColor;
        _appNameLabel.text = GCLocalizedString(@"SAIHUBApp");
        [self.view addSubview:_appNameLabel];
    }
    return _appNameLabel;
}
-(UILabel *)appVersionLabel
{
    if (_appVersionLabel == nil) {
        _appVersionLabel = [[UILabel alloc]init];
        _appVersionLabel.font = kCustomMontserratRegularFont(12);
        _appVersionLabel.textColor = SHTheme.setPasswordTipsColor;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _appVersionLabel.text = [NSString stringWithFormat:@"%@ %@",GCLocalizedString(@"current_version_number"),appVersion];
        [self.view addSubview:_appVersionLabel];
    }
    return _appVersionLabel;
}
-(UIButton *)checkUpdataButton
{
    if (_checkUpdataButton == nil) {
        _checkUpdataButton = [[UIButton alloc]init];
        _checkUpdataButton.backgroundColor = SHTheme.shareBackgroundColor;
        _checkUpdataButton.layer.cornerRadius = 26*FitHeight;
        _checkUpdataButton.layer.masksToBounds = YES;
        [_checkUpdataButton setTitle:GCLocalizedString(@"Check Update") forState:UIControlStateNormal];
        [_checkUpdataButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _checkUpdataButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_checkUpdataButton addTarget:self action:@selector(checkUpdataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_checkUpdataButton];
    }
    return _checkUpdataButton;
}
@end
