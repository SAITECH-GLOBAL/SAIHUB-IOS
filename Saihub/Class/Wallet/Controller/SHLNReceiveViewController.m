//
//  SHLNReceiveViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/22.
//

#import "SHLNReceiveViewController.h"
#import "SHLNQRReceiveViewController.h"
@interface SHLNReceiveViewController ()
@property (nonatomic, strong) UILabel *amountTipsLabel;
@property (nonatomic, strong) TGTextField *amountTf;
@property (nonatomic, strong) UIView *amountLineView;
@property (nonatomic, strong) UIButton *changeTypeButton;
@property (nonatomic, strong) UILabel *equivalentLabel;
@property (nonatomic, strong) UILabel *equivalentRateLabel;

@property (nonatomic, strong) UILabel *memoTipsLabel;
@property (nonatomic, strong) UITextField *memoTf;
@property (nonatomic, strong) UIView *memoLineView;


@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, assign) BOOL isSats;
@end

@implementation SHLNReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSats = YES;
    // Do any additional setup after loading the view.
    self.titleLabel.text = GCLocalizedString(@"Receive");
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.amountTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(22*FitHeight);
    [self.amountTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.amountTf.sd_layout.leftEqualToView(self.amountTipsLabel).topSpaceToView(self.amountTipsLabel, 0).rightSpaceToView(self.view, 70*FitWidth).heightIs(46*FitHeight);
    self.amountLineView.sd_layout.leftEqualToView(self.amountTf).rightSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.amountTf, 0).heightIs(1);
    self.changeTypeButton.sd_layout.rightEqualToView(self.amountLineView).centerYEqualToView(self.amountTf).widthIs(49*FitWidth).heightIs(22*FitHeight);
    
    self.equivalentLabel.sd_layout.leftEqualToView(self.amountLineView).topSpaceToView(self.amountLineView, 11*FitHeight).heightIs(12*FitHeight);
    [self.equivalentLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    
    self.equivalentRateLabel.sd_layout.rightEqualToView(self.amountLineView).topSpaceToView(self.amountLineView, 11*FitHeight).heightIs(12*FitHeight);
    [self.equivalentRateLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    
    
    self.memoTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.amountLineView, 38*FitHeight).heightIs(22*FitHeight);
    [self.memoTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.memoTf.sd_layout.leftEqualToView(self.memoTipsLabel).topSpaceToView(self.memoTipsLabel, 0).rightSpaceToView(self.view, 20*FitWidth).heightIs(46*FitHeight);
    self.memoLineView.sd_layout.leftEqualToView(self.amountLineView).rightEqualToView(self.amountLineView).topSpaceToView(self.memoTf, 0).heightIs(1);
    
    self.confirmButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.memoLineView, 42*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    
}
#pragma mark //创建invoice
-(void)creatInvoice
{
    NSDecimalNumber *amountTfNumber = [NSDecimalNumber decimalNumberWithString:self.amountTf.text];
    NSDecimalNumber *powUPNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, 8)]];
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpwithHeader:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",[SHKeyStorage shared].currentLNWalletModel.access_token]} WithPath:[NSString stringWithFormat:@"%@/addinvoice",[SHKeyStorage shared].currentLNWalletModel.hostUrl] withMethodType:Post withParams:@{@"amt":self.isSats?self.amountTf.text:[amountTfNumber decimalNumberByMultiplyingBy:powUPNumber],@"memo":IsEmpty(self.memoTf.text)?@"":self.memoTf.text} result:^(id  _Nullable resultData, NSInteger resultCode, NSString *resultMessage) {
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
            SHLNQRReceiveViewController *LNQRReceiveViewController = [SHLNQRReceiveViewController new];
            LNQRReceiveViewController.address = resultData[@"payment_request"];
            LNQRReceiveViewController.amountString = [NSString stringWithFormat:@"%@ %@",self.isSats?self.amountTf.text:[amountTfNumber decimalNumberByMultiplyingBy:powUPNumber],GCLocalizedString(@"sats")];
            LNQRReceiveViewController.memo = self.memoTf.text;
            LNQRReceiveViewController.timeCreat = [NSString getNowTimeTimestamp]/1000;
            [self.navigationController pushViewController:LNQRReceiveViewController animated:YES];

        }else
        {
            [MBProgressHUD showError:resultMessage toView:nil];
        }
    }];
}
#pragma mark 按钮事件
-(void)confirmButtonAction:(UIButton *)btn
{
    [self creatInvoice];
}
-(void)changeTypeButtonAction:(UIButton *)btn
{
    [self.amountTf resignFirstResponder];
    [self.amountTf setText:@""];
    [self layoutStartButtonColor];
    self.isSats = !self.isSats;
}
-(void)setIsSats:(BOOL)isSats
{
    _isSats = isSats;
    NSString *rate = [SHKeyStorage shared].btcRate;
    NSDecimalNumber *amountTfNumber = [NSDecimalNumber decimalNumberWithString:self.amountTf.text];
    NSDecimalNumber *zeroNumber = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *powNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.8lf",pow(10, -8)]];
    NSDecimalNumber *powUPNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, 8)]];
    if (isSats) {
        [self.changeTypeButton setTitle:GCLocalizedString(@"sats") forState:UIControlStateNormal];
        if (!IsEmpty(self.amountTf.text)) {
            NSLog(@"%@",[amountTfNumber decimalNumberByMultiplyingBy:powNumber].stringValue);
        }
        self.equivalentLabel.text = [NSString stringWithFormat:@"%@ BTC",IsEmpty(self.amountTf.text)?[zeroNumber decimalNumberByMultiplyingBy:powNumber].stringValue:[amountTfNumber decimalNumberByMultiplyingBy:powNumber].stringValue];
        self.equivalentRateLabel.text  =  [NSString stringWithFormat:@"≈%@%@",KAppSetting.currencySymbol,[NSString digitStringWithValue:[IsEmpty(self.amountTf.text)?[zeroNumber decimalNumberByMultiplyingBy:powNumber].stringValue:[amountTfNumber decimalNumberByMultiplyingBy:powNumber].stringValue to_multiplyingWithStr:rate] count:6]];
        self.amountTf.limitType = TextFieldLimitNumberType;
    }else
    {
        [self.changeTypeButton setTitle:GCLocalizedString(@"BTC") forState:UIControlStateNormal];
        self.equivalentLabel.text = [NSString stringWithFormat:@"%@ sats",IsEmpty(self.amountTf.text)?[zeroNumber decimalNumberByMultiplyingBy:powUPNumber].stringValue:[amountTfNumber decimalNumberByMultiplyingBy:powUPNumber].stringValue];
        self.equivalentRateLabel.text  =  [NSString stringWithFormat:@"≈%@%@",KAppSetting.currencySymbol,[NSString digitStringWithValue:[self.amountTf.text to_multiplyingWithStr:rate] count:6]];
        self.amountTf.limitType = TextFieldLimitDecimalType;
        self.amountTf.decimalCount = 8;
    }
}
#pragma mark 懒加载

#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
//    if ([textField isEqual:self.amountTf] && textField.text.length >=30) {
//        textField.text = [textField.text substringToIndex:30];
//    }
    self.isSats = self.isSats;
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.amountTf.text)) {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = YES;
    }else
    {
        [self.confirmButton setBackgroundImage:[UIImage gradientImageWithBounds:self.confirmButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.confirmButton.enabled = NO;
    }
}
#pragma mark 懒加载
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
        _amountTf.limitType = TextFieldLimitNumberType;
        _amountTf.placeholder = GCLocalizedString(@"0");
        _amountTf.clearButtonMode = UITextFieldViewModeAlways;
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
-(UILabel *)memoTipsLabel
{
    if (_memoTipsLabel == nil) {
        _memoTipsLabel = [[UILabel alloc]init];
        _memoTipsLabel.font = kCustomMontserratMediumFont(14);
        _memoTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _memoTipsLabel.text = GCLocalizedString(@"Memo");
        [self.view addSubview:_memoTipsLabel];
    }
    return _memoTipsLabel;
}
-(UITextField *)memoTf
{
    if (_memoTf == nil) {
        _memoTf = [[UITextField alloc]init];
        _memoTf.tintColor = SHTheme.agreeButtonColor;
        _memoTf.placeholder = GCLocalizedString(@"Enter_memo");
        _memoTf.clearButtonMode = UITextFieldViewModeAlways;
        [_memoTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_memoTf];
    }
    return _memoTf;
}
- (UIView *)memoLineView
{
    if (_memoLineView == nil) {
        _memoLineView = [[UIView alloc]init];
        _memoLineView.backgroundColor = SHTheme.appBlackColor;
        _memoLineView.alpha = 0.12;
        [self.view addSubview:_memoLineView];
    }
    return _memoLineView;
}
-(UILabel *)equivalentLabel
{
    if (_equivalentLabel == nil) {
        _equivalentLabel = [[UILabel alloc]init];
        _equivalentLabel.font = kCustomMontserratMediumFont(12);
        _equivalentLabel.textColor = SHTheme.agreeTipsLabelColor;
        _equivalentLabel.text = @"0 BTC";
        [self.view addSubview:_equivalentLabel];
    }
    return _equivalentLabel;
}
-(UILabel *)equivalentRateLabel
{
    if (_equivalentRateLabel == nil) {
        _equivalentRateLabel = [[UILabel alloc]init];
        _equivalentRateLabel.font = kCustomMontserratMediumFont(12);
        _equivalentRateLabel.textColor = SHTheme.agreeTipsLabelColor;
        _equivalentRateLabel.text = [NSString stringWithFormat:@"≈%@ 0",KAppSetting.currencySymbol];
        [self.view addSubview:_equivalentRateLabel];
    }
    return _equivalentRateLabel;
}
-(UIButton *)confirmButton
{
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc]init];
        _confirmButton.layer.cornerRadius = 26*FitHeight;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.enabled = NO;
        [_confirmButton setTitle:GCLocalizedString(@"Create_Invoice") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = kMediunFont(14);
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}
-(UIButton *)changeTypeButton
{
    if (_changeTypeButton == nil) {
        _changeTypeButton = [[UIButton alloc]init];
        _changeTypeButton.backgroundColor = SHTheme.labelBackgroundColor;
        _changeTypeButton.layer.cornerRadius = 2;
        _changeTypeButton.layer.masksToBounds = YES;
        _changeTypeButton.layer.borderColor = SHTheme.agreeButtonColor.CGColor;
        _changeTypeButton.layer.borderWidth = 1;
        [_changeTypeButton setTitle:GCLocalizedString(@"sats") forState:UIControlStateNormal];
        [_changeTypeButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _changeTypeButton.titleLabel.font = kCustomMontserratMediumFont(12);
        [_changeTypeButton addTarget:self action:@selector(changeTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_changeTypeButton];
    }
    return _changeTypeButton;
}
@end
