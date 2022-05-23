//
//  SHAgreeMentFirsViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/18.
//

#import "SHAgreeMentFirsViewController.h"
#import "SHBtcCreatOrImportWalletManage.h"

@interface SHAgreeMentFirsViewController ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *appNameImageView;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *topTipsLabel;
@property (nonatomic, strong) UILabel *agreementLabel;
@end

@implementation SHAgreeMentFirsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    self.view.backgroundColor = SHTheme.agreementVcBackColor;
    [self layoutScale];
    // Do any additional setup after loading the view.

}
#pragma mark 布局页面
-(void)layoutScale
{
    self.backImageView.sd_layout.rightEqualToView(self.view).topEqualToView(self.view).widthIs(295).heightIs(344);
    self.iconImageView.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, 140 + kStatusBarHeight).widthIs(136).heightEqualToWidth();
    self.appNameImageView.sd_layout.centerXEqualToView(self.iconImageView).topSpaceToView(self.iconImageView, 0).widthIs(100).heightIs(18);
    self.agreeButton.sd_layout.centerXEqualToView(self.view).bottomSpaceToView(self.view, 114*FitHeight + SafeAreaBottomHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    self.topTipsLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.agreeButton, 16*FitHeight).heightIs(22*FitHeight);
    [self.topTipsLabel setSingleLineAutoResizeWithMaxWidth:345*FitWidth];
    self.selectButton.sd_layout.centerYEqualToView(self.topTipsLabel).rightSpaceToView(self.topTipsLabel, 4*FitWidth).widthIs(20*FitWidth).heightEqualToWidth();
    self.agreementLabel.sd_layout.centerXEqualToView(self.topTipsLabel).topSpaceToView(self.topTipsLabel, 0).heightIs(22*FitHeight);
    [self.agreementLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    
}
#pragma mark 按钮事件
-(void)agreeButtonAction:(UIButton *)btn
{
    if (self.selectButton.selected) {
        if (IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:FirstCreaatOrImportWalletKey])) {
            [self.navigationController pushViewController:[SHSetWalletPassWordViewController new] animated:YES];
        }
    }
}
-(void)selectButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
#pragma mark 懒加载
-(UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"openVc_logo_whight"];
        [self.view addSubview:_iconImageView];
    }
    return _iconImageView;
}
-(UIImageView *)backImageView
{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"agreeMentVc_backImageView"];
        [self.view addSubview:_backImageView];
    }
    return _backImageView;
}
-(UIImageView *)appNameImageView
{
    if (_appNameImageView == nil) {
        _appNameImageView = [[UIImageView alloc]init];
        _appNameImageView.image = [UIImage imageNamed:@"saihubNameIcon"];
        [self.view addSubview:_appNameImageView];
    }
    return _appNameImageView;
}
-(UIButton *)agreeButton
{
    if (_agreeButton == nil) {
        _agreeButton = [[UIButton alloc]init];
        _agreeButton.backgroundColor = SHTheme.appWhightColor;
        _agreeButton.layer.cornerRadius = 26*FitHeight;
        _agreeButton.layer.masksToBounds = YES;
        [_agreeButton setTitle:GCLocalizedString(@"Next") forState:UIControlStateNormal];
        [_agreeButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _agreeButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_agreeButton];
    }
    return _agreeButton;
}
-(UIButton *)selectButton
{
    if (_selectButton == nil) {
        _selectButton = [[UIButton alloc]init];
        [_selectButton setImage:[UIImage imageNamed:@"agreeMentVc_selectButton_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"agreeMentVc_selectButton_select"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_selectButton];
    }
    return _selectButton;
}
-(UILabel *)topTipsLabel
{
    if (_topTipsLabel == nil) {
        _topTipsLabel = [[UILabel alloc]init];
        _topTipsLabel.font = kCustomMontserratMediumFont(12);
        _topTipsLabel.textColor = SHTheme.appWhightColor;
        _topTipsLabel.text = GCLocalizedString(@"agreement_tip");
        [self.view addSubview:_topTipsLabel];
    }
    return _topTipsLabel;
}
-(UILabel *)agreementLabel
{
    if (_agreementLabel == nil) {
        _agreementLabel = [[UILabel alloc]init];
        _agreementLabel.font = kCustomMontserratSemiBoldFont(12);
        _agreementLabel.textColor = SHTheme.appWhightColor;
        _agreementLabel.userInteractionEnabled = YES;
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:GCLocalizedString(@"agreement") attributes:@{NSFontAttributeName:kCustomMontserratSemiBoldFont(12),NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName: SHTheme.appWhightColor}];
        MJWeakSelf;
        //设置高亮色和点击事件
        [content setTextHighlightRange:[[content string] rangeOfString:[content string]] color:SHTheme.appWhightColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {

        }];
        _agreementLabel.attributedText = content;
        [self.view addSubview:_agreementLabel];
    }
    return _agreementLabel;
}
@end
