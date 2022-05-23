//
//  SHSetPassWordViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/24.
//

#import "SHSetPassWordViewController.h"
#import "SHPasswordStrength.h"
#import "SHImportCheckTypeManage.h"
#import "SHSetOptionalPassWordViewController.h"
#import "SHBtcWallet.h"
#import "SHBtcCreatOrImportWalletManage.h"
#import "BTBIP39.h"
#import "SHWalletModel.h"
#import "BTHDAccount.h"
#import "SHWalletController.h"
#import <WebKit/WebKit.h>
@interface SHSetPassWordViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) UILabel *setPassTipsLabel;
@property (nonatomic, strong) TGTextField *setPassTf;
@property (nonatomic, strong) UIButton *setSeeOrHidderButton;
@property (nonatomic, strong) UIView *setPassLineView;
@property (nonatomic, strong) TGTextField *resetPassTf;
@property (nonatomic, strong) UIButton *resetSeeOrHidderButton;
@property (nonatomic, strong) UIView *resetPassLineView;

@property (nonatomic, strong) TGTextField *passPhrasePassTf;
@property (nonatomic, strong) UIButton *passPhraseSeeOrHidderButton;
@property (nonatomic, strong) UIView *passPhrasePassLineView;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UILabel *passPhraseTipsLabel;
@property (nonatomic, strong) UIButton *passPhraseButton;
@property (nonatomic, strong) SHPasswordStrength *passwordStrengthView;
@property (nonatomic, assign) NSInteger importType;
@property (nonatomic, strong) UILabel *errorTipsLabel;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NSString *bc1AddressString;
@property (nonatomic, strong) NSString *Address3String;

@end

@implementation SHSetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"add_wallet");
    self.importType = [SHImportCheckTypeManage importWalletCheckTypeWithCheckString:self.importKeyString];
    [self layoutScale];
    // Do any additional setup after loading the view.
    if (self.importType == 1 ) {
        [self loadWebView];
    }
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.setPassTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(22*FitHeight);
    [self.setPassTipsLabel setSingleLineAutoResizeWithMaxWidth:350*FitWidth];
    self.passwordStrengthView.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(self.setPassTipsLabel).widthIs(300*FitWidth).heightIs(14*FitHeight);
    
    
    
    self.setPassTf.sd_layout.leftEqualToView(self.setPassTipsLabel).topSpaceToView(self.setPassTipsLabel, 1*FitHeight).widthIs(300*FitWidth).heightIs(45*FitHeight);
    self.setSeeOrHidderButton.sd_layout.centerYEqualToView(self.setPassTf).rightSpaceToView(self.view, 20*FitWidth).widthIs(20*FitWidth).heightEqualToWidth();
    self.setPassLineView.sd_layout.leftEqualToView(self.setPassTipsLabel).rightEqualToView(self.setSeeOrHidderButton).topSpaceToView(self.setPassTf, 1*FitHeight).heightIs(1);
    self.resetPassTf.sd_layout.leftEqualToView(self.setPassLineView).topSpaceToView(self.setPassLineView, 15*FitHeight).widthIs(300*FitWidth).heightIs(45*FitHeight);
    self.resetSeeOrHidderButton.sd_layout.centerYEqualToView(self.resetPassTf).rightEqualToView(self.setPassLineView).widthIs(20*FitWidth).heightEqualToWidth();
    self.resetPassLineView.sd_layout.leftEqualToView(self.setPassLineView).rightEqualToView(self.setPassLineView).topSpaceToView(self.resetPassTf, 1*FitHeight).heightIs(1);
    self.errorTipsLabel.sd_layout.leftEqualToView(self.resetPassLineView).topSpaceToView(self.resetPassLineView, 8*FitHeight).heightIs(18*FitHeight);
    [self.errorTipsLabel setSingleLineAutoResizeWithMaxWidth:335*FitWidth];
    self.passPhraseTipsLabel.sd_layout.leftEqualToView(self.setPassTipsLabel).topSpaceToView(self.resetPassLineView, 24*FitHeight).heightIs(22*FitHeight);
    [self.passPhraseTipsLabel setSingleLineAutoResizeWithMaxWidth:300];
    self.passPhraseButton.sd_layout.rightEqualToView(self.resetPassLineView).centerYEqualToView(self.passPhraseTipsLabel).widthIs(32*FitWidth).heightIs(20*FitHeight);
    
    self.passPhrasePassTf.sd_layout.leftEqualToView(self.setPassLineView).topSpaceToView(self.passPhraseTipsLabel, 0*FitHeight).widthIs(300*FitWidth).heightIs(45*FitHeight);
    self.passPhraseSeeOrHidderButton.sd_layout.centerYEqualToView(self.passPhrasePassTf).rightEqualToView(self.passPhraseButton).widthIs(20*FitWidth).heightEqualToWidth();
    self.passPhrasePassLineView.sd_layout.leftEqualToView(self.setPassLineView).rightEqualToView(self.setPassLineView).topSpaceToView(self.passPhrasePassTf, 1*FitHeight).heightIs(1);
    if (self.importType == 0) {
        self.passPhraseTipsLabel.hidden = NO;
        self.passPhraseButton.hidden = NO;
    }else
    {
        self.passPhraseTipsLabel.hidden = YES;
        self.passPhraseButton.hidden = YES;
    }
    self.confirmButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.resetPassLineView, 198*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    self.cancelButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.confirmButton, 0).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    
}
-(void)loadWebView
{
    //创建一个WKWebView的配置对象
    WKWebViewConfiguration *configur=[[WKWebViewConfiguration alloc]init];
    //设置configur对象的preferences属性的信息
    WKPreferences *preferences = [[WKPreferences alloc]init];
    configur.preferences=preferences;
    //是否允许与js进行交互，默认是YES的，如果设置为NO，js的代码就不起作用了
    preferences.javaScriptEnabled =YES;
    WKUserContentController *userContentController=[[WKUserContentController alloc]init];
//    WKUserScript *script = [[WKUserScript alloc] initWithSource:[NSString stringWithFormat:@"privateKeyToBech32Address('%@')",self.importKeyString] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//    [userContentController addUserScript:script];
//    //添加消息处理，注意：self指代的是需要遵守WKScriptMessageHandler协议，结束时需要移除
//    [userContentController addScriptMessageHandler:self name:@"privateKeyToBech32AddressBack"];
//
    configur.userContentController=userContentController;
    //解决跨域问题
    [configur.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    if (@available(iOS 10.0, *)) {
        [configur setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
    }
    WKWebView *wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0,0 , 1) configuration:configur];
    wkWebView.hidden = YES;
    self.wkWebView = wkWebView;
    [self.view addSubview:wkWebView];
    //设置内边距底部，主要是为了让网页最后的内容不被底部的toolBar挡着
    //wkWebView.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 104, 0);
    //这句代码是让竖直方向的滚动条显示在正确的位置
    wkWebView.scrollView.scrollIndicatorInsets=wkWebView.scrollView.contentInset;
    wkWebView.UIDelegate=self;
    wkWebView.navigationDelegate=self;
    //加载html字符串
    //[wkWebView loadHTMLString:html StrbaseURL:nil];
    //加载html网页
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ocCallJs"withExtension:@"html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [wkWebView loadRequest:urlRequest];
}

- (void)getBc1Address {
    NSString *jsStr = [NSString stringWithFormat:@"privateKeyToBech32Address('%@')",self.importKeyString];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error)
     {
        NSLog(@"%@",result);
        if (IsEmpty(result)) {
            [MBProgressHUD hideCustormLoadingWithView:nil];
            [MBProgressHUD showError:GCLocalizedString(@"privateKeyToBech32Address error") toView:self.view];
            return;
        }
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resutDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                        if (self.selectedNestedSegWitButton) {
                            if ([resutDic containsObjectForKey:@"bip49"]) {
                                self.bc1AddressString = resutDic[@"bip49"];
                            }
                        }else
                        {
                            if ([resutDic containsObjectForKey:@"bech32"]) {
                                self.bc1AddressString = resutDic[@"bech32"];
                            }
                        }
    }];
    });
}
-(void)setBc1AddressString:(NSString *)bc1AddressString
{
    _bc1AddressString = bc1AddressString;
    [self privateKeyImportWithPassWord:self.setPassTf.text];
}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
    //    if ([textField isEqual:self.remarkNameTf] && textField.text.length >=30) {
    //        textField.text = [textField.text substringToIndex:30];
    //    }
    if ([textField isEqual:self.setPassTf]||[textField isEqual:self.resetPassTf]) {
        self.setPassLineView.backgroundColor = SHTheme.appBlackColor;
        self.resetPassLineView.backgroundColor = SHTheme.appBlackColor;
        self.setPassLineView.alpha = 0.12;
        self.resetPassLineView.alpha = 0.12;
        self.errorTipsLabel.hidden = YES;
    }
    if ([textField isEqual:self.setPassTf]) {
        self.passwordStrengthView.passwordStrengthType = [NSString judgePasswordStrength:textField.text];
    }
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.setPassTf.text)&&!IsEmpty(self.resetPassTf.text)&&(!self.passPhraseButton.selected || (self.passPhraseButton.selected&&!IsEmpty(self.passPhrasePassTf.text)))) {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = YES;
        self.cancelButton.enabled = YES;
        
    }else
    {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = NO;
        self.cancelButton.enabled = NO;
    }
}
#pragma mark 按钮事件
-(void)setSeeOrHidderButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.setPassTf.secureTextEntry = !self.setPassTf.secureTextEntry;
}
-(void)resetSeeOrHidderButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.resetPassTf.secureTextEntry = !self.resetPassTf.secureTextEntry;
}
-(void)passPhraseSeeOrHidderButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.passPhrasePassTf.secureTextEntry = !self.passPhrasePassTf.secureTextEntry;
}
-(void)confirmButtonAction:(UIButton *)btn
{
    if (![self.setPassTf.text isEqualToString:self.resetPassTf.text]) {
        self.setPassLineView.backgroundColor = SHTheme.errorTipsRedColor;
        self.resetPassLineView.backgroundColor = SHTheme.errorTipsRedColor;
        self.setPassLineView.alpha = 1;
        self.resetPassLineView.alpha = 1;
        self.errorTipsLabel.hidden = NO;
        return;
    }
    if (self.setPassTf.text.length <8) {
        [MBProgressHUD showError:GCLocalizedString(@"pwd_tip") toView:self.view];
        return;
    }
    [self.setPassTf resignFirstResponder];
    [self.resetPassTf resignFirstResponder];
    [self.passPhrasePassTf resignFirstResponder];

    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:GCLocalizedString(@"import_loading")];
    [self.view bringSubviewToFront:self.navBar];
    self.confirmButton.enabled = NO;
    NSString *passWord = self.setPassTf.text;
    NSString *passPhrase = IsEmpty(self.passPhrasePassTf.text)?@"":self.passPhrasePassTf.text;
    BOOL passPhraseSelect = self.passPhraseButton.selected;
    dispatch_async(dispatch_queue_create("importBTCWallet", DISPATCH_QUEUE_SERIAL),^{//DISPATCH_QUEUE_SERIAL:串行队列DISPATCH_QUEUE_CONCURRENT：并发队列
        switch (self.importType) {
            case 0:
            {//助记词导入
                [self mnemonicWordImportWithPassWord:passWord WithPassPhrase:passPhrase WithPassPhraseSelect:passPhraseSelect];
            }
                break;
            case 1:
            {//私钥导入
//                if (self.selectedNestedSegWitButton) {
//                    [self privateKeyImportWithPassWord:passWord];
//                }else
//                {
                    [self getBc1Address];
//                }
                
            }
                break;
            case 2:
            {//公钥导入
            }
                break;
            case 3:
            {//地址导入
            }
                break;
            default:
                break;
        }
    });
}
#pragma mark 助记词导入
-(void)mnemonicWordImportWithPassWord:(NSString *)passWord  WithPassPhrase:(NSString *)passPhrase WithPassPhraseSelect:(BOOL)passPhraseSelect
{
    RLMResults<SHWalletModel *> *wallets = [SHWalletModel objectsWhere:[NSString stringWithFormat:@"importType=%zd",SHWalletImportTypeMnemonic]];
    for (SHWalletModel *walletModel in wallets) {
        if ([walletModel.mnemonic isEqualToString:self.importKeyString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.confirmButton.enabled = YES;
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:GCLocalizedString(@"same_wallet_tip") toView:nil];
            });
            return;
        }
    }
    //地址导入
    SHBtcWallet *btcWalletModel = [SHBtcCreatOrImportWalletManage importBtcWalletWithMnemonics:self.importKeyString WithPassWord:passWord withPassphrase:passPhraseSelect?passPhrase:@""];
    if (IsEmpty(btcWalletModel)||IsEmpty(btcWalletModel.mnemonics)) {
        [MBProgressHUD showError:GCLocalizedString(@"wallet_import_error") toView:self.view];
        self.confirmButton.enabled = YES;
        return;
    }
    //存储钱包信息
    SHWalletModel *model = [[SHWalletModel alloc]init];
    model.importType = SHWalletImportTypeMnemonic;
    model.isCurrent = YES;
    model.name = self.walletName;
    model.mnemonic = self.importKeyString;
    model.password = passWord;
    model.publicKey = btcWalletModel.publick;
    model.createTimestamp = [NSString getNowTimeTimestamp];
    model.hdAccountId = btcWalletModel.hdAccountId;
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:[self.importKeyString componentsSeparatedByString:@" "] password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    BTCKeychain *masterKey = mnemonic.keychain;
    //添加地址列表
    NSError *error = nil;
    for (int index = 0; index < 20; index ++ ) {
        NSDictionary *addressOrPriveKeyDic = [SHCreatOrImportManage creatBTCAdressOrPriveKeyWalletWithMnemonics:btcWalletModel.mnemonics passphrase:passPhrase index:index error:&error];
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
        self.confirmButton.enabled = YES;
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
        [self loadUtxoForMnemonicImport];
    });
    
}
#pragma mark 预加载助记词导入hd账户utxo信息
-(void)loadUtxoForMnemonicImport
{
    NSMutableArray *addressArray = [NSMutableArray array];
    
    for (NSInteger countIndex = 0; countIndex < [SHKeyStorage shared].currentWalletModel.subAddressList.count; countIndex ++) {
        SHWalletSubAddressModel *subAddressModel = [[SHKeyStorage shared].currentWalletModel.subAddressList objectAtIndex:countIndex];
        [addressArray addObject:subAddressModel.address];
        if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypeMnemonic ||[SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey ) {
            SHWalletSubAddressModel *internalAddressModel = [[SHKeyStorage shared].currentWalletModel.changeAddressList objectAtIndex:countIndex];
            [addressArray addObject:internalAddressModel.address];
        }
    }
    if ([[SHKeyStorage.shared.currentWalletModel.address substringToIndex:3].lowercaseString isEqualToString:@"bc1"]) {
        [self signMnemonicForBc1AddressWithAddressArray:addressArray];
    }else
    {
        [self signMnemonicFor3AddressWithAddressArray:addressArray];
    }
}
-(void)signMnemonicForBc1AddressWithAddressArray:(NSMutableArray *)addressArray
{
    [[SHWalletNetManager shared] queryBtcUnspentUtxoBc1WithAddress:addressArray WithblockchairUtxos:[NSMutableArray new] succes:^(NSArray *outs) {
    } fail:^(NSInteger errorCode, NSString * _Nonnull errorMessage) {
        
    }];
}
-(void)signMnemonicFor3AddressWithAddressArray:(NSMutableArray *)addressArray
{
    [[SHWalletNetManager shared] queryBtcUnspentUtxoWithAddress:addressArray  WithblockchairUtxos:[NSMutableArray new] succes:^(id  _Nonnull result) {
    } fail:^(NSInteger errorCode, NSString * _Nonnull errorMessage) {
        
    }];
}
#pragma mark 私钥导入
-(void)privateKeyImportWithPassWord:(NSString *)passWord
{
    RLMResults<SHWalletModel *> *wallets = [SHWalletModel objectsWhere:[NSString stringWithFormat:@"importType=%zd",SHWalletImportTypePrivateKey]];
    for (SHWalletModel *walletModel in wallets) {
        if ([walletModel.privateKey isEqualToString:self.importKeyString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.confirmButton.enabled = YES;
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:GCLocalizedString(@"same_wallet_tip") toView:nil];
            });
            return;
        }
    }
    SHBtcWallet *btcWalletModel = [SHBtcCreatOrImportWalletManage importBtcWalletWithPrivateKey:self.importKeyString WithPassWord:passWord withPassphrase:@""];
    if (IsEmpty(btcWalletModel)||IsEmpty(btcWalletModel.ordinaryAddress)||IsEmpty(btcWalletModel.segwitAddress)) {
        [MBProgressHUD showError:GCLocalizedString(@"fail") toView:self.view];
        return;
    }
    //存储钱包信息
    SHWalletModel *model = [[SHWalletModel alloc]init];
    model.importType = SHWalletImportTypePrivateKey;
    model.isCurrent = YES;
    model.name = self.walletName;
    model.privateKey = self.importKeyString;
    model.password = passWord;
    model.createTimestamp = [NSString getNowTimeTimestamp];
//    if (!self.selectedNestedSegWitButton) {
//        //bc1地址(目前无法生成bc1)
        SHWalletSubAddressModel *address3SubModel = [[SHWalletSubAddressModel alloc]init];
        address3SubModel.address = self.bc1AddressString;
    address3SubModel.privateKey = self.importKeyString;
        [model.subAddressList addObject:address3SubModel];
        model.address = self.bc1AddressString;
//
//
//    }else
//    {
//        //3地址
//        SHWalletSubAddressModel *address3SubModel = [[SHWalletSubAddressModel alloc]init];
//        address3SubModel.address = btcWalletModel.segwitAddress;
//        [model.subAddressList addObject:address3SubModel];
//
//        model.address = btcWalletModel.segwitAddress;
//    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.confirmButton.enabled = YES;
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

-(void)cancelButtonAction:(UIButton *)btn
{
    [self popViewController];
}
-(void)passPhraseButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.passPhrasePassTf.hidden = !btn.selected;
    self.passPhraseSeeOrHidderButton.hidden = !btn.selected;
    self.passPhrasePassLineView.hidden = !btn.selected;
    [self layoutStartButtonColor];
}
#pragma mark 懒加载
-(UILabel *)setPassTipsLabel
{
    if (_setPassTipsLabel == nil) {
        _setPassTipsLabel = [[UILabel alloc]init];
        _setPassTipsLabel.font = kCustomMontserratMediumFont(14);
        _setPassTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _setPassTipsLabel.text = GCLocalizedString(@"set_password");
        [self.view addSubview:_setPassTipsLabel];
    }
    return _setPassTipsLabel;
}
-(TGTextField *)setPassTf
{
    if (_setPassTf == nil) {
        _setPassTf = [[TGTextField alloc]init];
        _setPassTf.tintColor = SHTheme.agreeButtonColor;
        _setPassTf.placeholder = GCLocalizedString(@"pwd_tip_0");
        _setPassTf.font = kCustomMontserratRegularFont(14);
        _setPassTf.secureTextEntry = YES;
        _setPassTf.clearButtonMode = UITextFieldViewModeAlways;
        [_setPassTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_setPassTf];
    }
    return _setPassTf;
}
-(TGTextField *)resetPassTf
{
    if (_resetPassTf == nil) {
        _resetPassTf = [[TGTextField alloc]init];
        _resetPassTf.tintColor = SHTheme.agreeButtonColor;
        _resetPassTf.placeholder = GCLocalizedString(@"pwd_tip_1");
        _resetPassTf.font = kCustomMontserratRegularFont(14);
        _resetPassTf.secureTextEntry = YES;
        _resetPassTf.clearButtonMode = UITextFieldViewModeAlways;
        [_resetPassTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_resetPassTf];
    }
    return _resetPassTf;
}
- (UIView *)setPassLineView
{
    if (_setPassLineView == nil) {
        _setPassLineView = [[UIView alloc]init];
        _setPassLineView.backgroundColor = SHTheme.appBlackColor;
        _setPassLineView.alpha = 0.12;
        [self.view addSubview:_setPassLineView];
    }
    return _setPassLineView;
}
- (UIView *)resetPassLineView
{
    if (_resetPassLineView == nil) {
        _resetPassLineView = [[UIView alloc]init];
        _resetPassLineView.backgroundColor = SHTheme.appBlackColor;
        _resetPassLineView.alpha = 0.12;
        [self.view addSubview:_resetPassLineView];
    }
    return _resetPassLineView;
}
-(UIButton *)setSeeOrHidderButton
{
    if (_setSeeOrHidderButton == nil) {
        _setSeeOrHidderButton = [[UIButton alloc]init];
        [_setSeeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_on"] forState:UIControlStateNormal];
        [_setSeeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_off"] forState:UIControlStateSelected];
        [_setSeeOrHidderButton addTarget:self action:@selector(setSeeOrHidderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_setSeeOrHidderButton];
    }
    return _setSeeOrHidderButton;
}
-(UIButton *)resetSeeOrHidderButton
{
    if (_resetSeeOrHidderButton == nil) {
        _resetSeeOrHidderButton = [[UIButton alloc]init];
        [_resetSeeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_on"] forState:UIControlStateNormal];
        [_resetSeeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_off"] forState:UIControlStateSelected];
        [_resetSeeOrHidderButton addTarget:self action:@selector(resetSeeOrHidderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_resetSeeOrHidderButton];
    }
    return _resetSeeOrHidderButton;
}
-(UIButton *)confirmButton
{
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc]init];
        _confirmButton.layer.cornerRadius = 26*FitHeight;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.enabled = NO;
        [_confirmButton setTitle:GCLocalizedString(@"Confirm") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = kMediunFont(14);
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}
-(UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitle:GCLocalizedString(@"Cancel") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}
-(UILabel *)passPhraseTipsLabel
{
    if (_passPhraseTipsLabel == nil) {
        _passPhraseTipsLabel = [[UILabel alloc]init];
        _passPhraseTipsLabel.font = kCustomMontserratMediumFont(14);
        _passPhraseTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _passPhraseTipsLabel.text = GCLocalizedString(@"passphrase_desc");
        [self.view addSubview:_passPhraseTipsLabel];
    }
    return _passPhraseTipsLabel;
}
-(UIButton *)passPhraseButton
{
    if (_passPhraseButton == nil) {
        _passPhraseButton = [[UIButton alloc]init];
        [_passPhraseButton setImage:[UIImage imageNamed:@"setPassWordVc_passPhraseButton_normal"] forState:UIControlStateNormal];
        [_passPhraseButton setImage:[UIImage imageNamed:@"setPassWordVc_passPhraseButton_select"] forState:UIControlStateSelected];
        [_passPhraseButton addTarget:self action:@selector(passPhraseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_passPhraseButton];
    }
    return _passPhraseButton;
}
-(TGTextField *)passPhrasePassTf
{
    if (_passPhrasePassTf == nil) {
        _passPhrasePassTf = [[TGTextField alloc]init];
        _passPhrasePassTf.tintColor = SHTheme.agreeButtonColor;
        _passPhrasePassTf.placeholder = GCLocalizedString(@"passphrase_hint");
        _passPhrasePassTf.font = kCustomMontserratRegularFont(14);
        _passPhrasePassTf.hidden = YES;
        _passPhrasePassTf.secureTextEntry = YES;
        _passPhrasePassTf.clearButtonMode = UITextFieldViewModeAlways;
        [_passPhrasePassTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_passPhrasePassTf];
    }
    return _passPhrasePassTf;
}
-(UIButton *)passPhraseSeeOrHidderButton
{
    if (_passPhraseSeeOrHidderButton == nil) {
        _passPhraseSeeOrHidderButton = [[UIButton alloc]init];
        [_passPhraseSeeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_on"] forState:UIControlStateNormal];
        [_passPhraseSeeOrHidderButton setImage:[UIImage imageNamed:@"passWordTf_eyes_off"] forState:UIControlStateSelected];
        [_passPhraseSeeOrHidderButton addTarget:self action:@selector(passPhraseSeeOrHidderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _passPhraseSeeOrHidderButton.hidden = YES;
        [self.view addSubview:_passPhraseSeeOrHidderButton];
    }
    return _passPhraseSeeOrHidderButton;
}
- (UIView *)passPhrasePassLineView
{
    if (_passPhrasePassLineView == nil) {
        _passPhrasePassLineView = [[UIView alloc]init];
        _passPhrasePassLineView.backgroundColor = SHTheme.appBlackColor;
        _passPhrasePassLineView.alpha = 0.12;
        _passPhrasePassLineView.hidden = YES;
        [self.view addSubview:_passPhrasePassLineView];
    }
    return _passPhrasePassLineView;
}
-(SHPasswordStrength *)passwordStrengthView
{
    if (_passwordStrengthView == nil) {
        _passwordStrengthView = [[SHPasswordStrength alloc]init];
        [self.view addSubview:_passwordStrengthView];
    }
    return _passwordStrengthView;
}
-(UILabel *)errorTipsLabel
{
    if (_errorTipsLabel == nil) {
        _errorTipsLabel = [[UILabel alloc]init];
        _errorTipsLabel.font = kCustomMontserratRegularFont(12);
        _errorTipsLabel.textColor = SHTheme.errorTipsRedColor;
        _errorTipsLabel.text = GCLocalizedString(@"pwd_repeat_tip");
        _errorTipsLabel.hidden = YES;
        [self.view addSubview:_errorTipsLabel];
    }
    return _errorTipsLabel;
}
-(void)dealloc
{
    [self.wkWebView.configuration.userContentController removeAllUserScripts];
    self.wkWebView.navigationDelegate = nil;
    [self.wkWebView removeFromSuperview];
}
@end
