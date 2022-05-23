//
//  SHAdressBookTableViewCell.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHAdressBookTableViewCell.h"
@interface SHAdressBookTableViewCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *adressBookIcon;
@property (nonatomic, strong) UILabel *adressBookNameLabel;
@property (nonatomic, strong) UILabel *adressLabel;
@end
@implementation SHAdressBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setConstraints];
    }
    return self;
}
- (void)setConstraints {
    self.backView.sd_layout.centerXEqualToView(self.contentView).topSpaceToView(self.contentView, 16*FitHeight).widthIs(335*FitWidth).heightIs(78*FitHeight);
    self.adressBookIcon.sd_layout.rightSpaceToView(self.backView, 16*FitWidth).centerYEqualToView(self.backView).widthIs(42*FitWidth).heightEqualToWidth();
    self.adressBookNameLabel.sd_layout.leftSpaceToView(self.backView, 16*FitWidth).topSpaceToView(self.backView, 17*FitHeight).heightIs(26*FitHeight);
    [self.adressBookNameLabel setSingleLineAutoResizeWithMaxWidth:241];
    self.adressLabel.sd_layout.leftEqualToView(self.adressBookNameLabel).topSpaceToView(self.adressBookNameLabel, 0*FitHeight).heightIs(12*FitHeight);
    [self.adressLabel setSingleLineAutoResizeWithMaxWidth:241];
}
-(void)setAddressBookModel:(SHAddressBookModel *)addressBookModel
{
    _addressBookModel = addressBookModel;
    self.adressBookNameLabel.text = addressBookModel.addressName;
    self.adressLabel.text = addressBookModel.addressValue;
    self.adressLabel.text = (addressBookModel.addressValue.length >12)?[NSString stringWithFormat:@"%@...%@",[addressBookModel.addressValue substringToIndex:6],[addressBookModel.addressValue substringFromIndex:addressBookModel.addressValue.length - 6]]:addressBookModel.addressValue;
}
#pragma mark 按钮事件
-(void)moreButtonAction:(UIButton *)btn
{
    
}
#pragma mark 懒加载
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 8;
        _backView.backgroundColor = SHTheme.addressTypeCellBackColor;
        [self.contentView addSubview:_backView];
    }
    return _backView;
}
-(UIImageView *)adressBookIcon
{
    if (_adressBookIcon == nil) {
        _adressBookIcon = [[UIImageView alloc]init];
        _adressBookIcon.image = [UIImage imageNamed:@"addressVc_btcIcon"];
        [self.backView addSubview:_adressBookIcon];
    }
    return _adressBookIcon;
}
-(UILabel *)adressBookNameLabel
{
    if (_adressBookNameLabel == nil) {
        _adressBookNameLabel = [[UILabel alloc]init];
        _adressBookNameLabel.font = kCustomMontserratMediumFont(20);
        _adressBookNameLabel.textColor = SHTheme.appTopBlackColor;
        [self.backView addSubview:_adressBookNameLabel];
    }
    return _adressBookNameLabel;
}
-(UILabel *)adressLabel
{
    if (_adressLabel == nil) {
        _adressLabel = [[UILabel alloc]init];
        _adressLabel.font = kCustomDDINExpBoldFont(12);
        _adressLabel.textColor = SHTheme.walletNameLabelColor;
        [self.backView addSubview:_adressLabel];
    }
    return _adressLabel;
}
@end
