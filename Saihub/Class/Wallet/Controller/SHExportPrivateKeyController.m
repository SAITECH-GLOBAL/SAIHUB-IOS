//
//  SHExportPrivateKeyController.m
//  Saihub
//
//  Created by 周松 on 2022/3/3.
//

#import "SHExportPrivateKeyController.h"
#import "JLQRCodeTool.h"

@interface SHExportPrivateKeyController ()

@property (nonatomic, weak) UIImageView *qrCodeImageView;

@end

@implementation SHExportPrivateKeyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YYLabel *titleLabel = [[YYLabel alloc]init];
    titleLabel.text = GCLocalizedString(@"export_tip_private");
    titleLabel.textColor = SHTheme.errorTipsRedColor;
    titleLabel.font = kCustomMontserratRegularFont(14);
    titleLabel.numberOfLines = 0;
    titleLabel.preferredMaxLayoutWidth = kScreenWidth - 40;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    titleLabel.layer.cornerRadius = 8;
    titleLabel.backgroundColor = [SHTheme.errorTipsRedColor colorWithAlphaComponent:0.1];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
    }];
    
    UIView *qrBorderView = [[UIView alloc]init];
    qrBorderView.backgroundColor = SHTheme.addressTypeCellBackColor;
    qrBorderView.layer.cornerRadius = 8 *FitWidth;
    [self.view addSubview:qrBorderView];
    [qrBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(titleLabel.mas_bottom).offset(24);
        make.size.mas_equalTo(CGSizeMake(241 *FitWidth, 241 *FitWidth));
    }];
    
    UIImageView *qrBorderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"exportPrivatekey_qrBorderImage"]];
    [qrBorderView addSubview:qrBorderImageView];
    [qrBorderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(qrBorderView);
        make.size.mas_equalTo(CGSizeMake(199 *FitWidth, 199 *FitWidth));
    }];
    
    UIImageView *eyeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"exportPrivateKey_eyeImage"]];
    [qrBorderView addSubview:eyeImageView];
    [eyeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrBorderImageView.mas_top).offset(45 *FitWidth);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *tapLabel = [[UILabel alloc]init];
    tapLabel.text = GCLocalizedString(@"export_private_key_tip");
    tapLabel.textColor = SHTheme.pageUnselectColor;
    tapLabel.font = kCustomMontserratMediumFont(14);
    tapLabel.numberOfLines = 0;
    tapLabel.textAlignment = NSTextAlignmentCenter;
    [qrBorderView addSubview:tapLabel];
    [tapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(eyeImageView.mas_bottom).offset(12 *FitWidth);
        make.left.equalTo(qrBorderImageView.mas_left).offset(3 *FitWidth);
        make.right.equalTo(qrBorderImageView.mas_right).offset(-3 *FitWidth);
    }];
    
    UIImageView *qrCodeImageView = [[UIImageView alloc]init];
    self.qrCodeImageView = qrCodeImageView;
    [qrBorderView addSubview:qrCodeImageView];
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(qrBorderImageView);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeTap)];
    [qrBorderView addGestureRecognizer:tap];
    
    // 地址
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.text = self.privateKey;
    addressLabel.textColor = SHTheme.agreeTipsLabelColor;
    addressLabel.font = kCustomMontserratRegularFont(14);
    addressLabel.numberOfLines = 0;
    addressLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(qrBorderView.mas_bottom).offset(16);
    }];
    
    // 复制
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyButton setTitle:GCLocalizedString(@"copy_private_key") forState:UIControlStateNormal];
    [copyButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
    copyButton.titleLabel.font = kCustomMontserratMediumFont(14);
    copyButton.layer.cornerRadius = 26*FitWidth;
    copyButton.layer.masksToBounds = YES;
    [self.view addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(52 *FitWidth);
        make.top.mas_equalTo(addressLabel.mas_bottom).offset(48);
    }];
    [copyButton addTarget:self action:@selector(copyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view layoutIfNeeded];
    [copyButton setBackgroundImage:[UIImage gradientImageWithBounds:copyButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionLeftToRight] forState:UIControlStateNormal];
    
    qrCodeImageView.hidden = YES;
    
    qrCodeImageView.image = [JLQRCodeTool qrcodeImageWithInfo:self.privateKey withSize:199 *FitWidth];
}

// 复制地址
- (void)copyButtonClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.privateKey];
    [MBProgressHUD showSuccess:GCLocalizedString(@"content_copy_success") toView:self.view];
}

/// 隐藏/显示 二维码
- (void)changeTap {
    self.qrCodeImageView.hidden = !self.qrCodeImageView.isHidden;
}

@end
