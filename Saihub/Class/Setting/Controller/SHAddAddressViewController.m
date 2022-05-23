//
//  SHAddAddressViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHAddAddressViewController.h"
#import "SHCompleteView.h"
@interface SHAddAddressViewController ()
@property (nonatomic, strong) UILabel *foundationTipsLabel;
@property (nonatomic, strong) UILabel *foundationValueLabel;
@property (nonatomic, strong) UILabel *addressNameTipsLabel;
@property (nonatomic, strong) UITextField *addressNameTf;
@property (nonatomic, strong) UIView *addressNameLineView;
@property (nonatomic, strong) UILabel *addressValueTipsLabel;
@property (nonatomic, strong) UITextField *addressValueTf;
@property (nonatomic, strong) UIView *addressValueLineView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *qrButton;

@end

@implementation SHAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutScale];
    if (!IsEmpty(self.addressModel)) {
        self.addressNameTf.text = self.addressModel.addressName;
        self.addressValueTf.text = self.addressModel.addressValue;
        [self layoutStartButtonColor];
        self.titleLabel.text = GCLocalizedString(@"edict_address_title");
    }else
    {
        self.titleLabel.text = GCLocalizedString(@"add_address_title");
    }
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.foundationTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 24*FitHeight).heightIs(22*FitHeight);
    [self.foundationTipsLabel setSingleLineAutoResizeWithMaxWidth:350*FitWidth];
    self.foundationValueLabel.sd_layout.rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(self.foundationTipsLabel).heightIs(22*FitHeight);
    [self.foundationValueLabel setSingleLineAutoResizeWithMaxWidth:350*FitWidth];
    self.addressNameTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.foundationTipsLabel, 24*FitHeight).heightIs(22*FitHeight);
    [self.addressNameTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.addressNameTf.sd_layout.leftEqualToView(self.addressNameTipsLabel).topSpaceToView(self.addressNameTipsLabel, 0).rightSpaceToView(self.view, 20*FitWidth).heightIs(46*FitHeight);
    self.addressNameLineView.sd_layout.leftEqualToView(self.addressNameTf).rightEqualToView(self.addressNameTf).topSpaceToView(self.addressNameTf, 0).heightIs(1);
    self.addressValueTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.addressNameLineView, 24*FitHeight).heightIs(22*FitHeight);
    [self.addressValueTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.addressValueTf.sd_layout.leftEqualToView(self.addressValueTipsLabel).topSpaceToView(self.addressValueTipsLabel, 0).rightSpaceToView(self.view, 20*FitWidth + 30*FitWidth).heightIs(46*FitHeight);
    self.addressValueLineView.sd_layout.leftEqualToView(self.addressValueTf).rightEqualToView(self.addressNameLineView).topSpaceToView(self.addressValueTf, 0).heightIs(1);
    self.qrButton.sd_layout.rightEqualToView(self.addressNameLineView).centerYEqualToView(self.addressValueTf).widthIs(20*FitWidth).heightEqualToWidth();
    self.saveButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.addressValueLineView, 80*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.saveButton setBackgroundImage:[UIImage gradientImageWithBounds:self.saveButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 按钮事件
-(void)saveButtonAction:(UIButton *)btn
{
    NSString *addressRegex = @"^(3|b)[a-zA-Z\\d]{24,62}$";
    NSPredicate *addressTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", addressRegex];
    if (![addressTest evaluateWithObject:self.addressValueTf.text]) {
        [MBProgressHUD showError:GCLocalizedString(@"addres_format_error") toView:self.view];
        return;
    }
    if (!IsEmpty(self.addressModel)) {
        [[SHKeyStorage shared] updateModelBlock:^{
            self.addressModel.addressName = self.addressNameTf.text;;
            self.addressModel.addressValue = self.addressValueTf.text;
        }];
        [self popViewController];
        return;
    }
    SHAddressBookModel *AddressModel = [SHAddressBookModel new];
    AddressModel.addressName = self.addressNameTf.text;
    AddressModel.addressValue = self.addressValueTf.text;
    if ([[SHAddressSaveStorage shared] addModel:AddressModel]) {
        [self popViewController];
    }else
    {
        SHCompleteView *completeView = [[SHCompleteView alloc]init];
        completeView.completeViewType = CompleteViewAddressExistsFailType;
        completeView.completeBlock = ^{

        };
        [completeView presentInView:self.view];
    }
}
-(void)qrButtonAction:(UIButton *)btn
{
    UIViewController *vc = [SHOCToSwiftUI makeScanViewWithScanBlock:^(NSString * _Nonnull qrString) {
        self.addressValueTf.text = qrString;
        [self layoutStartButtonColor];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
    if ([textField isEqual:self.addressNameTf] && textField.text.length >=30) {
        textField.text = [textField.text substringToIndex:30];
    }
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.addressNameTf.text)&&!IsEmpty(self.addressValueTf.text)) {
        [self.saveButton setBackgroundImage:[UIImage gradientImageWithBounds:self.saveButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.saveButton.enabled = YES;
    }else
    {
        [self.saveButton setBackgroundImage:[UIImage gradientImageWithBounds:self.saveButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.saveButton.enabled = NO;
    }
}
#pragma mark 懒加载
-(UILabel *)foundationTipsLabel
{
    if (_foundationTipsLabel == nil) {
        _foundationTipsLabel = [[UILabel alloc]init];
        _foundationTipsLabel.font = kCustomMontserratMediumFont(14);
        _foundationTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _foundationTipsLabel.text = GCLocalizedString(@"foundation");
        [self.view addSubview:_foundationTipsLabel];
    }
    return _foundationTipsLabel;
}
-(UILabel *)foundationValueLabel
{
    if (_foundationValueLabel == nil) {
        _foundationValueLabel = [[UILabel alloc]init];
        _foundationValueLabel.font = kCustomMontserratMediumFont(20);
        _foundationValueLabel.textColor = SHTheme.setPasswordTipsColor;
        _foundationValueLabel.text = GCLocalizedString(@"BTC");
        [self.view addSubview:_foundationValueLabel];
    }
    return _foundationValueLabel;
}
-(UILabel *)addressNameTipsLabel
{
    if (_addressNameTipsLabel == nil) {
        _addressNameTipsLabel = [[UILabel alloc]init];
        _addressNameTipsLabel.font = kCustomMontserratMediumFont(14);
        _addressNameTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _addressNameTipsLabel.text = GCLocalizedString(@"Name");
        [self.view addSubview:_addressNameTipsLabel];
    }
    return _addressNameTipsLabel;
}
-(UITextField *)addressNameTf
{
    if (_addressNameTf == nil) {
        _addressNameTf = [[UITextField alloc]init];
        _addressNameTf.tintColor = SHTheme.agreeButtonColor;
        _addressNameTf.placeholder = GCLocalizedString(@"please_enter_a_name");
        _addressNameTf.clearButtonMode = UITextFieldViewModeAlways;
        [_addressNameTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_addressNameTf];
    }
    return _addressNameTf;
}
- (UIView *)addressNameLineView
{
    if (_addressNameLineView == nil) {
        _addressNameLineView = [[UIView alloc]init];
        _addressNameLineView.backgroundColor = SHTheme.appBlackColor;
        _addressNameLineView.alpha = 0.12;
        [self.view addSubview:_addressNameLineView];
    }
    return _addressNameLineView;
}
-(UILabel *)addressValueTipsLabel
{
    if (_addressValueTipsLabel == nil) {
        _addressValueTipsLabel = [[UILabel alloc]init];
        _addressValueTipsLabel.font = kCustomMontserratMediumFont(14);
        _addressValueTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _addressValueTipsLabel.text = GCLocalizedString(@"address");
        [self.view addSubview:_addressValueTipsLabel];
    }
    return _addressValueTipsLabel;
}
-(UITextField *)addressValueTf
{
    if (_addressValueTf == nil) {
        _addressValueTf = [[UITextField alloc]init];
        _addressValueTf.tintColor = SHTheme.agreeButtonColor;
        _addressValueTf.placeholder = GCLocalizedString(@"scan_or_paste_wallet_address");
        _addressValueTf.clearButtonMode = UITextFieldViewModeAlways;
        [_addressValueTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_addressValueTf];
    }
    return _addressValueTf;
}
- (UIView *)addressValueLineView
{
    if (_addressValueLineView == nil) {
        _addressValueLineView = [[UIView alloc]init];
        _addressValueLineView.backgroundColor = SHTheme.appBlackColor;
        _addressValueLineView.alpha = 0.12;
        [self.view addSubview:_addressValueLineView];
    }
    return _addressValueLineView;
}

-(UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [[UIButton alloc]init];
        _saveButton.layer.cornerRadius = 26*FitHeight;
        _saveButton.layer.masksToBounds = YES;
        _saveButton.enabled = NO;
        [_saveButton setTitle:GCLocalizedString(@"Next") forState:UIControlStateNormal];
        [_saveButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saveButton];
    }
    return _saveButton;
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
@end
