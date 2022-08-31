//
//  SHLNExportWalltViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/23.
//

#import "SHLNExportWalltViewController.h"

#import "JLQRCodeTool.h"

@interface SHLNExportWalltViewController ()

@property (nonatomic, weak) UIImageView *qrCodeImageView;

@end

@implementation SHLNExportWalltViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSubviews];
}

- (void)setSubviews {
    self.titleLabel.text = GCLocalizedString(@"Export");
    
    UIView *receiveView = [[UIView alloc]init];
    receiveView.backgroundColor = SHTheme.addressTypeCellBackColor;
    receiveView.layer.cornerRadius = 8;
    [self.view addSubview:receiveView];
    [receiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(67);
        make.right.mas_equalTo(-67);
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
        make.height.mas_equalTo(241 *FitWidth);
    }];
    
    UIImageView *qrCodeImageView = [[UIImageView alloc]initWithImage:[JLQRCodeTool qrcodeImageWithInfo:self.address withSize:193 *FitWidth]];
    self.qrCodeImageView = qrCodeImageView;
    [receiveView addSubview:qrCodeImageView];
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(24);
        make.size.mas_equalTo(CGSizeMake(193 *FitWidth, 193 *FitWidth));
    }];
    
    YYLabel *addressLabel = [[YYLabel alloc]init];
    addressLabel.text = self.address;
    addressLabel.textColor = SHTheme.agreeTipsLabelColor;
    addressLabel.font = kCustomMontserratRegularFont(14);
    addressLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 28);
    [self.view addSubview:addressLabel];
    addressLabel.sd_layout.centerXEqualToView(receiveView).topSpaceToView(receiveView, 16*FitHeight).widthIs(335*FitWidth).heightIs(44*FitHeight);
    addressLabel.lineBreakMode = NSLineBreakByCharWrapping;
    addressLabel.numberOfLines = 2;
    addressLabel.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *copyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(copyAddressClick)];
    [addressLabel addGestureRecognizer:copyTap];
    
}

#pragma mark -- 复制地址
- (void)copyAddressClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.address];
    [MBProgressHUD showSuccess:GCLocalizedString(@"copy_address_success") toView:self.view];
}

@end
