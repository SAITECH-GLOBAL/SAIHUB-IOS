//
//  SHPowerDetailChartLineView.m
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import "SHPowerDetailChartLineView.h"
#import <AAChartKit/AAChartModel.h>
#import <AAChartView.h>

@interface SHPowerDetailChartLineView ()
@property (nonatomic, strong) UILabel *totalPowerValueLabel;
@property (nonatomic, strong) UILabel *totalPowerCoinLabel;
@property (nonatomic, strong) UILabel *totalPowerTipsLabel;
@property (nonatomic, strong) UIImageView *totalPowerImageView;

@property (nonatomic, strong) UILabel *powerConsumptionValueLabel;
@property (nonatomic, strong) UILabel *powerConsumptionCoinLabel;
@property (nonatomic, strong) UILabel *powerConsumptionTipsLabel;
@property (nonatomic, strong) UIImageView *powerConsumptionImageView;

//@property (nonatomic, strong) UILabel *chatCoinLabel;
@property (nonatomic, strong) UIView *containerView;
@end
@implementation SHPowerDetailChartLineView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.totalPowerValueLabel.sd_layout.leftSpaceToView(self, 20*FitWidth).topSpaceToView(self, 0).heightIs(20*FitHeight);
    [self.totalPowerValueLabel setSingleLineAutoResizeWithMaxWidth:300*FitWidth];
    self.totalPowerCoinLabel.sd_layout.leftSpaceToView(self.totalPowerValueLabel, 4*FitWidth).bottomEqualToView(self.totalPowerValueLabel).heightIs(12*FitHeight);
    [self.totalPowerCoinLabel setSingleLineAutoResizeWithMaxWidth:200];
    self.totalPowerTipsLabel.sd_layout.leftEqualToView(self.totalPowerValueLabel).topSpaceToView(self.totalPowerValueLabel, 12*FitHeight).heightIs(12*FitHeight);
    [self.totalPowerTipsLabel setSingleLineAutoResizeWithMaxWidth:300];
    self.totalPowerImageView.sd_layout.leftSpaceToView(self.totalPowerTipsLabel, 2*FitWidth).centerYEqualToView(self.totalPowerTipsLabel).widthIs(16*FitWidth).heightEqualToWidth();
    
    self.powerConsumptionValueLabel.sd_layout.rightSpaceToView(self, 141*FitWidth).topSpaceToView(self, 0).heightIs(20*FitHeight);
    [self.powerConsumptionValueLabel setSingleLineAutoResizeWithMaxWidth:300*FitWidth];
    self.powerConsumptionCoinLabel.sd_layout.leftSpaceToView(self.powerConsumptionValueLabel, 4*FitWidth).bottomEqualToView(self.powerConsumptionValueLabel).heightIs(12*FitHeight);
    [self.powerConsumptionCoinLabel setSingleLineAutoResizeWithMaxWidth:200];
    self.powerConsumptionTipsLabel.sd_layout.leftEqualToView(self.powerConsumptionValueLabel).topSpaceToView(self.powerConsumptionValueLabel, 12*FitHeight).heightIs(12*FitHeight);
    [self.powerConsumptionTipsLabel setSingleLineAutoResizeWithMaxWidth:300];
    self.powerConsumptionImageView.sd_layout.leftSpaceToView(self.powerConsumptionTipsLabel, 2*FitWidth).centerYEqualToView(self.powerConsumptionTipsLabel).widthIs(16*FitWidth).heightEqualToWidth();
    
//    self.chatCoinLabel.sd_layout.leftEqualToView(self.totalPowerTipsLabel).topSpaceToView(self.totalPowerTipsLabel, 16*FitHeight).heightIs(12*FitHeight);
//    [self.chatCoinLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    
}
-(void)loadAAchartViewScaleWithTimeArray:(NSMutableArray *)timeArray WithPowerArray:(NSMutableArray *)powerArray WithConsumptionArray:(NSMutableArray *)consumptionArray
{
//    NSArray *timeArrayTest = @[@"1:00", @"2:00", @"3:00", @"4:00", @"5:00", @"6:00",@"7:00", @"8:00", @"9:00", @"10:00", @"11:00", @"12:00"];
//    NSArray *powerArrayTest = @[@7.0, @6.9, @2.5, @14.5, @18.2, @21.5, @5.2, @26.5, @23.3, @45.3, @13.9, @9.6];
//    NSArray *consumptionArraytest = @[@17.0, @16.9, @12.5, @114.5, @118.2, @121.5, @15.2, @126.5, @123.3, @145.3, @113.9, @19.6];

//    NSArray *doubleTimeArray = [NSArray new];
    [self.containerView removeFromSuperview];
    NSMutableArray *power = [NSMutableArray array];
    NSMutableArray *allDataArray = [NSMutableArray array];
    [allDataArray addObjectsFromArray:powerArray];
    [allDataArray addObjectsFromArray:consumptionArray];
    
    for (NSDecimalNumber *item in allDataArray) {
            [power addObject: item];
        }
    NSDecimalNumber *maxPower = [[NSDecimalNumber decimalNumberWithDecimal:[[power valueForKeyPath:@"@max.floatValue"] decimalValue]]decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1.1"]];
    if ([maxPower isEqual:[NSDecimalNumber decimalNumberWithString:@"0"]]) {
        maxPower = [[NSDecimalNumber decimalNumberWithString:@"1"]decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1.1"]];
    }
    
    NSDecimalNumber *minPower = [[NSDecimalNumber decimalNumberWithDecimal:[[power valueForKeyPath:@"@min.floatValue"] decimalValue]]decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.9"]];

    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 6;
    [self addSubview:containerView];
    self.containerView = containerView;
    containerView.sd_layout.leftSpaceToView(self, 0*FitWidth).topSpaceToView(self.totalPowerTipsLabel, 10*FitHeight).rightSpaceToView(self, 20*FitWidth).bottomEqualToView(self);
    [containerView layoutIfNeeded];
    
    NSDictionary *gradientColorDic1 =[AAGradientColor gradientColorWithDirection:AALinearGradientDirectionToBottom
                                                                startColorString:AARgbaColor(72, 173, 195, 0.2)
                                                                  endColorString:AARgbaColor(72, 173, 195, 0)];//热情的粉红, alpha 透明度 0.3
    NSDictionary *gradientColorDic2 =[AAGradientColor gradientColorWithDirection:AALinearGradientDirectionToBottom
                                                                startColorString:AARgbaColor(0, 0, 0, 0)
                                                                  endColorString:AARgbaColor(255, 187, 108, 0)];//热情的粉红, alpha 透明度 0.3
    AAChartView *chartView = [[AAChartView alloc]initWithFrame:CGRectMake(20*FitWidth, 0, kWIDTH - 40*FitWidth, 210*FitHeight)];
    chartView.backgroundColor = SHTheme.appWhightColor;
    [containerView addSubview:chartView];
    AAChartModel *aaChartModel= AAObject(AAChartModel)
        .chartTypeSet(AAChartTypeAreaspline)
        .yAxisLineWidthSet(@0)//Y轴轴线线宽为0即是隐藏Y轴轴线
        .xAxisLabelsStyleSet(AAStyleColorSizeWeight(@"#3E475A", 10, AAChartFontWeightTypeBold))
        .yAxisLabelsStyleSet(AAStyleColorSizeWeight(@"#3E475A", 10, AAChartFontWeightTypeBold))
        .yAxisMaxSet(maxPower)
        .yAxisMinSet(minPower)
//        .categoriesSet(timeArray)//图表横轴的内容
        .markerSymbolSet(AAChartSymbolTypeCircle)
        .markerRadiusSet(@0)
        .colorsThemeSet(@[@"#FF8300",@"#48ADC3"])
        .xAxisLabelsEnabledSet(true)
        .yAxisLabelsEnabledSet(true)
        .legendEnabledSet(false)
        .seriesSet(@[AAObject(AASeriesElement)
                         .nameSet(@"consum")
                         .fillColorSet((id)gradientColorDic2)
                         .dataSet(consumptionArray)
                         .statesSet(AAStates.new
                         .hoverSet(AAHover.new
                         .enabledSet(true)
                         .lineWidthPlusSet(@0)//手指盘旋或选中图表时,禁止线条变粗
                     )),
            AAObject(AASeriesElement)
                .nameSet(@"power")
                         .lineWidthSet(@3)
                         .dashStyleSet(AAChartLineDashStyleTypeDash)
                .fillColorSet((id)gradientColorDic1)
                .dataSet(powerArray)
                .statesSet(AAStates.new
                .hoverSet(AAHover.new
                .enabledSet(true)
                .lineWidthPlusSet(@0)//手指盘旋或选中图表时,禁止线条变粗
            ))]);
    AAOptions *aaOptions = aaChartModel.aa_toAAOptions;
    aaOptions.xAxis.visibleSet(true);
    aaOptions.yAxis.visibleSet(true);
    aaOptions.tooltip
        .animationSet(false)
        .shadowSet(false)
        .borderRadiusSet(@4)
        .borderColorSet(AARgbaColor(0, 0, 0, 0.8))
        .backgroundColorSet(AARgbaColor(0, 0, 0, 0.8))
        .styleSet(AAStyleColor(AAColor.whiteColor))
        .useHTMLSet(true)
        .formatterSet((@AAJSFunc(function () {
            return this.points[0].y.toFixed(2) + '<br/>' + this.points[1].y.toFixed(3) ;
        })))
        .valueDecimalsSet(@(4));
    
    NSString *xAxisLabelsFormatter = [NSString stringWithFormat:(@AAJSFunc(function () {
        return %@[this.value];
    })),[timeArray aa_toJSArray]];

    aaOptions.xAxis.labels.formatterSet(xAxisLabelsFormatter);
    aaOptions.xAxis.tickIntervalSet(@1);
    
    [chartView aa_drawChartWithOptions:aaOptions];
    
}
-(void)setPowerDetailModel:(SHPowerDetailModel *)powerDetailModel
{
    _powerDetailModel = powerDetailModel;
    self.totalPowerValueLabel.text = powerDetailModel.unitEnergyConsumption;
    self.totalPowerCoinLabel.text = powerDetailModel.consumptionUnit;
    self.totalPowerTipsLabel.text = GCLocalizedString(@"Total_Power");
    self.totalPowerImageView.image = [UIImage imageNamed:@"detailChartLineView_totalPowerImageView"];

    self.powerConsumptionValueLabel.text = powerDetailModel.outputHeat;
    self.powerConsumptionCoinLabel.text = powerDetailModel.outputHeatUnit;
    self.powerConsumptionTipsLabel.text = GCLocalizedString(@"Power_Consumption");
    self.powerConsumptionImageView.image = [UIImage imageNamed:@"detailChartLineView_powerConsumptionImageView"];

//    self.chatCoinLabel.text = [NSString stringWithFormat:@"%@/h",powerDetailModel.powerUnit];
    NSMutableArray *timeArray = [NSMutableArray new];
    NSMutableArray *powerArray = [NSMutableArray new];
    NSMutableArray *consumptionArray = [NSMutableArray new];
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:@"1"];
    NSDecimalNumberHandler *roundThreeUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:3 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];

    for (HourDataListItem *subModel in powerDetailModel.hourDataList) {
        [timeArray addObject:[NSString dateStringFromTimestampWithTimeTamp:subModel.timestamp withFormat:@"HH:mm"]];
        [powerArray addObject:[[NSDecimalNumber decimalNumberWithString:subModel.outputHeat] decimalNumberByMultiplyingBy:one withBehavior:roundThreeUp]];
        [consumptionArray addObject:[[NSDecimalNumber decimalNumberWithString:subModel.unitEnergyConsumption] decimalNumberByMultiplyingBy:one withBehavior:roundThreeUp]];
    }
    [self loadAAchartViewScaleWithTimeArray:timeArray WithPowerArray:powerArray WithConsumptionArray:consumptionArray];
}
- (NSString *)aa_toJSArray {
    NSString *originalJsArrStr = @"";
    for (NSString *obj in self) {
        originalJsArrStr = [originalJsArrStr stringByAppendingFormat:@"'%@',",obj];
    }
    
    NSString *finalJSArrStr = [NSString stringWithFormat:@"[%@]",originalJsArrStr];
    return finalJSArrStr;
}
#pragma mark 懒加载
-(UILabel *)totalPowerValueLabel
{
    if (_totalPowerValueLabel == nil) {
        _totalPowerValueLabel = [[UILabel alloc]init];
        _totalPowerValueLabel.font = kCustomDDINExpBoldFont(20);
        _totalPowerValueLabel.textColor = SHTheme.appBlackColor;
        _totalPowerValueLabel.text = @"";
        [self addSubview:_totalPowerValueLabel];
    }
    return _totalPowerValueLabel;
}
-(UILabel *)totalPowerCoinLabel
{
    if (_totalPowerCoinLabel == nil) {
        _totalPowerCoinLabel = [[UILabel alloc]init];
        _totalPowerCoinLabel.font = kCustomMontserratMediumFont(12);
        _totalPowerCoinLabel.textColor = SHTheme.appBlackColor;
        _totalPowerCoinLabel.text = @"";
        [self addSubview:_totalPowerCoinLabel];
    }
    return _totalPowerCoinLabel;
}
-(UILabel *)totalPowerTipsLabel
{
    if (_totalPowerTipsLabel == nil) {
        _totalPowerTipsLabel = [[UILabel alloc]init];
        _totalPowerTipsLabel.font = kCustomMontserratRegularFont(12);
        _totalPowerTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _totalPowerTipsLabel.text = @"";
        [self addSubview:_totalPowerTipsLabel];
    }
    return _totalPowerTipsLabel;
}
-(UIImageView *)totalPowerImageView
{
    if (_totalPowerImageView == nil) {
        _totalPowerImageView = [[UIImageView alloc]init];
        [self addSubview:_totalPowerImageView];
    }
    return _totalPowerImageView;
}

-(UILabel *)powerConsumptionValueLabel
{
    if (_powerConsumptionValueLabel == nil) {
        _powerConsumptionValueLabel = [[UILabel alloc]init];
        _powerConsumptionValueLabel.font = kCustomDDINExpBoldFont(20);
        _powerConsumptionValueLabel.textColor = SHTheme.appBlackColor;
        _powerConsumptionValueLabel.text = @"";
        [self addSubview:_powerConsumptionValueLabel];
    }
    return _powerConsumptionValueLabel;
}
-(UILabel *)powerConsumptionCoinLabel
{
    if (_powerConsumptionCoinLabel == nil) {
        _powerConsumptionCoinLabel = [[UILabel alloc]init];
        _powerConsumptionCoinLabel.font = kCustomMontserratMediumFont(12);
        _powerConsumptionCoinLabel.textColor = SHTheme.appBlackColor;
        _powerConsumptionCoinLabel.text = @"";
        [self addSubview:_powerConsumptionCoinLabel];
    }
    return _powerConsumptionCoinLabel;
}
-(UILabel *)powerConsumptionTipsLabel
{
    if (_powerConsumptionTipsLabel == nil) {
        _powerConsumptionTipsLabel = [[UILabel alloc]init];
        _powerConsumptionTipsLabel.font = kCustomMontserratRegularFont(12);
        _powerConsumptionTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        _powerConsumptionTipsLabel.text = @"";
        [self addSubview:_powerConsumptionTipsLabel];
    }
    return _powerConsumptionTipsLabel;
}
-(UIImageView *)powerConsumptionImageView
{
    if (_powerConsumptionImageView == nil) {
        _powerConsumptionImageView = [[UIImageView alloc]init];
        [self addSubview:_powerConsumptionImageView];
    }
    return _powerConsumptionImageView;
}
//-(UILabel *)chatCoinLabel
//{
//    if (_chatCoinLabel == nil) {
//        _chatCoinLabel = [[UILabel alloc]init];
//        _chatCoinLabel.font = kCustomDDINExpBoldFont(12);
//        _chatCoinLabel.textColor = SHTheme.powerChartTipsColor;
//        _chatCoinLabel.text = @"";
//        [self addSubview:_chatCoinLabel];
//    }
//    return _chatCoinLabel;
//}
@end
