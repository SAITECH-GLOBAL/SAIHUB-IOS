//
//  SHRepeatPassWordViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHRepeatPassWordViewController.h"
#import "SHUnlockSettingViewController.h"
@interface SHRepeatPassWordViewController ()
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) SHpassWordView *passWordTf;

@end

@implementation SHRepeatPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"set_password_login");
    [self layoutScale];
    // Do any additional setup after loading the view.
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.appNameLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(36*FitHeight);
    [self.appNameLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.passWordTf.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.appNameLabel, 16*FitHeight).heightIs(ceil(40*FitHeight));
    [self.passWordTf click];

}
#pragma mark 按钮事件

#pragma mark 懒加载
-(UILabel *)appNameLabel
{
    if (_appNameLabel == nil) {
        _appNameLabel = [[UILabel alloc]init];
        _appNameLabel.font = kCustomMontserratMediumFont(24);
        _appNameLabel.textColor = SHTheme.appTopBlackColor;
        _appNameLabel.text = GCLocalizedString(@"Repeat");
        [self.view addSubview:_appNameLabel];
    }
    return _appNameLabel;
}
-(SHpassWordView *)passWordTf
{
    MJWeakSelf;
    if (_passWordTf == nil) {
        _passWordTf = [[SHpassWordView alloc]init];
        _passWordTf.leftMargin = 20*FitWidth;
        _passWordTf.Itemspacing = 19*FitWidth;
        _passWordTf.ItemWidth = 40*FitWidth;
        _passWordTf.ItemHeight = 40*FitWidth;
        _passWordTf.itemCount = 6;
        _passWordTf.isShowPassWord = @"2";
        [_passWordTf initUI];
        _passWordTf.valueChangeBtnBlock = ^(NSString * _Nonnull textValue) {
            if (textValue.length == 6) {
                if ([textValue isEqualToString:weakSelf.passWord]) {
                    KAppSetting.unlockedPassWord = textValue;
                    [weakSelf popBackWithClassArray:@[[SHUnlockSettingViewController class]]];
                }else
                {
                    weakSelf.passWordTf.pswTF.text = @"";
                    [weakSelf.passWordTf.pswTF insertText:@""];
                    [MBProgressHUD showError:GCLocalizedString(@"the_two_passwords_do_not_match") toView:weakSelf.view];
                }
            }
        };
        [self.view addSubview:_passWordTf];
    }
    return _passWordTf;
}

@end
