//
//  SHChangeLanguagesViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHChangeLanguagesViewController.h"
#import "SHSettingController.h"
#import "SHNavigationController.h"
#import <IQKeyboardManager.h>
#import "MJRefreshConfig.h"

@interface SHChangeLanguagesViewController ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) NSMutableArray *languagesLabelArray;
@property (nonatomic, strong) NSMutableArray *languagesButtonArray;
@property (nonatomic, assign) SHApplicationLanguage selectLangUage;

@end

@implementation SHChangeLanguagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"Languages");
    // Do any additional setup after loading the view.
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.backView.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.navBar, 20*FitHeight).widthIs(335*FitWidth).heightIs(208*FitHeight);
    NSArray *languagesArray = @[@"English",@"简体中文",@"繁体中文",@"Русский"];
    for (NSInteger i=0; i<languagesArray.count; i++) {
        UILabel *languageTipsLabel = [[UILabel alloc]init];
        [self.backView addSubview:languageTipsLabel];
        languageTipsLabel.sd_layout.leftSpaceToView(self.backView, 16*FitWidth).topSpaceToView(self.backView, 15*FitHeight + i*52*FitHeight).heightIs(22*FitHeight);
        [languageTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
        languageTipsLabel.font = kCustomMontserratMediumFont(14);
        languageTipsLabel.textColor = SHTheme.appBlackColor;
        languageTipsLabel.text = languagesArray[i];
        languageTipsLabel.tag = i;
        [self.languagesLabelArray addObject:languageTipsLabel];
        UIButton *selectButton = [[UIButton alloc]init];
        [self.backView addSubview:selectButton];
        selectButton.sd_layout.rightSpaceToView(self.backView, 16*FitWidth).centerYEqualToView(languageTipsLabel).widthIs(300*FitWidth).heightIs(50*FitHeight);
        selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [selectButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        selectButton.tag = i;
        [selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.languagesButtonArray addObject:selectButton];
        UIView *lineView = [[UIView alloc]init];
        [self.backView addSubview:lineView];
        lineView.sd_layout.leftSpaceToView(self.backView, 16*FitWidth).rightSpaceToView(self.backView, 16*FitWidth).topSpaceToView(languageTipsLabel, 14*FitHeight).heightIs(1);
        lineView.backgroundColor = SHTheme.appBlackColor;
        lineView.alpha = 0.12;
        if (i == languagesArray.count - 1) {
            lineView.hidden = YES;
        }
        if (i == KAppSetting.language) {
            languageTipsLabel.textColor = SHTheme.agreeButtonColor;
            [selectButton setImage:[UIImage imageNamed:@"changeLanguageVc_selectButton"] forState:UIControlStateNormal];
            self.selectLangUage = KAppSetting.language;
        }
    }
    self.saveButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.backView, 80*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.saveButton setBackgroundImage:[UIImage gradientImageWithBounds:self.saveButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
}
#pragma mark 按钮事件
-(void)selectButtonAction:(UIButton *)btn
{
    UIButton *selectButton = self.languagesButtonArray[btn.tag];
    UILabel *languageLabel = self.languagesLabelArray[btn.tag];
    for (UIButton *subButton in self.languagesButtonArray) {
        [subButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    for (UILabel *subLabel in self.languagesLabelArray) {
        subLabel.textColor = SHTheme.appBlackColor;
    }
    [selectButton setImage:[UIImage imageNamed:@"changeLanguageVc_selectButton"] forState:UIControlStateNormal];
    languageLabel.textColor = SHTheme.agreeButtonColor;
    self.selectLangUage = btn.tag;
    
}
-(void)saveButtonAction:(UIButton *)btn
{
    KAppSetting.language = self.selectLangUage;
    MJRefreshConfig.defaultConfig.languageCode = KAppSetting.lang;
    NSLog(@"%@",MJRefreshConfig.defaultConfig.languageCode);
    SHTabBarController *tabbarVc = [[SHTabBarController alloc]init];
    [tabbarVc setIndex:3];
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = tabbarVc;
    
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = GCLocalizedString(@"iqkeyboard_done");

}
#pragma mark 懒加载
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 8;
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = SHTheme.addressTypeCellBackColor;
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
-(NSMutableArray *)languagesLabelArray
{
    if (_languagesLabelArray == nil) {
        _languagesLabelArray = [NSMutableArray new];
    }
    return _languagesLabelArray;
}
-(NSMutableArray *)languagesButtonArray
{
    if (_languagesButtonArray == nil) {
        _languagesButtonArray = [NSMutableArray new];
    }
    return _languagesButtonArray;
}
@end
