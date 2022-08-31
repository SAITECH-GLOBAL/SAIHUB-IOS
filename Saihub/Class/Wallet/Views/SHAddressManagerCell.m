//
//  SHAddressManagerCell.m
//  Saihub
//
//  Created by 周松 on 2022/3/3.
//

#import "SHAddressManagerCell.h"
#import "SHKeyStorage.h"
#import "SHVerifyPasswordController.h"
#import "SHExportPrivateKeyController.h"

@interface SHAddressManagerCell ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIButton *exportButton;

@end

@implementation SHAddressManagerCell

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = SHTheme.addressTypeCellBackColor;
        _containerView.layer.cornerRadius = 8;
        [self.contentView addSubview:_containerView];
    }
    return _containerView;
}

- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textColor = SHTheme.agreeButtonColor;
        _numberLabel.text = @"1";
        _numberLabel.font = kCustomMontserratMediumFont(14);
        _numberLabel.backgroundColor = SHTheme.labelBackgroundColor;
        _numberLabel.layer.cornerRadius = 4;
        _numberLabel.layer.masksToBounds = YES;
        [self.containerView addSubview:_numberLabel];
    }
    return _numberLabel;
}

- (UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = @"33333";
        _addressLabel.textColor = SHTheme.walletTextColor;
        _addressLabel.font = kCustomMontserratMediumFont(14);
        [self.containerView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UIButton *)exportButton {
    if (_exportButton == nil) {
        _exportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exportButton setImage:[UIImage imageNamed:@"addressManager_exportButton"] forState:UIControlStateNormal];
        [_exportButton addTarget:self action:@selector(exportButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:_exportButton];
    }
    return _exportButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(16);
            make.height.mas_equalTo(52);
        }];
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.equalTo(self.containerView);
        }];
        
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numberLabel.mas_right).offset(8);
            make.centerY.equalTo(self.numberLabel);
        }];
        
        [self.exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.containerView.mas_right).offset(-16);
            make.centerY.equalTo(self.addressLabel);
        }];
        
        if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey || [SHKeyStorage shared].currentWalletModel.passPhrase.length != 0) {
            self.exportButton.hidden = YES;
        }
    }
    return self;
}

- (void)setAddressModel:(SHWalletSubAddressModel *)addressModel {
    _addressModel = addressModel;
    
    self.addressLabel.text = [addressModel.address formatAddressStrLeft:6 right:6];
}

#pragma mark -- 导出私钥
- (void)exportButtonClick {
    
    SHVerifyPasswordController *verifyPwsVc = [[SHVerifyPasswordController alloc]init];
    verifyPwsVc.controllerType = SHVerifyPasswordControllerTypeExport;
    verifyPwsVc.verifyPasswordBlock = ^{
        SHExportPrivateKeyController *exportPrivateKeyVc = [[SHExportPrivateKeyController alloc]init];
        exportPrivateKeyVc.address = self.addressModel.address;
        exportPrivateKeyVc.privateKey = self.addressModel.privateKey;
        [[CTMediator sharedInstance].topViewController.navigationController pushViewController:exportPrivateKeyVc animated:YES];
    };
    [[CTMediator sharedInstance].topViewController.navigationController pushViewController:verifyPwsVc animated:YES];
}

@end
