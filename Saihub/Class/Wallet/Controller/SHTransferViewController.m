//
//  SHTransferViewController.m
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHTransferViewController.h"
#import "SHMinerFeeView.h"
#import "SHAdressBookViewController.h"
#import "SHQrScanningViewController.h"
#import "SHTransferInfoModel.h"
#import "SHTransferValidationForTouchOrFaceViewController.h"
#import "SHTransferValidationForPassWordViewController.h"
#import "SHMultipleSignatureViewController.h"
@interface SHTransferViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) UILabel *toAddressTipsLabel;
@property (nonatomic, strong) TGTextField *toAddressTf;
@property (nonatomic, strong) UIButton *qrButton;
@property (nonatomic, strong) UIButton *addressListButton;
@property (nonatomic, strong) UIView *toAddressLineView;

@property (nonatomic, strong) UILabel *amountTipsLabel;
@property (nonatomic, strong) TGTextField *amountTf;
@property (nonatomic, strong) UIView *amountLineView;

@property (nonatomic, strong) UILabel *balanceTipsLabel;
@property (nonatomic, strong) UILabel *balanceValueLabel;
@property (nonatomic, strong) UILabel *minerFeeTipsLabel;

@property (nonatomic, strong) UIButton *continueButton;

@property (nonatomic, strong) SHMinerFeeView *fastMinerFeeView;
@property (nonatomic, strong) SHMinerFeeView *avgMinerFeeView;
@property (nonatomic, strong) SHMinerFeeView *slowMinerFeeView;
///gasPrice

@property (nonatomic,copy) NSString *minPrice;

@property (nonatomic,copy) NSString *maxPrice;

@property (nonatomic,copy) NSString *proposePrice;

@property (nonatomic,copy) NSString *gasLimit;

@property (nonatomic,assign) NSInteger utxoCount;

@property (nonatomic,strong) BTCTransaction *transaction;

@property (nonatomic,strong) BTTx *tx;
@property (nonatomic, strong) SHTransferInfoModel *transferInfoModel;

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation SHTransferViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getBalanceData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"Transfer");
    if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePrivateKey ||[SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypeMnemonic||[SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey) {
        [self loadWebView];
    }
    [self layoutScale];
    [self loadGasPrice];
    // Do any additional setup after loading the view.
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.toAddressTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(22*FitHeight);
    [self.toAddressTipsLabel setSingleLineAutoResizeWithMaxWidth:200];
    self.toAddressTf.sd_layout.leftEqualToView(self.toAddressTipsLabel).topSpaceToView(self.toAddressTipsLabel, 0).rightSpaceToView(self.view, 80*FitWidth).heightIs(45*FitHeight);
    self.addressListButton.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(self.toAddressTf).widthIs(20*FitWidth).heightEqualToWidth();
    self.qrButton.sd_layout.rightSpaceToView(self.addressListButton, 12*FitWidth).centerYEqualToView(self.addressListButton).widthIs(20*FitWidth).heightEqualToWidth();
    self.toAddressLineView.sd_layout.leftEqualToView(self.toAddressTipsLabel).topSpaceToView(self.toAddressTf, 0).rightSpaceToView(self.view, 20*FitWidth).heightIs(1);
    self.amountTipsLabel.sd_layout.leftEqualToView(self.toAddressLineView).topSpaceToView(self.toAddressLineView, 24*FitHeight).heightIs(22*FitHeight);
    [self.amountTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.amountTf.sd_layout.leftEqualToView(self.amountTipsLabel).topSpaceToView(self.amountTipsLabel, 0).rightSpaceToView(self.view, 20*FitWidth).heightIs(45*FitHeight);
    self.amountLineView.sd_layout.leftEqualToView(self.amountTf).rightEqualToView(self.amountTf).topSpaceToView(self.amountTf, 0).heightIs(1);
    self.balanceTipsLabel.sd_layout.leftEqualToView(self.amountLineView).topSpaceToView(self.amountLineView, 8*FitHeight).heightIs(18*FitHeight);
    [self.balanceTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.balanceValueLabel.sd_layout.rightSpaceToView(self.view, 20*FitHeight).centerYEqualToView(self.balanceTipsLabel).heightIs(14*FitHeight);
    [self.balanceValueLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.minerFeeTipsLabel.sd_layout.leftEqualToView(self.balanceTipsLabel).topSpaceToView(self.balanceTipsLabel, 39*FitHeight).heightIs(22*FitHeight);
    [self.minerFeeTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.fastMinerFeeView.sd_layout.leftEqualToView(self.minerFeeTipsLabel).topSpaceToView(self.minerFeeTipsLabel, 16*FitHeight).widthIs(101*FitWidth).heightIs(84*FitHeight);
    self.avgMinerFeeView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.fastMinerFeeView).widthIs(101*FitWidth).heightIs(84*FitHeight);
    self.slowMinerFeeView.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(self.avgMinerFeeView).widthIs(101*FitWidth).heightIs(84*FitHeight);
    self.continueButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.minerFeeTipsLabel, 171*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    [self.fastMinerFeeView layoutScale];
    [self.avgMinerFeeView layoutScale];
    [self.slowMinerFeeView layoutScale];
}
#pragma mark bc1相关交易调用web
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
    //添加消息处理，注意：self指代的是需要遵守WKScriptMessageHandler协议，结束时需要移除
    [userContentController addScriptMessageHandler:self name:@"privateKeyToBech32Address"];
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

#pragma mark  私钥导入bc1交易逻辑
-(void)bc1PrivateKeyToTradding
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
    NSString *addressesStr = [addressArray componentsJoinedByString:@"|"];
    NSMutableArray *blockchairUtxos = [NSMutableArray new];
    [[NetWorkTool shareNetworkTool]requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"https://blockchain.info/unspent?active=%@",addressesStr] withMethodType:Get withParams:@{} result:^(id  _Nullable responseObject, NSInteger code, NSString *message) {
        if (code == 0) {
            NSArray *utxoArr = responseObject[@"unspent_outputs"];
            if (utxoArr.count == 0) {
                self.continueButton.enabled = YES;
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:GCLocalizedString(@"Lack_balance") toView:self.view];
                return;
            }
            for (NSDictionary *utxoJson in utxoArr) {
                if (!utxoJson) {
                    self.continueButton.enabled = YES;
                    continue;
                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:utxoJson[@"value"] forKey:@"value"];
                [dic setValue:utxoJson[@"tx_output_n"] forKey:@"vout"];
                [dic setValue:utxoJson[@"tx_hash_big_endian"] forKey:@"txId"];
                [dic setValue:utxoJson[@"tx_hash_big_endian"] forKey:@"txid"];
                [dic setValue:utxoJson[@"confirmations"] forKey:@"confirmations"];
                [dic setValue:[SHKeyStorage shared].currentWalletModel.address forKey:@"address"];
                
                [[NetWorkTool shareNetworkTool]requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"https://blockchain.info/rawtx/%@?format=hex",dic[@"txId"]] withMethodType:Get withParams:@{} result:^(id  _Nullable responseObject, NSInteger code, NSString *message) {
                    if (!IsEmpty(responseObject)) {
                        [dic setValue:responseObject forKey:@"txhex"];
                        [blockchairUtxos addObject:dic];
                    }else
                    {
                        [dic setValue:@"" forKey:@"txhex"];
                        [blockchairUtxos addObject:dic];
                    }
                    if (blockchairUtxos.count == utxoArr.count) {
                        NSString *sat = @"";
                        if (self.fastMinerFeeView.backButton.selected) {
                            sat = self.maxPrice;
                        }
                        if (self.avgMinerFeeView.backButton.selected) {
                            sat = self.proposePrice;
                        }
                        if (self.slowMinerFeeView.backButton.selected) {
                            sat = self.minPrice;
                        }
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:blockchairUtxos options:0 error:nil];
                        
                        NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSDecimalNumber *valueNum = [NSDecimalNumber decimalNumberWithString:self.amountTf.text];
                        NSDecimalNumber *powNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, 8)]];
                        NSString *jsFeeStr = [NSString stringWithFormat:@"calculateFee(%@,'%@',%@,%@)",strJson,self.toAddressTf.text,[valueNum decimalNumberByMultiplyingBy:powNum].stringValue,sat];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.wkWebView evaluateJavaScript:jsFeeStr completionHandler:^(id _Nullable calculateFeeresult, NSError * _Nullable error) {
                                if (IsEmpty(calculateFeeresult)) {
                                    self.continueButton.enabled = YES;
                                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                                    [MBProgressHUD showError:GCLocalizedString(@"calculateFee error") toView:self.view];
                                    return;
                                }
                                NSData *calculateFeeresultdata = [calculateFeeresult dataUsingEncoding:NSUTF8StringEncoding];
                                NSDictionary *calculateFeeresultDic = [NSJSONSerialization JSONObjectWithData:calculateFeeresultdata options:NSJSONReadingMutableContainers error:NULL];
                                if (![[calculateFeeresultDic objectForKey:@"isEnough"] boolValue]) {
                                    self.continueButton.enabled = YES;
                                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                                    [MBProgressHUD showError:GCLocalizedString(@"Lack_balance") toView:self.view];
                                    return;
                                }
                                NSString *jsStr = [NSString stringWithFormat:@"createSingleTransaction('%@',%@,'%@',%@,'%@',%@,%@)",[SHKeyStorage shared].currentWalletModel.privateKey,strJson,self.toAddressTf.text,[valueNum decimalNumberByMultiplyingBy:powNum].stringValue,[SHKeyStorage shared].currentWalletModel.address,sat,[[[SHKeyStorage shared].currentWalletModel.address substringToIndex:3].lowercaseString isEqualToString:@"bc1"]?@"true":@"false"];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                                        NSLog(@"%@",result);
                                        if (IsEmpty(result)) {
                                            self.continueButton.enabled = YES;
                                            [MBProgressHUD hideCustormLoadingWithView:self.view];
                                            [MBProgressHUD showError:GCLocalizedString(@"createSingleTransaction error") toView:self.view];
                                            return;
                                        }
                                        [MBProgressHUD hideCustormLoadingWithView:self.view];
                                        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                                        NSDictionary *resutDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                                        NSLog(@"%@",resutDic[@"fee"]);
                                        self.transferInfoModel.valueString = self.amountTf.text;
                                        self.transferInfoModel.addressString = self.toAddressTf.text;
                                        self.transferInfoModel.coinString = self.tokenModel.isPrimaryToken?@"BTC":@"USDT";
                                        self.transferInfoModel.trueFee = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",resutDic[@"fee"]]].stringValue;
                                        if ([SHKeyStorage shared].currentWalletModel.isNoSecret){//如果是免密
                                            SHTransferValidationForTouchOrFaceViewController *transferValidationForTouchOrFaceViewController = [[SHTransferValidationForTouchOrFaceViewController alloc]init];
                                            transferValidationForTouchOrFaceViewController.tokenModel =  self.tokenModel;
                                            transferValidationForTouchOrFaceViewController.transferInfoModel = self.transferInfoModel;
                                            transferValidationForTouchOrFaceViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                                            transferValidationForTouchOrFaceViewController.bc1Hex = resutDic[@"hex"];
                                            [self.navigationController pushViewController:transferValidationForTouchOrFaceViewController animated:YES];
                                        }else {
                                            SHTransferValidationForPassWordViewController *transferValidationForPassWordViewController = [[SHTransferValidationForPassWordViewController alloc]init];
                                            transferValidationForPassWordViewController.tokenModel = self.tokenModel;
                                            transferValidationForPassWordViewController.transferInfoModel = self.transferInfoModel;
                                            transferValidationForPassWordViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                                            transferValidationForPassWordViewController.bc1Hex = resutDic[@"hex"];
                                            [self.navigationController pushViewController:transferValidationForPassWordViewController animated:YES];
                                        }
                                        self.continueButton.enabled = YES;
                                    }];
                                });
                                
                            }];
                        });
                        

                    }
                    
                }];
            }
        }else
        {
            [MBProgressHUD showError:message toView:nil];
        }
    }];
}
#pragma mark  多签交易逻辑
- (void)createMultisigTransaction {
    MJWeakSelf
    
    NSMutableArray *addressArray = [NSMutableArray array];
    
    for (NSInteger countIndex = 0; countIndex < [SHKeyStorage shared].currentWalletModel.subAddressList.count; countIndex ++) {
        SHWalletSubAddressModel *subAddressModel = [[SHKeyStorage shared].currentWalletModel.subAddressList objectAtIndex:countIndex];
        [addressArray addObject:subAddressModel.address];
        if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypeMnemonic ||[SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey ) {
            SHWalletSubAddressModel *internalAddressModel = [[SHKeyStorage shared].currentWalletModel.changeAddressList objectAtIndex:countIndex];
            [addressArray addObject:internalAddressModel.address];
        }
    }
    NSString *addressesStr = [addressArray componentsJoinedByString:@"|"];
    NSMutableArray *blockchairUtxos = [NSMutableArray new];
    [[NetWorkTool shareNetworkTool]requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"https://blockchain.info/unspent?active=%@",addressesStr] withMethodType:Get withParams:@{} result:^(id  _Nullable responseObject, NSInteger code, NSString *message) {
        if (code == 0) {
            NSArray *utxoArr = responseObject[@"unspent_outputs"];
            if (utxoArr.count == 0) {
                self.continueButton.enabled = YES;
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:GCLocalizedString(@"Lack_balance") toView:self.view];
                return;
            }
            for (NSDictionary *utxoJson in utxoArr) {
                if (!utxoJson) {
                    self.continueButton.enabled = YES;
                    continue;
                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:utxoJson[@"value"] forKey:@"value"];
                [dic setValue:utxoJson[@"tx_output_n"] forKey:@"vout"];
                [dic setValue:utxoJson[@"tx_hash_big_endian"] forKey:@"txId"];
                [dic setValue:utxoJson[@"tx_hash_big_endian"] forKey:@"txid"];
                [dic setValue:@"false" forKey:@"wif"];
                [dic setValue:utxoJson[@"confirmations"] forKey:@"confirmations"];
                if (IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:utxoJson[@"script"]])) {
                    NSString *jsAddressStr = [NSString stringWithFormat:@"scriptToBech32(%@)",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@[utxoJson[@"script"]] options:0 error:nil] encoding:NSUTF8StringEncoding]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.wkWebView evaluateJavaScript:jsAddressStr completionHandler:^(id _Nullable scriptToBech32Result, NSError * _Nullable error) {
                            if (IsEmpty(scriptToBech32Result)) {
                                self.continueButton.enabled = YES;
                                [MBProgressHUD hideCustormLoadingWithView:self.view];
                                [MBProgressHUD showError:GCLocalizedString(@"scriptToBech32 error") toView:self.view];
                                return;
                            }
                            NSData *data = [scriptToBech32Result dataUsingEncoding:NSUTF8StringEncoding];
                            NSArray *resutDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                            [dic setValue:resutDic[0] forKey:@"address"];
                            [[NSUserDefaults standardUserDefaults]setObject:resutDic[0] forKey:utxoJson[@"script"]];
                            if (IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]])) {
                                [[NetWorkTool shareNetworkTool]requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"https://blockchain.info/rawtx/%@?format=hex",dic[@"txId"]] withMethodType:Get withParams:@{} result:^(id  _Nullable responseObject, NSInteger code, NSString *message) {
                                    if (!IsEmpty(responseObject)) {
                                        [dic setValue:responseObject forKey:@"txhex"];
                                        [blockchairUtxos addObject:dic];
                                        [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]];
                                    }else
                                    {
                                        [dic setValue:@"" forKey:@"txhex"];
                                        [blockchairUtxos addObject:dic];
                                    }
                                    [self createMultisigTransactionEndingWith:blockchairUtxos WithUtxoArr:utxoArr];
                                }];
                            }else
                            {
                                if (!IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]])) {
                                    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]] forKey:@"txhex"];
                                    [blockchairUtxos addObject:dic];
                                }else
                                {
                                    [dic setValue:@"" forKey:@"txhex"];
                                    [blockchairUtxos addObject:dic];
                                }
                                [self createMultisigTransactionEndingWith:blockchairUtxos WithUtxoArr:utxoArr];
                            }
                        }];
                    });
                }else
                {

                    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:utxoJson[@"script"]] forKey:@"address"];
                    if (IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]])) {
                        [[NetWorkTool shareNetworkTool]requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"https://blockchain.info/rawtx/%@?format=hex",dic[@"txId"]] withMethodType:Get withParams:@{} result:^(id  _Nullable responseObject, NSInteger code, NSString *message) {
                            if (!IsEmpty(responseObject)) {
                                [dic setValue:responseObject forKey:@"txhex"];
                                [blockchairUtxos addObject:dic];
                                [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]];
                            }else
                            {
                                [dic setValue:@"" forKey:@"txhex"];
                                [blockchairUtxos addObject:dic];
                            }
                            [self createMultisigTransactionEndingWith:blockchairUtxos WithUtxoArr:utxoArr];
                        }];
                    }else
                    {
                        if (!IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]])) {
                            [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]] forKey:@"txhex"];
                            [blockchairUtxos addObject:dic];
                        }else
                        {
                            [dic setValue:@"" forKey:@"txhex"];
                            [blockchairUtxos addObject:dic];
                        }
                        [self createMultisigTransactionEndingWith:blockchairUtxos WithUtxoArr:utxoArr];
                    }
                    
                }

            }
        }else
        {
            [MBProgressHUD showError:message toView:nil];
        }
    }];
}
-(void)createMultisigTransactionEndingWith:(NSMutableArray *)blockchairUtxos WithUtxoArr:(NSArray *)utxoArr
{
    if (blockchairUtxos.count == utxoArr.count) {
        NSString *sat = @"";
        if (self.fastMinerFeeView.backButton.selected) {
            sat = self.maxPrice;
        }
        if (self.avgMinerFeeView.backButton.selected) {
            sat = self.proposePrice;
        }
        if (self.slowMinerFeeView.backButton.selected) {
            sat = self.minPrice;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:blockchairUtxos options:0 error:nil];
        
        NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDecimalNumber *valueNum = [NSDecimalNumber decimalNumberWithString:self.amountTf.text];
        NSDecimalNumber *powNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, 8)]];
        NSString *jsFeeStr = [NSString stringWithFormat:@"calculateFee(%@,'%@',%@,%@)",strJson,self.toAddressTf.text,[valueNum decimalNumberByMultiplyingBy:powNum].stringValue,sat];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.wkWebView evaluateJavaScript:jsFeeStr completionHandler:^(id _Nullable calculateFeeresult, NSError * _Nullable error) {
                if (IsEmpty(calculateFeeresult)) {
                    self.continueButton.enabled = YES;
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showError:GCLocalizedString(@"calculateFee error") toView:self.view];
                    return;
                }
                NSData *calculateFeeresultdata = [calculateFeeresult dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *calculateFeeresultDic = [NSJSONSerialization JSONObjectWithData:calculateFeeresultdata options:NSJSONReadingMutableContainers error:NULL];
                if (![[calculateFeeresultDic objectForKey:@"isEnough"] boolValue]) {
                    self.continueButton.enabled = YES;
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showError:GCLocalizedString(@"Lack_balance") toView:self.view];
                    return;
                }
                NSMutableArray *zpubArray = [NSMutableArray new];
                for (SHWalletZpubModel *subModel in [SHKeyStorage shared].currentWalletModel.zpubList) {
                    [zpubArray  addObject:@[subModel.publicKey,subModel.title]];
                }
                NSData *jsonZpubArrayData = [NSJSONSerialization dataWithJSONObject:zpubArray options:0 error:nil];
                
                NSString *strZpubArrayJson = [[NSString alloc] initWithData:jsonZpubArrayData encoding:NSUTF8StringEncoding];
                NSString *jsStr = @"";
                if ([SHKeyStorage shared].currentWalletModel.zpubList.count) {
                    //多签
                    jsStr = [NSString stringWithFormat:@"createMultisigTransaction(%@,%@,%@,%@,'%@',%@,%@,'%@')",strJson,strZpubArrayJson,[[[SHKeyStorage shared].currentWalletModel.zpubList[0].publicKey substringToIndex:4].lowercaseString isEqualToString:@"zpub"]?@"true":@"false",@([SHKeyStorage shared].currentWalletModel.policySureCount),self.toAddressTf.text,[valueNum decimalNumberByMultiplyingBy:powNum].stringValue,sat,[SHKeyStorage shared].currentWalletModel.changeAddressList[arc4random() % 10].address];
                }else
                {
                    //单签
                    jsStr = [NSString stringWithFormat:@"createWatchOnlyTransaction(%@,%@,'%@',%@,%@,'%@',%@)",strJson,[SHKeyStorage shared].currentWalletModel.zpubJsonString,self.toAddressTf.text,[valueNum decimalNumberByMultiplyingBy:powNum].stringValue,sat,[SHKeyStorage shared].currentWalletModel.changeAddressList[arc4random() % 10].address,@"false"];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"zhaohong_调用h5签名方法%ld",[NSString getNowTimeTimestamp]);
                    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable createMultisigTransactionResult, NSError * _Nullable error) {
                        NSLog(@"zhaohong_调用h5签名方法回调%ld",[NSString getNowTimeTimestamp]);
                        if (IsEmpty(createMultisigTransactionResult)) {
                            self.continueButton.enabled = YES;
                            [MBProgressHUD hideCustormLoadingWithView:self.view];
                            [MBProgressHUD showError:GCLocalizedString(@"createMultisigTransaction error") toView:self.view];
                            return;
                        }
                        NSDictionary *createMultisigTransactionResultDic = [NSJSONSerialization JSONObjectWithData:[createMultisigTransactionResult dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
                        [MBProgressHUD hideCustormLoadingWithView:self.view];
                        self.continueButton.enabled = YES;
                        UIViewController *vc = [SHOCToSwiftUI makeDisplayViewWithText:[NSString stringWithFormat:@"%@",createMultisigTransactionResultDic[@"urcode"]] signTransactionBlock:^{
                            UIViewController *scanVc = [SHOCToSwiftUI makeScanViewWithScanBlock:^(NSString * _Nonnull scanResult) {
                                //判断是否同一个交易
                                NSMutableArray *transactionsArray = [NSMutableArray new];
                                [transactionsArray addObject:createMultisigTransactionResultDic[@"urcode"]];
                                [transactionsArray addObject:scanResult];
                                NSData *transactionsArrayData = [NSJSONSerialization dataWithJSONObject:transactionsArray options:0 error:nil];
                                
                                NSString *transactionsArrayJson = [[NSString alloc] initWithData:transactionsArrayData encoding:NSUTF8StringEncoding];
                                NSString *isSameTransactionStr = [NSString stringWithFormat:@"isSameTransaction(%@)",transactionsArrayJson];
                                [self.wkWebView evaluateJavaScript:isSameTransactionStr completionHandler:^(id _Nullable isSameTransactionResult, NSError * _Nullable error) {
                                    if (IsEmpty(isSameTransactionResult)) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.continueButton.enabled = YES;
                                            [MBProgressHUD hideCustormLoadingWithView:self.view];
                                            [MBProgressHUD showError:GCLocalizedString(@"isSameTransaction error") toView:self.view];
                                        });
                                        return;
                                    }
                                    if (![isSameTransactionResult boolValue]) {
                                        [MBProgressHUD showError:GCLocalizedString(@"Not_same_deal") toView:nil];
                                        return;
                                    }
                                    if ([SHKeyStorage shared].currentWalletModel.zpubList.count) {
                                        //多签
                                        NSString *jsTransactionStr = [NSString stringWithFormat:@"getTransactionSignedNum('%@',%@,%@,%@)",scanResult,strZpubArrayJson,[[[SHKeyStorage shared].currentWalletModel.zpubList[0].publicKey substringToIndex:4].lowercaseString isEqualToString:@"zpub"]?@"true":@"false",@([SHKeyStorage shared].currentWalletModel.policySureCount)];
                                        [self.wkWebView evaluateJavaScript:jsTransactionStr completionHandler:^(id _Nullable getTransactionSignedNumResult, NSError * _Nullable error) {
                                            if (IsEmpty(getTransactionSignedNumResult)) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    self.continueButton.enabled = YES;
                                                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                                                    [MBProgressHUD showError:GCLocalizedString(@"getTransactionSignedNum error") toView:self.view];
                                                });
                                                return;
                                            }
                                            [MBProgressHUD hideCustormLoadingWithView:self.view];
                                            self.transferInfoModel.valueString = self.amountTf.text;
                                            self.transferInfoModel.addressString = self.toAddressTf.text;
                                            self.transferInfoModel.coinString = self.tokenModel.isPrimaryToken?@"BTC":@"USDT";
                                            self.transferInfoModel.trueFee = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",createMultisigTransactionResultDic[@"fee"]]].stringValue;
                                            SHMultipleSignatureViewController *multipleSignatureViewController = [SHMultipleSignatureViewController new];
                                            multipleSignatureViewController.transferInfoModel = self.transferInfoModel;
                                            multipleSignatureViewController.haveSureNum = [getTransactionSignedNumResult intValue];
                                            multipleSignatureViewController.URPsbtString = scanResult;
                                            multipleSignatureViewController.tokenModel = self.tokenModel;
                                            multipleSignatureViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                                            [self.navigationController pushViewController:multipleSignatureViewController animated:YES];
                                            self.continueButton.enabled = YES;
                                        }];
                                    }else
                                    {
                                        //单签
                                        [MBProgressHUD hideCustormLoadingWithView:self.view];
                                        self.transferInfoModel.valueString = self.amountTf.text;
                                        self.transferInfoModel.addressString = self.toAddressTf.text;
                                        self.transferInfoModel.coinString = self.tokenModel.isPrimaryToken?@"BTC":@"USDT";
                                        self.transferInfoModel.trueFee = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",createMultisigTransactionResultDic[@"fee"]]].stringValue;
                                        SHMultipleSignatureViewController *multipleSignatureViewController = [SHMultipleSignatureViewController new];
                                        multipleSignatureViewController.transferInfoModel = self.transferInfoModel;
                                        multipleSignatureViewController.haveSureNum = 1;
                                        multipleSignatureViewController.URPsbtString = scanResult;
                                        multipleSignatureViewController.tokenModel = self.tokenModel;
                                        multipleSignatureViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                                        [self.navigationController pushViewController:multipleSignatureViewController animated:YES];
                                        self.continueButton.enabled = YES;
                                    }
                                }];
                                
                            }];
                            [self.navigationController pushViewController:scanVc animated:YES];

                        }];
                        NSLog(@"zhaohong_进入下一页面%ld",[NSString getNowTimeTimestamp]);
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                });

            }];
        });
        
    }

}
#pragma mark  助记词导入bc1交易逻辑
- (void)bc1ToTradding {
    NSMutableArray *addressArray = [NSMutableArray array];
    
    for (NSInteger countIndex = 0; countIndex < [SHKeyStorage shared].currentWalletModel.subAddressList.count; countIndex ++) {
        SHWalletSubAddressModel *subAddressModel = [[SHKeyStorage shared].currentWalletModel.subAddressList objectAtIndex:countIndex];
        [addressArray addObject:subAddressModel.address];
        if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypeMnemonic ||[SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey ) {
            SHWalletSubAddressModel *internalAddressModel = [[SHKeyStorage shared].currentWalletModel.changeAddressList objectAtIndex:countIndex];
            [addressArray addObject:internalAddressModel.address];
        }
    }
    NSString *addressesStr = [addressArray componentsJoinedByString:@"|"];
    NSMutableArray *blockchairUtxos = [NSMutableArray new];
    [[NetWorkTool shareNetworkTool]requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"https://blockchain.info/unspent?active=%@",addressesStr] withMethodType:Get withParams:@{} result:^(id  _Nullable responseUnspentObject, NSInteger code, NSString *message) {
        if (code == 0) {
            NSArray *utxoArr = responseUnspentObject[@"unspent_outputs"];
            if (utxoArr.count == 0) {
                self.continueButton.enabled = YES;
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:GCLocalizedString(@"Lack_balance") toView:self.view];
                return;
            }
            for (NSDictionary *utxoJson in utxoArr) {
                if (!utxoJson) {
                    self.continueButton.enabled = YES;
                    continue;
                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:utxoJson[@"value"] forKey:@"value"];
                [dic setValue:utxoJson[@"tx_output_n"] forKey:@"vout"];
                [dic setValue:utxoJson[@"tx_hash_big_endian"] forKey:@"txId"];
                [dic setValue:utxoJson[@"tx_hash_big_endian"] forKey:@"txid"];
                [dic setValue:@"false" forKey:@"wif"];
                [dic setValue:utxoJson[@"confirmations"] forKey:@"confirmations"];
                
                if (IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:utxoJson[@"script"]])) {
                    NSString *jsAddressStr = [NSString stringWithFormat:@"scriptToBech32(%@)",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@[utxoJson[@"script"]] options:0 error:nil] encoding:NSUTF8StringEncoding]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.wkWebView evaluateJavaScript:jsAddressStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                            NSLog(@"%@",result);
                            if (IsEmpty(result)) {
                                self.continueButton.enabled = YES;
                                [MBProgressHUD hideCustormLoadingWithView:self.view];
                                [MBProgressHUD showError:GCLocalizedString(@"scriptToBech32 error") toView:self.view];
                                return;
                            }
                            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                            NSArray *resutDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                            [dic setValue:resutDic[0] forKey:@"address"];
                            [[NSUserDefaults standardUserDefaults] setObject:resutDic[0] forKey:utxoJson[@"script"]];
                            if (IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]])) {
                                [[NetWorkTool shareNetworkTool]requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"https://blockchain.info/rawtx/%@?format=hex",dic[@"txId"]] withMethodType:Get withParams:@{} result:^(id  _Nullable responseObject, NSInteger code, NSString *message) {
                                    if (!IsEmpty(responseObject)) {
                                        [dic setValue:responseObject forKey:@"txhex"];
                                        [blockchairUtxos addObject:dic];
                                        [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]];
                                    }else
                                    {
                                        [dic setValue:@"" forKey:@"txhex"];
                                        [blockchairUtxos addObject:dic];
                                    }
                                    [self bc1ToTraddingEndWith:blockchairUtxos WithUtxoArr:utxoArr];
                                }];

                            }else
                            {
                                if (!IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]])) {
                                    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]] forKey:@"txhex"];
                                    [blockchairUtxos addObject:dic];
                                }else
                                {
                                    [dic setValue:@"" forKey:@"txhex"];
                                    [blockchairUtxos addObject:dic];
                                }
                                [self bc1ToTraddingEndWith:blockchairUtxos WithUtxoArr:utxoArr];
                            }
                                                        
                        }];
                    });

                }else
                {
                    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:utxoJson[@"script"]] forKey:@"address"];
                    if (IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]])) {
                        [[NetWorkTool shareNetworkTool]requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"https://blockchain.info/rawtx/%@?format=hex",dic[@"txId"]] withMethodType:Get withParams:@{} result:^(id  _Nullable responseObject, NSInteger code, NSString *message) {
                            if (!IsEmpty(responseObject)) {
                                [dic setValue:responseObject forKey:@"txhex"];
                                [blockchairUtxos addObject:dic];
                                [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]];
                            }else
                            {
                                [dic setValue:@"" forKey:@"txhex"];
                                [blockchairUtxos addObject:dic];
                            }
                            [self bc1ToTraddingEndWith:blockchairUtxos WithUtxoArr:utxoArr];
                        }];

                    }else
                    {
                        if (!IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]])) {
                            [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",@"txId",dic[@"txId"]]] forKey:@"txhex"];
                            [blockchairUtxos addObject:dic];
                        }else
                        {
                            [dic setValue:@"" forKey:@"txhex"];
                            [blockchairUtxos addObject:dic];
                        }
                        [self bc1ToTraddingEndWith:blockchairUtxos WithUtxoArr:utxoArr];
                    }
                                        
                }
                
            }
        }else
        {
            [MBProgressHUD showError:message toView:nil];
        }
    }];
}
-(void)bc1ToTraddingEndWith:(NSMutableArray *)blockchairUtxos WithUtxoArr:(NSArray *)utxoArr
{

    if (blockchairUtxos.count == utxoArr.count) {
        NSString *sat = @"";
        if (self.fastMinerFeeView.backButton.selected) {
            sat = self.maxPrice;
        }
        if (self.avgMinerFeeView.backButton.selected) {
            sat = self.proposePrice;
        }
        if (self.slowMinerFeeView.backButton.selected) {
            sat = self.minPrice;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:blockchairUtxos options:0 error:nil];
        
        NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDecimalNumber *valueNum = [NSDecimalNumber decimalNumberWithString:self.amountTf.text];
        NSDecimalNumber *powNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, 8)]];
        NSString *jsFeeStr = [NSString stringWithFormat:@"calculateFee(%@,'%@',%@,%@)",strJson,self.toAddressTf.text,[valueNum decimalNumberByMultiplyingBy:powNum].stringValue,sat];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.wkWebView evaluateJavaScript:jsFeeStr completionHandler:^(id _Nullable calculateFeeresult, NSError * _Nullable error) {
                if (IsEmpty(calculateFeeresult)) {
                    self.continueButton.enabled = YES;
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showError:GCLocalizedString(@"calculateFee error") toView:self.view];
                    return;
                }
                NSData *calculateFeeresultdata = [calculateFeeresult dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *calculateFeeresultDic = [NSJSONSerialization JSONObjectWithData:calculateFeeresultdata options:NSJSONReadingMutableContainers error:NULL];
                if (![[calculateFeeresultDic objectForKey:@"isEnough"] boolValue]) {
                    self.continueButton.enabled = YES;
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showError:GCLocalizedString(@"Lack_balance") toView:self.view];
                    return;
                }
                NSString *jsStr = [NSString stringWithFormat:@"createHDTransaction('%@',%@,'%@',%@,'%@',%@,%@)",[SHKeyStorage shared].currentWalletModel.mnemonic,strJson,self.toAddressTf.text,[valueNum decimalNumberByMultiplyingBy:powNum].stringValue,[SHKeyStorage shared].currentWalletModel.changeAddressList[0].address,sat,@"true"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                        NSLog(@"%@",result);
                        if (IsEmpty(result)) {
                            self.continueButton.enabled = YES;
                            [MBProgressHUD hideCustormLoadingWithView:self.view];
                            [MBProgressHUD showError:GCLocalizedString(@"createHDTransaction error") toView:self.view];
                            return;
                        }
                        [MBProgressHUD hideCustormLoadingWithView:self.view];
                        NSDictionary *resutDic = result;
                        NSLog(@"%@",resutDic[@"fee"]);
                        self.transferInfoModel.valueString = self.amountTf.text;
                        self.transferInfoModel.addressString = self.toAddressTf.text;
                        self.transferInfoModel.coinString = self.tokenModel.isPrimaryToken?@"BTC":@"USDT";
                        self.transferInfoModel.trueFee = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",resutDic[@"fee"]]].stringValue;
                        if ([SHKeyStorage shared].currentWalletModel.isNoSecret){//如果是免密
                            SHTransferValidationForTouchOrFaceViewController *transferValidationForTouchOrFaceViewController = [[SHTransferValidationForTouchOrFaceViewController alloc]init];
                            transferValidationForTouchOrFaceViewController.tokenModel =  self.tokenModel;
                            transferValidationForTouchOrFaceViewController.transferInfoModel = self.transferInfoModel;
                            transferValidationForTouchOrFaceViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                            transferValidationForTouchOrFaceViewController.bc1Hex = resutDic[@"hex"];
                            [self.navigationController pushViewController:transferValidationForTouchOrFaceViewController animated:YES];
                        }else {
                            SHTransferValidationForPassWordViewController *transferValidationForPassWordViewController = [[SHTransferValidationForPassWordViewController alloc]init];
                            transferValidationForPassWordViewController.tokenModel = self.tokenModel;
                            transferValidationForPassWordViewController.transferInfoModel = self.transferInfoModel;
                            transferValidationForPassWordViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                            transferValidationForPassWordViewController.bc1Hex = resutDic[@"hex"];
                            [self.navigationController pushViewController:transferValidationForPassWordViewController animated:YES];
                        }
                        self.continueButton.enabled = YES;
                    }];
                });
            }];
        });

    }
    
}
- (NSURLSessionDataTask *)btcRequestHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(NSMutableDictionary *)params success:(void(^)(id responseObjc))successBlok fail:(void(^)(NSInteger errorCode,NSString *errorMessage))failBlock {
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    securityPolicy.validatesDomainName = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager setSecurityPolicy:securityPolicy];
    
    if (method == Get) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;
        //设置响应数据格式
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/json", @"application/json",  @"text/javascript", @"application/javascript", @"text/plain",  @"text/html", nil]];
        __block NSMutableString *url = [NSMutableString stringWithString:path];
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [url appendFormat:@"&%@", [NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        return [manager GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlok) {
                successBlok(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败 -- %@",error);
            if (failBlock) failBlock(error.code,error.localizedDescription);
        }];
    } else if (method == Post) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //响应
        //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;
        //设置响应数据格式
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/json", @"application/json",  @"text/javascript", @"application/javascript", @"text/plain",  @"text/html", nil]];
        
        return [manager POST:path parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlok) {
                successBlok([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failBlock) failBlock(error.code,error.localizedDescription);
        }];
    } else if (method == FormData) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;
        //设置响应数据格式
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/json", @"application/json",  @"text/javascript", @"application/javascript", @"text/plain",  @"text/html", nil]];
        NSArray *address = params[@"addr"];
        return [manager POST:path parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [address enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [formData appendPartWithFormData:[obj dataUsingEncoding:NSUTF8StringEncoding] name:@"addr"];
            }];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlok) {
                successBlok([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failBlock) failBlock(error.code,error.localizedDescription);
        }];
    }
    return nil;
}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
    //    if ([textField isEqual:self.remarkNameTf] && textField.text.length >=30) {
    //        textField.text = [textField.text substringToIndex:30];
    //    }
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.toAddressTf.text)&&!IsEmpty(self.amountTf.text)&&(self.fastMinerFeeView.backButton.selected || self.avgMinerFeeView.backButton.selected || self.slowMinerFeeView.backButton.selected)) {
        [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.continueButton.enabled = YES;
    }else
    {
        [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.continueButton.enabled = NO;
    }
}
#pragma mark set
- (void)setTokenModel:(SHWalletTokenModel *)tokenModel {
    _tokenModel = tokenModel;
}
#pragma mark 网络请求
#pragma mark 获取balance
-(void)getBalanceData
{
    // 没有钱包 return
    if ([SHKeyStorage shared].currentWalletModel == nil) {
        return;
    }
    // 选中的单地址
    SHWalletSubAddressModel *subAddressModel = [[SHKeyStorage shared].currentWalletModel.subAddressList objectAtIndex:[SHKeyStorage shared].currentWalletModel.selectSubIndex];
    SHWalletTokenModel *usdtTokenModel = [SHKeyStorage shared].currentWalletModel.tokenList.lastObject;
    // 所有地址字符串
    NSString *totalAddress = [SHKeyStorage shared].currentWalletModel.subAddressStr;
    NSString *usdtAddress = subAddressModel.address;
    NSInteger timestamp = [SHKeyStorage shared].currentWalletModel.lastRequestTimestamp;
    if (self.tokenModel.isPrimaryToken) { //主链币
        self.balanceValueLabel.text = [NSString stringWithFormat:@"%@ BTC",[NSString formStringWithValue:[SHWalletUtils coin_highToLowWithAmount:self.tokenModel.balance decimal:usdtTokenModel.places] count:8]];
        [[SHWalletNetManager shared] getBtcBalanceWithAddresses:totalAddress timestamp: timestamp  result:^(NSInteger code, NSString * _Nonnull message) {
            if (code == 0) {
                self.balanceValueLabel.text = [NSString stringWithFormat:@"%@ BTC",[NSString formStringWithValue:[SHWalletUtils coin_convertWithAmount:[SHKeyStorage shared].currentWalletModel.tokenList.firstObject.balance decimal:8] count:8]];
            }
        }];
    } else {
        self.balanceValueLabel.text = [NSString stringWithFormat:@"%@ USDT",[NSString formStringWithValue:[SHWalletUtils coin_highToLowWithAmount:self.tokenModel.balance decimal:usdtTokenModel.places] count:6]];
        [[SHWalletNetManager shared] getBtcUsdtBalanceWithAddress:usdtAddress result:^(NSString * _Nullable balance, NSInteger code, NSString * _Nonnull message) {
            if (code == 0) {
                self.balanceValueLabel.text = [NSString stringWithFormat:@"%@ USDT",[NSString formStringWithValue:[SHWalletUtils coin_highToLowWithAmount:[SHWalletUtils coin_lowTohighWithAmount:balance decimal:usdtTokenModel.places] decimal:usdtTokenModel.places] count:6]];
            }
        }];
    }
}
#pragma mark 获取gasPrice/预估gaslimit
-(void)loadGasPrice
{
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    __block NSString *limit = @"";
    [[SHWalletNetManager shared]getGasPriceSuccess:^(SHBaseResponseModel * _Nonnull result) {
        self.minPrice = [NSString stringWithFormat:@"%@",result.data.result[@"safeGasPrice"]];
        self.proposePrice = [NSString formStringWithValue:[NSString stringWithFormat:@"%@",result.data.result[@"proposeGasPrice"]] count:2];
        self.maxPrice = [NSString stringWithFormat:@"%@",result.data.result[@"fastGasPrice"]];
        //btc下limit 相当于bytes = 78 + count * 102
        [self queryBtcUtxoCountBlock:^(NSInteger count) {
            limit = [NSString stringWithFormat:@"%zd",count * 102 + 78];
            self.gasLimit = limit;
            NSString *fastTotalValue = [NSString formStringWithValue:[SHWalletUtils coin_convertWithAmount:[SHWalletUtils coin_multiplyingWithAmount:self.maxPrice count:limit] decimal:8] count:8];
            NSString *avgTotalValue = [NSString formStringWithValue:[SHWalletUtils coin_convertWithAmount:[SHWalletUtils coin_multiplyingWithAmount:self.proposePrice count:limit] decimal:8] count:8];
            NSString *slowTotalValue = [NSString formStringWithValue:[SHWalletUtils coin_convertWithAmount:[SHWalletUtils coin_multiplyingWithAmount:self.minPrice count:limit] decimal:8] count:8];
            
            
            NSDecimalNumber *rateNum = [NSDecimalNumber decimalNumberWithString:[SHKeyStorage shared].btcRate];
            
            NSDecimalNumber *fastTotal = [rateNum decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:fastTotalValue]];
            NSDecimalNumber *avgTotal = [rateNum decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:avgTotalValue]];
            NSDecimalNumber *slowTotal = [rateNum decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:slowTotalValue]];
            NSInteger decimal = 2;
            self.fastMinerFeeView.feeTypeNameLabel.text = GCLocalizedString(@"Fast");
            self.fastMinerFeeView.feeValueBtcLabel.text = [NSString stringWithFormat:@"%@ %@",fastTotalValue,@"BTC"];
            self.fastMinerFeeView.feeValueMoneyLabel.text = [NSString stringWithFormat:@"%@ %@",KAppSetting.currencySymbol,[NSString formStringWithValue:fastTotal.stringValue count:decimal]];
            
            self.avgMinerFeeView.feeTypeNameLabel.text = GCLocalizedString(@"Avg");
            self.avgMinerFeeView.feeValueBtcLabel.text = [NSString stringWithFormat:@"%@ %@",avgTotalValue,@"BTC"];
            self.avgMinerFeeView.feeValueMoneyLabel.text = [NSString stringWithFormat:@"%@ %@",KAppSetting.currencySymbol,[NSString formStringWithValue:avgTotal.stringValue count:decimal]];
            [self.avgMinerFeeView.backButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            self.slowMinerFeeView.feeTypeNameLabel.text = GCLocalizedString(@"Slow");
            self.slowMinerFeeView.feeValueBtcLabel.text = [NSString stringWithFormat:@"%@ %@",slowTotalValue,@"BTC"];
            self.slowMinerFeeView.feeValueMoneyLabel.text = [NSString stringWithFormat:@"%@ %@",KAppSetting.currencySymbol,[NSString formStringWithValue:slowTotal.stringValue count:decimal]];
            [MBProgressHUD hideCustormLoadingWithView:self.view];
        }];
    } fail:^(NSInteger errorCode, NSString * _Nonnull errorMessage) {
        [MBProgressHUD hideCustormLoadingWithView:self.view];
    }];
}
#pragma mark 获取UTXO数量
- (void)queryBtcUtxoCountBlock:(void(^)(NSInteger count))block {
    //每次请求都置空
    self.utxoCount = 0;
    NSMutableArray *addressArray = [NSMutableArray array];
    if (self.tokenModel.isPrimaryToken) {
        for (NSInteger countIndex = 0; countIndex < [SHKeyStorage shared].currentWalletModel.subAddressList.count; countIndex ++) {
            SHWalletSubAddressModel *subAddressModel = [[SHKeyStorage shared].currentWalletModel.subAddressList objectAtIndex:countIndex];
            [addressArray addObject:subAddressModel.address];
            if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypeMnemonic ||[SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey ) {
                SHWalletSubAddressModel *internalAddressModel = [[SHKeyStorage shared].currentWalletModel.changeAddressList objectAtIndex:countIndex];
                [addressArray addObject:internalAddressModel.address];
            }
        }
    }else
    {
        [addressArray addObject:[SHKeyStorage shared].currentWalletModel.address];
    }

    [[SHWalletNetManager shared] getBtcUtxoWithArray:addressArray succes:^(id  _Nonnull result) {
        NSDictionary *dict = (NSDictionary *)result;
        if (dict[@"unspent_outputs"]) {
            NSArray *utxoArray = dict[@"unspent_outputs"];
            self.utxoCount = utxoArray.count;
            if (block) {
                block(self.utxoCount);
            }
        } else {
            if (block) {
                block(0);
            }
        }
    } fail:^(NSInteger errorCode, NSString * _Nonnull errorMessage) {
        if (block) {
            block(0);
        }
    }];
}
#pragma mark  btc推荐矿工费生成真实矿工费
-(void)btcGetRealFee
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
    if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePrivateKey || self.tokenModel.isPrimaryToken == NO) { //私钥导入,OMNI交易
        uint64_t value = 0;
        NSString *omniValue = @"";
        NSString *omniId ;
        if (self.tokenModel.isPrimaryToken == YES) { //BTC
            value = [[SHWalletUtils coin_btcConvertSatWithStr:self.amountTf.text] longLongValue];
            omniId = nil;
        } else { //OMNI
            value = 546;
            omniValue = self.amountTf.text;
            omniId = @"31";
        }
        NSString *sat = @"";
        if (self.fastMinerFeeView.backButton.selected) {
            sat = self.maxPrice;
        }
        if (self.avgMinerFeeView.backButton.selected) {
            sat = self.proposePrice;
        }
        if (self.slowMinerFeeView.backButton.selected) {
            sat = self.minPrice;
        }
        [[SHWalletNetManager shared] creatBtcPrivateKeyTransactionWithToAddress:self.toAddressTf.text FromeAddress:[SHKeyStorage shared].currentWalletModel.address withValue:value withOmniValue:omniValue withomniId:omniId sat:sat bytes:[self.gasLimit longLongValue] PrivateKey:[SHKeyStorage shared].currentWalletModel.privateKey isSegwit:YES transactionCallBack:^(NSError * _Nonnull error, BTCTransaction * _Nonnull transaction, uint64_t realBytes) {
            if (transaction == nil) {
                if (self.tokenModel.isPrimaryToken == NO) {
                    [MBProgressHUD showError:GCLocalizedString(@"insufficient_BTC_balance") toView:self.view];
                } else {
                    if (error.code == 2001) {
                        [MBProgressHUD showError:GCLocalizedString(@"transfer_amount_low") toView:self.view];
                    }else
                    {
                        [MBProgressHUD showError:GCLocalizedString(@"insufficient_balance") toView:self.view];
                    }
                }
                self.continueButton.enabled = YES;
                return;
            }
            [MBProgressHUD hideCustormLoadingWithView:self.view];
            self.gasLimit = [NSString stringWithFormat:@"%llu",realBytes];
            self.transaction = transaction;
            self.transferInfoModel.valueString = self.amountTf.text;
            self.transferInfoModel.addressString = self.toAddressTf.text;
            self.transferInfoModel.coinString = self.tokenModel.isPrimaryToken?@"BTC":@"USDT";
            self.transferInfoModel.gasPrice = sat;
            self.transferInfoModel.gasLimit = self.gasLimit;
            self.transferInfoModel.transaction = self.transaction;
            if ([SHKeyStorage shared].currentWalletModel.isNoSecret){//如果是免密
                SHTransferValidationForTouchOrFaceViewController *transferValidationForTouchOrFaceViewController = [[SHTransferValidationForTouchOrFaceViewController alloc]init];
                transferValidationForTouchOrFaceViewController.tokenModel =  self.tokenModel;
                transferValidationForTouchOrFaceViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                transferValidationForTouchOrFaceViewController.transferInfoModel = self.transferInfoModel;
                [self.navigationController pushViewController:transferValidationForTouchOrFaceViewController animated:YES];
            }else {
                SHTransferValidationForPassWordViewController *transferValidationForPassWordViewController = [[SHTransferValidationForPassWordViewController alloc]init];
                transferValidationForPassWordViewController.tokenModel = self.tokenModel;
                transferValidationForPassWordViewController.transferInfoModel = self.transferInfoModel;
                transferValidationForPassWordViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                [self.navigationController pushViewController:transferValidationForPassWordViewController animated:YES];
            }
            self.continueButton.enabled = YES;
        }];
    } else { //BTC 转账 助记词导入
        NSString *sat = @"";
        if (self.fastMinerFeeView.backButton.selected) {
            sat = self.maxPrice;
        }
        if (self.avgMinerFeeView.backButton.selected) {
            sat = self.proposePrice;
        }
        if (self.slowMinerFeeView.backButton.selected) {
            sat = self.minPrice;
        }
        if ([[SHKeyStorage.shared.currentWalletModel.address substringToIndex:3].lowercaseString isEqualToString:@"bc1"]) {
            [self signMnemonicForBc1AddressWithAddressArray:addressArray WithSat:sat];
        }else
        {
            [self signMnemonicFor3AddressWithAddressArray:addressArray WithSat:sat];
        }
        self.continueButton.enabled = YES;
    }
}
-(void)signMnemonicForBc1AddressWithAddressArray:(NSMutableArray *)addressArray WithSat:(NSString *)sat
{
    NSString *addressesStr = [addressArray componentsJoinedByString:@"|"];
    NSMutableArray *blockchairUtxos = [NSMutableArray new];
    [[NetWorkTool shareNetworkTool]requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"https://blockchain.info/unspent?active=%@",addressesStr] withMethodType:Get withParams:@{} result:^(id  _Nullable responseObject, NSInteger code, NSString *message) {
        if (code == 0) {
            NSArray *utxoArr = responseObject[@"unspent_outputs"];
            if (utxoArr.count == 0) {
                self.continueButton.enabled = YES;
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:GCLocalizedString(@"Lack_balance") toView:self.view];
                return;
            }
            for (NSDictionary *utxoJson in utxoArr) {
                if (!utxoJson) {
                    self.continueButton.enabled = YES;
                    continue;
                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:utxoJson[@"value"] forKey:@"value"];
                [dic setValue:utxoJson[@"tx_index"] forKey:@"index"];
                [dic setValue:utxoJson[@"tx_hash_big_endian"] forKey:@"transaction_hash"];
                
                NSString *jsAddressStr = [NSString stringWithFormat:@"scriptToBech32(%@)",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@[utxoJson[@"script"]] options:0 error:nil] encoding:NSUTF8StringEncoding]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.wkWebView evaluateJavaScript:jsAddressStr completionHandler:^(id _Nullable scriptToBech32Result, NSError * _Nullable error) {
                        if (IsEmpty(scriptToBech32Result)) {
                            self.continueButton.enabled = YES;
                            [MBProgressHUD hideCustormLoadingWithView:self.view];
                            [MBProgressHUD showError:GCLocalizedString(@"scriptToBech32 error") toView:self.view];
                            return;
                        }
                        NSData *data = [scriptToBech32Result dataUsingEncoding:NSUTF8StringEncoding];
                        NSArray *resutDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                        [dic setValue:resutDic[0] forKey:@"address"];
                        [blockchairUtxos addObject:dic];
                        if (blockchairUtxos.count == utxoArr.count) {
                            [[SHWalletNetManager shared] saveBtcTransactionsBc1WithBlockchair:blockchairUtxos succes:^(NSArray *outs) {
                                [[SHWalletNetManager shared] createBtcMnemonicBc1TransactionWithToAddress:self.toAddressTf.text withValue:[[SHWalletUtils coin_btcConvertSatWithStr:self.amountTf.text]longLongValue] withOuts:outs pathType:EXTERNAL_BIP49_PATH sat:sat bytes:[self.gasLimit longLongValue] password:[SHKeyStorage shared].currentWalletModel.password transactionCallBack:^(NSError * _Nonnull error, BTTx * _Nonnull tx, uint64_t realBytes) {
                                    if (tx == nil) {
                                        if (error.code == 2001) {
                                            [MBProgressHUD showError:GCLocalizedString(@"transfer_amount_low") toView:self.view];
                                        }else
                                        {
                                            [MBProgressHUD showError:GCLocalizedString(@"insufficient_balance") toView:self.view];
                                        }
                                        return;
                                    }
                                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                                    self.tx = tx;
                                    self.gasLimit = [NSString stringWithFormat:@"%llu",realBytes];
                                    self.transferInfoModel.valueString = self.amountTf.text;
                                    self.transferInfoModel.addressString = self.toAddressTf.text;
                                    self.transferInfoModel.coinString = self.tokenModel.isPrimaryToken?@"BTC":@"USDT";
                                    self.transferInfoModel.gasPrice = sat;
                                    self.transferInfoModel.gasLimit = self.gasLimit;
                                    self.transferInfoModel.tx = self.tx;
                                    if ([SHKeyStorage shared].currentWalletModel.isNoSecret){//如果是免密
                                        SHTransferValidationForTouchOrFaceViewController *transferValidationForTouchOrFaceViewController = [[SHTransferValidationForTouchOrFaceViewController alloc]init];
                                        transferValidationForTouchOrFaceViewController.tokenModel =  self.tokenModel;
                                        transferValidationForTouchOrFaceViewController.transferInfoModel = self.transferInfoModel;
                                        transferValidationForTouchOrFaceViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                                        [self.navigationController pushViewController:transferValidationForTouchOrFaceViewController animated:YES];
                                    }else {
                                        SHTransferValidationForPassWordViewController *transferValidationForPassWordViewController = [[SHTransferValidationForPassWordViewController alloc]init];
                                        transferValidationForPassWordViewController.tokenModel = self.tokenModel;
                                        transferValidationForPassWordViewController.transferInfoModel = self.transferInfoModel;
                                        transferValidationForPassWordViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                                        [self.navigationController pushViewController:transferValidationForPassWordViewController animated:YES];
                                    }
                                }];
                            }];
                        }
                    }];
                });
            }
        }else
        {
            [MBProgressHUD showError:message toView:nil];
        }
    }];
}
-(void)signMnemonicFor3AddressWithAddressArray:(NSMutableArray *)addressArray WithSat:(NSString *)sat
{
    NSString *addressesStr = [addressArray componentsJoinedByString:@"|"];
    NSMutableArray *blockchairUtxos = [NSMutableArray new];
    [[NetWorkTool shareNetworkTool]requestBaseUrlForCheckContractHttpWithPath:[NSString stringWithFormat:@"https://blockchain.info/unspent?active=%@",addressesStr] withMethodType:Get withParams:@{} result:^(id  _Nullable responseObject, NSInteger code, NSString *message) {
        if (code == 0) {
            NSArray *utxoArr = responseObject[@"unspent_outputs"];
            if (utxoArr.count == 0) {
                self.continueButton.enabled = YES;
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:GCLocalizedString(@"Lack_balance") toView:self.view];
                return;
            }
            for (NSDictionary *utxoJson in utxoArr) {
                if (!utxoJson) {
                    self.continueButton.enabled = YES;
                    continue;
                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:utxoJson[@"value"] forKey:@"value"];
                [dic setValue:utxoJson[@"tx_index"] forKey:@"index"];
                [dic setValue:utxoJson[@"tx_hash_big_endian"] forKey:@"transaction_hash"];
                
                NSString *jsAddressStr = [NSString stringWithFormat:@"scriptToBech32(%@)",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@[utxoJson[@"script"]] options:0 error:nil] encoding:NSUTF8StringEncoding]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.wkWebView evaluateJavaScript:jsAddressStr completionHandler:^(id _Nullable scriptToBech32Result, NSError * _Nullable error) {
                        if (IsEmpty(scriptToBech32Result)) {
                            self.continueButton.enabled = YES;
                            [MBProgressHUD hideCustormLoadingWithView:self.view];
                            [MBProgressHUD showError:GCLocalizedString(@"scriptToBech32 error") toView:self.view];
                            return;
                        }
                        NSData *data = [scriptToBech32Result dataUsingEncoding:NSUTF8StringEncoding];
                        NSArray *resutDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                        [dic setValue:resutDic[0] forKey:@"address"];
                        [blockchairUtxos addObject:dic];
                        if (blockchairUtxos.count == utxoArr.count) {
                            [[SHWalletNetManager shared] saveBtcTransactionsWithBlockchair:blockchairUtxos succes:^(id _Nonnull result) {
                                [[SHWalletNetManager shared] createBtcMnemonicTransactionWithToAddress:self.toAddressTf.text withValue:[[SHWalletUtils coin_btcConvertSatWithStr:self.amountTf.text]longLongValue] pathType:EXTERNAL_BIP49_PATH sat:sat bytes:[self.gasLimit longLongValue] password:[SHKeyStorage shared].currentWalletModel.password transactionCallBack:^(NSError * _Nonnull error, BTTx * _Nonnull tx, uint64_t realBytes) {
                                    
                                    if (tx == nil) {
                                        if (error.code == 2001) {
                                            [MBProgressHUD showError:GCLocalizedString(@"transfer_amount_low") toView:self.view];
                                        }else
                                        {
                                            [MBProgressHUD showError:GCLocalizedString(@"insufficient_balance") toView:self.view];
                                        }
                                        return;
                                    }
                                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                                    self.tx = tx;
                                    self.gasLimit = [NSString stringWithFormat:@"%llu",realBytes];
                                    self.transferInfoModel.valueString = self.amountTf.text;
                                    self.transferInfoModel.addressString = self.toAddressTf.text;
                                    self.transferInfoModel.coinString = self.tokenModel.isPrimaryToken?@"BTC":@"USDT";
                                    self.transferInfoModel.gasPrice = sat;
                                    self.transferInfoModel.gasLimit = self.gasLimit;
                                    self.transferInfoModel.tx = self.tx;
                                    if ([SHKeyStorage shared].currentWalletModel.isNoSecret){//如果是免密
                                        SHTransferValidationForTouchOrFaceViewController *transferValidationForTouchOrFaceViewController = [[SHTransferValidationForTouchOrFaceViewController alloc]init];
                                        transferValidationForTouchOrFaceViewController.tokenModel =  self.tokenModel;
                                        transferValidationForTouchOrFaceViewController.transferInfoModel = self.transferInfoModel;
                                        transferValidationForTouchOrFaceViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                                        [self.navigationController pushViewController:transferValidationForTouchOrFaceViewController animated:YES];
                                    }else {
                                        SHTransferValidationForPassWordViewController *transferValidationForPassWordViewController = [[SHTransferValidationForPassWordViewController alloc]init];
                                        transferValidationForPassWordViewController.tokenModel = self.tokenModel;
                                        transferValidationForPassWordViewController.transferInfoModel = self.transferInfoModel;
                                        transferValidationForPassWordViewController.isPrimaryToken = self.tokenModel.isPrimaryToken;
                                        [self.navigationController pushViewController:transferValidationForPassWordViewController animated:YES];
                                    }
                                }];
                            }];
                        }
                    }];
                });
            }
        }else
        {
            [MBProgressHUD showError:message toView:nil];
        }
    }];
}
#pragma mark 按钮事件
-(void)qrButtonAction:(UIButton *)btn
{
    UIViewController *vc = [SHOCToSwiftUI makeScanViewWithScanBlock:^(NSString * _Nonnull qrString) {
        self.toAddressTf.text = qrString;
        [self layoutStartButtonColor];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)addressListButtonAction:(UIButton *)btn
{
    SHAdressBookViewController *adressBookViewController = [[SHAdressBookViewController alloc]init];
    adressBookViewController.inputType = 1;
    adressBookViewController.selectAddressClickBlock = ^(SHAddressBookModel * _Nonnull addressModel) {
        self.toAddressTf.text = addressModel.addressValue;
    };
    [self.navigationController pushViewController:adressBookViewController animated:YES];
}
-(void)continueButtonAction:(UIButton *)btn
{
    self.continueButton.enabled = NO;
    NSLog(@"zhaohong_点击下一步%ld",[NSString getNowTimeTimestamp]);
    if (self.tokenModel.isPrimaryToken == NO&&([[self.toAddressTf.text substringToIndex:3].lowercaseString isEqualToString:@"bc1"] ||[[[SHKeyStorage shared].currentWalletModel.address substringToIndex:3].lowercaseString isEqualToString:@"bc1"])) {
        self.continueButton.enabled = YES;
        [MBProgressHUD showError:GCLocalizedString(@"Omni_not_transfer") toView:self.view];
        return;
    }
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypeMnemonic&&[[[SHKeyStorage shared].currentWalletModel.address substringToIndex:3].lowercaseString isEqualToString:@"bc1"]) {//hd  bc1交易
        [self bc1ToTradding];
    }else if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePrivateKey&&self.tokenModel.isPrimaryToken&&([[self.toAddressTf.text substringToIndex:3].lowercaseString isEqualToString:@"bc1"] ||[[[SHKeyStorage shared].currentWalletModel.address substringToIndex:3].lowercaseString isEqualToString:@"bc1"])) {//私钥交易
        [self bc1PrivateKeyToTradding];
    }else if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey) {//多签、单签交易
        [self createMultisigTransaction];
    }else
    {
        [self btcGetRealFee];
    }
}
#pragma mark 懒加载
-(UILabel *)toAddressTipsLabel
{
    if (_toAddressTipsLabel == nil) {
        _toAddressTipsLabel = [[UILabel alloc]init];
        _toAddressTipsLabel.font = kCustomMontserratMediumFont(14);
        _toAddressTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _toAddressTipsLabel.text = GCLocalizedString(@"to");
        [self.view addSubview:_toAddressTipsLabel];
    }
    return _toAddressTipsLabel;
}
-(TGTextField *)toAddressTf
{
    if (_toAddressTf == nil) {
        _toAddressTf = [[TGTextField alloc]init];
        _toAddressTf.tintColor = SHTheme.agreeButtonColor;
        _toAddressTf.placeholder = GCLocalizedString(@"et_address_hint");
        _toAddressTf.font = kCustomMontserratRegularFont(14);
        _toAddressTf.clearButtonMode = UITextFieldViewModeAlways;
        //        _toAddressTf.secureTextEntry = YES;
        [_toAddressTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_toAddressTf];
    }
    return _toAddressTf;
}
-(UIButton *)qrButton
{
    if (_qrButton == nil) {
        _qrButton = [[UIButton alloc]init];
        [_qrButton setImage:[UIImage imageNamed:@"transgerVc_qrButton"] forState:UIControlStateNormal];
        [_qrButton addTarget:self action:@selector(qrButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_qrButton];
    }
    return _qrButton;
}
-(UIButton *)addressListButton
{
    if (_addressListButton == nil) {
        _addressListButton = [[UIButton alloc]init];
        [_addressListButton setImage:[UIImage imageNamed:@"transgerVc_addressListButton"] forState:UIControlStateNormal];
        [_addressListButton addTarget:self action:@selector(addressListButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addressListButton];
    }
    return _addressListButton;
}
- (UIView *)toAddressLineView
{
    if (_toAddressLineView == nil) {
        _toAddressLineView = [[UIView alloc]init];
        _toAddressLineView.backgroundColor = SHTheme.appBlackColor;
        _toAddressLineView.alpha = 0.12;
        [self.view addSubview:_toAddressLineView];
    }
    return _toAddressLineView;
}


-(UILabel *)amountTipsLabel
{
    if (_amountTipsLabel == nil) {
        _amountTipsLabel = [[UILabel alloc]init];
        _amountTipsLabel.font = kCustomMontserratMediumFont(14);
        _amountTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _amountTipsLabel.text = GCLocalizedString(@"amount");
        [self.view addSubview:_amountTipsLabel];
    }
    return _amountTipsLabel;
}
-(TGTextField *)amountTf
{
    if (_amountTf == nil) {
        _amountTf = [[TGTextField alloc]init];
        _amountTf.tintColor = SHTheme.agreeButtonColor;
        _amountTf.placeholder = GCLocalizedString(@"et_amount_hint");
        _amountTf.font = kCustomMontserratRegularFont(14);
        _amountTf.clearButtonMode = UITextFieldViewModeAlways;
        _amountTf.limitType = TextFieldLimitDecimalType;
        _amountTf.decimalCount = self.tokenModel.isPrimaryToken?8:2;
        //        _amountTf.secureTextEntry = YES;
        [_amountTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_amountTf];
    }
    return _amountTf;
}

- (UIView *)amountLineView
{
    if (_amountLineView == nil) {
        _amountLineView = [[UIView alloc]init];
        _amountLineView.backgroundColor = SHTheme.appBlackColor;
        _amountLineView.alpha = 0.12;
        [self.view addSubview:_amountLineView];
    }
    return _amountLineView;
}

-(UILabel *)balanceTipsLabel
{
    if (_balanceTipsLabel == nil) {
        _balanceTipsLabel = [[UILabel alloc]init];
        _balanceTipsLabel.font = kCustomMontserratMediumFont(12);
        _balanceTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _balanceTipsLabel.text = GCLocalizedString(@"Balance");
        [self.view addSubview:_balanceTipsLabel];
    }
    return _balanceTipsLabel;
}
-(UILabel *)balanceValueLabel
{
    if (_balanceValueLabel == nil) {
        _balanceValueLabel = [[UILabel alloc]init];
        _balanceValueLabel.font = kCustomMontserratMediumFont(12);
        _balanceValueLabel.textColor = SHTheme.agreeTipsLabelColor;
        _balanceValueLabel.text = @"--";
        [self.view addSubview:_balanceValueLabel];
    }
    return _balanceValueLabel;
}
-(UILabel *)minerFeeTipsLabel
{
    if (_minerFeeTipsLabel == nil) {
        _minerFeeTipsLabel = [[UILabel alloc]init];
        _minerFeeTipsLabel.font = kCustomMontserratMediumFont(14);
        _minerFeeTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _minerFeeTipsLabel.text = GCLocalizedString(@"miner_fee");
        [self.view addSubview:_minerFeeTipsLabel];
    }
    return _minerFeeTipsLabel;
}
-(UIButton *)continueButton
{
    if (_continueButton == nil) {
        _continueButton = [[UIButton alloc]init];
        _continueButton.layer.cornerRadius = 26*FitHeight;
        _continueButton.layer.masksToBounds = YES;
        _continueButton.enabled = NO;
        [_continueButton setTitle:GCLocalizedString(@"Next") forState:UIControlStateNormal];
        [_continueButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _continueButton.titleLabel.font = kMediunFont(14);
        [_continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_continueButton];
    }
    return _continueButton;
}
-(SHMinerFeeView *)fastMinerFeeView
{
    MJWeakSelf;
    if (_fastMinerFeeView == nil) {
        _fastMinerFeeView = [[SHMinerFeeView alloc]init];
        _fastMinerFeeView.layer.cornerRadius = 8;
        _fastMinerFeeView.backgroundColor = SHTheme.addressTypeCellBackColor;
        _fastMinerFeeView.backButtonClickBlock = ^{
            weakSelf.avgMinerFeeView.backButton.selected = NO;
            weakSelf.slowMinerFeeView.backButton.selected = NO;
            [weakSelf.avgMinerFeeView loadSelectViewWithBool:NO];
            [weakSelf.slowMinerFeeView loadSelectViewWithBool:NO];
            [weakSelf layoutStartButtonColor];
        };
        [self.view addSubview:_fastMinerFeeView];
    }
    return _fastMinerFeeView;
}
-(SHMinerFeeView *)avgMinerFeeView
{
    MJWeakSelf;
    if (_avgMinerFeeView == nil) {
        _avgMinerFeeView = [[SHMinerFeeView alloc]init];
        _avgMinerFeeView.layer.cornerRadius = 8;
        _avgMinerFeeView.backgroundColor = SHTheme.addressTypeCellBackColor;
        _avgMinerFeeView.backButtonClickBlock = ^{
            weakSelf.fastMinerFeeView.backButton.selected = NO;
            weakSelf.slowMinerFeeView.backButton.selected = NO;
            [weakSelf.fastMinerFeeView loadSelectViewWithBool:NO];
            [weakSelf.slowMinerFeeView loadSelectViewWithBool:NO];
            [weakSelf layoutStartButtonColor];
        };
        [self.view addSubview:_avgMinerFeeView];
    }
    return _avgMinerFeeView;
}
-(SHMinerFeeView *)slowMinerFeeView
{
    MJWeakSelf;
    if (_slowMinerFeeView == nil) {
        _slowMinerFeeView = [[SHMinerFeeView alloc]init];
        _slowMinerFeeView.layer.cornerRadius = 8;
        _slowMinerFeeView.backgroundColor = SHTheme.addressTypeCellBackColor;
        _slowMinerFeeView.backButtonClickBlock = ^{
            weakSelf.avgMinerFeeView.backButton.selected = NO;
            weakSelf.fastMinerFeeView.backButton.selected = NO;
            [weakSelf.avgMinerFeeView loadSelectViewWithBool:NO];
            [weakSelf.fastMinerFeeView loadSelectViewWithBool:NO];
            [weakSelf layoutStartButtonColor];
        };
        [self.view addSubview:_slowMinerFeeView];
    }
    return _slowMinerFeeView;
}
-(SHTransferInfoModel *)transferInfoModel
{
    if (_transferInfoModel == nil) {
        _transferInfoModel = [[SHTransferInfoModel alloc]init];
    }
    return _transferInfoModel;
}
-(void)dealloc
{
    self.wkWebView.navigationDelegate = nil;
    [self.wkWebView removeFromSuperview];
}
@end
