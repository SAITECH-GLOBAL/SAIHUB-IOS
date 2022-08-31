//
//  SHLNQRReceiveViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/22.
//

#import "SHLNQRReceiveViewController.h"
#import "JLQRCodeTool.h"

@interface SHLNQRReceiveViewController ()
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, weak) UIImageView *qrCodeImageView;

@property (nonatomic, weak) YYLabel *addressLabel;
@property (nonatomic, strong) UILabel *timeValueLabel;
@property (nonatomic, strong) dispatch_source_t _timer;
@end

@implementation SHLNQRReceiveViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSubviews];
    [self.rightButton setImage:[UIImage imageNamed:@"backMainVc"] forState:UIControlStateNormal];
}
-(void)rightButtonClick:(UIButton *)sender
{
    [self popBackWithClassArray:@[[SHLNWalletViewController class]]];
}
- (void)setSubviews {
    self.titleLabel.text = GCLocalizedString(@"Receive");
    self.backScrollView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.navBar, 0).bottomEqualToView(self.view);
    UIView *receiveView = [[UIView alloc]init];
    receiveView.backgroundColor = SHTheme.addressTypeCellBackColor;
    receiveView.layer.cornerRadius = 8;
    [self.backScrollView addSubview:receiveView];
    receiveView.sd_layout.leftSpaceToView(self.backScrollView, 47*FitWidth).rightSpaceToView(self.backScrollView, 47*FitWidth).topSpaceToView(self.backScrollView, 20*FitHeight).heightIs(319*FitHeight);
    
    UIImageView *qrCodeImageView = [[UIImageView alloc]initWithImage:[JLQRCodeTool qrcodeImageWithInfo:self.address withSize:193 *FitWidth]];
    self.qrCodeImageView = qrCodeImageView;
    [receiveView addSubview:qrCodeImageView];
    qrCodeImageView.sd_layout.centerXEqualToView(receiveView).topSpaceToView(receiveView, 40*FitHeight).widthIs(193*FitWidth).heightEqualToWidth();
    
    YYLabel *addressLabel = [[YYLabel alloc]init];
    self.addressLabel = addressLabel;
    addressLabel.text = self.address.length>40?[self.address formatAddressStrLeft:20 right:20]:self.address;
    addressLabel.textColor = SHTheme.agreeTipsLabelColor;
    addressLabel.font = kCustomMontserratRegularFont(14);
//    addressLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 28);
    [receiveView addSubview:addressLabel];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.sd_layout.centerXEqualToView(qrCodeImageView).topSpaceToView(qrCodeImageView, 24*FitHeight).widthIs(248*FitWidth).heightIs(44*FitHeight);
    addressLabel.numberOfLines = 2;
//    addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    UITapGestureRecognizer *copyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(copyAddressClick)];
    [addressLabel addGestureRecognizer:copyTap];
    
    UIImageView *topLineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"receiveQR_line"]];
    [self.backScrollView addSubview:topLineImageView];
    topLineImageView.sd_layout.leftEqualToView(receiveView).rightEqualToView(receiveView).topSpaceToView(receiveView, 40*FitHeight).heightIs(1);

    //amount
    UILabel *amountTipsLabel = [[UILabel alloc]init];
    amountTipsLabel.text = GCLocalizedString(@"amount");
    amountTipsLabel.textColor = SHTheme.setPasswordTipsColor;
    amountTipsLabel.font = kCustomMontserratRegularFont(14);
    [self.backScrollView addSubview:amountTipsLabel];
    amountTipsLabel.sd_layout.leftEqualToView(topLineImageView).topSpaceToView(topLineImageView, 15*FitHeight).heightIs(22*FitHeight);
    [amountTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    
    UILabel *amountValueLabel = [[UILabel alloc]init];
    amountValueLabel.text = self.amountString;
    amountValueLabel.textColor = SHTheme.agreeButtonColor;
    amountValueLabel.font = kCustomDDINExpBoldFont(14);
    [self.backScrollView addSubview:amountValueLabel];
    amountValueLabel.sd_layout.rightEqualToView(topLineImageView).centerYEqualToView(amountTipsLabel).heightIs(14*FitHeight);
    [amountValueLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    
    UIImageView *bottomLineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"receiveQR_line"]];
    [self.backScrollView addSubview:bottomLineImageView];
    if (!IsEmpty(self.memo)) {
        //memo
        UILabel *memoTipsLabel = [[UILabel alloc]init];
        memoTipsLabel.text = GCLocalizedString(@"Memo");
        memoTipsLabel.textColor = SHTheme.setPasswordTipsColor;
        memoTipsLabel.font = kCustomMontserratRegularFont(14);
        [self.backScrollView addSubview:memoTipsLabel];
        memoTipsLabel.sd_layout.leftEqualToView(topLineImageView).topSpaceToView(amountTipsLabel, 10*FitHeight).heightIs(22*FitHeight);
        [memoTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
        
        UILabel *memoValueLabel = [[UILabel alloc]init];
        memoValueLabel.text = self.memo;
        memoValueLabel.textColor = SHTheme.agreeTipsLabelColor;
        memoValueLabel.font = kCustomDDINExpBoldFont(14);
        [self.backScrollView addSubview:memoValueLabel];
        memoValueLabel.sd_layout.rightEqualToView(topLineImageView).centerYEqualToView(memoTipsLabel).heightIs(14*FitHeight);
        [memoValueLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
        bottomLineImageView.sd_layout.leftEqualToView(receiveView).rightEqualToView(receiveView).topSpaceToView(memoTipsLabel, 15*FitHeight).heightIs(1);

    }else
    {
        bottomLineImageView.sd_layout.leftEqualToView(receiveView).rightEqualToView(receiveView).topSpaceToView(amountTipsLabel, 15*FitHeight).heightIs(1);
    }
    //有效期
    UILabel *timeTipsLabel = [[UILabel alloc]init];
    timeTipsLabel.text = GCLocalizedString(@"Expires_in");
    timeTipsLabel.textColor = SHTheme.setPasswordTipsColor;
    timeTipsLabel.font = kCustomMontserratRegularFont(14);
    [self.backScrollView addSubview:timeTipsLabel];
    timeTipsLabel.sd_layout.leftEqualToView(topLineImageView).topSpaceToView(bottomLineImageView, 15*FitHeight).heightIs(22*FitHeight);
    [timeTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    
    UIImageView *timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"receiveQR_timeicon"]];
    [self.backScrollView addSubview:timeImageView];
    timeImageView.sd_layout.centerYEqualToView(timeTipsLabel).leftSpaceToView(timeTipsLabel, 5*FitWidth).widthIs(12*FitWidth).heightEqualToWidth();
    
    UILabel *timeValueLabel = [[UILabel alloc]init];
    timeValueLabel.textColor = SHTheme.agreeTipsLabelColor;
    timeValueLabel.font = kCustomDDINExpBoldFont(14);
    [self.backScrollView addSubview:timeValueLabel];
    self.timeValueLabel = timeValueLabel;
    timeValueLabel.sd_layout.rightEqualToView(topLineImageView).centerYEqualToView(timeTipsLabel).heightIs(14*FitHeight);
    [timeValueLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    [self countdownAction];
    JLButton *shareButton = [JLButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = SHTheme.shareBackgroundColor;
    shareButton.layer.cornerRadius = 26;
    shareButton.layer.masksToBounds = YES;
    shareButton.spacingBetweenImageAndTitle = 4;
    [shareButton setTitle:GCLocalizedString(@"Share") forState:UIControlStateNormal];
    [shareButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
    shareButton.titleLabel.font = kCustomMontserratMediumFont(14);
    [shareButton setImage:[UIImage imageNamed:@"wallet_shareButton"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(receiveView.mas_bottom).offset(237*FitHeight);
        make.size.mas_equalTo(CGSizeMake(209, 52));
    }];
    [self.view layoutIfNeeded];
    self.backScrollView.contentSize = CGSizeMake(kWIDTH, shareButton.height + shareButton.origin.y + 100);
}
-(void)countdownAction
{
    if ([NSString getNowTimeTimestamp]/1000 - self.timeCreat >=86400) {
        self.timeValueLabel.text = GCLocalizedString(@"Expired");
    }else
    {
        if (self._timer) {
            dispatch_source_cancel(self._timer);
        }
        __block long timeout= 86400 - ([NSString getNowTimeTimestamp]/1000 - self.timeCreat); //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self._timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(self._timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(self._timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(self._timer);
                dispatch_async(dispatch_get_main_queue(), ^{
      //设置界面的按钮显示 根据自己需求设置
                    self.timeValueLabel.text = GCLocalizedString(@"Expired");
                });
            }else{
                long hour = timeout / 3600;
                long minutes = timeout % 3600/60;
                long seconds = timeout % 3600 % 60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    self.timeValueLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minutes,seconds];
                });
                timeout--;
                  
            }
        });
        dispatch_resume(self._timer);
    }
}
#pragma mark -- 复制地址
- (void)copyAddressClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.address];
    [MBProgressHUD showSuccess:GCLocalizedString(@"copy_address_success") toView:self.view];
}

#pragma mark -- 分享
- (void)shareButtonClick {
    if (self.qrCodeImageView.image == nil) {
        return;
    }
    
    UIView *screenView = [[UIView alloc]initWithFrame:kSCREEN];
    screenView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:screenView];
    
    CGFloat contentW = kScreenWidth;
    CGFloat contentH = 568;
    
    // 二维码size
    CGFloat qrCodeW = 275 *FitWidth;
    
    // 底部高
    CGFloat bottomH = 99;
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = SHTheme.appWhightColor;
    contentView.layer.cornerRadius = 16;
    [screenView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(126 *FitWidth + kStatusBarHeight);
        make.size.mas_equalTo(CGSizeMake(contentW, contentH));
    }];
    
    // 底部渐变view
    UIImageView *bottomView = [[UIImageView alloc]init];
    [contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(contentView);
        make.height.mas_equalTo(bottomH);
    }];
    bottomView.image = [UIImage gradientImageWithBounds:CGRectMake(0, 0, contentW, bottomH) andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionLeftToRight];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, contentW, bottomH) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(16, 16)].CGPath;
    bottomView.layer.mask = shapeLayer;
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 16;
    [contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView);
        make.height.mas_equalTo(contentH - bottomH + 16);
        make.top.centerX.mas_equalTo(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"BTC";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = kCustomMontserratMediumFont(18);
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(20);
    }];
    
    UIView *qrCodeBorderView = [[UIView alloc]init];
    qrCodeBorderView.backgroundColor = SHTheme.addressTypeCellBackColor;
    [contentView addSubview:qrCodeBorderView];
    qrCodeBorderView.layer.cornerRadius = 16;
    [qrCodeBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(qrCodeW, qrCodeW));
        make.centerX.equalTo(contentView);
        make.top.mas_equalTo(54);
    }];
    
    // 地址二维码
    UIImageView *qrCodeImageView = [[UIImageView alloc]initWithImage:self.qrCodeImageView.image];
    [qrCodeBorderView addSubview:qrCodeImageView];
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 12, 12, 12));
    }];
    
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.text = self.address;
    addressLabel.textColor = SHTheme.agreeTipsLabelColor;
    addressLabel.font = kCustomMontserratRegularFont(12);
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.numberOfLines = 0;
    [topView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25 *FitWidth);
        make.right.mas_equalTo(-25 *FitWidth);
        make.top.equalTo(qrCodeBorderView.mas_bottom).offset(16);
    }];

    // icon
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"appIcon_whiteImage"]];
    [bottomView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 *FitWidth);
        make.top.equalTo(bottomView.mas_top).offset(32);
    }];
    
    // 网址
    UILabel *websiteLabel = [[UILabel alloc]init];
    websiteLabel.text = @"https://sai.tech";
    websiteLabel.textColor = SHTheme.appWhightColor;
    websiteLabel.font = kCustomMontserratRegularFont(12);
    [bottomView addSubview:websiteLabel];
    [websiteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_left);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-21);
    }];
    
    // 下载二维码
    UIView *downloadView = [[UIView alloc]init];
    [bottomView addSubview:downloadView];
    downloadView.layer.cornerRadius = 4;
    downloadView.backgroundColor = [UIColor whiteColor];
    [downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20 *FitWidth);
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    
    UIImageView *downloadImageView = [[UIImageView alloc]init];
    [downloadView addSubview:downloadImageView];
    [downloadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(3, 3, 3, 3));
    }];
    downloadImageView.image = [JLQRCodeTool qrcodeImageWithInfo:@"https://sai.tech" withSize:40];
    
    [self.view layoutIfNeeded];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, contentView.height),YES,[UIScreen mainScreen].scale);
    [contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    screenView.hidden = YES;
    [screenView removeFromSuperview];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[image] applicationActivities:nil];
    
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        if (completed == YES) {
            if ([activityType isEqualToString:@"com.apple.UIKit.activity.CopyToPasteboard"]) {
                [MBProgressHUD showSuccess:GCLocalizedString(@"copy_success") toView:self.view];
            } else {
                [MBProgressHUD showSuccess:GCLocalizedString(@"share_success") toView:self.view];
            }
        }
    };
    activityVC.completionWithItemsHandler = myBlock;
    activityVC.excludedActivityTypes = nil;
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
-(UIScrollView *)backScrollView
{
    if (_backScrollView == nil) {
        _backScrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_backScrollView];
    }
    return _backScrollView;
}
-(void)dealloc
{
    if (self._timer) {
        dispatch_source_cancel(self._timer);
    }
}
@end
