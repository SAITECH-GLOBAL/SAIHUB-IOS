//
//  SHSettingTableViewCell.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHSettingTableViewCell.h"
@interface SHSettingTableViewCell()
@property (nonatomic, strong) UIView *backView;
@end
@implementation SHSettingTableViewCell

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
    self.backView.sd_layout.centerXEqualToView(self.contentView).topSpaceToView(self.contentView, 16*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    self.rightButton.sd_layout.rightSpaceToView(self.backView, 16*FitWidth).centerYEqualToView(self.backView).widthIs(150*FitWidth).heightEqualToWidth();
    self.settingTipsLabel.sd_layout.leftSpaceToView(self.backView, 16*FitWidth).centerYEqualToView(self.backView).heightIs(22*FitHeight);
    [self.settingTipsLabel setSingleLineAutoResizeWithMaxWidth:300];
}
#pragma mark 按钮事件
-(void)rightButtonAction:(UIButton *)btn
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

-(JLButton *)rightButton
{
    if (_rightButton == nil) {
        _rightButton = [[JLButton alloc]init];
        [_rightButton setTitle:@"" forState:UIControlStateNormal];
        [_rightButton setTitleColor:SHTheme.pageUnselectColor forState:UIControlStateNormal];
        _rightButton.titleLabel.font = kCustomMontserratRegularFont(12);
        _rightButton.imagePosition = JLButtonImagePositionRight;
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightButton setImage:[UIImage imageNamed:@"settingVc_rightButton"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_rightButton];
    }
    return _rightButton;
}
-(UILabel *)settingTipsLabel
{
    if (_settingTipsLabel == nil) {
        _settingTipsLabel = [[UILabel alloc]init];
        _settingTipsLabel.font = kCustomMontserratRegularFont(14);
        _settingTipsLabel.textColor = SHTheme.appBlackColor;
        [self.backView addSubview:_settingTipsLabel];
    }
    return _settingTipsLabel;
}
@end
