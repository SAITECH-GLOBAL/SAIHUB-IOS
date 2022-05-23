//
//  SHMultipleSignatureTableViewCell.m
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHMultipleSignatureTableViewCell.h"
@interface SHMultipleSignatureTableViewCell ()



@end
@implementation SHMultipleSignatureTableViewCell

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
    self.backView.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).topSpaceToView(self.contentView, 0).heightIs(52*FitHeight);
    self.signedIndexNameLabel.sd_layout.centerYEqualToView(self.backView).leftSpaceToView(self.backView, 16*FitWidth).heightIs(22*FitHeight);
    [self.signedIndexNameLabel setSingleLineAutoResizeWithMaxWidth:250*FitWidth];
    self.signStatusBackView.sd_layout.rightSpaceToView(self.backView, 16*FitWidth).centerYEqualToView(self.backView).widthIs(32*FitWidth).heightEqualToWidth();
    self.signStatusImageView.sd_layout.centerXEqualToView(self.signStatusBackView).centerYEqualToView(self.signStatusBackView).widthIs(20*FitWidth).heightEqualToWidth();
}
#pragma mark 懒加载
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 8;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = SHTheme.intensityGreenWithAlphaColor;
        [self.contentView addSubview:_backView];
    }
    return _backView;
}
-(UILabel *)signedIndexNameLabel
{
    if (_signedIndexNameLabel == nil) {
        _signedIndexNameLabel = [[UILabel alloc]init];
        _signedIndexNameLabel.font = kCustomMontserratMediumFont(14);
        _signedIndexNameLabel.textColor = SHTheme.appBlackColor;
        _signedIndexNameLabel.text = @"--";
        [self.backView addSubview:_signedIndexNameLabel];
    }
    return _signedIndexNameLabel;
}
-(UIImageView *)signStatusImageView
{
    if (_signStatusImageView == nil) {
        _signStatusImageView = [[UIImageView alloc]init];
        _signStatusImageView.image = [UIImage imageNamed:@"multipleSignatureCell_succese"];
        [self.signStatusBackView addSubview:_signStatusImageView];
    }
    return _signStatusImageView;
}
- (UIView *)signStatusBackView
{
    if (_signStatusBackView == nil) {
        _signStatusBackView = [[UIView alloc]init];
        _signStatusBackView.layer.cornerRadius = 16*FitWidth;
        _signStatusBackView.layer.masksToBounds = YES;
        _signStatusBackView.backgroundColor = SHTheme.intensityGreenColor;
        [self.backView addSubview:_signStatusBackView];
    }
    return _signStatusBackView;
}
@end
