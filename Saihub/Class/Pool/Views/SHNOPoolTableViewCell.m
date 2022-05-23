//
//  SHNOPoolTableViewCell.m
//  Saihub
//
//  Created by macbook on 2022/2/24.
//

#import "SHNOPoolTableViewCell.h"
@interface SHNOPoolTableViewCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *poolIcon;
@property (nonatomic, strong) JLButton *moreButton;
@property (nonatomic, strong) UILabel *poolNameLabel;
@property (nonatomic, strong) UILabel *adressLabel;
@end
@implementation SHNOPoolTableViewCell

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
        self.userInteractionEnabled = YES;
    }
    return self;
}
-(void)setCellType:(poolOrPowerCellTye)cellType
{
    _cellType = cellType;
    [self setConstraints];
}
- (void)setConstraints {
    self.backView.sd_layout.centerXEqualToView(self.contentView).topSpaceToView(self.contentView, 16*FitHeight).widthIs(335*FitWidth).heightIs(180*FitHeight);
    self.poolIcon.sd_layout.leftSpaceToView(self.backView, 16*FitWidth).topSpaceToView(self.backView, 24*FitHeight).widthIs(20*FitWidth).heightEqualToWidth();
    self.poolNameLabel.sd_layout.leftSpaceToView(self.poolIcon, 12*FitWidth).centerYEqualToView(self.poolIcon).heightIs(36*FitHeight);
    [self.poolNameLabel setSingleLineAutoResizeWithMaxWidth:300];
    self.adressLabel.sd_layout.leftEqualToView(self.poolIcon).topSpaceToView(self.poolIcon, 24*FitHeight).rightSpaceToView(self.backView, 16*FitWidth).autoHeightRatio(0);
    self.moreButton.sd_layout.leftEqualToView(self.poolIcon).topSpaceToView(self.adressLabel, 16*FitHeight).widthIs(120*FitWidth).heightIs(40*FitHeight);
    [self.contentView layoutIfNeeded];
    [self.moreButton setBackgroundImage:[UIImage gradientImageWithBounds:self.moreButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    [self.backView setupAutoHeightWithBottomView:self.moreButton bottomMargin:24*FitHeight];
}
#pragma mark 按钮事件
-(void)moreButtonAction:(UIButton *)btn
{
    if (self.addNowClickBlock) {
        self.addNowClickBlock();
    }
}
#pragma mark 懒加载
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 8;
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = SHTheme.addressTypeCellBackColor;
        [self.contentView addSubview:_backView];
    }
    return _backView;
}
-(UIImageView *)poolIcon
{
    if (_poolIcon == nil) {
        _poolIcon = [[UIImageView alloc]init];
        _poolIcon.image = [UIImage imageNamed:self.cellType == SHPoolCellType?@"poolCell_poolIcon_dark":@"powerCell_powerIcon_dark"];
        [self.backView addSubview:_poolIcon];
    }
    return _poolIcon;
}
-(JLButton *)moreButton
{
    if (_moreButton == nil) {
        _moreButton = [[JLButton alloc]init];
        _moreButton.backgroundColor = SHTheme.passwordInputWithAlphaColor;
        _moreButton.layer.cornerRadius = 20*FitHeight;
        _moreButton.layer.masksToBounds = YES;
        [_moreButton setImage:[UIImage imageNamed:@"addIcon_whight"] forState:UIControlStateNormal];
        _moreButton.imagePosition = JLButtonImagePositionLeft;
        _moreButton.spacingBetweenImageAndTitle = 5;
        [_moreButton setTitle:GCLocalizedString(@"add_wallet_now") forState:UIControlStateNormal];
        [_moreButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _moreButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_moreButton];
    }
    return _moreButton;
}
-(UILabel *)poolNameLabel
{
    if (_poolNameLabel == nil) {
        _poolNameLabel = [[UILabel alloc]init];
        _poolNameLabel.font = kCustomMontserratMediumFont(24);
        _poolNameLabel.textColor = SHTheme.appTopBlackColor;
        _poolNameLabel.text = self.cellType == SHPoolCellType?GCLocalizedString(@"add_observer_link"):GCLocalizedString(@"add_a_power");
        [self.backView addSubview:_poolNameLabel];
    }
    return _poolNameLabel;
}
-(UILabel *)adressLabel
{
    if (_adressLabel == nil) {
        _adressLabel = [[UILabel alloc]init];
        _adressLabel.font = kCustomMontserratRegularFont(14);
        _adressLabel.textColor = SHTheme.setPasswordTipsColor;
        _adressLabel.text = self.cellType == SHPoolCellType?GCLocalizedString(@"poll_empty_hint"):GCLocalizedString(@"power_empty_hint");
        [self.backView addSubview:_adressLabel];
    }
    return _adressLabel;
}
@end
