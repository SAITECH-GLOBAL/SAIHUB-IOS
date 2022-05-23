//
//  SHCreatNewPowerViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import "SHCreatNewPowerViewController.h"
#import "SHPowerSaveStorage.h"
@interface SHCreatNewPowerViewController ()
@property (nonatomic, strong) UILabel *remarkNameTipsLabel;
@property (nonatomic, strong) UITextField *remarkNameTf;
@property (nonatomic, strong) UIView *remarkNameLineView;

@property (nonatomic, strong) UILabel *numberTipsLabel;
@property (nonatomic, strong) UITextField *numberTf;
@property (nonatomic, strong) UIView *numberLineView;
@property (nonatomic, strong) UIButton *qrButton;

@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation SHCreatNewPowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = GCLocalizedString(@"add_device");
    [self layoutScale];
    if (!IsEmpty(self.powerModel)) {
        self.titleLabel.text = GCLocalizedString(@"edict_device");
        self.remarkNameTf.text = self.powerModel.powerName;
        self.numberTf.text = self.powerModel.powerValue;
        [self layoutStartButtonColor];
    }
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.remarkNameTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(22*FitHeight);
    [self.remarkNameTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.remarkNameTf.sd_layout.leftEqualToView(self.remarkNameTipsLabel).topSpaceToView(self.remarkNameTipsLabel, 0).rightSpaceToView(self.view, 20*FitWidth).heightIs(46*FitHeight);
    self.remarkNameLineView.sd_layout.leftEqualToView(self.remarkNameTf).rightEqualToView(self.remarkNameTf).topSpaceToView(self.remarkNameTf, 0).heightIs(1);
   
    self.numberTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.remarkNameLineView, 24*FitHeight).heightIs(22*FitHeight);
    [self.numberTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.numberTf.sd_layout.leftEqualToView(self.numberTipsLabel).topSpaceToView(self.numberTipsLabel, 0).rightSpaceToView(self.view, 52*FitWidth).heightIs(46*FitHeight);
    self.numberLineView.sd_layout.leftEqualToView(self.remarkNameLineView).rightEqualToView(self.remarkNameLineView).topSpaceToView(self.numberTf, 0).heightIs(1);
    self.qrButton.sd_layout.rightEqualToView(self.remarkNameLineView).centerYEqualToView(self.numberTf).widthIs(20*FitWidth).heightEqualToWidth();
    
    self.saveButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.numberLineView, 162*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.saveButton setBackgroundImage:[UIImage gradientImageWithBounds:self.saveButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 按钮事件
-(void)saveButtonAction:(UIButton *)btn
{
    if (!IsEmpty(self.powerModel)) {
        [[SHKeyStorage shared] updateModelBlock:^{
            self.powerModel.powerName = self.remarkNameTf.text;;
            self.powerModel.powerValue = self.numberTf.text;
        }];
        [self popViewController];
        return;
    }
    SHPowerListModel *powerModel = [[SHPowerListModel alloc]init];
    powerModel.powerName = self.remarkNameTf.text;
    powerModel.powerValue = self.numberTf.text;
    if ([[SHPowerSaveStorage shared] addModel:powerModel]) {
        [self popViewController];
    }else
    {
        [MBProgressHUD showError:GCLocalizedString(@"device_exists") toView:self.view];
    }
}
-(void)qrButtonAction:(UIButton *)btn
{
    UIViewController *vc = [SHOCToSwiftUI makeScanViewWithScanBlock:^(NSString * _Nonnull qrString) {
        self.numberTf.text = qrString;
        [self layoutStartButtonColor];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 第三方方法
- (void)textFieldChanged:(UITextField *)textField {
    if ([textField isEqual:self.remarkNameTf] && textField.text.length >=30) {
        textField.text = [textField.text substringToIndex:30];
    }
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.remarkNameTf.text)&&!IsEmpty(self.numberTf.text)) {
        [self.saveButton setBackgroundImage:[UIImage gradientImageWithBounds:self.saveButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.saveButton.enabled = YES;
    }else
    {
        [self.saveButton setBackgroundImage:[UIImage gradientImageWithBounds:self.saveButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.saveButton.enabled = NO;
    }
}
#pragma mark 懒加载
-(UILabel *)remarkNameTipsLabel
{
    if (_remarkNameTipsLabel == nil) {
        _remarkNameTipsLabel = [[UILabel alloc]init];
        _remarkNameTipsLabel.font = kCustomMontserratMediumFont(14);
        _remarkNameTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _remarkNameTipsLabel.text = GCLocalizedString(@"Name");
        [self.view addSubview:_remarkNameTipsLabel];
    }
    return _remarkNameTipsLabel;
}
-(UITextField *)remarkNameTf
{
    if (_remarkNameTf == nil) {
        _remarkNameTf = [[UITextField alloc]init];
        _remarkNameTf.tintColor = SHTheme.agreeButtonColor;
        _remarkNameTf.placeholder = GCLocalizedString(@"enter_the_remark_name");
        _remarkNameTf.clearButtonMode = UITextFieldViewModeAlways;
        [_remarkNameTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_remarkNameTf];
    }
    return _remarkNameTf;
}
- (UIView *)remarkNameLineView
{
    if (_remarkNameLineView == nil) {
        _remarkNameLineView = [[UIView alloc]init];
        _remarkNameLineView.backgroundColor = SHTheme.appBlackColor;
        _remarkNameLineView.alpha = 0.12;
        [self.view addSubview:_remarkNameLineView];
    }
    return _remarkNameLineView;
}
-(UILabel *)numberTipsLabel
{
    if (_numberTipsLabel == nil) {
        _numberTipsLabel = [[UILabel alloc]init];
        _numberTipsLabel.font = kCustomMontserratMediumFont(14);
        _numberTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _numberTipsLabel.text = GCLocalizedString(@"Number");
        [self.view addSubview:_numberTipsLabel];
    }
    return _numberTipsLabel;
}
-(UITextField *)numberTf
{
    if (_numberTf == nil) {
        _numberTf = [[UITextField alloc]init];
        _numberTf.tintColor = SHTheme.agreeButtonColor;
        _numberTf.placeholder = GCLocalizedString(@"input_paste_number");
        _numberTf.clearButtonMode = UITextFieldViewModeAlways;
        [_numberTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_numberTf];
    }
    return _numberTf;
}
- (UIView *)numberLineView
{
    if (_numberLineView == nil) {
        _numberLineView = [[UIView alloc]init];
        _numberLineView.backgroundColor = SHTheme.appBlackColor;
        _numberLineView.alpha = 0.12;
        [self.view addSubview:_numberLineView];
    }
    return _numberLineView;
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
-(UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [[UIButton alloc]init];
        _saveButton.layer.cornerRadius = 26*FitHeight;
        _saveButton.layer.masksToBounds = YES;
        [_saveButton setTitle:GCLocalizedString(@"Save") forState:UIControlStateNormal];
        [_saveButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saveButton];
    }
    return _saveButton;
}

@end
