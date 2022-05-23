//
//  SHDeveceOffline.m
//  Saihub
//
//  Created by macbook on 2022/3/29.
//

#import "SHDeveceOffline.h"
@interface SHDeveceOffline()
@property (nonatomic, strong) UIImageView *urllinkErrorImageView;
@property (nonatomic, strong)  UILabel*invalidTipsLabel;
@end
@implementation SHDeveceOffline

#pragma mark 布局页面
-(void)layoutScale
{
    self.urllinkErrorImageView.sd_layout.centerXEqualToView(self).topEqualToView(self).widthIs(45*FitWidth).heightEqualToWidth();
    self.invalidTipsLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.urllinkErrorImageView, 18*FitHeight).heightIs(20*FitHeight);
    [self.invalidTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
}
#pragma mark 懒加载
-(UIImageView *)urllinkErrorImageView
{
    if (_urllinkErrorImageView == nil) {
        _urllinkErrorImageView = [[UIImageView alloc]init];
        _urllinkErrorImageView.image = [UIImage imageNamed:@"SHdeviceOfflineView_errorImageView"];
        [self addSubview:_urllinkErrorImageView];
    }
    return _urllinkErrorImageView;
}
-(UILabel *)invalidTipsLabel
{
    if (_invalidTipsLabel == nil) {
        _invalidTipsLabel = [[UILabel alloc]init];
        _invalidTipsLabel.text = GCLocalizedString(@"Device_offline_tips");
        _invalidTipsLabel.font = kMediunFont(14);
        _invalidTipsLabel.textColor = SHTheme.appBlackWithAlphaColor;
        [self addSubview:_invalidTipsLabel];
    }
    return _invalidTipsLabel;
}

@end
