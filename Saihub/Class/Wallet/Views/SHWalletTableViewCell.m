//
//  SHWalletTableViewCell.m
//  Saihub
//
//  Created by 周松 on 2022/2/23.
//

#import "SHWalletTableViewCell.h"

@interface SHWalletTableViewCell ()

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *tokenNameLabel;

@property (nonatomic,strong) UILabel *balanceLabel;

@property (nonatomic,strong) UILabel *convertPriceLabel;

@end

@implementation SHWalletTableViewCell

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc]init];
        _containerView.layer.cornerRadius = 16;
        _containerView.backgroundColor = SHTheme.addressTypeCellBackColor;
        [self.contentView addSubview:_containerView];
    }
    return _containerView;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 21;
        _iconImageView.layer.masksToBounds = YES;
        [self.containerView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)tokenNameLabel {
    if (_tokenNameLabel == nil) {
        _tokenNameLabel = [[UILabel alloc]init];
        _tokenNameLabel.text = @"BTC";
        _tokenNameLabel.textColor = SHTheme.walletTextColor;
        _tokenNameLabel.font = kCustomDDINExpBoldFont(18);
        [self.containerView addSubview:_tokenNameLabel];
    }
    return _tokenNameLabel;
}

- (UILabel *)balanceLabel {
    if (_balanceLabel == nil) {
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.text = @"--";
        _balanceLabel.textColor = SHTheme.walletTextColor;
        _balanceLabel.font = kCustomDDINExpBoldFont(14);
        _balanceLabel.textAlignment = NSTextAlignmentRight;
        [self.containerView addSubview:_balanceLabel];
    }
    return _balanceLabel;
}

- (UILabel *)convertPriceLabel {
    if (_convertPriceLabel == nil) {
        _convertPriceLabel = [[UILabel alloc]init];
        _convertPriceLabel.text = @"--";
        _convertPriceLabel.textColor = SHTheme.walletNameLabelColor;
        _convertPriceLabel.font = kCustomMontserratMediumFont(12);
        [self.containerView addSubview:_convertPriceLabel];
    }
    return _convertPriceLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setConstraints];
    }
    return self;
}

- (void)setConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(16);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [self.tokenNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.centerY.equalTo(self.iconImageView);
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(22);
        make.width.mas_lessThanOrEqualTo(150 *FitWidth);
    }];
    
    [self.convertPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.balanceLabel);
        make.bottom.mas_equalTo(-23);
        make.width.mas_lessThanOrEqualTo(150 *FitWidth);
    }];
    
}

- (void)setTokenModel:(SHWalletTokenModel *)tokenModel {
    _tokenModel = tokenModel;
    
    self.iconImageView.image = [UIImage imageWithData:tokenModel.imageData];
    
    self.tokenNameLabel.text = tokenModel.tokenShort;
    
    NSInteger place = 8;
    
    NSString *rate = [SHKeyStorage shared].btcRate;
    
    if (tokenModel.isPrimaryToken == NO) {
        place = 2;
        rate = [SHKeyStorage shared].usdtRate;
    }
    
    // 余额
    self.balanceLabel.text = [NSString formStringWithValue:[SHWalletUtils coin_highToLowWithAmount:tokenModel.balance decimal:tokenModel.places] count:place];
    
    // 折合
    self.convertPriceLabel.text = [NSString stringWithFormat:@"≈%@%@",KAppSetting.currencySymbol,[NSString digitStringWithValue:[[SHWalletUtils coin_highToLowWithAmount:tokenModel.balance decimal:tokenModel.places] to_multiplyingWithStr:rate] count:2]];
}

@end
