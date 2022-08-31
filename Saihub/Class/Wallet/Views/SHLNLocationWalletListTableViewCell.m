//
//  SHLNLocationWalletListTableViewCell.m
//  Saihub
//
//  Created by macbook on 2022/6/24.
//

#import "SHLNLocationWalletListTableViewCell.h"
@interface SHLNLocationWalletListTableViewCell ()

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *walletNameLabel;

@property (nonatomic,strong) UILabel *walletAdressLabel;

@end
@implementation SHLNLocationWalletListTableViewCell
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"locationWallet_bgcell"];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)walletNameLabel {
    if (_walletNameLabel == nil) {
        _walletNameLabel = [[UILabel alloc]init];
        _walletNameLabel.text = @"--";
        _walletNameLabel.textColor = SHTheme.appWhightColor;
        _walletNameLabel.font = kCustomMontserratMediumFont(14);
        [self.iconImageView addSubview:_walletNameLabel];
    }
    return _walletNameLabel;
}
- (UILabel *)walletAdressLabel {
    if (_walletAdressLabel == nil) {
        _walletAdressLabel = [[UILabel alloc]init];
        _walletAdressLabel.text = @"--";
        _walletAdressLabel.textColor = SHTheme.appWhightColor;
        _walletAdressLabel.font = kCustomDDINExpBoldFont(12);
        _walletAdressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _walletAdressLabel.textAlignment = NSTextAlignmentRight;
        [self.iconImageView addSubview:_walletAdressLabel];
    }
    return _walletAdressLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setConstraints];

    }
    return self;
}
- (void)setConstraints {
    self.iconImageView.sd_layout.centerXEqualToView(self.contentView).widthIs(335*FitWidth).heightIs(78*FitHeight);
    self.walletNameLabel.sd_layout.leftSpaceToView(self.iconImageView, 13*FitWidth).topSpaceToView(self.iconImageView, 20*FitHeight).heightIs(14*FitHeight);
    [self.walletNameLabel setSingleLineAutoResizeWithMaxWidth:300];
    self.walletAdressLabel.sd_layout.leftEqualToView(self.walletNameLabel).topSpaceToView(self.walletNameLabel, 12*FitHeight).heightIs(12*FitHeight);
    [self.walletAdressLabel setSingleLineAutoResizeWithMaxWidth:156*FitWidth];

}
-(void)setWalletModel:(SHWalletModel *)walletModel
{
    _walletModel = walletModel;
    self.walletNameLabel.text = walletModel.name;
    self.walletAdressLabel.text = walletModel.address;
}
@end
