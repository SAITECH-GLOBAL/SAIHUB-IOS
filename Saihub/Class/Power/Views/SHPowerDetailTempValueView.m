//
//  SHPowerDetailTempValueView.m
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import "SHPowerDetailTempValueView.h"
@interface SHPowerDetailTempValueView ()
@property (nonatomic, strong) UIView *backView;
@end
@implementation SHPowerDetailTempValueView
#pragma mark 布局页面
-(void)layoutScale
{
    self.backView.sd_layout.leftSpaceToView(self, 20*FitWidth).topEqualToView(self).rightSpaceToView(self, 20*FitWidth).heightIs(196*FitHeight);
    NSArray *tempTipsArray = @[GCLocalizedString(@"Indoor_Temp"),GCLocalizedString(@"Outdoor_Temp"),GCLocalizedString(@"Cabinet_Temp")];
    for (NSInteger i=0; i<tempTipsArray.count; i++) {
        UILabel *tempTipsLabel = [[UILabel alloc]init];
        [self.backView addSubview:tempTipsLabel];
        tempTipsLabel.font = kCustomMontserratRegularFont(14);
        tempTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        tempTipsLabel.text = tempTipsArray[i];
        tempTipsLabel.sd_layout.leftSpaceToView(self.backView, 20*FitWidth).topSpaceToView(self.backView, 28*FitHeight + i*61*FitHeight).heightIs(22*FitHeight);
        [tempTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
        
        UILabel *tempValueLabel = [[UILabel alloc]init];
        [self.backView addSubview:tempValueLabel];
        tempValueLabel.font = kCustomDDINExpBoldFont(14);
        tempValueLabel.textColor = SHTheme.appTopBlackColor;
        tempValueLabel.text = @"";
        tempValueLabel.sd_layout.rightSpaceToView(self.backView, 20*FitWidth).centerYEqualToView(tempTipsLabel).heightIs(16*FitHeight);
        [tempValueLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
        switch (i) {
            case 0:
            {
                tempValueLabel.text = [NSString stringWithFormat:@"%@℃",self.powerDetailModel.indoorTemperature];
            }
                break;
            case 1:
            {
                tempValueLabel.text = [NSString stringWithFormat:@"%@℃",self.powerDetailModel.outdoorTemperature];
            }
                break;
            case 2:
            {
                tempValueLabel.text = [NSString stringWithFormat:@"%@℃",self.powerDetailModel.cabinetTemperature];
            }
                break;
            default:
                break;
        }
        
        UIView *lineView = [[UIView alloc]init];
        [self.backView addSubview:lineView];
        lineView.sd_layout.leftSpaceToView(self.backView, 20*FitWidth).rightEqualToView(self.backView).topSpaceToView(tempTipsLabel, 18*FitHeight).heightIs(1);
        lineView.backgroundColor = SHTheme.appTopBlackColor;
        lineView.hidden = i==2?YES:NO;
        lineView.alpha = 0.06;
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

@end
