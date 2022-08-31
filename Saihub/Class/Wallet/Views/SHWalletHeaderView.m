//
//  SHWalletHeaderView.m
//  Saihub
//
//  Created by 周松 on 2022/2/23.
//

#import "SHWalletHeaderView.h"
#import "SHReceiveAddressController.h"
#import "CTMediator+SHModule.h"
#import "SHWalletManagerController.h"
@interface SHWalletHeaderView ()

@property (nonatomic,strong) UIImageView *backImageView;


@property (nonatomic,strong) UIButton *qrCodeButton;

/// 总余额
@property (nonatomic,strong) UILabel *balanceLabel;

@property (nonatomic,strong) UIButton *moreButton;

@property (nonatomic,strong) UILabel *assetTitleLabel;

@end

@implementation SHWalletHeaderView

- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wallet_backImage"]];
        [self addSubview:_backImageView];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (UILabel *)walletNameLabel {
    if (_walletNameLabel == nil) {
        _walletNameLabel = [[UILabel alloc]init];
        _walletNameLabel.text = @"BTC";
        _walletNameLabel.textColor = SHTheme.appWhightColor;
        _walletNameLabel.font = kCustomMontserratMediumFont(14);
        [self.backImageView addSubview:_walletNameLabel];
    }
    return _walletNameLabel;
}

- (UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = @"bc1a9e91e9..25cbC26D";
        _addressLabel.textColor = [SHTheme.appWhightColor colorWithAlphaComponent:0.7];
        _addressLabel.font = kCustomMontserratMediumFont(12);
        [self.backImageView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UIButton *)qrCodeButton {
    if (_qrCodeButton == nil) {
        _qrCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qrCodeButton setImage:[UIImage imageNamed:@"wallet_receiveQrCodeImage"] forState:UIControlStateNormal];
        [_qrCodeButton addTarget:self action:@selector(qrCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:_qrCodeButton];
    }
    return _qrCodeButton;
}

- (UIButton *)moreButton {
    if (_moreButton == nil) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"wallet_moreButton"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:_moreButton];
    }
    return _moreButton;
}

- (UILabel *)balanceLabel {
    if (_balanceLabel == nil) {
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.text = @"2222";
        _balanceLabel.textColor = SHTheme.appWhightColor;
        _balanceLabel.font = kCustomDDINExpBoldFont(48);
        [self.backImageView addSubview:_balanceLabel];
    }
    return _balanceLabel;
}

- (UILabel *)assetTitleLabel {
    if (_assetTitleLabel == nil) {
        _assetTitleLabel = [[UILabel alloc]init];
        _assetTitleLabel.text = GCLocalizedString(@"wallet_assetTitle");
        _assetTitleLabel.textColor = SHTheme.walletTextColor;
        _assetTitleLabel.font = kCustomMontserratMediumFont(14);
        [self addSubview:_assetTitleLabel];
    }
    return _assetTitleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(20);
            make.width.mas_equalTo(kScreenWidth - 40);
            make.height.mas_equalTo(168);
        }];
        
        [self.walletNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(24);
            make.width.mas_lessThanOrEqualTo(150 *FitWidth);
        }];
        
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.walletNameLabel);
            make.top.equalTo(self.walletNameLabel.mas_bottom).offset(12);
        }];
        
        [self.qrCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressLabel.mas_right).offset(4);
            make.centerY.equalTo(self.addressLabel);
        }];
        
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.centerY.equalTo(self.walletNameLabel);
        }];
        
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.equalTo(self.addressLabel.mas_bottom).offset(26);
            make.right.mas_equalTo(-20);
        }];
        
        [self.assetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

#pragma mark -- 跳转到收款码
- (void)qrCodeButtonClick {
    SHReceiveAddressController *receiveAddressVc = [[SHReceiveAddressController alloc]init];
    receiveAddressVc.address = [SHKeyStorage shared].currentWalletModel.address;
    [[CTMediator sharedInstance].topViewController.navigationController pushViewController:receiveAddressVc animated:YES];
}

#pragma mark -- 跳转到管理钱包
- (void)moreButtonClick {
    SHWalletManagerController *walletManagerVc = [[SHWalletManagerController alloc]init];
    [[CTMediator sharedInstance].topViewController.navigationController pushViewController:walletManagerVc animated:YES];
}

- (void)setWalletModel:(SHWalletModel *)walletModel {
    _walletModel = walletModel;
    
    self.addressLabel.text = [walletModel.address formatAddressStrLeft:6 right:6];
    
    self.walletNameLabel.text = walletModel.name;
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%@%@",KAppSetting.currencySymbol,[NSString digitStringWithValue:walletModel.balance count:2]];
}

@end
