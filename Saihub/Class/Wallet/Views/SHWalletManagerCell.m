//
//  SHWalletManagerCell.m
//  Saihub
//
//  Created by 周松 on 2022/2/24.
//

#import "SHWalletManagerCell.h"

@interface SHWalletManagerCell ()

@property (nonatomic,strong) UIView *containerView;

@end

@implementation SHWalletManagerCell

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc]init];
        _containerView.layer.cornerRadius = 8;
        _containerView.backgroundColor = SHTheme.addressTypeCellBackColor;
        [self.contentView addSubview:_containerView];
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"--";
        _titleLabel.textColor = SHTheme.appBlackColor;
        _titleLabel.font = kCustomMontserratRegularFont(14);
        [self.containerView addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UILabel *)rightValueLabel
{
    if (_rightValueLabel == nil) {
        _rightValueLabel = [[UILabel alloc]init];
        _rightValueLabel.text = @"--";
        _rightValueLabel.hidden = YES;
        _rightValueLabel.textColor = SHTheme.appBlackColor;
        _rightValueLabel.font = kCustomMontserratRegularFont(14);
        [self.containerView addSubview:_rightValueLabel];
    }
    return _rightValueLabel;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"walletManage_arrowImage"]];
        [self.containerView addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (UISwitch *)switchButton {
    if (_switchButton == nil) {
        _switchButton = [[UISwitch alloc]init];
        _switchButton.on = YES;
        _switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
        _switchButton.thumbTintColor = SHTheme.appWhightColor;
        _switchButton.onTintColor = SHTheme.switchOnColor;
        [_switchButton addTarget:self action:@selector(switchButtonCLick:) forControlEvents:UIControlEventValueChanged];
        [self.containerView addSubview:_switchButton];
    }
    return _switchButton;
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
        make.height.mas_equalTo(52);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(170 *FitWidth);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.rightValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-35);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setCellType:(SHManageWalletCellType)cellType {
    _cellType = cellType;
    if (cellType == SHManageWalletNoneCellType) {
        self.arrowImageView.hidden = NO;
        self.switchButton.hidden = YES;
    } else if (cellType == SHManageWalletSwitchCellType) {
        self.arrowImageView.hidden = YES;
        self.switchButton.hidden = NO;
    }
}

- (void)switchButtonCLick:(UISwitch *)switchButton {
    if (self.switchButtonClickBlock) {
        self.switchButtonClickBlock(switchButton);
    }
}

@end
