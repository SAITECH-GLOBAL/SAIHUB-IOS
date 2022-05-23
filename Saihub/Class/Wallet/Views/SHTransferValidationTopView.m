//
//  SHTransferValidationTopView.m
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHTransferValidationTopView.h"
@interface SHTransferValidationTopView ()
@property (nonatomic, strong) UILabel *btcValueLabel;
@property (nonatomic, strong) UILabel *btcCoinLabel;
@property (nonatomic, strong) UILabel *moneyValueLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *feeLabel;

@end
@implementation SHTransferValidationTopView

#pragma mark 布局页面
-(void)layoutScale
{
    self.btcValueLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self, 20*FitHeight).heightIs(48*FitHeight);
    [self.btcValueLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.btcCoinLabel.sd_layout.leftSpaceToView(self.btcValueLabel, 4*FitWidth).bottomEqualToView(self.btcValueLabel).heightIs(18*FitHeight);
    [self.btcCoinLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.moneyValueLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.btcValueLabel, 12*FitHeight).heightIs(18*FitHeight);
    [self.moneyValueLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.addressLabel.sd_layout.leftSpaceToView(self, 5*FitWidth).rightSpaceToView(self,    5*FitWidth).topSpaceToView(self.moneyValueLabel, 16*FitHeight).autoHeightRatio(0);
    self.feeLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.addressLabel, 12*FitHeight).heightIs(18*FitHeight);
    [self.feeLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
}
-(void)setTransferInfoModel:(SHTransferInfoModel *)transferInfoModel
{
    _transferInfoModel = transferInfoModel;
    self.btcValueLabel.text = transferInfoModel.valueString;
    self.btcCoinLabel.text = transferInfoModel.coinString;
//    self.moneyValueLabel.text = [NSString stringWithFormat:@"%@%@",KAppSetting.currencySymbol,[NSString formStringWithValue:transferInfoModel.moneyString count:2]];
    self.addressLabel.text = transferInfoModel.addressString;
    [self loadFeeLabelValue];
}
-(void)loadFeeLabelValue
{
    NSDecimalNumber *rateForValueNum = [NSDecimalNumber decimalNumberWithString:self.isPrimaryToken?[SHKeyStorage shared].btcRate:[SHKeyStorage shared].usdtRate];
    NSDecimalNumberHandler *roundPlain = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSLog(@"%@",[rateForValueNum decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:self.transferInfoModel.valueString]withBehavior:roundPlain]);
    self.moneyValueLabel.text = [NSString stringWithFormat:@"%@%@",KAppSetting.currencySymbol,[NSString digitStringWithValue:[rateForValueNum decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:self.transferInfoModel.valueString]withBehavior:roundPlain].stringValue count:2]];

    NSString *feeString = IsEmpty(self.transferInfoModel.trueFee)?[SHWalletUtils coin_multiplyingWithAmount:self.transferInfoModel.gasPrice count:self.transferInfoModel.gasLimit]:self.transferInfoModel.trueFee;
    NSString *fastTotalValue = [NSString formStringWithValue:[SHWalletUtils coin_convertWithAmount:feeString decimal:8] count:8];
    NSDecimalNumber *rateNum = [NSDecimalNumber decimalNumberWithString:[SHKeyStorage shared].btcRate];

    NSDecimalNumber *fastTotal = [rateNum decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:fastTotalValue]withBehavior:roundPlain];
    NSInteger decimal = 2;
    self.feeLabel.text = [NSString stringWithFormat:@"%@:%@(%@)",GCLocalizedString(@"Fee"),[NSString stringWithFormat:@"%@ %@",fastTotalValue,@"BTC"],[NSString stringWithFormat:@"%@ %@",KAppSetting.currencySymbol,[NSString formStringWithValue:fastTotal.stringValue count:decimal]]];
}
#pragma mark 懒加载
-(UILabel *)btcValueLabel
{
    if (_btcValueLabel == nil) {
        _btcValueLabel = [[UILabel alloc]init];
        _btcValueLabel.font = kCustomDDINExpBoldFont(48);
        _btcValueLabel.textColor = SHTheme.agreeButtonColor;
        _btcValueLabel.text = @"--";
        [self addSubview:_btcValueLabel];
    }
    return _btcValueLabel;
}
-(UILabel *)btcCoinLabel
{
    if (_btcCoinLabel == nil) {
        _btcCoinLabel = [[UILabel alloc]init];
        _btcCoinLabel.font = kCustomMontserratMediumFont(14);
        _btcCoinLabel.textColor = SHTheme.agreeButtonColor;
        _btcCoinLabel.text = @"--";
        [self addSubview:_btcCoinLabel];
    }
    return _btcCoinLabel;
}
-(UILabel *)moneyValueLabel
{
    if (_moneyValueLabel == nil) {
        _moneyValueLabel = [[UILabel alloc]init];
        _moneyValueLabel.font = kCustomDDINExpFont(16);
        _moneyValueLabel.textColor = SHTheme.agreeButtonColor;
        _moneyValueLabel.text = @"--";
        [self addSubview:_moneyValueLabel];
    }
    return _moneyValueLabel;
}
-(UILabel *)addressLabel
{
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = kCustomMontserratRegularFont(14);
        _addressLabel.textColor = SHTheme.setPasswordTipsColor;
        _addressLabel.text = @"--";
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_addressLabel];
    }
    return _addressLabel;
}
-(UILabel *)feeLabel
{
    if (_feeLabel == nil) {
        _feeLabel = [[UILabel alloc]init];
        _feeLabel.font = kCustomDDINExpFont(16);
        _feeLabel.textColor = SHTheme.agreeButtonColor;
        _feeLabel.text = @"--";
        [self addSubview:_feeLabel];
    }
    return _feeLabel;
}
@end
