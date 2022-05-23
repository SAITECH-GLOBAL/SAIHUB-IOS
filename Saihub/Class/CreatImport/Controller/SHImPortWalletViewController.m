//
//  SHImPortWalletViewController.m
//  Saihub
//
//  Created by macbook on 2022/3/24.
//

#import "SHImPortWalletViewController.h"
#import "SHBtcCreatOrImportWalletManage.h"
#import <WebKit/WebKit.h>
#import "SHWalletController.h"
#import "SHUnlockSettingViewController.h"
#import "SHImportCheckTypeManage.h"
#import "SHSetPassWordViewController.h"
@interface SHImPortWalletViewController ()<UITextViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) UILabel *importTipsLabel;
@property (nonatomic, strong) UILabel *pleaseEnterTipsLabel;
@property (nonatomic, strong) UILabel *coldWalletTipsLabel;
@property (nonatomic, strong) UIView *inputTVBackView;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UILabel *walletNameTipsLabel;
@property (nonatomic, strong) UILabel *walletNameValueLabel;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation SHImPortWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
    self.titleLabel.text = GCLocalizedString(@"add_wallet");
    [self.rightButton setImage:[UIImage imageNamed:@"importWallet_scanButton"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    [self layoutScale];
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
#pragma mark 布局页面
-(void)layoutScale
{
    self.importTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(36*FitHeight);
    [self.importTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.pleaseEnterTipsLabel.sd_layout.leftEqualToView(self.importTipsLabel).rightSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.importTipsLabel, 8*FitHeight).autoHeightRatio(0);
    self.coldWalletTipsLabel.sd_layout.leftEqualToView(self.pleaseEnterTipsLabel).rightEqualToView(self.pleaseEnterTipsLabel).topSpaceToView(self.pleaseEnterTipsLabel, 8*FitHeight).autoHeightRatio(0);
    self.inputTVBackView.sd_layout.leftEqualToView(self.pleaseEnterTipsLabel).rightEqualToView(self.pleaseEnterTipsLabel).topSpaceToView(self.coldWalletTipsLabel, 16*FitHeight).heightIs(156*FitHeight);
    self.inputTextView.sd_layout.leftSpaceToView(self.inputTVBackView, 12*FitWidth).topSpaceToView(self.inputTVBackView, 12*FitHeight).rightSpaceToView(self.inputTVBackView, 12*FitWidth).bottomSpaceToView(self.inputTVBackView, 12*FitHeight);
    self.walletNameTipsLabel.sd_layout.leftEqualToView(self.inputTVBackView).topSpaceToView(self.inputTVBackView, 24*FitHeight).heightIs(22*FitHeight);
    [self.walletNameTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.walletNameValueLabel.sd_layout.rightEqualToView(self.inputTVBackView).centerYEqualToView(self.walletNameTipsLabel).heightIs(22*FitHeight);
    [self.walletNameValueLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.createButton.sd_layout.centerXEqualToView(self.view).widthIs(335*FitWidth).heightIs(52*FitHeight).topSpaceToView(self.walletNameTipsLabel, 88*FitHeight);
    [self.view layoutIfNeeded];
    [self.createButton setBackgroundImage:[UIImage gradientImageWithBounds:self.createButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 按钮事件
-(void)createButtonAction:(UIButton *)btn
{
    NSString *textString = self.inputTextView.text;
    [self.view bringSubviewToFront:self.navBar];
    NSInteger type = [SHImportCheckTypeManage importWalletCheckTypeWithCheckString: self.inputTextView.text];
    switch (type) {
        case 0:
        {//助记词导入
            [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:GCLocalizedString(@"import_loading")];
            if ([SHImportCheckTypeManage importWalletCheckHaveSameWalletWithCheckString:self.inputTextView.text WithImportType:0]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showError:GCLocalizedString(@"same_wallet_tip") toView:self.view];
                });
                return;
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                });
                SHAlertView *alertView = [[SHAlertView alloc]initSelectAdressTypeWithTitle:GCLocalizedString(@"Address Type") alert:@"" sureTitle:GCLocalizedString(@"import_desc") sureBlock:^(NSString * _Nonnull str) {
                    SHSetPassWordViewController *setPassWordViewController = [SHSetPassWordViewController new];
                    setPassWordViewController.importKeyString = self.inputTextView.text;
                    setPassWordViewController.walletName = self.walletName;
                    setPassWordViewController.selectedNestedSegWitButton = [str isEqualToString:@"1"]?YES:NO;
                    [self.navigationController pushViewController:setPassWordViewController animated:YES];
                }];
                [KeyWindow addSubview:alertView];
            }
        }
            break;
        case 1:
        {//私钥导入
            [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:GCLocalizedString(@"import_loading")];
            if ([SHImportCheckTypeManage importWalletCheckHaveSameWalletWithCheckString:self.inputTextView.text WithImportType:1]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showError:GCLocalizedString(@"same_wallet_tip") toView:self.view];
                });
                return;
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                });
                SHAlertView *alertView = [[SHAlertView alloc]initSelectAdressTypeWithTitle:GCLocalizedString(@"Address Type") alert:@"" sureTitle:GCLocalizedString(@"import_desc") sureBlock:^(NSString * _Nonnull str) {
                    SHSetPassWordViewController *setPassWordViewController = [SHSetPassWordViewController new];
                    setPassWordViewController.importKeyString = self.inputTextView.text;
                    setPassWordViewController.walletName = self.walletName;
                    setPassWordViewController.selectedNestedSegWitButton = [str isEqualToString:@"1"]?YES:NO;
                    [self.navigationController pushViewController:setPassWordViewController animated:YES];
                }];
                [KeyWindow addSubview:alertView];
            }
            
        }
            break;
        case 2:
        {//公钥导入
            [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:GCLocalizedString(@"import_loading")];
            dispatch_async(dispatch_queue_create("importBTCWallet", DISPATCH_QUEUE_SERIAL),^{//DISPATCH_QUEUE_SERIAL:串行队列DISPATCH_QUEUE_CONCURRENT：并发队列
                [self publickImportActionWith:textString withExtpubKeyJson:@""];
            });
        }
            break;
        case 3:
        {//地址导入
            dispatch_async(dispatch_queue_create("importBTCWallet", DISPATCH_QUEUE_SERIAL),^{//DISPATCH_QUEUE_SERIAL:串行队列DISPATCH_QUEUE_CONCURRENT：并发队列
                [self addressImportActionWith:textString];
            });
        }
            break;
        case 4:
        {//多签公钥导入
            [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:GCLocalizedString(@"import_loading")];
            dispatch_async(dispatch_queue_create("importBTCWallet", DISPATCH_QUEUE_SERIAL),^{//DISPATCH_QUEUE_SERIAL:串行队列DISPATCH_QUEUE_CONCURRENT：并发队列
                [self publickMutImportActionWith:textString];
            });
        }
            break;
        case 5:
        {//未知导入
            [MBProgressHUD hideCustormLoadingWithView:self.view];
            [MBProgressHUD showError:GCLocalizedString(@"wallet_import_error") toView:self.view];
        }
            break;
        case 6:
        {//单签公钥导入
            [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:GCLocalizedString(@"import_loading")];
            dispatch_async(dispatch_queue_create("importBTCWallet", DISPATCH_QUEUE_SERIAL),^{//DISPATCH_QUEUE_SERIAL:串行队列DISPATCH_QUEUE_CONCURRENT：并发队列
                NSData *data = [textString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *resutDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                if (![resutDic containsObjectForKey:@"ExtPubKey"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideCustormLoadingWithView:self.view];
                        [MBProgressHUD showError:GCLocalizedString(@"ExtPubKey nil") toView:nil];
                    });
                    return;
                }
                [self publickImportActionWith:resutDic[@"ExtPubKey"] withExtpubKeyJson:textString];
            });
        }
            break;
        default:
            break;
    }
}
#pragma mark 多签公钥导入
-(void)publickMutImportActionWith:(NSString *)textString
{
    //多签公钥导入
    NSMutableArray *wordlist = [[NSMutableArray alloc]initWithArray:[textString componentsSeparatedByString:@"\n"]];
    NSMutableArray *wordMutlist = [[NSMutableArray alloc]initWithArray:[textString componentsSeparatedByString:@"\n"]];
    __block NSInteger nameIndex = 1000;
    [wordMutlist enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((obj.length>=5)) {
            if (![[obj substringToIndex:5] isEqualToString:@"Name:"]) {
                if (nameIndex >idx) {
                    [wordlist removeObject:obj];
                }else
                {
                    if ([obj isEqualToString:@""]) {
                        [wordlist removeObject:obj];
                    }
                }
            }else
            {
                nameIndex = idx;
            }
        }else
        {
            [wordlist removeObject:obj];
        }
        
    }];
    NSString *policyString = [wordlist[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableDictionary *pubDic = [NSMutableDictionary new];
    NSString *derivation = [[wordlist[2] stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@":"][1];
    NSString *format = [[wordlist[3] stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@":"][1];
    NSString *policySureCount = [[policyString componentsSeparatedByString:@":"][1] componentsSeparatedByString:@"of"][0];
    NSString *policyTotalCount = [[policyString componentsSeparatedByString:@":"][1] componentsSeparatedByString:@"of"][1];
    [pubDic setObject:derivation forKey:@"derivation"];
    [pubDic setObject:format forKey:@"format"];
    [pubDic setObject:policySureCount forKey:@"policySureCount"];
    [pubDic setObject:policyTotalCount forKey:@"policyTotalCount"];
    
    NSMutableArray *pubkeyArray = [NSMutableArray new];
    NSMutableArray *pubkeyTitleArray = [NSMutableArray new];
    NSMutableArray *pubkeyForMutArray = [NSMutableArray new];
    
    for (NSInteger i = 4; i < 4 + [policyTotalCount intValue]; i++) {
        NSString *pubId = [[wordlist[i] stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@":"][0];
        [pubkeyTitleArray addObject:pubId];
        NSString *pubString = [[wordlist[i] stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@":"][1];
        [pubkeyForMutArray addObject:@[pubString,pubId]];
        [pubkeyArray addObject:pubString];
    }
    RLMResults<SHWalletModel *> *wallets = [SHWalletModel objectsWhere:[NSString stringWithFormat:@"importType=%zd",SHWalletImportTypePublicKey]];
    for (SHWalletModel *walletModel in wallets) {
        BOOL isHaveSameWallet = YES;
        if (walletModel.zpubList.count == pubkeyArray.count) {
            for (SHWalletZpubModel *zpubModel in walletModel.zpubList) {
                if (![pubkeyArray containsObject:zpubModel.publicKey]) {
                    isHaveSameWallet = NO;
                }
            }
        }else
        {
            isHaveSameWallet = NO;
        }
        if (isHaveSameWallet) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:GCLocalizedString(@"same_wallet_tip") toView:nil];
            });
            return;
        }
    }
    
    SHWalletModel *walletModel = [SHBtcCreatOrImportWalletManage importBtcWalletWithPubs:pubkeyArray WithPubDic:pubDic WithPubTitles:pubkeyTitleArray withWalletName:self.walletName];
    [self getMutPubAddressWithPubs:pubkeyForMutArray WithSureCount:policySureCount withModel:walletModel];
    
    
}
- (void)getMutPubAddressWithPubs:pubkeyMutArray WithSureCount:sureCount withModel:(SHWalletModel*)walletModel {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pubkeyMutArray options:0 error:nil];
    
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsStr = [NSString stringWithFormat:@"getMultiSigAddresses(%@,%@,%@)",strJson,@"true",sureCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error)
         {
            if (IsEmpty(result)) {
                [MBProgressHUD hideCustormLoadingWithView:nil];
                [MBProgressHUD showError:GCLocalizedString(@"getMultiSigAddresses error") toView:self.view];
                return;
            }
            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resutDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            NSArray *externalAddresses = resutDic[@"externalAddresses"];
            NSArray *internalAddress = resutDic[@"internalAddress"];
            for (int index = 0; index < externalAddresses.count; index ++ ) {
                SHWalletSubAddressModel *address3SubModel = [[SHWalletSubAddressModel alloc]init];
                address3SubModel.address = externalAddresses[index];
                [walletModel.subAddressList addObject:address3SubModel];
                
                SHWalletSubAddressModel *address3ChangeSubModel = [[SHWalletSubAddressModel alloc]init];
                address3ChangeSubModel.address = internalAddress[index];
                [walletModel.changeAddressList addObject:address3ChangeSubModel];
                if (index == 0) {
                    walletModel.address = externalAddresses[index];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideCustormLoadingWithView:nil];
                [[SHKeyStorage shared] createWalletsWithWalletModel:walletModel];
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
            
        }];
    });
}
#pragma mark 公钥导入
-(void)publickImportActionWith:(NSString *)textString withExtpubKeyJson:(NSString *)extpubkeyJson
{
    //公钥导入
    RLMResults<SHWalletModel *> *wallets = [SHWalletModel objectsWhere:[NSString stringWithFormat:@"importType=%zd",SHWalletImportTypePublicKey]];
    for (SHWalletModel *walletModel in wallets) {
        if ([walletModel.publicKey isEqualToString:textString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:GCLocalizedString(@"same_wallet_tip") toView:nil];
            });
            return;
        }
    }
    SHWalletModel *walletModel = [SHBtcCreatOrImportWalletManage importBtcWalletWithPub:[NSString stringWithFormat:@"%@",textString] withWalletName:self.walletName];
    walletModel.zpubJsonString = extpubkeyJson;
    walletModel.policySureCount = 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideCustormLoadingWithView:nil];
        if (IsEmpty(walletModel.address)) {
            [MBProgressHUD showError:GCLocalizedString(@"wallet_import_error") toView:nil];
        }else
        {
            [[SHKeyStorage shared] createWalletsWithWalletModel:walletModel];
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
        }
        
        
    });
}
#pragma mark 地址导入
-(void)addressImportActionWith:(NSString *)textString
{
    //地址导入
    RLMResults<SHWalletModel *> *wallets = [SHWalletModel objectsWhere:[NSString stringWithFormat:@"importType=%zd",SHWalletImportTypeAddress]];
    for (SHWalletModel *walletModel in wallets) {
        if ([walletModel.address isEqualToString:textString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:GCLocalizedString(@"same_wallet_tip") toView:nil];
            });
            return;
        }
    }
    SHWalletModel *walletModel = [SHBtcCreatOrImportWalletManage importBtcWalletWithAddress:textString withWalletName:self.walletName];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideCustormLoadingWithView:nil];
        [[SHKeyStorage shared] createWalletsWithWalletModel:walletModel];
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
-(void)rightButtonAction:(UIButton *)btn
{
    UIViewController *vc = [SHOCToSwiftUI makeScanViewWithScanBlock:^(NSString * _Nonnull qrString) {
        NSError *error = nil;
        if (qrString.length >=8 && [[qrString substringToIndex:8].lowercaseString isEqualToString:@"ur:bytes"]) {
            NSString *text = [SHCreatOrImportManage parsingUrBytesWithQrstring:qrString error:&error];
            self.inputTextView.text = text;
        }else if (qrString.length >=17 && [[qrString substringToIndex:17].lowercaseString isEqualToString:@"ur:crypto-account"]) {
            NSString *jsStr = [NSString stringWithFormat:@"convertUrAccountToAccount('%@')",qrString];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error)
                 {
                    NSLog(@"%@",result);
                    if (IsEmpty(result)) {
                        [MBProgressHUD hideCustormLoadingWithView:nil];
                        [MBProgressHUD showError:GCLocalizedString(@"convertUrAccountToAccount error") toView:self.view];
                        return;
                    }
//                    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
//                    NSDictionary *resutDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                    self.inputTextView.text = result;
                    if (IsEmpty(self.inputTextView.text)) {
                        [self.createButton setBackgroundImage:[UIImage gradientImageWithBounds:self.createButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
                        self.createButton.enabled = NO;
                    }else
                    {
                        [self.createButton setBackgroundImage:[UIImage gradientImageWithBounds:self.createButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
                        self.createButton.enabled = YES;
                    }
                }];
            });
        }
        else
        {
            self.inputTextView.text = qrString;
        }
        if (IsEmpty(self.inputTextView.text)) {
            [self.createButton setBackgroundImage:[UIImage gradientImageWithBounds:self.createButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
            self.createButton.enabled = NO;
        }else
        {
            [self.createButton setBackgroundImage:[UIImage gradientImageWithBounds:self.createButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
            self.createButton.enabled = YES;
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 第三方方法
-(void)textViewDidChange:(UITextView *)textView
{
    if (IsEmpty(textView.text)) {
        [self.createButton setBackgroundImage:[UIImage gradientImageWithBounds:self.createButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.createButton.enabled = NO;
    }else
    {
        [self.createButton setBackgroundImage:[UIImage gradientImageWithBounds:self.createButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.createButton.enabled = YES;
    }
}
- (void)tapGesture :(UITapGestureRecognizer *)tap
{
    switch (KAppSetting.language) {
        case SHApplicationLanguageEn:
        {
            SHPublicWebViewController *publicWebViewController = [[SHPublicWebViewController alloc]init];
            publicWebViewController.url = @"https://support.keyst.one/";
            [self.navigationController pushViewController:publicWebViewController animated:YES];
        }
            break;
        case SHApplicationLanguageZhHans:
        {
            SHPublicWebViewController *publicWebViewController = [[SHPublicWebViewController alloc]init];
            publicWebViewController.url = @"https://support.keyst.one/v/chinese/";
            [self.navigationController pushViewController:publicWebViewController animated:YES];
        }
            break;
        case SHApplicationLanguageZhHant:
        {
            SHPublicWebViewController *publicWebViewController = [[SHPublicWebViewController alloc]init];
            publicWebViewController.url = @"https://support.keyst.one/v/chinese/";
            [self.navigationController pushViewController:publicWebViewController animated:YES];
        }
            break;
        case SHApplicationLanguageRussian:
        {
            SHPublicWebViewController *publicWebViewController = [[SHPublicWebViewController alloc]init];
            publicWebViewController.url = @"https://support.keyst.one/";
            [self.navigationController pushViewController:publicWebViewController animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark 懒加载
-(UILabel *)importTipsLabel
{
    if (_importTipsLabel == nil) {
        _importTipsLabel = [[UILabel alloc]init];
        _importTipsLabel.font = kCustomMontserratMediumFont(24);
        _importTipsLabel.textColor = SHTheme.appTopBlackColor;
        _importTipsLabel.text = GCLocalizedString(@"import_wallet");
        [self.view addSubview:_importTipsLabel];
    }
    return _importTipsLabel;
}
-(UILabel *)pleaseEnterTipsLabel
{
    if (_pleaseEnterTipsLabel == nil) {
        _pleaseEnterTipsLabel = [[UILabel alloc]init];
        _pleaseEnterTipsLabel.font = kCustomMontserratRegularFont(14);
        _pleaseEnterTipsLabel.textColor = SHTheme.appBlackColor;
        _pleaseEnterTipsLabel.text = GCLocalizedString(@"import_wallet_tip_0");
        [self.view addSubview:_pleaseEnterTipsLabel];
    }
    return _pleaseEnterTipsLabel;
}
-(UILabel *)coldWalletTipsLabel
{
    if (_coldWalletTipsLabel == nil) {
        _coldWalletTipsLabel = [[UILabel alloc]init];
        _coldWalletTipsLabel.font = kCustomMontserratRegularFont(14);
        _coldWalletTipsLabel.textColor = SHTheme.appBlackColor;
        _coldWalletTipsLabel.text = GCLocalizedString(@"");
        _coldWalletTipsLabel.text = [NSString stringWithFormat:@"%@ %@%@",GCLocalizedString(@"import_wallet_tip_1"),GCLocalizedString(@"cold_wallet"),GCLocalizedString(@" etc.")];
        _coldWalletTipsLabel.userInteractionEnabled = YES;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_coldWalletTipsLabel.text];
        NSRange range = NSMakeRange(GCLocalizedString(@"import_wallet_tip_1").length + 1, GCLocalizedString(@"cold_wallet").length);
        [attrStr addAttributes:@{NSForegroundColorAttributeName : rgba(0, 95, 111, 1)} range:range];
        [attrStr addAttributes:@{NSUnderlineStyleAttributeName : @1} range:range];
        _coldWalletTipsLabel.attributedText = attrStr;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [_coldWalletTipsLabel addGestureRecognizer:tap];
        [self.view addSubview:_coldWalletTipsLabel];
    }
    return _coldWalletTipsLabel;
}
- (UIView *)inputTVBackView
{
    if (_inputTVBackView == nil) {
        _inputTVBackView = [[UIView alloc]init];
        _inputTVBackView.backgroundColor = SHTheme.addressTypeCellBackColor;
        _inputTVBackView.layer.cornerRadius = 8;
        _inputTVBackView.layer.masksToBounds = YES;
        _inputTVBackView.layer.borderColor = SHTheme.buttonForMnemonicSelectBackColor.CGColor;
        _inputTVBackView.layer.borderWidth = 1;
        [self.view addSubview:_inputTVBackView];
    }
    return _inputTVBackView;
}
-(UITextView *)inputTextView
{
    if (_inputTextView == nil) {
        _inputTextView = [UITextView new];
        _inputTextView.backgroundColor = SHTheme.addressTypeCellBackColor;
        _inputTextView.delegate = self;
        _inputTextView.font = kCustomMontserratRegularFont(14);
        _inputTextView.placeholder = GCLocalizedString(@"import_wallet_hint");
        _inputTextView.placeholderColor = SHTheme.pageUnselectColor;
        _inputTextView.tintColor = SHTheme.agreeButtonColor;
        [self.inputTVBackView addSubview:_inputTextView];
    }
    return _inputTextView;
}

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
-(UILabel *)walletNameValueLabel
{
    if (_walletNameValueLabel == nil) {
        _walletNameValueLabel = [[UILabel alloc]init];
        _walletNameValueLabel.font = kCustomMontserratMediumFont(20);
        _walletNameValueLabel.textColor = SHTheme.setPasswordTipsColor;
        _walletNameValueLabel.text = self.walletName;
        [self.view addSubview:_walletNameValueLabel];
    }
    return _walletNameValueLabel;
}
-(UIButton *)createButton
{
    if (_createButton == nil) {
        _createButton = [[UIButton alloc]init];
        _createButton.layer.cornerRadius = 26*FitHeight;
        _createButton.layer.masksToBounds = YES;
        _createButton.enabled = NO;
        [_createButton setTitle:GCLocalizedString(@"Create") forState:UIControlStateNormal];
        [_createButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _createButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_createButton addTarget:self action:@selector(createButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_createButton];
    }
    return _createButton;
}
@end
