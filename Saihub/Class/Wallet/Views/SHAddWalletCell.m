//
//  SHAddWalletCell.m
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import "SHAddWalletCell.h"

@interface SHAddWalletCell ()

@property (nonatomic, strong) UIImageView *backGroundImageView;

@property (nonatomic, strong) UIImageView *currentImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, strong) UIImageView *addImageView;

@end

@implementation SHAddWalletCell

- (UIImageView *)addImageView {
    if (_addImageView == nil) {
        _addImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addIcon_draw"]];
        [self.contentView addSubview:_addImageView];
    }
    return _addImageView;
}

- (UIImageView *)backGroundImageView {
    if (_backGroundImageView == nil) {
        _backGroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addWallet_backgroundImage"]];
        [self.contentView addSubview:_backGroundImageView];
    }
    return _backGroundImageView;
}

- (UIImageView *)currentImageView {
    if (_currentImageView == nil) {
        _currentImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addWallet_current"]];
        [self.contentView addSubview:_currentImageView];
    }
    return _currentImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"BTC";
        _nameLabel.textColor = SHTheme.appWhightColor;
        _nameLabel.font = kCustomMontserratMediumFont(14);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = @"dddddddddddd";
        _addressLabel.textColor = [SHTheme.appWhightColor colorWithAlphaComponent:0.75];
        _addressLabel.font = kCustomDAboldFont(12);
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UILabel *)emptyLabel {
    if (_emptyLabel == nil) {
        _emptyLabel = [[UILabel alloc]init];
        _emptyLabel.text = GCLocalizedString(@"add_wallet");
        _emptyLabel.textColor = SHTheme.pageUnselectColor;
        _emptyLabel.font = kCustomMontserratMediumFont(12);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_emptyLabel];
    }
    return _emptyLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setConstraints];
    }
    return self;
}

- (void)setConstraints {
    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(78);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundImageView.mas_left).offset(20);
        make.top.equalTo(self.backGroundImageView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundImageView.mas_left).offset(20);
        make.top.mas_equalTo(20);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(2.5);
    }];
    
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.emptyLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setIsEmpty:(BOOL)isEmpty {
    _isEmpty = isEmpty;
    
    self.currentImageView.hidden = isEmpty;
    self.nameLabel.hidden = isEmpty;
    self.addressLabel.hidden = isEmpty;
    self.emptyLabel.hidden = !isEmpty;
    self.addImageView.hidden = !isEmpty;
    
    if (isEmpty == YES) {
        self.backGroundImageView.image = [UIImage imageNamed:@"addWallet_backgroundImage_empty"];
    } else {
        self.backGroundImageView.image = [UIImage imageNamed:@"addWallet_backgroundImage"];
    }
}

- (void)setWalletModel:(SHWalletModel *)walletModel {
    _walletModel = walletModel;
    
    self.nameLabel.text = walletModel.name;
    
    self.addressLabel.text = [walletModel.address formatAddressStrLeft:6 right:6];
    
    self.currentImageView.hidden = !walletModel.isCurrent;
    
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 16;
    [super setFrame:frame];
}

@end
