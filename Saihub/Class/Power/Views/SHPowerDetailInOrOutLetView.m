//
//  SHPowerDetailInOrOutLetView.m
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import "SHPowerDetailInOrOutLetView.h"
@interface SHPowerDetailInOrOutLetView ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *inletTipsLabel;
@property (nonatomic, strong) UILabel *outletTipsLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation SHPowerDetailInOrOutLetView
#pragma mark 布局页面
-(void)layoutScale
{
    self.backView.sd_layout.leftSpaceToView(self, 20*FitWidth).topEqualToView(self).rightSpaceToView(self, 20*FitWidth).heightIs(184*FitHeight);
    self.inletTipsLabel.sd_layout.leftSpaceToView(self.backView, 20*FitWidth).topSpaceToView(self.backView, 16*FitHeight).heightIs(12*FitHeight);
    [self.inletTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.outletTipsLabel.sd_layout.leftSpaceToView(self.backView, 188*FitWidth).centerYEqualToView(self.inletTipsLabel).heightIs(12*FitHeight);
    [self.outletTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.lineView.sd_layout.leftSpaceToView(self.backView, 20*FitWidth).rightSpaceToView(self.backView, 20*FitWidth).topSpaceToView(self.backView, 43*FitHeight).heightIs(1);
    NSArray *inOrOutTipsArray = @[GCLocalizedString(@"Water_Temp"),GCLocalizedString(@"Water_Temp"),GCLocalizedString(@"Water_Pressure"),GCLocalizedString(@"Water_Pressure")];
    for (NSInteger i=0; i<inOrOutTipsArray.count; i++) {
        UILabel *inOrOutValueLabel = [[UILabel alloc]init];
        [self.backView addSubview:inOrOutValueLabel];
        inOrOutValueLabel.sd_layout.leftSpaceToView(self.backView, 20*FitWidth + i%2*168*FitWidth).topSpaceToView(self.lineView, 16*FitHeight + i/2*61*FitHeight).heightIs(16*FitHeight);
        [inOrOutValueLabel setSingleLineAutoResizeWithMaxWidth:200];
        inOrOutValueLabel.font = kCustomDDINExpBoldFont(16);
        inOrOutValueLabel.textColor = SHTheme.appTopBlackColor;
        switch (i) {
            case 0:
            {
                inOrOutValueLabel.text = [NSString stringWithFormat:@"%@℃",self.powerDetailModel.inletWaterTemperature];
            }
                break;
            case 1:
            {
                inOrOutValueLabel.text = [NSString stringWithFormat:@"%@℃",self.powerDetailModel.outWaterTemperature];
            }
                break;
            case 2:
            {
                inOrOutValueLabel.text = [NSString stringWithFormat:@"%@Mpa",self.powerDetailModel.waterInletPressure];
            }
                break;
            case 3:
            {
                inOrOutValueLabel.text = [NSString stringWithFormat:@"%@Mpa",self.powerDetailModel.waterOutPressure];
            }
                break;
            default:
                break;
        }
        UILabel *inOrOutTipsLabel = [[UILabel alloc]init];
        [self.backView addSubview:inOrOutTipsLabel];
        inOrOutTipsLabel.sd_layout.leftEqualToView(inOrOutValueLabel).topSpaceToView(inOrOutValueLabel, 8*FitHeight).heightIs(14*FitHeight);
        [inOrOutTipsLabel setSingleLineAutoResizeWithMaxWidth:200];
        inOrOutTipsLabel.font = kCustomMontserratRegularFont(14);
        inOrOutTipsLabel.textColor = SHTheme.pageUnselectColor;
        inOrOutTipsLabel.text = inOrOutTipsArray[i];
    }
}
-(void)setPowerDetailModel:(SHPowerDetailModel *)powerDetailModel
{
    _powerDetailModel = powerDetailModel;
    [self layoutSubViewNil];
    [self layoutScale];
}
-(void)layoutSubViewNil
{
    [self removeAllSubviews];
    self.backView = nil;
    self.inletTipsLabel = nil;
    self.outletTipsLabel = nil;
    self.lineView = nil;
}
#pragma mark 懒加载
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 8;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = SHTheme.addressTypeCellBackColor;
        [self addSubview:_backView];
    }
    return _backView;
}
-(UILabel *)inletTipsLabel
{
    if (_inletTipsLabel == nil) {
        _inletTipsLabel = [[UILabel alloc]init];
        _inletTipsLabel.font = kCustomMontserratMediumFont(12);
        _inletTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _inletTipsLabel.text = GCLocalizedString(@"Inlet");
        [self.backView addSubview:_inletTipsLabel];
    }
    return _inletTipsLabel;
}
-(UILabel *)outletTipsLabel
{
    if (_outletTipsLabel == nil) {
        _outletTipsLabel = [[UILabel alloc]init];
        _outletTipsLabel.font = kCustomMontserratMediumFont(12);
        _outletTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _outletTipsLabel.text = GCLocalizedString(@"Outlet");
        [self.backView addSubview:_outletTipsLabel];
    }
    return _outletTipsLabel;
}
- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = SHTheme.appTopBlackColor;
        _lineView.alpha = 0.06;
        [self.backView addSubview:_lineView];
    }
    return _lineView;
}
@end
