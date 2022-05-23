//
//  SHShowMnemonicViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/23.
//

#import "SHShowMnemonicViewController.h"
#import "XMPageControl.h"
#import "SHVerifyMnemonicViewController.h"
@interface SHShowMnemonicViewController ()
@property (nonatomic, strong) UILabel *topTipsLabel;
@property (nonatomic, strong) UILabel *detailTipsLabel;
@property (nonatomic, strong) UIScrollView *mnemonicBackScrollView;
@property (nonatomic ,strong) XMPageControl *pageControl;
@property (nonatomic, strong) UIButton *continueButton;

@end

@implementation SHShowMnemonicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.topTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(36*FitHeight);
    [self.topTipsLabel setSingleLineAutoResizeWithMaxWidth:335*FitWidth];
    self.detailTipsLabel.sd_layout.leftEqualToView(self.topTipsLabel).topSpaceToView(self.topTipsLabel, 8*FitHeight).rightSpaceToView(self.view, 20*FitWidth).autoHeightRatio(0);
    self.mnemonicBackScrollView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.detailTipsLabel, (self.mnemonicArray.count == 12)?48*FitHeight:24*FitHeight).heightIs((self.mnemonicArray.count == 12)?266*FitHeight:368*FitHeight);
    self.pageControl.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.mnemonicBackScrollView, (self.mnemonicArray.count == 12)?38*FitHeight:14*FitHeight).widthIs(kWIDTH).heightIs(10);
    if (KAppSetting.language == SHApplicationLanguageRussian) {
        self.continueButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.pageControl, (self.mnemonicArray.count == 12)?60*FitHeight:28*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    }else
    {
        self.continueButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.pageControl, (self.mnemonicArray.count == 12)?80*FitHeight:48*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    }
    [self.view layoutIfNeeded];
    [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];

    [self layoutMnemonicScrollData];
}
-(void)layoutMnemonicScrollData
{
    int  mnemonicSubCount = (self.mnemonicArray.count == 12)?3:4;
    for (NSInteger i=0; i<mnemonicSubCount; i++) {
        UIView *mnemonicBackView = [[UIView alloc]init];
        [self.mnemonicBackScrollView addSubview:mnemonicBackView];
        mnemonicBackView.sd_layout.leftSpaceToView(self.mnemonicBackScrollView, 0 + i*kWIDTH).topEqualToView(self.mnemonicBackScrollView).bottomEqualToView(self.mnemonicBackScrollView).widthIs(kWIDTH);
        [self layoutSubMnemonicViewWithSuperView:mnemonicBackView withTag:i];
    }
    self.mnemonicBackScrollView.contentSize = CGSizeMake(kWIDTH *mnemonicSubCount, 0);
}
-(void)layoutSubMnemonicViewWithSuperView:(UIView *)mnemonicSuperView withTag:(NSInteger)tag
{
    int  mnemonicSubCount = (self.mnemonicArray.count == 12)?4:6;
    for (NSInteger i=0; i<mnemonicSubCount; i++) {
        UILabel *mnemonicLabel = [[UILabel alloc]init];
        [mnemonicSuperView addSubview:mnemonicLabel];
        mnemonicLabel.sd_layout.centerXEqualToView(mnemonicSuperView).topSpaceToView(mnemonicSuperView, 0+i*((self.mnemonicArray.count == 12)?72*FitHeight:64*FitHeight)).heightIs(48*FitHeight);
        [mnemonicLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
        mnemonicLabel.text = [NSString stringWithFormat:@"%ld.%@",tag*mnemonicSubCount + i + 1,self.mnemonicArray[tag*mnemonicSubCount + i]];
        mnemonicLabel.font = kCustomMontserratSemiBoldFont(32);
        mnemonicLabel.textColor = SHTheme.appBlackColor;
        NSMutableAttributedString * content = [[NSMutableAttributedString alloc] initWithString:mnemonicLabel.text];
        [content addAttribute:NSForegroundColorAttributeName value:SHTheme.agreeButtonColor range:NSMakeRange(0, (tag*mnemonicSubCount + i >9)?3:2)];
        mnemonicLabel.attributedText = content;
    }
}
#pragma mark 按钮事件
-(void)continueButtonAction:(UIButton *)btn
{
    if (self.pageControl.currentPage <self.pageControl.numberOfPages -1) {
        if (self.pageControl.currentPage == self.pageControl.numberOfPages - 2) {
            [self.continueButton setTitle:GCLocalizedString(@"complete_tip") forState:UIControlStateNormal];
        }
        [self.mnemonicBackScrollView setContentOffset:CGPointMake(kWIDTH*(self.pageControl.currentPage + 1), 0)];
        self.pageControl.currentPage ++;
    }else
    {
        SHVerifyMnemonicViewController *verifyMnemonicViewController = [[SHVerifyMnemonicViewController alloc]init];
        verifyMnemonicViewController.controllerType = self.controllerType;
        verifyMnemonicViewController.mnemonicArray = self.mnemonicArray;
        verifyMnemonicViewController.passWord = self.passWord;
        verifyMnemonicViewController.selectedNestedSegWitButton = self.selectedNestedSegWitButton;
        verifyMnemonicViewController.walletName = self.walletName;
        [self.navigationController pushViewController:verifyMnemonicViewController animated:YES];
    }

}
#pragma mark 懒加载
-(UIScrollView *)mnemonicBackScrollView
{
    if (_mnemonicBackScrollView == nil) {
        _mnemonicBackScrollView = [[UIScrollView alloc]init];
        _mnemonicBackScrollView.scrollEnabled = NO;
        [self.view addSubview:_mnemonicBackScrollView];
    }
    return _mnemonicBackScrollView;
}
-(UILabel *)topTipsLabel
{
    if (_topTipsLabel == nil) {
        _topTipsLabel = [[UILabel alloc]init];
        _topTipsLabel.font = kCustomMontserratMediumFont(24);
        _topTipsLabel.text = GCLocalizedString(@"recovery_title");
        _topTipsLabel.textColor = SHTheme.appTopBlackColor;
        [self.view addSubview:_topTipsLabel];
    }
    return _topTipsLabel;
}
-(UILabel *)detailTipsLabel
{
    if (_detailTipsLabel == nil) {
        _detailTipsLabel = [[UILabel alloc]init];
        _detailTipsLabel.font = kCustomMontserratMediumFont(14);
        _detailTipsLabel.text = GCLocalizedString(@"recovery_content");
        _detailTipsLabel.textColor = SHTheme.appBlackColor;
        [self.view addSubview:_detailTipsLabel];
    }
    return _detailTipsLabel;
}
- (XMPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[XMPageControl alloc] init];
        _pageControl.cornerRadius = 2.5;
        _pageControl.dotHeight = 5;
        _pageControl.dotSpace = 4;
        _pageControl.currentDotWidth = 10;
        _pageControl.otherDotWidth = 5;
        _pageControl.otherDotColor = SHTheme.pageUnselectColor;
        _pageControl.currentDotColor = SHTheme.agreeButtonColor;
        _pageControl.numberOfPages = (self.mnemonicArray.count == 12)?3:4;
        _pageControl.currentPage = 0;
        _pageControl.style = PageControlStyle_tailMoving;
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
}
-(UIButton *)continueButton
{
    if (_continueButton == nil) {
        _continueButton = [[UIButton alloc]init];
        _continueButton.layer.cornerRadius = 26*FitHeight;
        _continueButton.layer.masksToBounds = YES;
        [_continueButton setTitle:GCLocalizedString(@"continue_desc") forState:UIControlStateNormal];
        [_continueButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _continueButton.titleLabel.font = kMediunFont(14);
        [_continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_continueButton];
    }
    return _continueButton;
}
@end
