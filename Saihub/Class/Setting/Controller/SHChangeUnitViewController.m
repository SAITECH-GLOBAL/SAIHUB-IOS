//
//  SHChangeUnitViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHChangeUnitViewController.h"

@interface SHChangeUnitViewController ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) NSMutableArray *unitLabelArray;
@property (nonatomic, strong) NSMutableArray *unitButtonArray;
@property (nonatomic, assign) SHApplicationCurrency selectUnit;

@end

@implementation SHChangeUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"currency_unit");
    // Do any additional setup after loading the view.
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.backView.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.navBar, 20*FitHeight).widthIs(335*FitWidth).heightIs(156*FitHeight);
    NSArray *changeUnitArray = @[@"USD",@"CNY",@"RUB"];
    for (NSInteger i=0; i<changeUnitArray.count; i++) {
        UILabel *changeUnitTipsLabel = [[UILabel alloc]init];
        [self.backView addSubview:changeUnitTipsLabel];
        changeUnitTipsLabel.sd_layout.leftSpaceToView(self.backView, 16*FitWidth).topSpaceToView(self.backView, 15*FitHeight + i*52*FitHeight).heightIs(22*FitHeight);
        [changeUnitTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
        changeUnitTipsLabel.font = kCustomMontserratMediumFont(14);
        changeUnitTipsLabel.textColor = SHTheme.appBlackColor;
        changeUnitTipsLabel.text = changeUnitArray[i];
        changeUnitTipsLabel.tag = i;
        [self.unitLabelArray addObject:changeUnitTipsLabel];
        UIButton *selectButton = [[UIButton alloc]init];
        [self.backView addSubview:selectButton];
        selectButton.sd_layout.rightSpaceToView(self.backView, 16*FitWidth).centerYEqualToView(changeUnitTipsLabel).widthIs(300*FitWidth).heightIs(50*FitHeight);
        selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [selectButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        selectButton.tag = i;
        [self.unitButtonArray addObject:selectButton];
        [selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [[UIView alloc]init];
        [self.backView addSubview:lineView];
        lineView.sd_layout.leftSpaceToView(self.backView, 16*FitWidth).rightSpaceToView(self.backView, 16*FitWidth).topSpaceToView(changeUnitTipsLabel, 14*FitHeight).heightIs(1);
        lineView.backgroundColor = SHTheme.appBlackColor;
        lineView.alpha = 0.12;
        if (i == changeUnitArray.count - 1) {
            lineView.hidden = YES;
        }
        if (i == KAppSetting.currency) {
            changeUnitTipsLabel.textColor = SHTheme.agreeButtonColor;
            [selectButton setImage:[UIImage imageNamed:@"changeLanguageVc_selectButton"] forState:UIControlStateNormal];
            self.selectUnit = KAppSetting.currency;
        }
    }
    self.saveButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.backView, 80*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.saveButton setBackgroundImage:[UIImage gradientImageWithBounds:self.saveButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 按钮事件
-(void)selectButtonAction:(UIButton *)btn
{
    UIButton *selectButton = self.unitButtonArray[btn.tag];
    UILabel *languageLabel = self.unitLabelArray[btn.tag];
    for (UIButton *subButton in self.unitButtonArray) {
        [subButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    for (UILabel *subLabel in self.unitLabelArray) {
        subLabel.textColor = SHTheme.appBlackColor;
    }
    [selectButton setImage:[UIImage imageNamed:@"changeLanguageVc_selectButton"] forState:UIControlStateNormal];
    languageLabel.textColor = SHTheme.agreeButtonColor;
    self.selectUnit = btn.tag;
}
-(void)saveButtonAction:(UIButton *)btn
{
    KAppSetting.currency = self.selectUnit;
    [self popViewController];
}
#pragma mark 懒加载
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 8;
        _backView.backgroundColor = SHTheme.addressTypeCellBackColor;
        _backView.userInteractionEnabled = YES;
        [self.view addSubview:_backView];
    }
    return _backView;
}
-(UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [[UIButton alloc]init];
        _saveButton.layer.cornerRadius = 26*FitHeight;
        _saveButton.layer.masksToBounds = YES;
        [_saveButton setTitle:GCLocalizedString(@"Save") forState:UIControlStateNormal];
        [_saveButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kMediunFont(14);
        [_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saveButton];
    }
    return _saveButton;
}
-(NSMutableArray *)unitLabelArray
{
    if (_unitLabelArray == nil) {
        _unitLabelArray = [NSMutableArray new];
    }
    return _unitLabelArray;
}
-(NSMutableArray *)unitButtonArray
{
    if (_unitButtonArray == nil) {
        _unitButtonArray = [NSMutableArray new];
    }
    return _unitButtonArray;
}
@end
