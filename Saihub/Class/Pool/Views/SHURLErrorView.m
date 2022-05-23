//
//  SHURLErrorView.m
//  Saihub
//
//  Created by macbook on 2022/3/23.
//

#import "SHURLErrorView.h"
@interface SHURLErrorView()
@property (nonatomic, strong) UIImageView *urllinkErrorImageView;
@property (nonatomic, strong)  UILabel*invalidTipsLabel;
@property (nonatomic, strong) UILabel *againTipsLabel;
@end
@implementation SHURLErrorView

#pragma mark 布局页面
-(void)layoutScale
{
    self.urllinkErrorImageView.sd_layout.centerXEqualToView(self).topEqualToView(self).widthIs(41*FitWidth).heightEqualToWidth();
    self.invalidTipsLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.urllinkErrorImageView, 15*FitHeight).heightIs(25*FitHeight);
    [self.invalidTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.againTipsLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.invalidTipsLabel, 4*FitHeight).heightIs(20*FitHeight);
    [self.againTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
}
#pragma mark 懒加载
-(UIImageView *)urllinkErrorImageView
{
    if (_urllinkErrorImageView == nil) {
        _urllinkErrorImageView = [[UIImageView alloc]init];
        _urllinkErrorImageView.image = [UIImage imageNamed:@"SHURLErrorView_errorImageView"];
        [self addSubview:_urllinkErrorImageView];
    }
    return _urllinkErrorImageView;
}
-(UILabel *)invalidTipsLabel
{
    if (_invalidTipsLabel == nil) {
        _invalidTipsLabel = [[UILabel alloc]init];
        _invalidTipsLabel.text = GCLocalizedString(@"invalid_url_link");
        _invalidTipsLabel.font = kMediunFont(18);
        _invalidTipsLabel.textColor = SHTheme.appBlackColor;
        [self addSubview:_invalidTipsLabel];
    }
    return _invalidTipsLabel;
}
-(UILabel *)againTipsLabel
{
    if (_againTipsLabel == nil) {
        _againTipsLabel = [[UILabel alloc]init];
        _againTipsLabel.text = GCLocalizedString(@"please_try_again");
        _againTipsLabel.font = kMediunFont(14);
        _againTipsLabel.textColor = SHTheme.appBlackWithAlphaColor;
        [self addSubview:_againTipsLabel];
    }
    return _againTipsLabel;
}
@end
