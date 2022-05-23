//
//  SHBottomAlertView.m
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import "SHBottomAlertView.h"
@interface SHBottomAlertView ()
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIImageView *closeView;

@end
@implementation SHBottomAlertView

- (instancetype)initWithFrame:(CGRect)frame withcontainerHeight:(float)containerHeight withBottomAlertType:(bottomAlertType)alerType{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.containerHeight = containerHeight;
        [self.whightBackView addSubview:self.closeView];
        self.closeView.sd_layout.centerXEqualToView(self.whightBackView).topSpaceToView(self.whightBackView, 8*FitHeight).widthIs(24*FitWidth).heightEqualToWidth();
        [self.whightBackView addSubview:self.closeButton];
        self.closeButton.sd_layout.centerXEqualToView(self.whightBackView).topSpaceToView(self.whightBackView, 0).widthIs(kWIDTH).heightIs(35*FitHeight);
        NSArray *poolMoreTitle = [NSArray new];
        switch (alerType) {
            case bottomAlertPoolType:
            {
                poolMoreTitle = @[GCLocalizedString(@"copy_url"),GCLocalizedString(@"Edit"),GCLocalizedString(@"Delete")];
            }
                break;
            case bottomAlertPowerType:
            {
                poolMoreTitle = @[GCLocalizedString(@"Edit"),GCLocalizedString(@"Delete")];
            }
                break;
            case bottomAlertAdressBookType:
            {
                poolMoreTitle = @[GCLocalizedString(@"copy_address"),GCLocalizedString(@"Edit"),GCLocalizedString(@"Delete")];
            }
                break;
            default:
                break;
        }
        for (NSInteger i=0; i<poolMoreTitle.count; i++) {
            UIButton *poolMoreButton =[[UIButton alloc]init];
            [self addSubview:poolMoreButton];
            poolMoreButton.sd_layout.centerXEqualToView(self).topSpaceToView(self.closeView, 8*FitHeight + 68*FitHeight *i).widthIs(335*FitWidth).heightIs(52*FitHeight);
            poolMoreButton.layer.cornerRadius = 8;
            poolMoreButton.layer.masksToBounds = YES;
            poolMoreButton.backgroundColor = SHTheme.addressTypeCellBackColor;
            [poolMoreButton setTitle:poolMoreTitle[i] forState:UIControlStateNormal];
            [poolMoreButton setTitleColor:SHTheme.appBlackColor forState:UIControlStateNormal];
            poolMoreButton.tag = i;
            poolMoreButton.titleLabel.font = kCustomMontserratRegularFont(14);
            [poolMoreButton setTarget:self action:@selector(poolMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}
#pragma mark 按钮事件
-(void)poolMoreButtonAction:(UIButton *)btn
{
    [self removeChnageWalletView];
    if (self.poolMoreClickBlock) {
        self.poolMoreClickBlock(btn.tag);
    }
}
//移除控件
- (void)removeChnageWalletView {
    [self dismissAnimated:YES completion:^{

    }];
}
-(void)closeButtonAction:(UIButton *)btn
{
}
#pragma mark 懒加载
- (UIView *)whightBackView {
    if (_whightBackView == nil) {
        _whightBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.containerHeight + 35*FitHeight)];
        _whightBackView.backgroundColor = [UIColor whiteColor];
        _whightBackView.userInteractionEnabled = YES;
        _whightBackView.layer.masksToBounds = YES;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(32, 32)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _whightBackView.bounds;
        maskLayer.path = maskPath.CGPath;
        _whightBackView.layer.mask = maskLayer;
        [self addSubview:_whightBackView];
    }
    return _whightBackView;
}
-(UIButton *)closeButton
{
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.whightBackView addSubview:_closeButton];
    }
    return _closeButton;
}
- (UIImageView *)closeView
{
    if (_closeView == nil) {
        _closeView = [[UIImageView alloc]init];
        _closeView.image = [UIImage imageNamed:@"BottomAlertVc_closeImageVeiw"];
        [self addSubview:_closeView];
    }
    return _closeView;
}
#pragma mark -- HWPanModalPresentable 代理
- (BOOL)showDragIndicator {
    return NO;
}
- (BOOL)allowsTapBackgroundToDismiss {
    return YES;
}
// 顶部距离
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, KScreenHeight - self.containerHeight - 35*FitHeight);
}
- (void)panModalDidDismissed
{
    if (self.closeClickBlock) {
        self.closeClickBlock();
    }
}

@end
