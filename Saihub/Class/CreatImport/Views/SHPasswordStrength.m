//
//  SHPasswordStrength.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHPasswordStrength.h"
@interface SHPasswordStrength ()
@property (nonatomic, strong) UILabel *intensityTipsLabel;
@property (nonatomic, strong) UIView *firstIntensityView;
@property (nonatomic, strong) UIView *secondIntensityView;
@property (nonatomic, strong) UIView *thirdIntensityView;
@end
@implementation SHPasswordStrength
- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        [self layoutScale];
    }
    return self;
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.thirdIntensityView.sd_layout.rightSpaceToView(self, 0*FitWidth).centerYEqualToView(self).widthIs(16*FitWidth).heightIs(4*FitHeight);
    self.secondIntensityView.sd_layout.rightSpaceToView(self.thirdIntensityView, 4*FitWidth).centerYEqualToView(self).widthIs(16*FitWidth).heightIs(4*FitHeight);
    self.firstIntensityView.sd_layout.rightSpaceToView(self.secondIntensityView, 4*FitWidth).centerYEqualToView(self).widthIs(16*FitWidth).heightIs(4*FitHeight);
    self.intensityTipsLabel.sd_layout.rightSpaceToView(self.firstIntensityView, 4*FitWidth).centerYEqualToView(self).heightIs(14*FitHeight);
    [self.intensityTipsLabel setSingleLineAutoResizeWithMaxWidth:100];
}
#pragma mark 函数方法  1：密码强度
-(void)setPasswordStrengthType:(SHPasswordStrengthType)passwordStrengthType
{
    _passwordStrengthType = passwordStrengthType;
    switch (passwordStrengthType) {
        case SHPasswordStrengthNormalType:
        {
            self.intensityTipsLabel.hidden = YES;
            self.intensityTipsLabel.textColor = SHTheme.buttonForMnemonicSelectBackColor;
            self.firstIntensityView.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
            self.secondIntensityView.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
            self.thirdIntensityView.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
        }
            break;
        case SHPasswordStrengthWeakType:
        {
            self.intensityTipsLabel.hidden = NO;
            self.intensityTipsLabel.text = GCLocalizedString(@"pwd_weak");
            self.intensityTipsLabel.textColor = SHTheme.errorTipsRedColor;
            self.firstIntensityView.backgroundColor = SHTheme.errorTipsRedColor;
            self.secondIntensityView.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
            self.thirdIntensityView.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
        }
            break;
        case SHPasswordStrengthMediumType:
        {
            self.intensityTipsLabel.hidden = NO;
            self.intensityTipsLabel.text = GCLocalizedString(@"pwd_medium");
            self.intensityTipsLabel.textColor = SHTheme.intensityBlueColor;
            self.firstIntensityView.backgroundColor = SHTheme.intensityBlueColor;
            self.secondIntensityView.backgroundColor = SHTheme.intensityBlueColor;
            self.thirdIntensityView.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
        }
            break;
        case SHPasswordStrengthStrongType:
        {
            self.intensityTipsLabel.hidden = NO;
            self.intensityTipsLabel.text = GCLocalizedString(@"pwd_strong");
            self.intensityTipsLabel.textColor = SHTheme.intensityGreenColor;
            self.firstIntensityView.backgroundColor = SHTheme.intensityGreenColor;
            self.secondIntensityView.backgroundColor = SHTheme.intensityGreenColor;
            self.thirdIntensityView.backgroundColor = SHTheme.intensityGreenColor;
        }
            break;
        default:
            break;
    }
}
#pragma mark 懒加载
-(UILabel *)intensityTipsLabel
{
    if (_intensityTipsLabel == nil) {
        _intensityTipsLabel = [[UILabel alloc]init];
        _intensityTipsLabel.font = kCustomMontserratRegularFont(12);
        _intensityTipsLabel.hidden = YES;
        _intensityTipsLabel.textColor = SHTheme.errorTipsRedColor;
        [self addSubview:_intensityTipsLabel];
    }
    return _intensityTipsLabel;
}
- (UIView *)firstIntensityView
{
    if (_firstIntensityView == nil) {
        _firstIntensityView = [[UIView alloc]init];
        _firstIntensityView.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
        _firstIntensityView.layer.cornerRadius = 2*FitHeight;
        _firstIntensityView.layer.masksToBounds = YES;
        [self addSubview:_firstIntensityView];
    }
    return _firstIntensityView;
}
- (UIView *)secondIntensityView
{
    if (_secondIntensityView == nil) {
        _secondIntensityView = [[UIView alloc]init];
        _secondIntensityView.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
        _secondIntensityView.layer.cornerRadius = 2*FitHeight;
        _secondIntensityView.layer.masksToBounds = YES;
        [self addSubview:_secondIntensityView];
    }
    return _secondIntensityView;
}
- (UIView *)thirdIntensityView
{
    if (_thirdIntensityView == nil) {
        _thirdIntensityView = [[UIView alloc]init];
        _thirdIntensityView.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
        _thirdIntensityView.layer.cornerRadius = 2*FitHeight;
        _thirdIntensityView.layer.masksToBounds = YES;
        [self addSubview:_thirdIntensityView];
    }
    return _thirdIntensityView;
}
@end
