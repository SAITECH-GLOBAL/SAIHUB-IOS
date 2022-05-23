//
//  SHSetFaceIDPassWordViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHSetFaceIDPassWordViewController.h"
#import "SHResetPassWordViewController.h"
@interface SHSetFaceIDPassWordViewController ()
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) SHpassWordView *passWordTf;
@property (nonatomic, assign) NSInteger errorNumber;
@property (nonatomic, assign) NSInteger firstErrorTime;

@end

@implementation SHSetFaceIDPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorNumber = 0;
    self.firstErrorTime = 0;
    [self layoutScale];
    // Do any additional setup after loading the view.
    [self getfaceOrTouchType];
}
-(void)getfaceOrTouchType
{
    if (self.intoType == 0) {
        self.titleLabel.text = GCLocalizedString(@"set_password_login");
        return;
    }
    MJWeakSelf;
    [SHTouchOrFaceUtil GetTouchIdOrFaceIdTypeWithFaceIdTypeBlock:^{
        self.titleLabel.text = GCLocalizedString(@"set_face_id");

    } WithTouchIdTypeBlock:^{
        self.titleLabel.text = GCLocalizedString(@"set_touch_id");

    } WithValidationBackBlock:^{
        [weakSelf getfaceOrTouchType];
    }];
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
        _appNameLabel.text = GCLocalizedString(@"unlock_password");
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
                    if (self.intoType == 0) {
                        KAppSetting.unlockedPassWord = @"";
                        KAppSetting.isOpenFaceID = @"";
                    }else if (self.intoType == 1)
                    {
                        KAppSetting.isOpenFaceID = @"1";
                    }
                    else if (self.intoType == 2)
                    {
                        KAppSetting.isOpenFaceID = @"";
                    }
                    [weakSelf popBackWithClassArray:@[[SHUnlockSettingViewController class]]];
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
                        [MBProgressHUD showError:GCLocalizedString(@"Wrong_Password") toView:weakSelf.view];
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
//-(void)ToSetgestures
//{
//    MJWeakSelf;
//    self.passWordTf.pswTF.text = @"";
//    [SHTouchOrFaceUtil selectTouchIdOrFaceIdWithSucessedBlock:^(BOOL isSuccess) {
//        KAppSetting.isOpenFaceID = @"1";
//        [weakSelf popBackWithClassArray:@[[SHUnlockSettingViewController class]]];
//    } WithSelectPassWordBlock:^{
//        [weakSelf ToSetgestures];
//    } WithErrorBlock:^(NSError * _Nonnull error) {
//    }withBtn:nil];
//}
@end
