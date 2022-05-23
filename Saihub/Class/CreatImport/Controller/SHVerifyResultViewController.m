//
//  SHVerifyResultViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/23.
//

#import "SHVerifyResultViewController.h"
#import "SHSetOptionalPassWordViewController.h"
#import "SHBtcWallet.h"
#import "SHBtcCreatOrImportWalletManage.h"
#import "BTBIP39.h"
#import "SHWalletModel.h"
#import "BTHDAccount.h"
#import "SHWalletController.h"
@interface SHVerifyResultViewController ()
@property (nonatomic, strong) UILabel *topTipsLabel;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UILabel *passPhraseLabel;
@property (nonatomic, strong) UIButton *passPhraseButton;
@end

@implementation SHVerifyResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.topTipsLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.navBar, 20*FitHeight).heightIs(36*FitHeight);
    [self.topTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.resultImageView.sd_layout.centerXEqualToView(self.topTipsLabel).topSpaceToView(self.topTipsLabel, 16*FitHeight).widthIs(132*FitWidth).heightIs(93*FitHeight);
    self.resultLabel.sd_layout.centerXEqualToView(self.resultImageView).topSpaceToView(self.resultImageView, 3*FitHeight).heightIs(22*FitHeight);
    [self.resultLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.continueButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.resultLabel, 88*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    
    // 正常创建才展示
    if (self.controllerType == SHShowMnemonicViewControllerTypeNormal) {
        self.passPhraseButton.sd_layout.centerXEqualToView(self.view).bottomSpaceToView(self.view, 72*FitHeight + SafeAreaTopHeight).widthIs(kWIDTH).heightIs(38*FitHeight);
        self.passPhraseLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.passPhraseButton, 0).heightIs(18*FitHeight);
        [self.passPhraseLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    }
    
}
#pragma mark 第三方事件
#pragma mark 创建btc钱包
-(void)CreatBTCWallet
{
    BTBIP39 *btbip39 = [BTBIP39 sharedInstance];
    NSString *code = [btbip39 toMnemonicWithArray:self.mnemonicArray];
    NSData *mnemonicCodeSeed = [btbip39 toEntropy:code];
    
        SHBtcWallet *btcWalletModel = [SHBtcCreatOrImportWalletManage creatBtcWalletWithPassWord:self.passWord withPassphrase:@"" withEntropy:mnemonicCodeSeed];
    if (IsEmpty(btcWalletModel)||IsEmpty(btcWalletModel.mnemonics)) {
        [MBProgressHUD showError:GCLocalizedString(@"wallet_import_error") toView:self.view];
        self.continueButton.enabled = YES;
        return;
    }
    //存储钱包信息
//    BTHDAccount *account = [[BTHDAccount alloc] initWithSeedId:btcWalletModel.hdAccountId];
//    //密码存储钥匙
//    NSLog(@"%@",[account xPub:self.passWord withPurposePathLevel:P2SHP2WPKH]);
//    NSString *pub = [[account xPub:self.passWord withPurposePathLevel:P2SHP2WPKH] serializePubB58];

    //存储钱包信息
    SHWalletModel *model = [[SHWalletModel alloc]init];
    model.importType = SHWalletImportTypeMnemonic;
    model.isCurrent = YES;
    model.name = self.walletName;
    model.mnemonic = [self.mnemonicArray componentsJoinedByString:@" "];
    model.password = self.passWord;
    model.publicKey = btcWalletModel.publick;
    model.createTimestamp = [NSString getNowTimeTimestamp];
    model.hdAccountId = btcWalletModel.hdAccountId;
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:self.mnemonicArray password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    BTCKeychain *masterKey = mnemonic.keychain;
    //添加地址列表
    NSError *error = nil;
    for (int index = 0; index < 20; index ++ ) {
       NSDictionary *addressOrPriveKeyDic = [SHCreatOrImportManage creatBTCAdressOrPriveKeyWalletWithMnemonics:btcWalletModel.mnemonics passphrase:@"" index:index error:&error];
        if (self.selectedNestedSegWitButton) {
            //3地址
            SHWalletSubAddressModel *address3SubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *general3Path = [NSString stringWithFormat:@"m/49'/0'/0'/0/%d",index];
            BTCKey * btc3Key = [[masterKey derivedKeychainWithPath:@"m/49'/0'/0'/0"] keyAtIndex:index];
            address3SubModel.pathString = general3Path;
            address3SubModel.address = addressOrPriveKeyDic[@"firstAddress49Address"];
            address3SubModel.privateKey = btc3Key.WIF;
            [model.subAddressList addObject:address3SubModel];

            //3找零地址
            SHWalletSubAddressModel *address3ChangeSubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *general3ChangePath = [NSString stringWithFormat:@"m/49'/0'/0'/1/%d",index];
            BTCKey * btc3ChangeKey = [[masterKey derivedKeychainWithPath:@"m/49'/0'/0'/1"] keyAtIndex:index];
            address3ChangeSubModel.pathString = general3ChangePath;
            address3ChangeSubModel.address = addressOrPriveKeyDic[@"changeAddress49Address"];
            address3ChangeSubModel.privateKey = btc3ChangeKey.WIF;
            [model.changeAddressList addObject:address3ChangeSubModel];
            if (index == 0) {
                model.address = addressOrPriveKeyDic[@"firstAddress49Address"];
                model.privateKey = addressOrPriveKeyDic[@"firstAddress49PriveKey"];
            }
        }else
        {
            //bc1地址
            SHWalletSubAddressModel *addressBc1SubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *generalPath = [NSString stringWithFormat:@"m/84'/0'/0'/0/%d",index];
            BTCKey * btcBc1Key = [[masterKey derivedKeychainWithPath:@"m/84'/0'/0'/0"] keyAtIndex:index];
            addressBc1SubModel.pathString = generalPath;
            addressBc1SubModel.address = addressOrPriveKeyDic[@"firstAddress84Address"];
            addressBc1SubModel.privateKey = btcBc1Key.WIF;
            [model.subAddressList addObject:addressBc1SubModel];

            //bc1找零地址
            SHWalletSubAddressModel *addressBc1ChangeSubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *generalChangePath = [NSString stringWithFormat:@"m/84'/0'/0'/1/%d",index];
            BTCKey * btcBc1ChangeKey = [[masterKey derivedKeychainWithPath:@"m/84'/0'/0'/1"] keyAtIndex:index];
            addressBc1ChangeSubModel.pathString = generalChangePath;
            addressBc1ChangeSubModel.address = addressOrPriveKeyDic[@"changeAddress84Address"];
            addressBc1ChangeSubModel.privateKey = btcBc1ChangeKey.WIF;
            [model.changeAddressList addObject:addressBc1ChangeSubModel];
            if (index == 0) {
                model.address = addressOrPriveKeyDic[@"firstAddress84Address"];
                model.privateKey = addressOrPriveKeyDic[@"firstAddress84PriveKey"];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.continueButton.enabled = YES;
        [[SHKeyStorage shared] createWalletsWithWalletModel:model];
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
            [self popBackWithClassArray:@[[SHUnlockSettingViewController class],[SHWalletController class]]];
        }
    });

}
#pragma mark 按钮事件

-(void)continueButtonAction:(UIButton *)btn
{
    // 导出助记词
    if (self.controllerType == SHShowMnemonicViewControllerTypeExport) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    self.continueButton.enabled = NO;
    dispatch_async(dispatch_queue_create("CreatBTCWallet", DISPATCH_QUEUE_SERIAL),^{//DISPATCH_QUEUE_SERIAL:串行队列DISPATCH_QUEUE_CONCURRENT：并发队列
        [self CreatBTCWallet];
    });
}
-(void)passPhraseButtonAction:(UIButton *)btn
{
    SHSetOptionalPassWordViewController *setOptionalPassWordViewController = [[SHSetOptionalPassWordViewController alloc]init];
    setOptionalPassWordViewController.selectedNestedSegWitButton = self.selectedNestedSegWitButton;
    setOptionalPassWordViewController.passWord = self.passWord;
    setOptionalPassWordViewController.mnemonicArray = self.mnemonicArray;
    setOptionalPassWordViewController.walletName = self.walletName;
    [self.navigationController pushViewController:setOptionalPassWordViewController animated:YES];
}
#pragma mark 懒加载
-(UILabel *)topTipsLabel
{
    if (_topTipsLabel == nil) {
        _topTipsLabel = [[UILabel alloc]init];
        _topTipsLabel.font = kCustomMontserratMediumFont(24);
        _topTipsLabel.text = GCLocalizedString(@"verify_result");
        _topTipsLabel.textColor = SHTheme.appTopBlackColor;
        [self.view addSubview:_topTipsLabel];
    }
    return _topTipsLabel;
}
-(UIButton *)continueButton
{
    if (_continueButton == nil) {
        _continueButton = [[UIButton alloc]init];
        _continueButton.layer.cornerRadius = 26*FitHeight;
        _continueButton.layer.masksToBounds = YES;
        [_continueButton setTitle:GCLocalizedString(@"enter_Wallet_desc") forState:UIControlStateNormal];
        [_continueButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _continueButton.titleLabel.font = kMediunFont(14);
        [_continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_continueButton];
    }
    return _continueButton;
}
-(UIImageView *)resultImageView
{
    if (_resultImageView == nil) {
        _resultImageView = [[UIImageView alloc]init];
        _resultImageView.image = [UIImage imageNamed:@"resultVc_resultImageView"];
        [self.view addSubview:_resultImageView];
    }
    return _resultImageView;
}
-(UILabel *)resultLabel
{
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.font = kCustomMontserratRegularFont(14);
        _resultLabel.textColor = SHTheme.appBlackColor;
        _resultLabel.text = GCLocalizedString(@"verify_success");
        [self.view addSubview:_resultLabel];
    }
    return _resultLabel;
}
-(UILabel *)passPhraseLabel
{
    if (_passPhraseLabel == nil) {
        _passPhraseLabel = [[UILabel alloc]init];
        _passPhraseLabel.font = kCustomMontserratRegularFont(12);
        _passPhraseLabel.textColor = SHTheme.agreeTipsLabelColor;
        _passPhraseLabel.text = GCLocalizedString(@"passphrase_tip");
        [self.view addSubview:_passPhraseLabel];
    }
    return _passPhraseLabel;
}
-(UIButton *)passPhraseButton
{
    if (_passPhraseButton == nil) {
        _passPhraseButton = [[UIButton alloc]init];
        [_passPhraseButton setTitle:GCLocalizedString(@"set_passphrase_desc") forState:UIControlStateNormal];
        [_passPhraseButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _passPhraseButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_passPhraseButton addTarget:self action:@selector(passPhraseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_passPhraseButton];
    }
    return _passPhraseButton;
}
@end
