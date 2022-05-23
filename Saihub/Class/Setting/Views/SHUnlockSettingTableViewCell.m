//
//  SHUnlockSettingTableViewCell.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHUnlockSettingTableViewCell.h"
@interface SHUnlockSettingTableViewCell()
@property (nonatomic, strong) UIView *backView;
@end
@implementation SHUnlockSettingTableViewCell

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
    self.rightButton.sd_layout.rightSpaceToView(self.backView, 16*FitWidth).centerYEqualToView(self.backView).widthIs(150*FitWidth).heightIs(50*FitHeight);
    self.settingTipsLabel.sd_layout.leftSpaceToView(self.backView, 16*FitWidth).centerYEqualToView(self.backView).heightIs(22*FitHeight);
    [self.settingTipsLabel setSingleLineAutoResizeWithMaxWidth:300];
}
#pragma mark 按钮事件
-(void)rightButtonAction:(UIButton *)btn
{
    if (self.rightButtonClickBlock) {
        self.rightButtonClickBlock(btn);
    }
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

-(UIButton *)rightButton
{
    if (_rightButton == nil) {
        _rightButton = [[UIButton alloc]init];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightButton setImage:[UIImage imageNamed:@"setPassWordVc_passPhraseButton_normal"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"setPassWordVc_passPhraseButton_select"] forState:UIControlStateSelected];
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
