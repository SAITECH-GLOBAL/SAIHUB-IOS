//
//  SHMinerFeeView.m
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHMinerFeeView.h"
@interface SHMinerFeeView ()


@end
@implementation SHMinerFeeView
#pragma mark 布局页面
-(void)layoutScale
{
    self.userInteractionEnabled = YES;
    self.feeTypeNameLabel.sd_layout.topSpaceToView(self, 8*FitHeight).leftEqualToView(self).rightEqualToView(self).heightIs(22*FitHeight);
    self.feeValueBtcLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.feeTypeNameLabel, 6*FitHeight).heightIs(14*FitHeight);
    [self.feeValueBtcLabel setSingleLineAutoResizeWithMaxWidth:100*FitWidth];
    self.feeValueMoneyLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.feeValueBtcLabel, 8*FitHeight).heightIs(18*FitHeight);
    [self.feeValueMoneyLabel setSingleLineAutoResizeWithMaxWidth:100*FitWidth];
    self.backButton.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(self).bottomEqualToView(self);
}
#pragma mark 按钮事件
-(void)backButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self loadSelectViewWithBool:btn.selected];
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock();
    }
}
-(void)loadSelectViewWithBool:(BOOL)select
{
    if (select) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = SHTheme.agreeButtonColor.CGColor;
        self.backgroundColor = SHTheme.labelBackgroundColor;
        self.feeTypeNameLabel.textColor = SHTheme.agreeButtonColor;
        self.feeValueBtcLabel.textColor = SHTheme.agreeButtonColor;
        self.feeValueMoneyLabel.textColor = SHTheme.agreeButtonColor;
        self.feeTypeNameLabel.font = kCustomMontserratMediumFont(14);
    }else
    {
        self.layer.borderWidth = 0;
        self.layer.borderColor = SHTheme.agreeButtonColor.CGColor;
        self.backgroundColor = SHTheme.addressTypeCellBackColor;
        self.feeTypeNameLabel.textColor = SHTheme.agreeTipsLabelColor;
        self.feeValueBtcLabel.textColor = SHTheme.agreeTipsLabelColor;
        self.feeValueMoneyLabel.textColor = SHTheme.agreeTipsLabelColor;
        self.feeTypeNameLabel.font = kCustomMontserratRegularFont(14);
    }
}
#pragma mark 懒加载
-(UIButton *)backButton
{
    if (_backButton == nil) {
        _backButton = [[UIButton alloc]init];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
    }
    return _backButton;
}
-(UILabel *)feeTypeNameLabel
{
    if (_feeTypeNameLabel == nil) {
        _feeTypeNameLabel = [[UILabel alloc]init];
        _feeTypeNameLabel.font = kCustomMontserratRegularFont(14);
        _feeTypeNameLabel.textColor = SHTheme.agreeTipsLabelColor;
        _feeTypeNameLabel.text = @"";
        _feeTypeNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_feeTypeNameLabel];
    }
    return _feeTypeNameLabel;
}
-(UILabel *)feeValueBtcLabel
{
    if (_feeValueBtcLabel == nil) {
        _feeValueBtcLabel = [[UILabel alloc]init];
        _feeValueBtcLabel.font = kCustomDDINExpBoldFont(12);
        _feeValueBtcLabel.textColor = SHTheme.agreeTipsLabelColor;
        _feeValueBtcLabel.text = @"";
        [self addSubview:_feeValueBtcLabel];
    }
    return _feeValueBtcLabel;
}
-(UILabel *)feeValueMoneyLabel
{
    if (_feeValueMoneyLabel == nil) {
        _feeValueMoneyLabel = [[UILabel alloc]init];
        _feeValueMoneyLabel.font = kCustomDDINExpFont(12);
        _feeValueMoneyLabel.textColor = SHTheme.agreeTipsLabelColor;
        _feeValueMoneyLabel.text = @"";
        [self addSubview:_feeValueMoneyLabel];
    }
    return _feeValueMoneyLabel;
}
@end
