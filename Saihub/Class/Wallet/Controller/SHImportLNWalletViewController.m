//
//  SHImportLNWalletViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/20.
//

#import "SHImportLNWalletViewController.h"

@interface SHImportLNWalletViewController ()
@property (nonatomic, strong) UILabel *walletNameTipsLabel;
@property (nonatomic, strong) UITextField *walletNameTf;
@property (nonatomic, strong) UIView *walletNameLineView;

@property (nonatomic, strong) UILabel *hostUrlTipsLabel;
@property (nonatomic, strong) UITextField *hostUrlTf;
@property (nonatomic, strong) UIView *hostUrlLineView;
@property (nonatomic, strong) UIButton *qrButton;

@property (nonatomic, strong) UIButton *importButton;
@end

@implementation SHImportLNWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = GCLocalizedString(@"Import_Lightning");
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.walletNameTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(22*FitHeight);
    [self.walletNameTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.walletNameTf.sd_layout.leftEqualToView(self.walletNameTipsLabel).topSpaceToView(self.walletNameTipsLabel, 0).rightSpaceToView(self.view, 20*FitWidth).heightIs(46*FitHeight);
    self.walletNameLineView.sd_layout.leftEqualToView(self.walletNameTf).rightEqualToView(self.walletNameTf).topSpaceToView(self.walletNameTf, 0).heightIs(1);
   
    self.hostUrlTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.walletNameLineView, 24*FitHeight).heightIs(22*FitHeight);
    [self.hostUrlTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.hostUrlTf.sd_layout.leftEqualToView(self.hostUrlTipsLabel).topSpaceToView(self.hostUrlTipsLabel, 0).rightSpaceToView(self.view, 52*FitWidth).heightIs(46*FitHeight);
    self.hostUrlLineView.sd_layout.leftEqualToView(self.walletNameLineView).rightEqualToView(self.walletNameLineView).topSpaceToView(self.hostUrlTf, 0).heightIs(1);
    self.qrButton.sd_layout.rightEqualToView(self.walletNameLineView).centerYEqualToView(self.hostUrlTf).widthIs(20*FitWidth).heightEqualToWidth();
    
    self.importButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.hostUrlLineView, 42*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.importButton setBackgroundImage:[UIImage gradientImageWithBounds:self.importButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 按钮事件
-(void)importButtonAction:(UIButton *)btn
{
    NSArray *hostUrlArray = [self.hostUrlTf.text componentsSeparatedByString:@"@"];
    NSArray *acountAndPassWordArray = hostUrlArray.count!=2?[NSArray new]:[hostUrlArray[0] componentsSeparatedByString:@"//"];
    NSArray *acountORPassWordArray = acountAndPassWordArray.count!=2?[NSArray new]:[acountAndPassWordArray[1] componentsSeparatedByString:@":"];
    if (acountORPassWordArray.count == 2) {
        [self importWalletWithLogin:acountORPassWordArray[0] WithPassword:acountORPassWordArray[1] WithHost:hostUrlArray[1]];
    }else
    {
        [MBProgressHUD showError:GCLocalizedString(@"Import_failed") toView:self.view];
    }
}
//导入钱包
-(void)importWalletWithLogin:(NSString *)login WithPassword:(NSString *)password WithHost:(NSString *)host
{
    if (!IsEmpty(host)&&[[host substringFromIndex:host.length - 1] isEqualToString:@"/"]) {
        host = [host substringToIndex:host.length - 1];
    }
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    //获取access_token、refresh_token
    [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"%@/auth?type=auth",host] withMethodType:Post withParams:@{@"login":login,@"password":password} result:^(id  _Nullable getAccessTokenDic, NSInteger getAccessTokenCode, NSString *getAccessTokenMessage) {
        if (getAccessTokenCode == 0) {
            //获取btc_address
            [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpwithHeader:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",getAccessTokenDic[@"access_token"]]} WithPath:[NSString stringWithFormat:@"%@/getbtc",host] withMethodType:Get withParams:@{} result:^(id  _Nullable btcAddressDic, NSInteger btcAddressCode, NSString *btcAddressMessage) {
                if ([[btcAddressDic className] containsString:@"NSDictionary"]&&[[(NSDictionary *)btcAddressDic allKeys]containsObject:@"message"]) {
                    if ([btcAddressDic[@"message"]isEqualToString:@"bad auth"]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTokenKey" object:nil];
                        return;
                    }
                    [MBProgressHUD showError:btcAddressDic[@"message"] toView:self.view];
                    return;
                }
                if (btcAddressCode == 0) {
                    SHLNWalletModel *lnWalletModel = [SHLNWalletModel new];
                    lnWalletModel.WalletName = self.walletNameTf.text;
                    lnWalletModel.hostUrl = host;
                    lnWalletModel.UserAccount = login;
                    lnWalletModel.UserPassWord = password;
                    lnWalletModel.refresh_token = getAccessTokenDic[@"refresh_token"];
                    lnWalletModel.access_token = getAccessTokenDic[@"access_token"];
                    lnWalletModel.btcAddress = btcAddressDic[0][@"address"];
                    lnWalletModel.createTimestamp = [NSString getNowTimeTimestamp];
                    [[SHKeyStorage shared]createLNWalletsWithWalletModel:lnWalletModel];
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showSuccess:GCLocalizedString(@"Import_successfully") toView:self.view];
                    if (IsEmpty([[NSUserDefaults standardUserDefaults] objectForKey:FirstCreaatOrImportWalletKey])) {
                        [[NSUserDefaults standardUserDefaults] setObject:@([NSString getNowTimeTimestamp]) forKey:FirstCreaatOrImportWalletKey];//存储首次创建或导入钱包时间戳
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        SHTabBarController *mianVc = [[SHTabBarController alloc]init];
                        delegate.window.rootViewController = mianVc;
                        [delegate.window makeKeyAndVisible];
                    }else
                    {
                        [self popBackWithClassArray:@[[SHUnlockSettingViewController class],[SHLNWalletViewController class]]];
                    }
                }else
                {
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showError:btcAddressMessage toView:nil];
                }
            }];
        }else
        {
            [MBProgressHUD hideCustormLoadingWithView:self.view];
            [MBProgressHUD showError:getAccessTokenMessage toView:nil];
        }
    }];
}
-(void)qrButtonAction:(UIButton *)btn
{
    SHQrScanningViewController *qrVc = [[SHQrScanningViewController alloc]init];
    qrVc.qrStringClickBlock = ^(NSString * _Nonnull qrString) {
        self.hostUrlTf.text = qrString;
        [self layoutStartButtonColor];
    };
    [self.navigationController pushViewController:qrVc animated:YES];
}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
    if ([textField isEqual:self.walletNameTf] && textField.text.length >=20) {
        textField.text = [textField.text substringToIndex:20];
    }
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.walletNameTf.text)&&!IsEmpty(self.hostUrlTf.text)) {
        [self.importButton setBackgroundImage:[UIImage gradientImageWithBounds:self.importButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.importButton.enabled = YES;
    }else
    {
        [self.importButton setBackgroundImage:[UIImage gradientImageWithBounds:self.importButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.importButton.enabled = NO;
    }
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
-(UITextField *)walletNameTf
{
    if (_walletNameTf == nil) {
        _walletNameTf = [[UITextField alloc]init];
        _walletNameTf.tintColor = SHTheme.agreeButtonColor;
        _walletNameTf.text = [NSString stringWithFormat:@"Lightning-%@",[NSString randomStringWithLength:4]];
        _walletNameTf.clearButtonMode = UITextFieldViewModeAlways;
        [_walletNameTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_walletNameTf];
    }
    return _walletNameTf;
}
- (UIView *)walletNameLineView
{
    if (_walletNameLineView == nil) {
        _walletNameLineView = [[UIView alloc]init];
        _walletNameLineView.backgroundColor = SHTheme.appBlackColor;
        _walletNameLineView.alpha = 0.12;
        [self.view addSubview:_walletNameLineView];
    }
    return _walletNameLineView;
}
-(UILabel *)hostUrlTipsLabel
{
    if (_hostUrlTipsLabel == nil) {
        _hostUrlTipsLabel = [[UILabel alloc]init];
        _hostUrlTipsLabel.font = kCustomMontserratMediumFont(14);
        _hostUrlTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _hostUrlTipsLabel.text = GCLocalizedString(@"LNDHub");
        [self.view addSubview:_hostUrlTipsLabel];
    }
    return _hostUrlTipsLabel;
}
-(UITextField *)hostUrlTf
{
    if (_hostUrlTf == nil) {
        _hostUrlTf = [[UITextField alloc]init];
        _hostUrlTf.tintColor = SHTheme.agreeButtonColor;
        _hostUrlTf.clearButtonMode = UITextFieldViewModeAlways;
        _hostUrlTf.placeholder = GCLocalizedString(@"Enter_LNDHub");
        [_hostUrlTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_hostUrlTf];
    }
    return _hostUrlTf;
}
- (UIView *)hostUrlLineView
{
    if (_hostUrlLineView == nil) {
        _hostUrlLineView = [[UIView alloc]init];
        _hostUrlLineView.backgroundColor = SHTheme.appBlackColor;
        _hostUrlLineView.alpha = 0.12;
        [self.view addSubview:_hostUrlLineView];
    }
    return _hostUrlLineView;
}
-(UIButton *)qrButton
{
    if (_qrButton == nil) {
        _qrButton = [[UIButton alloc]init];
        [_qrButton setImage:[UIImage imageNamed:@"creatPowerVc_qrButton"] forState:UIControlStateNormal];
        [_qrButton addTarget:self action:@selector(qrButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_qrButton];
    }
    return _qrButton;
}
-(UIButton *)importButton
{
    if (_importButton == nil) {
        _importButton = [[UIButton alloc]init];
        _importButton.layer.cornerRadius = 26*FitHeight;
        _importButton.layer.masksToBounds = YES;
        [_importButton setTitle:GCLocalizedString(@"import_desc") forState:UIControlStateNormal];
        [_importButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _importButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_importButton addTarget:self action:@selector(importButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_importButton];
    }
    return _importButton;
}

@end
