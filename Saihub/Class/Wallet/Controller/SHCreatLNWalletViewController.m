//
//  SHCreatLNWalletViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/20.
//

#import "SHCreatLNWalletViewController.h"
#import "SHImportLNWalletViewController.h"

@interface SHCreatLNWalletViewController ()
@property (nonatomic, strong) UILabel *walletNameTipsLabel;
@property (nonatomic, strong) UITextField *walletNameTf;
@property (nonatomic, strong) UIView *walletNameLineView;

@property (nonatomic, strong) UILabel *hostUrlTipsLabel;
@property (nonatomic, strong) UITextField *hostUrlTf;
@property (nonatomic, strong) UIView *hostUrlLineView;
@property (nonatomic, strong) UILabel *hostUrlErrorLabel;


@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *importButton;
@end

@implementation SHCreatLNWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = GCLocalizedString(@"Add_Lightning");
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
    self.hostUrlTf.sd_layout.leftEqualToView(self.hostUrlTipsLabel).topSpaceToView(self.hostUrlTipsLabel, 0).rightSpaceToView(self.view, 20*FitWidth).heightIs(46*FitHeight);
    self.hostUrlLineView.sd_layout.leftEqualToView(self.walletNameLineView).rightEqualToView(self.walletNameLineView).topSpaceToView(self.hostUrlTf, 0).heightIs(1);
    self.hostUrlErrorLabel.sd_layout.leftEqualToView(self.hostUrlLineView).rightEqualToView(self.hostUrlLineView).topSpaceToView(self.hostUrlLineView, 0).heightIs(18*FitHeight);
    
    self.confirmButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.hostUrlLineView, 42*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    self.confirmButton.enabled = YES;
    self.importButton.sd_layout.centerXEqualToView(self.confirmButton).topSpaceToView(self.confirmButton, 0).widthIs(335*FitWidth).heightIs(52*FitHeight);
}
#pragma mark 按钮事件
-(void)confirmButtonAction:(UIButton *)btn
{
    [self CreatWallet];
}
-(void)importButtonAction:(UIButton *)btn
{
    [self.navigationController pushViewController:[SHImportLNWalletViewController new] animated:YES];
}
//创建钱包
-(void)CreatWallet
{
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"%@/create",self.hostUrlTf.text] withMethodType:Post withParams:@{@"partnerid":@"bluewallet",@"accounttype":@"common"} result:^(id  _Nullable createAccountDic, NSInteger createAccountCode, NSString *createAccountMessage) {
        if (createAccountCode == 0) {
            self.hostUrlErrorLabel.hidden = YES;
            self.hostUrlLineView.backgroundColor = SHTheme.appBlackColor;
            self.hostUrlLineView.alpha = 0.12;

            //获取access_token、refresh_token
            [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"%@/auth?type=auth",self.hostUrlTf.text] withMethodType:Post withParams:@{@"login":createAccountDic[@"login"],@"password":createAccountDic[@"password"]} result:^(id  _Nullable getAccessTokenDic, NSInteger getAccessTokenCode, NSString *getAccessTokenMessage) {
                if (getAccessTokenCode == 0) {
                    //获取btc_address
                    [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpwithHeader:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",getAccessTokenDic[@"access_token"]]} WithPath:[NSString stringWithFormat:@"%@/getbtc",self.hostUrlTf.text] withMethodType:Get withParams:@{} result:^(id  _Nullable btcAddressDic, NSInteger btcAddressCode, NSString *btcAddressMessage) {
                        if (btcAddressCode == 0) {
                            SHLNWalletModel *lnWalletModel = [SHLNWalletModel new];
                            lnWalletModel.WalletName = self.walletNameTf.text;
                            lnWalletModel.hostUrl = self.hostUrlTf.text;
                            lnWalletModel.UserAccount = createAccountDic[@"login"];
                            lnWalletModel.UserPassWord = createAccountDic[@"password"];
                            lnWalletModel.refresh_token = getAccessTokenDic[@"refresh_token"];
                            lnWalletModel.access_token = getAccessTokenDic[@"access_token"];
                            lnWalletModel.btcAddress =  [(NSArray*)btcAddressDic count]>0?btcAddressDic[0][@"address"]:@"";
                            lnWalletModel.createTimestamp = [NSString getNowTimeTimestamp];
                            [[SHKeyStorage shared]createLNWalletsWithWalletModel:lnWalletModel];
                            [MBProgressHUD hideCustormLoadingWithView:self.view];
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
        }else
        {
            [MBProgressHUD hideCustormLoadingWithView:self.view];
            self.hostUrlErrorLabel.hidden = NO;
            self.hostUrlLineView.backgroundColor = SHTheme.errorTipsRedColor;
            self.hostUrlLineView.alpha = 1;
        }
    }];
}
#pragma mark 懒加载

#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
    if ([textField isEqual:self.walletNameTf] && textField.text.length >=20) {
        textField.text = [textField.text substringToIndex:20];
    }
    if ([textField isEqual:self.hostUrlTf]) {
        self.hostUrlLineView.alpha = 0.12;
        self.hostUrlErrorLabel.hidden = YES;
        self.hostUrlLineView.backgroundColor = SHTheme.appBlackColor;
    }
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.walletNameTf.text)&&!IsEmpty(self.hostUrlTf.text)) {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = YES;
    }else
    {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = NO;
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
        _walletNameTf.placeholder = GCLocalizedString(@"Enter_wallet_name");
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
        _hostUrlTipsLabel.text = GCLocalizedString(@"Host");
        [self.view addSubview:_hostUrlTipsLabel];
    }
    return _hostUrlTipsLabel;
}
-(UITextField *)hostUrlTf
{
    if (_hostUrlTf == nil) {
        _hostUrlTf = [[UITextField alloc]init];
        _hostUrlTf.tintColor = SHTheme.agreeButtonColor;
        _hostUrlTf.text = @"https://lndhub.io";
        _hostUrlTf.placeholder = GCLocalizedString(@"Enter_host");
        _hostUrlTf.clearButtonMode = UITextFieldViewModeAlways;
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
-(UILabel *)hostUrlErrorLabel
{
    if (_hostUrlErrorLabel == nil) {
        _hostUrlErrorLabel = [[UILabel alloc]init];
        _hostUrlErrorLabel.font = kCustomMontserratMediumFont(12);
        _hostUrlErrorLabel.textColor = SHTheme.errorTipsRedColor;
        _hostUrlErrorLabel.hidden = YES;
        _hostUrlErrorLabel.text = GCLocalizedString(@"Host_error");
        [self.view addSubview:_hostUrlErrorLabel];
    }
    return _hostUrlErrorLabel;
}
-(UIButton *)confirmButton
{
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc]init];
        _confirmButton.layer.cornerRadius = 26*FitHeight;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.enabled = NO;
        [_confirmButton setTitle:GCLocalizedString(@"Create") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = kMediunFont(14);
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}
-(UIButton *)importButton
{
    if (_importButton == nil) {
        _importButton = [[UIButton alloc]init];
        [_importButton setTitle:GCLocalizedString(@"import_desc") forState:UIControlStateNormal];
        [_importButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _importButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_importButton addTarget:self action:@selector(importButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_importButton];
    }
    return _importButton;
}
@end
