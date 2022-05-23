//
//  SHPassWordCheckViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/18.
//

#import "SHPassWordCheckViewController.h"
#import "SHResetPassWordViewController.h"
@interface SHPassWordCheckViewController ()
@property (nonatomic, strong) UIImageView *topIconImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) SHpassWordView *passWordTf;
@property (nonatomic, strong) UIButton *faceOrTouchLogButton;
@property (nonatomic, assign) NSInteger errorNumber;
@property (nonatomic, assign) NSInteger firstErrorTime;

@end

@implementation SHPassWordCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    self.errorNumber = 0;
    self.firstErrorTime = 0;
    [self layoutScale];
    [self getfaceOrTouchType];
    // Do any additional setup after loading the view.
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.topIconImageView.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.navBar, 45*FitHeight).widthIs(83*FitWidth).heightEqualToWidth();
    self.appNameLabel.sd_layout.centerXEqualToView(self.topIconImageView).topSpaceToView(self.topIconImageView, 8*FitHeight).heightIs(32*FitHeight);
    [self.appNameLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.passWordTf.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.appNameLabel, 40*FitHeight).heightIs(ceil(40*FitHeight));
    self.faceOrTouchLogButton.sd_layout.rightSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.view, kStatusBarHeight + 24*FitHeight).widthIs(220*FitWidth).heightIs(35*FitHeight);
    [self.passWordTf click];
}
-(void)getfaceOrTouchType
{
    MJWeakSelf;
    [SHTouchOrFaceUtil GetTouchIdOrFaceIdTypeWithFaceIdTypeBlock:^{
        [self.faceOrTouchLogButton setTitle:GCLocalizedString(@"Auth_Face_ID") forState:UIControlStateNormal];

    } WithTouchIdTypeBlock:^{
        [self.faceOrTouchLogButton setTitle:GCLocalizedString(@"Auth_Touch_ID") forState:UIControlStateNormal];
    } WithValidationBackBlock:^{
        [weakSelf getfaceOrTouchType];
    }];
}
#pragma mark 按钮事件
-(void)faceOrTouchLogButtonAction:(UIButton *)btn
{
    [self popViewController];
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
                if ([textValue isEqualToString:KAppSetting.unlockedPassWord]) {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    SHTabBarController *mianVc = [[SHTabBarController alloc]init];
                    delegate.window.rootViewController = mianVc;
                    [delegate.window makeKeyAndVisible];
                }else
                {
                    if ([NSString getNowTimeTimestamp] > weakSelf.firstErrorTime + 60*1000) {
                        weakSelf.firstErrorTime = [NSString getNowTimeTimestamp];
                        weakSelf.errorNumber = 0;
                    }
                        weakSelf.errorNumber ++;
                    if (weakSelf.errorNumber>=3) {
                        weakSelf.firstErrorTime = 0;
                        weakSelf.errorNumber = 0;
                        weakSelf.passWordTf.pswTF.text = @"";
                        [weakSelf.passWordTf.pswTF insertText:@""];
                        SHAlertView *alertView = [[SHAlertView alloc]initWithTitle:GCLocalizedString(@"reset_title") alert:GCLocalizedString(@"reset_tip") sureTitle:GCLocalizedString(@"Reset") sureBlock:^(NSString * _Nonnull str) {
                            [weakSelf.navigationController pushViewController:[SHResetPassWordViewController new] animated:YES];
                        } cancelTitle:GCLocalizedString(@"") cancelBlock:^(NSString * _Nonnull str) {
                            
                        }];
                        [KeyWindow addSubview:alertView];
                    }else
                    {
                        weakSelf.passWordTf.pswTF.text = @"";
                        [weakSelf.passWordTf.pswTF insertText:@""];
                        [MBProgressHUD showError:GCLocalizedString(@"password_error_try_again") toView:weakSelf.view];
                    }
                }
            }
            
        };
        [self.view addSubview:_passWordTf];
    }
    return _passWordTf;
}
//-(void)oneMinuteCheckNumber
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self oneMinuteCheckNumber];
//        self.errorNumber = 0;
//    });
//}
-(UIButton *)faceOrTouchLogButton
{
    if (_faceOrTouchLogButton == nil) {
        _faceOrTouchLogButton = [[UIButton alloc]init];
        if (IsEmpty(KAppSetting.isOpenFaceID)){
            _faceOrTouchLogButton.hidden = YES;
        }else
        {
            _faceOrTouchLogButton.hidden = NO;
        }
        [_faceOrTouchLogButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _faceOrTouchLogButton.titleLabel.font = kMediunFont(14);
        _faceOrTouchLogButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_faceOrTouchLogButton addTarget:self action:@selector(faceOrTouchLogButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_faceOrTouchLogButton];
    }
    return _faceOrTouchLogButton;
}
@end
