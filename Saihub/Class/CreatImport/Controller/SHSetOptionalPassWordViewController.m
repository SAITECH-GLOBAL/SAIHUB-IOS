//
//  SHSetOptionalPassWordViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/23.
//

#import "SHSetOptionalPassWordViewController.h"
#import "SHSetOptionalPassWordViewController.h"
#import "SHBtcWallet.h"
#import "SHBtcCreatOrImportWalletManage.h"
#import "BTBIP39.h"
#import "SHWalletModel.h"
#import "BTHDAccount.h"
#import "SHWalletController.h"
@interface SHSetOptionalPassWordViewController ()
@property (nonatomic, strong) UILabel *topTipsLabel;
@property (nonatomic, strong) UILabel *detailTipsLabel;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) NSMutableArray *optionalLineArray;
@property (nonatomic, strong) NSMutableArray *optionalTfArray;
@property (nonatomic, strong) UILabel *errorTipsLabel;

@end

@implementation SHSetOptionalPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.topTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(36*FitHeight);
    [self.topTipsLabel setSingleLineAutoResizeWithMaxWidth:335*FitWidth];
    self.detailTipsLabel.sd_layout.leftEqualToView(self.topTipsLabel).topSpaceToView(self.topTipsLabel, 8*FitHeight).rightSpaceToView(self.view, 20*FitWidth).autoHeightRatio(0);
    for (NSInteger i=0; i<2; i++) {
        UITextField *passphraseTf = [[UITextField alloc]init];
        passphraseTf.tintColor = SHTheme.agreeButtonColor;
        [self.view addSubview:passphraseTf];
        passphraseTf.secureTextEntry = YES;
        passphraseTf.clearButtonMode = UITextFieldViewModeAlways;
        passphraseTf.sd_layout.leftSpaceToView(self.view, 20*FitWidth).rightSpaceToView(self.view, 60*FitWidth).topSpaceToView(self.detailTipsLabel, 16*FitHeight + 54*FitHeight*i).heightIs(40*FitHeight);
        passphraseTf.placeholder = (i==0)?GCLocalizedString(@"set_passphrase_forpassphrase_hint_0"):GCLocalizedString(@"set_passphrase_hint_1");
        [passphraseTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.optionalTfArray addObject:passphraseTf];
        UIView *lineView = [[UIView alloc]init];
        [self.view addSubview:lineView];
        lineView.backgroundColor = SHTheme.appBlackColor;
        lineView.alpha = 0.12;
        lineView.sd_layout.leftEqualToView(passphraseTf).rightSpaceToView(self.view, 20*FitWidth).topSpaceToView(passphraseTf, 0*FitHeight).heightIs(1);
        [self.optionalLineArray addObject:lineView];
        UIButton *seeOrHiddeButton = [[UIButton alloc]init];
        [seeOrHiddeButton setImage:[UIImage imageNamed:@"passWordTf_eyes_on"] forState:UIControlStateNormal];
        [seeOrHiddeButton setImage:[UIImage imageNamed:@"passWordTf_eyes_off"] forState:UIControlStateSelected];
        seeOrHiddeButton.tag = i;
        [seeOrHiddeButton addTarget:self action:@selector(seeOrHiddeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:seeOrHiddeButton];
        seeOrHiddeButton.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(passphraseTf).widthIs(40*FitWidth).heightEqualToWidth();
        seeOrHiddeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    self.errorTipsLabel.sd_layout.leftEqualToView(self.detailTipsLabel).topSpaceToView(self.detailTipsLabel, 124*FitHeight).heightIs(18*FitHeight);
    [self.errorTipsLabel setSingleLineAutoResizeWithMaxWidth:335*FitWidth];
    self.continueButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.detailTipsLabel, 196*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
//    if ([textField isEqual:self.remarkNameTf] && textField.text.length >=30) {
//        textField.text = [textField.text substringToIndex:30];
//    }
    BOOL allInput = YES;
    for (NSInteger i=0; i<self.optionalTfArray.count; i++) {
        UITextField *passphraseTf = self.optionalTfArray[i];
        if (IsEmpty(passphraseTf.text)) {
            allInput = NO;
        }
            UIView *lineView = self.optionalLineArray[i];
            lineView.backgroundColor = SHTheme.appBlackColor;
            lineView.alpha = 0.12;
            self.errorTipsLabel.hidden = YES;
    }

    [self layoutStartButtonColorWithBool:allInput];
}
-(void)layoutStartButtonColorWithBool:(BOOL)allInput
{

    if (allInput) {
        [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.continueButton.enabled = YES;
    }else
    {
        [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.continueButton.enabled = NO;
    }
}
#pragma mark 创建btc钱包
-(void)CreatBTCWalletWithPassWord:(NSString *)passWord
{
    BTBIP39 *btbip39 = [BTBIP39 sharedInstance];
    NSString *code = [btbip39 toMnemonicWithArray:self.mnemonicArray];
    NSData *mnemonicCodeSeed = [btbip39 toEntropy:code];
    
        SHBtcWallet *btcWalletModel = [SHBtcCreatOrImportWalletManage creatBtcWalletWithPassWord:self.passWord withPassphrase:passWord withEntropy:mnemonicCodeSeed];
    if (IsEmpty(btcWalletModel)||IsEmpty(btcWalletModel.mnemonics)) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showError:GCLocalizedString(@"wallet_import_error") toView:self.view];
        self.continueButton.enabled = YES;
        });
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
    if ([self.mnemonicArray isEqualToArray:[[SHKeyStorage shared].currentWalletModel.mnemonic componentsSeparatedByString:@" "]]) {
        model.createTimestamp = [SHKeyStorage shared].currentWalletModel.createTimestamp;
    }else
    {
        model.createTimestamp = [NSString getNowTimeTimestamp];
    }
    model.hdAccountId = btcWalletModel.hdAccountId;
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:self.mnemonicArray password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    BTCKeychain *masterKey = mnemonic.keychain;
    //添加地址列表
    NSError *error = nil;
    for (int index = 0; index < 20; index ++ ) {
       NSDictionary *addressOrPriveKeyDic = [SHCreatOrImportManage creatBTCAdressOrPriveKeyWalletWithMnemonics:btcWalletModel.mnemonics passphrase:passWord index:index error:&error];
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
        if ([self.mnemonicArray isEqualToArray:[[SHKeyStorage shared].currentWalletModel.mnemonic componentsSeparatedByString:@" "]]) {
            [[SHKeyStorage shared] removeArray:@[[SHKeyStorage shared].currentWalletModel]];
        }
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
-(void)seeOrHiddeButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    UITextField *subTextView = self.optionalTfArray[btn.tag];
    subTextView.secureTextEntry = !subTextView.secureTextEntry;
}
-(void)continueButtonAction:(UIButton *)btn
{
    BOOL isEqual = YES;
    UITextField *textFirstField = self.optionalTfArray[0];
    UITextField *textSecondField = self.optionalTfArray[1];
        if (![textFirstField.text isEqualToString:textSecondField.text]) {
            UIView *lineFirstView = self.optionalLineArray[0];
            UIView *lineSecondView = self.optionalLineArray[1];
            lineFirstView.backgroundColor = SHTheme.errorTipsRedColor;
            lineFirstView.alpha = 1;
            lineSecondView.backgroundColor = SHTheme.errorTipsRedColor;
            lineSecondView.alpha = 1;
            self.errorTipsLabel.hidden = NO;
            isEqual = NO;
        }
    if (isEqual) {
        [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
        self.continueButton.enabled = NO;
        NSString *passWord = textFirstField.text;
        dispatch_async(dispatch_queue_create("CreatBTCWalletWithPassWord", DISPATCH_QUEUE_SERIAL),^{//DISPATCH_QUEUE_SERIAL:串行队列DISPATCH_QUEUE_CONCURRENT：并发队列
            [self CreatBTCWalletWithPassWord:passWord];
        });
    }else
    {
        [MBProgressHUD showSuccess:GCLocalizedString(@"Fail") toView:nil];
    }

}
#pragma mark 懒加载
-(NSMutableArray *)optionalTfArray
{
    if (_optionalTfArray == nil) {
        _optionalTfArray = [NSMutableArray new];
    }
    return _optionalTfArray;
}
-(NSMutableArray *)optionalLineArray
{
    if (_optionalLineArray == nil) {
        _optionalLineArray = [NSMutableArray new];
    }
    return _optionalLineArray;
}
-(UILabel *)topTipsLabel
{
    if (_topTipsLabel == nil) {
        _topTipsLabel = [[UILabel alloc]init];
        _topTipsLabel.font = kCustomMontserratMediumFont(24);
        _topTipsLabel.text = GCLocalizedString(@"set_passphrase_desc");
        _topTipsLabel.textColor = SHTheme.appTopBlackColor;
        [self.view addSubview:_topTipsLabel];
    }
    return _topTipsLabel;
}
-(UILabel *)detailTipsLabel
{
    if (_detailTipsLabel == nil) {
        _detailTipsLabel = [[UILabel alloc]init];
        _detailTipsLabel.font = kCustomMontserratMediumFont(14);
        _detailTipsLabel.text = GCLocalizedString(@"set_passphrase_tip");
        _detailTipsLabel.textColor = SHTheme.appBlackColor;
        [self.view addSubview:_detailTipsLabel];
    }
    return _detailTipsLabel;
}
-(UIButton *)continueButton
{
    if (_continueButton == nil) {
        _continueButton = [[UIButton alloc]init];
        _continueButton.layer.cornerRadius = 26*FitHeight;
        _continueButton.layer.masksToBounds = YES;
        _continueButton.enabled = NO;
        [_continueButton setTitle:GCLocalizedString(@"enter_Wallet_desc") forState:UIControlStateNormal];
        [_continueButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _continueButton.titleLabel.font = kMediunFont(14);
        [_continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_continueButton];
    }
    return _continueButton;
}
-(UILabel *)errorTipsLabel
{
    if (_errorTipsLabel == nil) {
        _errorTipsLabel = [[UILabel alloc]init];
        _errorTipsLabel.font = kCustomMontserratRegularFont(12);
        _errorTipsLabel.textColor = SHTheme.errorTipsRedColor;
        _errorTipsLabel.text = GCLocalizedString(@"passphrase_forpassphrase_repeat_tip");
        _errorTipsLabel.hidden = YES;
        [self.view addSubview:_errorTipsLabel];
    }
    return _errorTipsLabel;
}
@end
