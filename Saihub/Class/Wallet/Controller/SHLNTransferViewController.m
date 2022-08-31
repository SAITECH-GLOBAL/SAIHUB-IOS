//
//  SHLNTransferViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/23.
//

#import "SHLNTransferViewController.h"
#import "SHVerifyPasswordController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface SHLNTransferViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *invoiceTipsLabel;
@property (nonatomic, strong) UITextField *invoiceTf;
@property (nonatomic, strong) UIView *invoiceLineView;
@property (nonatomic, strong) UIButton *qrButton;

@property (nonatomic, strong) UIView *moneyBgView;
@property (nonatomic, strong) TGTextField *moneyTf;
@property (nonatomic, strong) UILabel *coinTipsLabel;
@property (nonatomic, strong) UILabel *equivalentLabel;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UILabel *detailOneTipsLabel;
@property (nonatomic, strong) UILabel *detailOneValueLabel;
@property (nonatomic, strong) UILabel *detailTwoTipsLabel;
@property (nonatomic, strong) UILabel *detailTwoValueLabel;
@property (nonatomic, strong) NSString *callBackString;


@property (nonatomic, strong) UIButton *PayButton;

@property (nonatomic, strong) dispatch_source_t _timer;
@end

@implementation SHLNTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.invoiceTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 24*FitHeight).heightIs(22*FitHeight);
    [self.invoiceTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.invoiceTf.sd_layout.leftEqualToView(self.invoiceTipsLabel).topSpaceToView(self.invoiceTipsLabel, 0).rightSpaceToView(self.view, 52*FitWidth).heightIs(46*FitHeight);
    self.invoiceLineView.sd_layout.leftEqualToView(self.invoiceTipsLabel).rightSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.invoiceTf, 0).heightIs(1);
    self.qrButton.sd_layout.rightEqualToView(self.invoiceLineView).centerYEqualToView(self.invoiceTf).widthIs(20*FitWidth).heightEqualToWidth();
    
    self.moneyBgView.sd_layout.centerXEqualToView(self.invoiceLineView).topSpaceToView(self.invoiceLineView, 20*FitHeight).widthIs(335*FitWidth).heightIs(106*FitHeight);
    self.moneyTf.sd_layout.centerXEqualToView(self.moneyBgView).centerYEqualToView(self.moneyBgView).widthIs(25*FitWidth).heightIs(48*FitHeight);
    self.coinTipsLabel.sd_layout.leftSpaceToView(self.moneyTf, 4*FitWidth).bottomEqualToView(self.moneyTf).heightIs(18*FitWidth);
    [self.coinTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    
    self.equivalentLabel.sd_layout.rightEqualToView(self.moneyBgView).topSpaceToView(self.moneyBgView, 10*FitHeight).heightIs(14*FitHeight);
    [self.equivalentLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.lineView.sd_layout.leftEqualToView(self.moneyBgView).rightEqualToView(self.moneyBgView).topSpaceToView(self.moneyBgView, 34*FitHeight).heightIs(1);
    self.detailOneTipsLabel.sd_layout.leftEqualToView(self.lineView).topSpaceToView(self.lineView, 15*FitHeight).heightIs(22*FitHeight);
    [self.detailOneTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.detailOneValueLabel.sd_layout.leftSpaceToView(self.detailOneTipsLabel, 0).centerYEqualToView(self.detailOneTipsLabel).heightIs(22*FitHeight);
    [self.detailOneValueLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.detailTwoTipsLabel.sd_layout.leftEqualToView(self.lineView).topSpaceToView(self.detailOneTipsLabel, 10*FitHeight).heightIs(22*FitHeight);
    [self.detailTwoTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.detailTwoValueLabel.sd_layout.leftSpaceToView(self.detailTwoTipsLabel, 0).centerYEqualToView(self.detailTwoTipsLabel).heightIs(22*FitHeight);
    [self.detailTwoValueLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    
    

    self.PayButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.moneyBgView, 190*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.PayButton setBackgroundImage:[UIImage gradientImageWithBounds:self.PayButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];

}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
    if ([textField isEqual:self.moneyTf]) {
        self.moneyTf.sd_layout.centerXEqualToView(self.moneyBgView).centerYEqualToView(self.moneyBgView).widthIs(25*FitWidth*(textField.text.length >10?10:(textField.text.length<1?1:textField.text.length))).heightIs(48*FitHeight);
        NSString *rate = [SHKeyStorage shared].btcRate;
        self.equivalentLabel.text = [NSString stringWithFormat:@"≈%@ %@",KAppSetting.currencySymbol,[NSString digitStringWithValue:[[NSString stringWithFormat:@"%.8lf",[textField.text longLongValue] * pow(10, -8)] to_multiplyingWithStr:rate] count:6]];
    }
    if ([textField isEqual:self.invoiceTf]) {
        if (self._timer) {
            dispatch_source_cancel(self._timer);
        }
        self.detailOneTipsLabel.hidden = YES;
        self.detailOneValueLabel.hidden = YES;
        self.detailTwoTipsLabel.hidden = YES;
        self.detailTwoValueLabel.hidden = YES;
//        self.moneyTf.text = @"0";
        self.equivalentLabel.text = [NSString stringWithFormat:@"≈%@ %@",KAppSetting.currencySymbol,[NSString digitStringWithValue:[[NSString stringWithFormat:@"%.8lf",[self.moneyTf.text longLongValue] * pow(10, -8)] to_multiplyingWithStr:[SHKeyStorage shared].btcRate] count:6]];
        self.moneyTf.enabled = YES;
    }
    [self layoutStartButtonColor];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
   return YES;
   }
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self textFieldEndEditAction];
    return YES;
}
-(void)textFieldEndEditAction
{
    if (IsEmpty(self.invoiceTf.text)) {
        return ;
    }
    if ([self.invoiceTf.text containsString:@"@"]) {
        [self sendPayWithEmail];
    }else
    {//解析invoice
        [self decodeInvoiceWithString:self.invoiceTf.text];
    }
}
#pragma mark keysend
//邮箱发起支付
-(void)sendPayWithEmail
{
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    NSString *emailString = self.invoiceTf.text;
    NSArray *emailArray = [emailString componentsSeparatedByString:@"@"];
    if (emailArray.count == 2) {
        NSString *urlString = [NSString stringWithFormat:@"https://%@/.well-known/lnurlp/%@",emailArray[1],emailArray[0]];
        [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpwithHeader:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",[SHKeyStorage shared].currentLNWalletModel.access_token]} WithPath:urlString withMethodType:Get withParams:@{} result:^(id  _Nullable getCallBackDic, NSInteger getCallBackCode, NSString *getCallBackMessage) {
            [MBProgressHUD hideCustormLoadingWithView:self.view];
            if ([[getCallBackDic className] containsString:@"NSDictionary"]&&[[(NSDictionary *)getCallBackDic allKeys]containsObject:@"message"]) {
                if ([getCallBackDic[@"message"]isEqualToString:@"bad auth"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTokenKey" object:nil];
                    return;
                }
                [MBProgressHUD showError:getCallBackDic[@"message"] toView:self.view];
                return;
            }
            if ([[(NSDictionary *)getCallBackDic allKeys]containsObject:@"callback"]) {
                self.callBackString = getCallBackDic[@"callback"];
                self.moneyTf.enabled = YES;
                self.detailOneTipsLabel.hidden = NO;
                self.detailOneValueLabel.hidden = NO;
                self.detailTwoTipsLabel.hidden = NO;
                self.detailTwoValueLabel.hidden = NO;

                self.detailOneTipsLabel.text = GCLocalizedString(@"please_pay");
                self.detailOneValueLabel.text = [NSString stringWithFormat:@"%lld-%lld sats",[getCallBackDic[@"minSendable"] longLongValue]/1000,[getCallBackDic[@"maxSendable"]longLongValue]/1000];
                self.detailTwoTipsLabel.text = GCLocalizedString(@"stas_for");
                NSArray *emailArray = [self.invoiceTf.text componentsSeparatedByString:@"@"];

                self.detailTwoValueLabel.text = [NSString stringWithFormat:@"%@ %@",emailArray[0],emailArray[1]];
                
                self.detailOneValueLabel.textColor = SHTheme.agreeButtonColor;

            }else
            {
                return;
            }
        }];
    }else
    {
        [MBProgressHUD hideLoadingWithView:self.view];
    }
}
-(void)sendPayWithEmalSub
{
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
        NSString *callBack = self.callBackString;
        NSString *callBackString = [NSString stringWithFormat:@"%@?amount=%ld&comment=%@&nonce=%ld",callBack,[self.moneyTf.text longValue]*1000,@"",[NSString getNowTimeTimestamp]];
    [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpwithHeader:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",[SHKeyStorage shared].currentLNWalletModel.access_token]} WithPath:callBackString withMethodType:Get withParams:@{} result:^(id  _Nullable getPrInvoiceDic, NSInteger getPrInvoiceCode, NSString *getPrInvoiceMessage) {
            if (getPrInvoiceCode == 0) {
                if ([[getPrInvoiceDic className] containsString:@"NSDictionary"]&&[[(NSDictionary *)getPrInvoiceDic allKeys]containsObject:@"message"]) {
                    if ([getPrInvoiceDic[@"message"]isEqualToString:@"bad auth"]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTokenKey" object:nil];
                        [MBProgressHUD hideCustormLoadingWithView:self.view];
                        return;
                    }
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showError:getPrInvoiceDic[@"message"] toView:self.view];
                    return;
                }
                [self payInvoiceWithInvoice:getPrInvoiceDic[@"pr"] withLoading:NO];
            }else
            {
                [MBProgressHUD hideCustormLoadingWithView:self.view];
                [MBProgressHUD showError:getPrInvoiceMessage toView:nil];
            }
        }];
        
    }
#pragma mark decodeInvoice
-(void)decodeInvoiceWithString:(NSString *)decodeInvoice
{
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
        NSString *callBackString = [NSString stringWithFormat:@"%@/decodeinvoice?invoice=%@",[SHKeyStorage shared].currentLNWalletModel.hostUrl,decodeInvoice];
    [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpwithHeader:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",[SHKeyStorage shared].currentLNWalletModel.access_token]} WithPath:callBackString withMethodType:Get withParams:@{} result:^(id  _Nullable getPrInvoiceDic, NSInteger getPrInvoiceCode, NSString *getPrInvoiceMessage) {
        [MBProgressHUD hideLoadingWithView:self.view];
            if (getPrInvoiceCode == 0) {
                if ([[getPrInvoiceDic className] containsString:@"NSDictionary"]&&[[(NSDictionary *)getPrInvoiceDic allKeys]containsObject:@"message"]) {
                    if ([getPrInvoiceDic[@"message"]isEqualToString:@"bad auth"]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTokenKey" object:nil];
                        return;
                    }
                    [MBProgressHUD showError:getPrInvoiceDic[@"message"] toView:self.view];
                    return;
                }
                self.moneyTf.enabled = NO;
                self.detailOneTipsLabel.hidden = NO;
                self.detailOneValueLabel.hidden = NO;
                self.detailTwoTipsLabel.hidden = NO;
                self.detailTwoValueLabel.hidden = NO;

                self.detailOneTipsLabel.text = GCLocalizedString(@"Expires_in_With");
                [self countdownActionWithTime:[getPrInvoiceDic[@"timestamp"] longValue] andWithExceitTime:[getPrInvoiceDic[@"expiry"] longValue]];
                self.detailTwoTipsLabel.text = GCLocalizedString(@"Potential_Fee");
                self.moneyTf.text = getPrInvoiceDic[@"num_satoshis"];
                self.moneyTf.sd_layout.centerXEqualToView(self.moneyBgView).centerYEqualToView(self.moneyBgView).widthIs(25*FitWidth*(self.moneyTf.text.length >10?10:(self.moneyTf.text.length<1?1:self.moneyTf.text.length))).heightIs(48*FitHeight);
                self.equivalentLabel.text = [NSString stringWithFormat:@"≈%@ %@",KAppSetting.currencySymbol,[NSString digitStringWithValue:[[NSString stringWithFormat:@"%.8lf",[self.moneyTf.text longLongValue] * pow(10, -8)] to_multiplyingWithStr:[SHKeyStorage shared].btcRate] count:6]];

                long minfee = floorf([getPrInvoiceDic[@"num_satoshis"] longValue] * 0.003);
                long maxfee = floorf([getPrInvoiceDic[@"num_satoshis"] longValue] * 0.01) + 1;

                self.detailTwoValueLabel.text = [NSString stringWithFormat:@"%ld-%ld sats",minfee,maxfee];
                [self layoutStartButtonColor];

            }else
            {
                [MBProgressHUD showError:getPrInvoiceMessage toView:nil];
            }
        }];
        
    }
#pragma mark //pay invoice
-(void)payInvoiceWithInvoice:(NSString *)invoice withLoading:(BOOL)isLoading
{
    if (isLoading) {
        [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    }
    [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpwithHeader:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",[SHKeyStorage shared].currentLNWalletModel.access_token]} WithPath:[NSString stringWithFormat:@"%@/payinvoice",[SHKeyStorage shared].currentLNWalletModel.hostUrl] withMethodType:Post withParams:@{@"amount":self.moneyTf.text,@"invoice":invoice} result:^(id  _Nullable resultData, NSInteger resultCode, NSString *resultMessage) {
        [MBProgressHUD hideCustormLoadingWithView:self.view];
        if (resultCode == 0) {
            if ([[resultData className] containsString:@"NSDictionary"]&&[[(NSDictionary *)resultData allKeys]containsObject:@"message"]) {
                if ([resultData[@"message"]isEqualToString:@"bad auth"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTokenKey" object:nil];
                    return;
                }
                [MBProgressHUD showError:resultData[@"message"] toView:self.view];
                return;
            }
            self.invoiceTf.text = @"";
            [self textFieldChanged:self.invoiceTf];
            [MBProgressHUD showSuccess:GCLocalizedString(@"Payment_successful") toView:self.view];
            [self popViewController];
        }else
        {
            [MBProgressHUD showError:resultMessage toView:nil];
        }
    }];
}
-(void)countdownActionWithTime:(long)creartTime andWithExceitTime:(long)exceitTime
{
    if (self._timer) {
        dispatch_source_cancel(self._timer);
    }
    if ([NSString getNowTimeTimestamp]/1000 - creartTime >=exceitTime) {
        self.detailOneValueLabel.text = GCLocalizedString(@"Expired");
    }else
    {
        __block long timeout= exceitTime - ([NSString getNowTimeTimestamp]/1000 - creartTime); //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self._timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(self._timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(self._timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(self._timer);
                dispatch_async(dispatch_get_main_queue(), ^{
      //设置界面的按钮显示 根据自己需求设置
                    self.detailOneValueLabel.text = GCLocalizedString(@"Expired");
                });
            }else{
                long hour = timeout / 3600;
                long minutes = timeout % 3600/60;
                long seconds = timeout % 3600 % 60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    self.detailOneValueLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minutes,seconds];
                });
                timeout--;
                  
            }
        });
        dispatch_resume(self._timer);
    }
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.invoiceTf.text)&&!IsEmpty(self.moneyTf.text)&&[self.moneyTf.text intValue]!=0) {
        [self.PayButton setBackgroundImage:[UIImage gradientImageWithBounds:self.PayButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.PayButton.enabled = YES;
    }else
    {
        [self.PayButton setBackgroundImage:[UIImage gradientImageWithBounds:self.PayButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.PayButton.enabled = NO;
    }
}
-(void)qrButtonAction:(UIButton *)btn
{
        UIViewController *vc = [SHOCToSwiftUI makeScanViewWithScanBlock:^(NSString * _Nonnull qrString) {
            self.invoiceTf.text = qrString;
            [self textFieldEndEditAction];
            [self layoutStartButtonColor];
        }];
        [self.navigationController pushViewController:vc animated:YES];
}
-(void)PayButtonAction:(UIButton *)btn
{
    if ([self.detailOneValueLabel.text isEqualToString:GCLocalizedString(@"Expired")]) {
        return;
    }
    if ([SHKeyStorage shared].currentLNWalletModel.isOpenFaceId)
    {
        [SHTouchOrFaceUtil selectTouchIdOrFaceIdWithSucessedBlock:^(BOOL isSuccess) {
            [self payAction];
        } WithSelectPassWordBlock:^{
            
        } WithErrorBlock:^(NSError * _Nonnull error) {
            if (error.code == LAErrorAuthenticationFailed) {
                [MBProgressHUD showError:GCLocalizedString(@"biometric_not_recognized") toView:self.view];
            } else if (error.code == LAErrorBiometryLockout) {
                [MBProgressHUD showError:GCLocalizedString(@"input_error_pwd_locked") toView:self.view];
            }
        } withBtn:nil];
        return;
    }else if (!IsEmpty([SHKeyStorage shared].currentLNWalletModel.walletPassWord)) {
       SHVerifyPasswordController *verifyPwdVc = [[SHVerifyPasswordController alloc]init];
       verifyPwdVc.controllerType = SHVerifyPasswordControllerTypeOther;
       verifyPwdVc.verifyPasswordBlock = ^{
           [self payAction];
       };
       [self.navigationController pushViewController:verifyPwdVc animated:YES];
       return;
    }else
    {
        [self payAction];
        return;
    }

}
-(void)payAction
{
    if ([self.invoiceTf.text containsString:@"@"]) {
        [self sendPayWithEmalSub];
    }else
    {
        [self payInvoiceWithInvoice:self.invoiceTf.text withLoading:YES];
    }
}
#pragma mark 懒加载
-(UILabel *)invoiceTipsLabel
{
    if (_invoiceTipsLabel == nil) {
        _invoiceTipsLabel = [[UILabel alloc]init];
        _invoiceTipsLabel.font = kCustomMontserratMediumFont(14);
        _invoiceTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _invoiceTipsLabel.text = GCLocalizedString(@"Invoice/Lightning Address");
        [self.view addSubview:_invoiceTipsLabel];
    }
    return _invoiceTipsLabel;
}
-(UITextField *)invoiceTf
{
    if (_invoiceTf == nil) {
        _invoiceTf = [[UITextField alloc]init];
        _invoiceTf.tintColor = SHTheme.agreeButtonColor;
        _invoiceTf.delegate = self;
        _invoiceTf.placeholder = GCLocalizedString(@"input_paste_address");
        _invoiceTf.clearButtonMode = UITextFieldViewModeAlways;
        [_invoiceTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_invoiceTf];
    }
    return _invoiceTf;
}
- (UIView *)invoiceLineView
{
    if (_invoiceLineView == nil) {
        _invoiceLineView = [[UIView alloc]init];
        _invoiceLineView.backgroundColor = SHTheme.appBlackColor;
        _invoiceLineView.alpha = 0.12;
        [self.view addSubview:_invoiceLineView];
    }
    return _invoiceLineView;
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
- (UIView *)moneyBgView
{
    if (_moneyBgView == nil) {
        _moneyBgView = [[UIView alloc]init];
        _moneyBgView.backgroundColor = SHTheme.labelBackgroundColor;
        _moneyBgView.layer.cornerRadius = 8;
        _moneyBgView.layer.masksToBounds = YES;
        [self.view addSubview:_moneyBgView];
    }
    return _moneyBgView;
}
-(TGTextField *)moneyTf
{
    if (_moneyTf == nil) {
        _moneyTf = [[TGTextField alloc]init];
        _moneyTf.limitType = TextFieldLimitNumberType;
        _moneyTf.textAlignment = NSTextAlignmentCenter;
        _moneyTf.textColor = SHTheme.agreeButtonColor;
        _moneyTf.font = kCustomDDINExpBoldFont(48);
        [_moneyTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _moneyTf.text = @"0";
        [self.moneyBgView addSubview:_moneyTf];
    }
    return _moneyTf;
}
-(UILabel *)coinTipsLabel
{
    if (_coinTipsLabel == nil) {
        _coinTipsLabel = [[UILabel alloc]init];
        _coinTipsLabel.font = kCustomMontserratMediumFont(14);
        _coinTipsLabel.textColor = SHTheme.agreeButtonColor;
        _coinTipsLabel.text = GCLocalizedString(@"sats");
        [self.moneyBgView addSubview:_coinTipsLabel];
    }
    return _coinTipsLabel;
}
-(UILabel *)equivalentLabel
{
    if (_equivalentLabel == nil) {
        _equivalentLabel = [[UILabel alloc]init];
        _equivalentLabel.font = kCustomSFUIFontBold(14);
        _equivalentLabel.textColor = SHTheme.agreeTipsLabelColor;
        _equivalentLabel.text = [NSString stringWithFormat:@"≈%@ 0",KAppSetting.currencySymbol];
        [self.view addSubview:_equivalentLabel];
    }
    return _equivalentLabel;
}
-(UIImageView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIImageView alloc]init];
        _lineView.image = [UIImage imageNamed:@"receiveQR_line"];
        [self.view addSubview:_lineView];
    }
    return _lineView;
}
-(UILabel *)detailOneTipsLabel
{
    if (_detailOneTipsLabel == nil) {
        _detailOneTipsLabel = [[UILabel alloc]init];
        _detailOneTipsLabel.font = kRegularFont(14);
        _detailOneTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _detailOneTipsLabel.hidden = YES;
        [self.view addSubview:_detailOneTipsLabel];
    }
    return _detailOneTipsLabel;
}
-(UILabel *)detailOneValueLabel
{
    if (_detailOneValueLabel == nil) {
        _detailOneValueLabel = [[UILabel alloc]init];
        _detailOneValueLabel.font = kCustomDDINExpBoldFont(14);
        _detailOneValueLabel.textColor = SHTheme.agreeTipsLabelColor;
        _detailOneValueLabel.hidden = YES;
        [self.view addSubview:_detailOneValueLabel];
    }
    return _detailOneValueLabel;
}

-(UILabel *)detailTwoTipsLabel
{
    if (_detailTwoTipsLabel == nil) {
        _detailTwoTipsLabel = [[UILabel alloc]init];
        _detailTwoTipsLabel.font = kRegularFont(14);
        _detailTwoTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _detailTwoTipsLabel.hidden = YES;
        [self.view addSubview:_detailTwoTipsLabel];
    }
    return _detailTwoTipsLabel;
}
-(UILabel *)detailTwoValueLabel
{
    if (_detailTwoValueLabel == nil) {
        _detailTwoValueLabel = [[UILabel alloc]init];
        _detailTwoValueLabel.font = kCustomDDINExpBoldFont(14);
        _detailTwoValueLabel.textColor = SHTheme.agreeButtonColor;
        [self.view addSubview:_detailTwoValueLabel];
    }
    return _detailTwoValueLabel;
}
-(UIButton *)PayButton
{
    if (_PayButton == nil) {
        _PayButton = [[UIButton alloc]init];
        _PayButton.layer.cornerRadius = 26*FitHeight;
        _PayButton.layer.masksToBounds = YES;
        _PayButton.enabled = NO;
        [_PayButton setTitle:GCLocalizedString(@"Pay") forState:UIControlStateNormal];
        [_PayButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _PayButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_PayButton addTarget:self action:@selector(PayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_PayButton];
    }
    return _PayButton;
}
-(void)dealloc
{
    if (self._timer) {
        dispatch_source_cancel(self._timer);
    }
}
@end
