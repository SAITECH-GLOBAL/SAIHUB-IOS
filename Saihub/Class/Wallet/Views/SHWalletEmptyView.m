//
//  SHWalletEmptyView.m
//  Saihub
//
//  Created by 周松 on 2022/3/5.
//

#import "SHWalletEmptyView.h"
#import "SHSetWalletPassWordViewController.h"
#import "SHCreatLNWalletViewController.h"
@interface SHWalletEmptyView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) YYLabel *addWalletLabel;

@end

@implementation SHWalletEmptyView

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wallet_emptyImage"]];
        [self addSubview:_backgroundImageView];
    }
    return _backgroundImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = GCLocalizedString(@"add_wallet");
        _titleLabel.font = kCustomMontserratMediumFont(24);
        _titleLabel.textColor = SHTheme.walletTextColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.text = GCLocalizedString(@"add_wallet_tip");
        _desLabel.textColor = SHTheme.agreeTipsLabelColor;
        _desLabel.font = kCustomMontserratRegularFont(12);
        _desLabel.numberOfLines = 0;
        [self addSubview:_desLabel];
    }
    return _desLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(20);
        }];
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        }];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setTitle:[NSString stringWithFormat:@"%@",GCLocalizedString(@"Add_now")] forState:UIControlStateNormal];

        [addButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        addButton.titleLabel.font = kCustomMontserratMediumFont(14);
        addButton.layer.cornerRadius = 19;
        addButton.layer.masksToBounds = YES;
        addButton.contentEdgeInsets = UIEdgeInsetsMake(10, 36, 10, 18);
        [addButton addTarget:self action:@selector(addWalletEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
        
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.bottom.equalTo(self.mas_bottom).offset(-20);
        }];
        
        [self layoutIfNeeded];

        [addButton setBackgroundImage:[UIImage gradientImageWithBounds:addButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = SHTheme.appWhightColor;
        line1.layer.cornerRadius = 1;
        [addButton addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(21);
            make.centerY.equalTo(addButton);
            make.size.mas_equalTo(CGSizeMake(9.7, 2));
        }];

        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = SHTheme.appWhightColor;
        line2.layer.cornerRadius = 1;
        [addButton addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(line1);
            make.size.mas_equalTo(CGSizeMake(2, 9.7));
        }];

    }
    return self;
}

/// 添加钱包
- (void)addWalletEvent {

    
    if ([SHKeyStorage shared].isLNWallet) {
        if ([SHLNWalletModel allObjects].count >=10) {
            [MBProgressHUD  showError:GCLocalizedString(@"wallet_num_tip") toView:nil];
            return;
        }
        [[CTMediator sharedInstance].topViewController.navigationController pushViewController:[SHCreatLNWalletViewController new] animated:YES];
    }else
    {
        if ([SHWalletModel allObjects].count >=10) {
            [MBProgressHUD  showError:GCLocalizedString(@"wallet_num_tip") toView:nil];
            return;
        }
        [[CTMediator sharedInstance].topViewController.navigationController pushViewController:[SHSetWalletPassWordViewController new] animated:YES];
    }
}

@end
