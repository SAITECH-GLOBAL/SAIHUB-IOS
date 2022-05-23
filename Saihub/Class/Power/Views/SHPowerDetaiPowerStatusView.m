//
//  SHPowerDetaiPowerStatusView.m
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import "SHPowerDetaiPowerStatusView.h"
@interface SHPowerDetaiPowerStatusView ()
@property (nonatomic, strong) UIView *backView;

@end

@implementation SHPowerDetaiPowerStatusView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.backView.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(self).bottomSpaceToView(self, 20*FitHeight);
    self.powerNameLabel.sd_layout.leftSpaceToView(self, 20*FitWidth).topSpaceToView(self, 20*FitHeight).heightIs(30*FitHeight);
    [self.powerNameLabel setSingleLineAutoResizeWithMaxWidth:200*FitWidth];
    self.powerStatusLabel.sd_layout.rightSpaceToView(self, 20*FitWidth).centerYEqualToView(self.powerNameLabel).heightIs(20*FitHeight);
    [self.powerStatusLabel setSingleLineAutoResizeWithMaxWidth:200];
    self.powerStatusImageView.sd_layout.rightSpaceToView(self.powerStatusLabel, 4*FitWidth).centerYEqualToView(self.powerStatusLabel).widthIs(12*FitWidth).heightEqualToWidth();
    [self layoutIfNeeded];
//    CGFloat radius = 16; // 圆角大小
//    UIRectCorner corner = UIRectCornerBottomLeft | UIRectCornerBottomRight; // 圆角位置
//    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.backView.bounds;
//    maskLayer.path = path.CGPath;
//    self.backView.layer.mask = maskLayer;
}
-(void)setPowerDetailModel:(SHPowerDetailModel *)powerDetailModel
{
    _powerDetailModel = powerDetailModel;
    if (powerDetailModel.online) {
        self.powerStatusImageView.image = [UIImage imageNamed:@"powerStatusView_online"];
        self.powerStatusLabel.textColor = SHTheme.intensityGreenColor;
        self.powerStatusLabel.text = GCLocalizedString(@"Online");
    }else
    {
        self.powerStatusImageView.image = [UIImage imageNamed:@"powerStatusView_offline"];
        self.powerStatusLabel.textColor = SHTheme.errorTipsRedColor;
        self.powerStatusLabel.text = GCLocalizedString(@"Offline");
    }
}
#pragma mark 懒加载
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = SHTheme.appWhightColor;
        _backView.layer.cornerRadius = 16*FitHeight;
        _backView.layer.shadowColor = [UIColor colorWithRed:68/255.0 green:73/255.0 blue:79/255.0 alpha:0.08].CGColor;
        _backView.layer.shadowOffset = CGSizeMake(0,2);
        _backView.layer.shadowOpacity = 1;
        _backView.layer.shadowRadius = 16;
        [self addSubview:_backView];
    }
    return _backView;
}
-(UILabel *)powerNameLabel
{
    if (_powerNameLabel == nil) {
        _powerNameLabel = [[UILabel alloc]init];
        _powerNameLabel.font = kCustomMontserratMediumFont(20);
        _powerNameLabel.textColor = SHTheme.agreeTipsLabelColor;
        [self addSubview:_powerNameLabel];
    }
    return _powerNameLabel;
}
-(UIImageView *)powerStatusImageView
{
    if (_powerStatusImageView == nil) {
        _powerStatusImageView = [[UIImageView alloc]init];
        [self addSubview:_powerStatusImageView];
    }
    return _powerStatusImageView;
}
-(UILabel *)powerStatusLabel
{
    if (_powerStatusLabel == nil) {
        _powerStatusLabel = [[UILabel alloc]init];
        _powerStatusLabel.font = kCustomMontserratMediumFont(14);
        _powerStatusLabel.textColor = SHTheme.intensityGreenColor;
        [self addSubview:_powerStatusLabel];
    }
    return _powerStatusLabel;
}
@end
