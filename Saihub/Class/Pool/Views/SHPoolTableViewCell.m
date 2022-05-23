//
//  SHPoolTableViewCell.m
//  Saihub
//
//  Created by macbook on 2022/2/24.
//

#import "SHPoolTableViewCell.h"
@interface SHPoolTableViewCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *poolIcon;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *poolNameLabel;
@property (nonatomic, strong) UILabel *adressLabel;
@end
@implementation SHPoolTableViewCell

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
    }
    return self;
}
-(void)setCellType:(poolOrPowerCellTye)cellType
{
    _cellType = cellType;
    [self setConstraints];
}
- (void)setConstraints {
    self.backView.sd_layout.centerXEqualToView(self.contentView).topSpaceToView(self.contentView, 16*FitHeight).widthIs(335*FitWidth).heightIs(112*FitHeight);
    self.poolIcon.sd_layout.leftSpaceToView(self.backView, 16*FitWidth).topSpaceToView(self.backView, 20*FitHeight).widthIs(24*FitWidth).heightEqualToWidth();
    self.moreButton.sd_layout.rightSpaceToView(self.backView, 16*FitWidth).topSpaceToView(self.backView, 16*FitHeight).widthIs(32*FitWidth).heightEqualToWidth();
    self.poolNameLabel.sd_layout.leftEqualToView(self.poolIcon).topSpaceToView(self.poolIcon, 8*FitHeight).heightIs(22*FitHeight);
    [self.poolNameLabel setSingleLineAutoResizeWithMaxWidth:300];
    self.adressLabel.sd_layout.leftEqualToView(self.poolNameLabel).topSpaceToView(self.poolNameLabel, 8*FitHeight).heightIs(12*FitHeight);
    [self.adressLabel setSingleLineAutoResizeWithMaxWidth:300];
}
-(void)setPoolModel:(SHPoolListModel *)poolModel
{
    _poolModel = poolModel;
    self.poolNameLabel.text = poolModel.poolName;
    self.adressLabel.text = (poolModel.poolUrl.length >10)?[NSString stringWithFormat:@"...%@",[poolModel.poolUrl substringFromIndex:poolModel.poolUrl.length - 10]]:poolModel.poolUrl;
}
-(void)setPowerModel:(SHPowerListModel *)powerModel
{
    _powerModel = powerModel;
    self.poolNameLabel.text = powerModel.powerName;
    self.adressLabel.text = powerModel.powerValue;
}
#pragma mark 按钮事件
-(void)moreButtonAction:(UIButton *)btn
{
    if (self.moreClickBlock) {
        self.moreClickBlock();
    }
}
#pragma mark 懒加载
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 8;
        _backView.backgroundColor = SHTheme.passwordInputWithAlphaColor;
        [self.contentView addSubview:_backView];
    }
    return _backView;
}
-(UIImageView *)poolIcon
{
    if (_poolIcon == nil) {
        _poolIcon = [[UIImageView alloc]init];
        _poolIcon.image = [UIImage imageNamed:self.cellType == SHPoolCellType?@"poolCell_poolIcon":@"powerlCell_powerIcon" ];
        [self.backView addSubview:_poolIcon];
    }
    return _poolIcon;
}
-(UIButton *)moreButton
{
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc]init];
        _moreButton.backgroundColor = SHTheme.passwordInputWithAlphaColor;
        _moreButton.layer.cornerRadius = 4;
        _moreButton.layer.masksToBounds = YES;
        [_moreButton setImage:[UIImage imageNamed:@"poolCell_moreButton"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_moreButton];
    }
    return _moreButton;
}
-(UILabel *)poolNameLabel
{
    if (_poolNameLabel == nil) {
        _poolNameLabel = [[UILabel alloc]init];
        _poolNameLabel.font = kCustomMontserratMediumFont(20);
        _poolNameLabel.textColor = SHTheme.appTopBlackColor;
        _poolNameLabel.text = @"--";
        [self.backView addSubview:_poolNameLabel];
    }
    return _poolNameLabel;
}
-(UILabel *)adressLabel
{
    if (_adressLabel == nil) {
        _adressLabel = [[UILabel alloc]init];
        _adressLabel.font = kCustomDDINExpBoldFont(12);
        _adressLabel.textColor = SHTheme.walletNameLabelColor;
        _adressLabel.text = @"--";
        [self.backView addSubview:_adressLabel];
    }
    return _adressLabel;
}
@end
