//
//  SHCompleteView.m
//  Saihub
//
//  Created by 周松 on 2022/3/1.
//

#import "SHCompleteView.h"

@interface SHCompleteView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *completeImageView;

@property (nonatomic, strong) UILabel *completeLabel;

@property (nonatomic, strong) UIButton *okButton;

@end

@implementation SHCompleteView

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = SHTheme.appWhightColor;
        _contentView.layer.cornerRadius = 16;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UIImageView *)completeImageView {
    if (_completeImageView == nil) {
        _completeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wallet_completeImage"]];//wallet_faileImage
        [self.contentView addSubview:_completeImageView];
    }
    return _completeImageView;
}

- (UILabel *)completeLabel {
    if (_completeLabel == nil) {
        _completeLabel = [[UILabel alloc]init];
        _completeLabel.textColor = SHTheme.appBlackColor;
        _completeLabel.font = kCustomMontserratRegularFont(14);
        [self.contentView addSubview:_completeLabel];
    }
    return _completeLabel;
}

- (UIButton *)okButton {
    if (_okButton == nil) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okButton setTitle:GCLocalizedString(@"OK") forState:UIControlStateNormal];
        [_okButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_okButton setBackgroundImage:[UIImage gradientImageWithBounds:CGRectMake(0, 0, kScreenWidth - 80 *FitWidth - 40, 40 *FitWidth) andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        _okButton.layer.cornerRadius = 20 *FitWidth;
        _okButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_okButton];
    }
    return _okButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
//        UIView *tapView = [[UIView alloc]init];
//        tapView.backgroundColor = [UIColor clearColor];
//        [self addSubview:tapView];
//        [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsZero);
//        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40 *FitWidth);
            make.right.mas_equalTo(-40 *FitWidth);
            make.centerY.mas_equalTo(-kNavBarHeight);
        }];
        
        [self.completeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(40);
        }];
        
        [self.completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.completeImageView.mas_bottom).offset(3);
        }];
        
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.completeLabel.mas_bottom).offset(24);
            make.height.mas_equalTo(40 *FitWidth);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-40);
        }];
        
        MJWeakSelf
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//            [weakSelf dismissAnimated:YES completion:^{
//
//            }];
//        }];
//        [tapView addGestureRecognizer:tap];
    }
    return self;
}
-(void)setCompleteViewType:(CompleteViewType)completeViewType
{
    _completeViewType = completeViewType;
    switch (completeViewType) {
        case CompleteViewSucceseType:
        {
            _completeImageView.image = [UIImage imageNamed:@"wallet_completeImage"];
            _completeLabel.text = GCLocalizedString(@"Complete");
        }
            break;
        case CompleteViewFailType:
        {
            _completeImageView.image = [UIImage imageNamed:@"wallet_faileImage"];
            _completeLabel.text = GCLocalizedString(@"Load_failure");
        }
            break;
        case CompleteViewAddressExistsFailType:
        {
            _completeImageView.image = [UIImage imageNamed:@"wallet_faileImage"];
            _completeLabel.text = GCLocalizedString(@"address_already_exists");
        }
            break;
        default:
            break;
    }

}
- (void)okButtonClick {
    [self dismissAnimated:YES completion:^{
        if (self.completeBlock) {
            self.completeBlock();
        }
    }];
}

- (BOOL)showDragIndicator {
    return NO;
}

- (BOOL)allowsDragToDismiss {
    return NO;
}

- (BOOL)allowsTapBackgroundToDismiss {
    return NO;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, kScreenHeight);
}

@end
