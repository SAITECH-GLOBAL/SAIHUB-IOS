//
//  SHCreatNewPoolViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import "SHCreatNewPoolViewController.h"
#import "SHPoolDetailViewController.h"
@interface SHCreatNewPoolViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *remarkNameTipsLabel;
@property (nonatomic, strong) UITextField *remarkNameTf;
@property (nonatomic, strong) UIView *remarkNameLineView;
@property (nonatomic, strong) UILabel *urlTipsLabel;
@property (nonatomic, strong) UIView *urlTextViewBackView;
@property (nonatomic, strong) UITextView *urlTextView;
@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation SHCreatNewPoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = GCLocalizedString(@"add_observer_link");
    [self layoutScale];
    if (!IsEmpty(self.poolModel)) {
        self.titleLabel.text = GCLocalizedString(@"edict_observer_link");
        self.remarkNameTf.text = self.poolModel.poolName;
        self.urlTextView.text = self.poolModel.poolUrl;
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
    self.urlTipsLabel.sd_layout.leftEqualToView(self.remarkNameTipsLabel).topSpaceToView(self.remarkNameLineView, 24*FitHeight).heightIs(22*FitHeight);
    [self.urlTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.urlTextViewBackView.sd_layout.leftEqualToView(self.urlTipsLabel).rightEqualToView(self.remarkNameLineView).topSpaceToView(self.urlTipsLabel, 16*FitHeight).heightIs(112*FitHeight);
    self.urlTextView.sd_layout.leftSpaceToView(self.urlTextViewBackView, 12*FitWidth).topSpaceToView(self.urlTextViewBackView, 12*FitHeight).rightSpaceToView(self.urlTextViewBackView, 12*FitHeight).bottomSpaceToView(self.urlTextViewBackView, 12*FitHeight);
    self.saveButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.urlTextViewBackView, 80*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.saveButton setBackgroundImage:[UIImage gradientImageWithBounds:self.saveButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 按钮事件
-(void)saveButtonAction:(UIButton *)btn
{
    if (!IsEmpty(self.poolModel)) {
        [[SHKeyStorage shared] updateModelBlock:^{
            self.poolModel.poolName = self.remarkNameTf.text;;
            self.poolModel.poolUrl = self.urlTextView.text;
        }];
        [self popViewController];
        return;
    }
    SHPoolListModel *poolModel = [[SHPoolListModel alloc]init];
    poolModel.poolName = self.remarkNameTf.text;
    poolModel.poolUrl = self.urlTextView.text;

    if ([[SHPoolSaveStorage shared] addModel:poolModel]) {
        [self popViewController];
    }else
    {
        [MBProgressHUD showSuccess:GCLocalizedString(@"Fail") toView:self.view];
    }
}
#pragma mark 第三方方法
- (void)textViewDidChange:(UITextView *)textView
{
//    if (textView.text.length >=30) {
//        textView.text = [textView.text substringToIndex:30];
//    }
    [self layoutStartButtonColor];
}
- (void)textFieldChanged:(UITextField *)textField {
    if ([textField isEqual:self.remarkNameTf] && textField.text.length >=30) {
        textField.text = [textField.text substringToIndex:30];
    }
    [self layoutStartButtonColor];
}
-(void)layoutStartButtonColor
{
    if (!IsEmpty(self.remarkNameTf.text)&&!IsEmpty(self.urlTextView.text)) {
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
        _remarkNameTipsLabel.text = GCLocalizedString(@"remark_name");
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
-(UILabel *)urlTipsLabel
{
    if (_urlTipsLabel == nil) {
        _urlTipsLabel = [[UILabel alloc]init];
        _urlTipsLabel.font = kCustomMontserratMediumFont(14);
        _urlTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _urlTipsLabel.text = GCLocalizedString(@"URL");
        [self.view addSubview:_urlTipsLabel];
    }
    return _urlTipsLabel;
}
- (UIView *)urlTextViewBackView
{
    if (_urlTextViewBackView == nil) {
        _urlTextViewBackView = [[UIView alloc]init];
        _urlTextViewBackView.layer.cornerRadius = 8;
        _urlTextViewBackView.layer.borderWidth = 1;
        _urlTextViewBackView.layer.borderColor = SHTheme.buttonForMnemonicSelectBackColor.CGColor;
        _urlTextViewBackView.layer.masksToBounds = YES;
        _urlTextViewBackView.backgroundColor = SHTheme.addressTypeCellBackColor;
        [self.view addSubview:_urlTextViewBackView];
    }
    return _urlTextViewBackView;
}
-(UITextView *)urlTextView
{
    if (_urlTextView == nil) {
        _urlTextView = [[UITextView alloc]init];
        _urlTextView.placeholder = GCLocalizedString(@"poll_add_url_hint");
        _urlTextView.placeholderColor = SHTheme.pageUnselectColor;
        _urlTextView.delegate = self;
        _urlTextView.backgroundColor = [UIColor clearColor];
        _urlTextView.tintColor = SHTheme.agreeButtonColor;
        [self.urlTextViewBackView addSubview:_urlTextView];
    }
    return _urlTextView;
}
-(UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [[UIButton alloc]init];
        _saveButton.layer.cornerRadius = 26*FitHeight;
        _saveButton.layer.masksToBounds = YES;
        _saveButton.enabled = NO;
        [_saveButton setTitle:GCLocalizedString(@"Save") forState:UIControlStateNormal];
        [_saveButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saveButton];
    }
    return _saveButton;
}
@end
