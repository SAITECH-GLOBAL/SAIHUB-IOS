//
//  SHTransactionRecordCell.m
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import "SHTransactionRecordCell.h"

@interface SHTransactionRecordCell ()

@property (nonatomic, strong) UIView *colorView;

@property (nonatomic, strong) UIImageView *iconImageView;

/// 地址
@property (nonatomic, strong) UILabel *addressLabel;

/// 时间
@property (nonatomic, strong) UILabel *timeLabel;

/// 金额
@property (nonatomic, strong) UILabel *amountLabel;

@end

@implementation SHTransactionRecordCell

- (UIView *)colorView {
    if (_colorView == nil) {
        _colorView = [[UIView alloc]init];
        _colorView.layer.cornerRadius = 10;
        [self.contentView addSubview:_colorView];
    }
    return _colorView;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = @"Ox1593…a8cc8";
        _addressLabel.textColor = SHTheme.walletTextColor;
        _addressLabel.font = kCustomMontserratMediumFont(14);
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"2006-01-04";
        _timeLabel.font = kCustomDDINExpFont(12);
        _timeLabel.textColor = [SHTheme.appBlackColor colorWithAlphaComponent:0.75];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [[UILabel alloc]init];
        _amountLabel.font = kCustomDDINExpBoldFont(18);
        _amountLabel.text = @"222";
        _amountLabel.textColor = SHTheme.errorTipsRedColor;
        [self.contentView addSubview:_amountLabel];
    }
    return _amountLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = SHTheme.addressTypeCellBackColor;
        
        [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(21);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.center.equalTo(self.colorView);
        }];
        
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(13);
            make.top.mas_equalTo(8);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressLabel);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        }];
        
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(0);
        }];
        
    }
    return self;
}

- (void)setListModel:(SHTransactionListModel *)listModel {
    _listModel = listModel;
    
    UIColor *color ;
    
    NSString *address;
    
    NSString *symbol;
    
    if (listModel.type == 2) { // 转出
        
        if (listModel.status == SHTransactionStatusPending) { // pending状态
            self.iconImageView.image = [UIImage imageNamed:@"transaction_pendingImage"];
            color = SHTheme.pendingTextColor;
        } else {
            self.iconImageView.image = [UIImage imageNamed:@"transaction_outImage"];
            color = SHTheme.outTextColor;
        }
        
        address = [listModel.toAddress componentsSeparatedByString:@","].firstObject;
        symbol = @"-";
    } else { // 转入
        self.iconImageView.image = [UIImage imageNamed:@"transaction_inImage"];
        color = SHTheme.inTextColor;
        address = [listModel.fromAddress componentsSeparatedByString:@","].firstObject;
        symbol = @"+";
    }

    if (listModel.status == SHTransactionStatusFailed) { // 失败
        self.iconImageView.image = [UIImage imageNamed:@"transaction_failedImage"];
        color = SHTheme.setPasswordTipsColor;
    }
    
    self.colorView.backgroundColor = [color colorWithAlphaComponent:0.1];
    
    // 地址
    self.addressLabel.text = [address formatAddressStrLeft:6 right:6];
    
    // 时间
    self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:listModel.timestamp];
    
    // 金额
    self.amountLabel.text = [NSString stringWithFormat:@"%@%@",symbol,[NSString digitStringWithValue:listModel.amount count:8]];
    self.amountLabel.textColor = color;
}

@end
