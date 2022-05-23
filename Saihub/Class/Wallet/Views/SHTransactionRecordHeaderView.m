//
//  SHTransactionRecordHeaderView.m
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import "SHTransactionRecordHeaderView.h"

@interface SHTransactionRecordHeaderView ()


@end

@implementation SHTransactionRecordHeaderView

- (UILabel *)balanceLabel {
    if (_balanceLabel == nil) {
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.text = @"2222";
        _balanceLabel.textColor = SHTheme.appWhightColor;
        _balanceLabel.font = kCustomDDINExpBoldFont(48);
        [self addSubview:_balanceLabel];
    }
    return _balanceLabel;
}

- (UILabel *)convertLabel {
    if (_convertLabel == nil) {
        _convertLabel = [[UILabel alloc]init];
        _convertLabel.textColor = SHTheme.appWhightColor;
        _convertLabel.font = kCustomMontserratMediumFont(14);
        _convertLabel.text = @"22333";
        [self addSubview:_convertLabel];
    }
    return _convertLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(kNavBarHeight + kStatusBarHeight + 20);
            make.right.mas_equalTo(-20);
        }];
        
        [self.convertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.balanceLabel);
            make.top.equalTo(self.balanceLabel.mas_bottom).offset(8);
        }];
    }
    return self;
}

- (void)setTokenModel:(SHWalletTokenModel *)tokenModel {
    _tokenModel = tokenModel;
    
    NSInteger place = 8;
    
    NSString *rate = [SHKeyStorage shared].btcRate;
    
    if (tokenModel.isPrimaryToken == NO) {
        place = 2;
        rate = [SHKeyStorage shared].usdtRate;
    }
    
    // 余额
    self.balanceLabel.text = [NSString formStringWithValue:[SHWalletUtils coin_highToLowWithAmount:tokenModel.balance decimal:tokenModel.places] count:place];
    
    // 折合
    self.convertLabel.text = [NSString stringWithFormat:@"≈%@%@",KAppSetting.currencySymbol,[NSString digitStringWithValue:[[SHWalletUtils coin_highToLowWithAmount:tokenModel.balance decimal:tokenModel.places] to_multiplyingWithStr:rate] count:2]];
}

@end
