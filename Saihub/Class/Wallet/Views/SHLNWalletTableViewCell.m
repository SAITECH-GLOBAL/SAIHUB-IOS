//
//  SHLNWalletTableViewCell.m
//  Saihub
//
//  Created by macbook on 2022/6/21.
//

#import "SHLNWalletTableViewCell.h"
@interface SHLNWalletTableViewCell ()

@property (nonatomic,strong) UIView *colorBgView;

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *memoLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *amountLabel;

@end
@implementation SHLNWalletTableViewCell
- (UIView *)colorBgView
{
    if (_colorBgView == nil) {
        _colorBgView = [[UIView alloc]init];
        _colorBgView.layer.cornerRadius = 10;
        _colorBgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_colorBgView];
    }
    return _colorBgView;
}
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];

        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)memoLabel {
    if (_memoLabel == nil) {
        _memoLabel = [[UILabel alloc]init];
        _memoLabel.text = @"BTC";
        _memoLabel.textColor = SHTheme.walletTextColor;
        _memoLabel.font = kCustomMontserratMediumFont(14);
        [self.contentView addSubview:_memoLabel];
    }
    return _memoLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"--";
        _timeLabel.textColor = SHTheme.appBlackColor;
        _timeLabel.font = kCustomDDINExpFont(12);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [[UILabel alloc]init];
        _amountLabel.text = @"--";
        _amountLabel.textColor = SHTheme.setPasswordTipsColor;
        _amountLabel.font = kCustomDDINExpBoldFont(18);
        [self.contentView addSubview:_amountLabel];
    }
    return _amountLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setConstraints];

    }
    return self;
}
- (void)setConstraints {
    self.colorBgView.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView, 21*FitWidth).widthIs(32*FitWidth).heightEqualToWidth();
    self.iconImageView.sd_layout.centerYEqualToView(self.colorBgView).centerXEqualToView(self.colorBgView).widthIs(20*FitWidth).heightEqualToWidth();
    self.amountLabel.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView, 20*FitWidth).heightIs(24*FitHeight);
    [self.amountLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    
    self.memoLabel.sd_layout.leftSpaceToView(self.iconImageView, 13*FitWidth).topSpaceToView(self.contentView, 8*FitHeight).rightSpaceToView(self.amountLabel, 24*FitWidth).heightIs(22*FitHeight);
    self.timeLabel.sd_layout.leftEqualToView(self.memoLabel).topSpaceToView(self.memoLabel, 4*FitHeight).heightIs(18*FitHeight);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];

    
}
-(void)setLnInvoiceListModel:(SHLNInvoiceListModel *)lnInvoiceListModel
{
    _lnInvoiceListModel = lnInvoiceListModel;
    self.amountLabel.font = kCustomDDINExpBoldFont(18);
    if ([lnInvoiceListModel.type isEqualToString:@"bitcoind_tx"]) {//线上收款成功
        self.colorBgView.backgroundColor = SHTheme.lnWalletInvoiceImageBgColor;
        self.iconImageView.image = [UIImage imageNamed:@"invoiceLis_btc_true"];
        self.memoLabel.text = GCLocalizedString(@"On-chain");
        self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:lnInvoiceListModel.timestamp*1000 withFormat:@"yyyy-MM-dd HH:mm"];
        NSDecimalNumber *amountTfNumber = [NSDecimalNumber decimalNumberWithString:lnInvoiceListModel.amount];
        NSDecimalNumber *powUPNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, 8)]];
        self.amountLabel.text = [NSString stringWithFormat:@"+%@",[amountTfNumber decimalNumberByMultiplyingBy:powUPNumber].stringValue];
        self.amountLabel.textColor = SHTheme.pendingTextColor;
    }else if ([lnInvoiceListModel.type isEqualToString:@"paid_invoice"])
    {//ln支付成功
        self.colorBgView.backgroundColor = SHTheme.errorTipsRedAlphaColor;
        self.iconImageView.image = [UIImage imageNamed:@"invoiceLis_send_true"];
        self.memoLabel.text = IsEmpty(lnInvoiceListModel.memo)?GCLocalizedString(@"Lightning_payment"):lnInvoiceListModel.memo;
        self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:lnInvoiceListModel.timestamp*1000 withFormat:@"yyyy-MM-dd HH:mm"];
        self.amountLabel.text = [NSString stringWithFormat:@"-%@",lnInvoiceListModel.amount];
        self.amountLabel.textColor = SHTheme.errorTipsRedColor;

    }else if ([lnInvoiceListModel.type isEqualToString:@"user_invoice"])
    {//ln发送
        if (lnInvoiceListModel.ispaid)
        {
            self.colorBgView.backgroundColor = SHTheme.intensityGreenWithAlphaColor;
            self.iconImageView.image = [UIImage imageNamed:@"invoiceLis_recive_true"];
            self.memoLabel.text = IsEmpty(lnInvoiceListModel.memo)?GCLocalizedString(@"Lightning_invoice"):lnInvoiceListModel.memo;
            self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:lnInvoiceListModel.timestamp withFormat:@"yyyy-MM-dd HH:mm"];
            self.memoLabel.text = IsEmpty(lnInvoiceListModel.memo)?GCLocalizedString(@"Lightning_invoice"):lnInvoiceListModel.memo;
            self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:lnInvoiceListModel.timestamp*1000 withFormat:@"yyyy-MM-dd HH:mm"];
            self.amountLabel.text = [NSString stringWithFormat:@"+%@",lnInvoiceListModel.amount];
            self.amountLabel.textColor = SHTheme.intensityGreenColor;

        }else if (!lnInvoiceListModel.ispaid && lnInvoiceListModel.timestamp + lnInvoiceListModel.expire_time <[NSString getNowTimeTimestamp]/1000)
        {//过期
            self.colorBgView.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
            self.iconImageView.image = [UIImage imageNamed:@"invoiceLis_send_false"];
            self.memoLabel.text = IsEmpty(lnInvoiceListModel.memo)?GCLocalizedString(@"Lightning_invoice"):lnInvoiceListModel.memo;
            self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:lnInvoiceListModel.timestamp*1000 withFormat:@"yyyy-MM-dd HH:mm"];
            self.amountLabel.text = GCLocalizedString(@"Expired");
            self.amountLabel.font = kCustomSemiboldFont(12);
            self.amountLabel.textColor = SHTheme.setPasswordTipsColor;
        }else
        {
            //待处理
            self.colorBgView.backgroundColor = SHTheme.intensityGreenWithAlphaColor;
            self.iconImageView.image = [UIImage imageNamed:@"invoiceLis_sending"];
            self.memoLabel.text = IsEmpty(lnInvoiceListModel.memo)?GCLocalizedString(@"Lightning_invoice"):lnInvoiceListModel.memo;
            self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:lnInvoiceListModel.timestamp*1000 withFormat:@"yyyy-MM-dd HH:mm"];
            self.amountLabel.text = [NSString stringWithFormat:@"%@",lnInvoiceListModel.amount];
            self.amountLabel.textColor = SHTheme.intensityGreenColor;
        }
    }
}
@end
