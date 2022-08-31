//
//  SHLNWalletHeaderView.m
//  Saihub
//
//  Created by macbook on 2022/6/21.
//

#import "SHLNWalletHeaderView.h"
#import "SHLNReceiveViewController.h"
#import "SHLNWalletManagerViewController.h"
#import "SHLNTransferViewController.h"
@interface SHLNWalletHeaderView ()

@property (nonatomic,strong) UIImageView *backImageView;

/// 钱包名
@property (nonatomic,strong) UILabel *walletNameLabel;

@property (nonatomic,strong) UIButton *topUpButton;

/// 总余额
@property (nonatomic,strong) UILabel *balanceBtcLabel;
@property (nonatomic,strong) UILabel *balanceBtcCoinLabel;
@property (nonatomic,strong) UILabel *balanceLabel;

@property (nonatomic,strong) UIButton *moreButton;

@property (nonatomic, strong) JLButton *receiveButton;
@property (nonatomic, strong) JLButton *sendButton;

@end

@implementation SHLNWalletHeaderView

- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lnwallet_backImage"]];
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



- (UIButton *)topUpButton {
    if (_topUpButton == nil) {
        _topUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topUpButton.layer.cornerRadius = 15;
        _topUpButton.layer.masksToBounds = YES;
        _topUpButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _topUpButton.layer.borderWidth = 1;
        [_topUpButton setTitle:GCLocalizedString(@"Refill") forState:UIControlStateNormal];
        [_topUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _topUpButton.titleLabel.font = kMediunFont(12);
        [_topUpButton addTarget:self action:@selector(topUpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:_topUpButton];
    }
    return _topUpButton;
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
- (UILabel *)balanceBtcLabel {
    if (_balanceBtcLabel == nil) {
        _balanceBtcLabel = [[UILabel alloc]init];
        _balanceBtcLabel.text = @"2222";
        _balanceBtcLabel.textColor = SHTheme.appWhightColor;
        _balanceBtcLabel.font = kCustomDDINExpBoldFont(40);
        [self.backImageView addSubview:_balanceBtcLabel];
    }
    return _balanceBtcLabel;
}
- (UILabel *)balanceBtcCoinLabel {
    if (_balanceBtcCoinLabel == nil) {
        _balanceBtcCoinLabel = [[UILabel alloc]init];
        _balanceBtcCoinLabel.text = @"2222";
        _balanceBtcCoinLabel.textColor = SHTheme.appWhightColor;
        _balanceBtcCoinLabel.font = kCustomDDINExpBoldFont(23);
        [self.backImageView addSubview:_balanceBtcCoinLabel];
    }
    return _balanceBtcCoinLabel;
}
- (UILabel *)balanceLabel {
    if (_balanceLabel == nil) {
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.text = @"2222";
        _balanceLabel.textColor = SHTheme.appWhightColor;
        _balanceLabel.font = kCustomDDINExpBoldFont(22);
        [self.backImageView addSubview:_balanceLabel];
    }
    return _balanceLabel;
}

-(JLButton *)receiveButton
{
    if (_receiveButton == nil) {
        _receiveButton = [[JLButton alloc]init];
        _receiveButton.backgroundColor = SHTheme.lnWalletButtonBgColor;
        _receiveButton.layer.cornerRadius = 26*FitHeight;
        _receiveButton.layer.masksToBounds = YES;
        [_receiveButton setTitle:GCLocalizedString(@"Receive") forState:UIControlStateNormal];
        [_receiveButton setTitleColor:SHTheme.lnWalletButtonColor forState:UIControlStateNormal];
        _receiveButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_receiveButton setImage:[UIImage imageNamed:@"lnWalletHeader_receive"] forState:UIControlStateNormal];
        _receiveButton.imagePosition = JLButtonImagePositionLeft;
        _receiveButton.spacingBetweenImageAndTitle = 4;
        [_receiveButton addTarget:self action:@selector(receiveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_receiveButton];
    }
    return _receiveButton;
}
-(JLButton *)sendButton
{
    if (_sendButton == nil) {
        _sendButton = [[JLButton alloc]init];
        _sendButton.backgroundColor = SHTheme.lnWalletButtonBgColor;
        _sendButton.layer.cornerRadius = 26*FitHeight;
        _sendButton.layer.masksToBounds = YES;
        [_sendButton setTitle:GCLocalizedString(@"Send") forState:UIControlStateNormal];
        [_sendButton setTitleColor:SHTheme.lnWalletButtonColor forState:UIControlStateNormal];
        _sendButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_sendButton setImage:[UIImage imageNamed:@"lnWalletHeader_send"] forState:UIControlStateNormal];
        _sendButton.spacingBetweenImageAndTitle = 4;

        [_sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendButton];
    }
    return _sendButton;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(20*FitWidth);
            make.width.mas_equalTo(kScreenWidth - 40*FitWidth);
            make.height.mas_equalTo(168*FitHeight);
        }];
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCoinAction)];
        [self.backImageView addGestureRecognizer:addTap];
        [self.walletNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*FitWidth);
            make.top.mas_equalTo(24*FitHeight);
            make.width.mas_lessThanOrEqualTo(150 *FitWidth);
        }];
        

        
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16*FitWidth);
            make.centerY.equalTo(self.walletNameLabel);
        }];
        self.balanceBtcLabel.sd_layout.leftEqualToView(self.walletNameLabel).topSpaceToView(self.walletNameLabel, 30*FitHeight).heightIs(30*FitHeight);
        [self.balanceBtcLabel setSingleLineAutoResizeWithMaxWidth:250*FitWidth];
        self.balanceBtcCoinLabel.sd_layout.leftSpaceToView(self.balanceBtcLabel, 10*FitWidth).bottomEqualToView(self.balanceBtcLabel).heightIs(20*FitHeight);
        [self.balanceBtcCoinLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*FitWidth);
            make.top.equalTo(self.balanceBtcLabel.mas_bottom).offset(10*FitHeight);
            make.right.mas_equalTo(-20*FitWidth);
            make.height.mas_equalTo(22*FitHeight);
        }];
        self.topUpButton.sd_layout.rightEqualToView(self.moreButton).centerYEqualToView(self.balanceLabel).widthIs(72*FitWidth).heightIs(30*FitHeight);

        self.receiveButton.sd_layout.leftSpaceToView(self, 42*FitWidth).topSpaceToView(self.backImageView, 24*FitHeight).widthIs(136*FitWidth).heightIs(52*FitHeight);
        self.sendButton.sd_layout.rightSpaceToView(self, 42*FitWidth).topSpaceToView(self.backImageView, 24*FitHeight).widthIs(136*FitWidth).heightIs(52*FitHeight);

    }
    return self;
}

-(void)setLnWalletModel:(SHLNWalletModel *)lnWalletModel
{
    _lnWalletModel = lnWalletModel;
    self.walletNameLabel.text = lnWalletModel.WalletName;
    self.balanceBtcLabel.text = IsEmpty(lnWalletModel.balance)?@"0":(lnWalletModel.isBTCCoin?[NSString removeFloatAllZeroByString:[NSString stringWithFormat:@"%.8lf",[lnWalletModel.balance longLongValue] * pow(10, -8)]]:lnWalletModel.balance);
    self.balanceBtcCoinLabel.text = lnWalletModel.isBTCCoin?@"BTC":GCLocalizedString(@"sats");
    NSString *rate = [SHKeyStorage shared].btcRate;
    self.balanceLabel.text = [NSString stringWithFormat:@"%@%@",KAppSetting.currencySymbol,[NSString removeFloatAllZeroByString:IsEmpty(lnWalletModel.balance)?@"0":[NSString digitStringWithValue:[[NSString stringWithFormat:@"%.8lf",[lnWalletModel.balance longLongValue] * pow(10, -8)] to_multiplyingWithStr:rate] count:6]]];
    self.topUpButton.hidden = IsEmpty([SHKeyStorage shared].currentLNWalletModel.btcAddress);
}
-(void)changeCoinAction
{
    if ([self.balanceBtcCoinLabel.text isEqualToString:GCLocalizedString(@"sats")]) {
            self.balanceBtcLabel.text = [NSString removeFloatAllZeroByString:[NSString stringWithFormat:@"%.8lf",[self.lnWalletModel.balance longLongValue] * pow(10, -8)]];
            self.balanceBtcCoinLabel.text = @"BTC";
        [[SHKeyStorage shared] updateModelBlock:^{
            self.lnWalletModel.isBTCCoin = YES;
        }];
    }else
    {
        self.balanceBtcLabel.text = self.lnWalletModel.balance;
        self.balanceBtcCoinLabel.text = GCLocalizedString(@"sats");
        [[SHKeyStorage shared] updateModelBlock:^{
            self.lnWalletModel.isBTCCoin = NO;
        }];
    }
}
#pragma mark -- 跳转到管理钱包
- (void)moreButtonClick {
    [[CTMediator sharedInstance].topViewController.navigationController pushViewController:[SHLNWalletManagerViewController new] animated:YES];
}
-(void)receiveButtonAction:(UIButton *)btn
{
    [[CTMediator sharedInstance].topViewController.navigationController pushViewController:[SHLNReceiveViewController new] animated:YES];
}
-(void)sendButtonAction:(UIButton *)btn
{
    [[CTMediator sharedInstance].topViewController.navigationController pushViewController:[SHLNTransferViewController new] animated:YES];
}
-(void)topUpButtonClick:(UIButton *)btn
{
    if (self.topUpButtonClickBlock) {
        self.topUpButtonClickBlock();
    }
}
@end
