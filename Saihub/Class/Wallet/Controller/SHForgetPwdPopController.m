//
//  SHForgetPwdPopController.m
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import "SHForgetPwdPopController.h"

@interface SHForgetPwdPopController () <HWPanModalPresentable>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *resetButton;

/// 高度
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation SHForgetPwdPopController

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = SHTheme.appWhightColor;
        _contentView.layer.cornerRadius = 16;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"forgetPwd_closeButton"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_closeButton];
    }
    return _closeButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = SHTheme.appBlackColor;
        _titleLabel.font = kCustomMontserratMediumFont(24);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = GCLocalizedString(@"forget_pwdPopView_title");
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.text = GCLocalizedString(@"forget_pwdPopView_subTitle");
        _subTitleLabel.textColor = SHTheme.appBlackColor;
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.font = kCustomMontserratRegularFont(14);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UIButton *)resetButton {
    if (_resetButton == nil) {
        _resetButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_resetButton setTitle:GCLocalizedString(@"Reset") forState:UIControlStateNormal];
        [_resetButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _resetButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_resetButton setBackgroundImage:[UIImage gradientImageWithBounds:CGRectMake(0, 0, kScreenWidth - 80 *FitWidth - 40, 40 *FitWidth) andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        _resetButton.layer.cornerRadius = 20 *FitWidth;
        _resetButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_resetButton];
    }
    return _resetButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40 *FitWidth);
        make.right.mas_equalTo(-40 *FitWidth);
        make.centerY.mas_equalTo(-kNavBarHeight);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(40);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40 *FitWidth);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(24);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-40);
    }];
        
}

#pragma mark -- 关闭
- (void)closeButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 重置
- (void)resetButtonClick {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.pushResetPwdBlock) {
            self.pushResetPwdBlock();
        }
    }];
}

#pragma mark -- HWPanModalPresentable 代理
- (BOOL)showDragIndicator {
    return NO;
}

- (HWBackgroundConfig *)backgroundConfig {
    HWBackgroundConfig *backgroundConfig;

    backgroundConfig = [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorDefault];
    return backgroundConfig;
}


@end
