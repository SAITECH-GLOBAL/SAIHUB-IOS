//
//  SHMultipleSignatureViewController.m
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHMultipleSignatureViewController.h"
#import "SHTransferValidationTopView.h"
#import "SHMultipleSignatureTableViewCell.h"
#import "SHTransferSucceseViewController.h"
@interface SHMultipleSignatureViewController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) SHTransferValidationTopView *transferValidationTopView;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UILabel *signatureStatusLabel;
@property (strong, nonatomic)  UITableView *signedTableView;
@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation SHMultipleSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = GCLocalizedString(@"Details");
    // Do any additional setup after loading the view.
    [self loadWebView];
    [self layoutScale];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RateChangeAction:) name:RateChangePushNoticeKey object:nil];
}
- (void)RateChangeAction:(NSNotification *)notification {
    [self.transferValidationTopView loadFeeLabelValue];
}

#pragma mark 布局页面
-(void)layoutScale
{
    self.transferValidationTopView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.navBar, 0).heightIs(166*FitHeight);
    [self.transferValidationTopView layoutScale];
    self.signatureStatusLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.transferValidationTopView, 24*FitHeight).heightIs(22*FitHeight);
    [self.signatureStatusLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.signedTableView.sd_layout.leftEqualToView(self.signatureStatusLabel).topSpaceToView(self.signatureStatusLabel, 16*FitHeight).rightSpaceToView(self.view, 20*FitWidth).bottomEqualToView(self.view);
    [self.view layoutIfNeeded];
    float resignatureY = [SHKeyStorage shared].currentWalletModel.policySureCount*68*FitHeight + 80*FitHeight + self.transferValidationTopView.height + 46*FitHeight + 16*FitHeight;
    NSLog(@"%lf",kHEIGHT - self.navBar.height - SafeAreaBottomHeight - 38*FitHeight -52*FitHeight);
    if (resignatureY > kHEIGHT - self.navBar.height - SafeAreaBottomHeight - 38*FitHeight -52*FitHeight) {
        resignatureY = kHEIGHT - self.navBar.height - SafeAreaBottomHeight - 38*FitHeight -52*FitHeight;
    }
    self.continueButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.navBar, resignatureY).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    self.transferValidationTopView.isPrimaryToken = self.isPrimaryToken;
    self.transferValidationTopView.transferInfoModel = self.transferInfoModel;
    if ([SHKeyStorage shared].currentWalletModel.policySureCount == self.haveSureNum) {
        [_continueButton setTitle:GCLocalizedString(@"send_now") forState:UIControlStateNormal];
    }else
    {
        [_continueButton setTitle:GCLocalizedString(@"resignature") forState:UIControlStateNormal];
    }
}
#pragma mark bc1相关交易调用web
-(void)loadWebView
{
    //创建一个WKWebView的配置对象
    WKWebViewConfiguration *configur=[[WKWebViewConfiguration alloc]init];
    //设置configur对象的preferences属性的信息
    WKPreferences *preferences = [[WKPreferences alloc]init];
    configur.preferences=preferences;
    //是否允许与js进行交互，默认是YES的，如果设置为NO，js的代码就不起作用了
    preferences.javaScriptEnabled =YES;
    WKUserContentController *userContentController=[[WKUserContentController alloc]init];
    //添加消息处理，注意：self指代的是需要遵守WKScriptMessageHandler协议，结束时需要移除
    [userContentController addScriptMessageHandler:self name:@"privateKeyToBech32Address"];
    configur.userContentController=userContentController;
    //解决跨域问题
    [configur.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    if (@available(iOS 10.0, *)) {
        [configur setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
    }
    WKWebView *wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0,0 , 1) configuration:configur];
    wkWebView.hidden = YES;
    self.wkWebView = wkWebView;
    [self.view addSubview:wkWebView];
    //设置内边距底部，主要是为了让网页最后的内容不被底部的toolBar挡着
    //wkWebView.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 104, 0);
    //这句代码是让竖直方向的滚动条显示在正确的位置
    wkWebView.scrollView.scrollIndicatorInsets=wkWebView.scrollView.contentInset;
    wkWebView.UIDelegate=self;
    wkWebView.navigationDelegate=self;
    //加载html字符串
    //[wkWebView loadHTMLString:html StrbaseURL:nil];
    //加载html网页
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ocCallJs"withExtension:@"html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [wkWebView loadRequest:urlRequest];
}

#pragma mark 按钮事件
-(void)continueButtonAction:(UIButton *)btn
{
    self.continueButton.enabled = NO;
    if (self.haveSureNum  == [SHKeyStorage shared].currentWalletModel.policySureCount) {
        if ([SHKeyStorage shared].currentWalletModel.zpubList.count) {
            //多签
            NSString *jsAddressStr = [NSString stringWithFormat:@"psbtBase64ToHex('%@')",self.URPsbtString];
            [self.wkWebView evaluateJavaScript:jsAddressStr completionHandler:^(id _Nullable psbtBase64ToHexResult, NSError * _Nullable error) {
                if (IsEmpty(psbtBase64ToHexResult)) {
                    self.continueButton.enabled = YES;
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showError:GCLocalizedString(@"psbtBase64ToHex error") toView:self.view];
                    return;
                }
                NSMutableDictionary *sendPara = [NSMutableDictionary dictionary];
                [sendPara setValue:psbtBase64ToHexResult forKey:@"transaction"];
                [sendPara setValue:@(2) forKey:@"coinType"];
                [self sendTransactionWithPara:sendPara];
            }];
        }else
        {
            //单签
            NSString *jsAddressStr = [NSString stringWithFormat:@"singlePsbtToHex('%@')",self.URPsbtString];
            [self.wkWebView evaluateJavaScript:jsAddressStr completionHandler:^(id _Nullable psbtBase64ToHexResult, NSError * _Nullable error) {
                if (IsEmpty(psbtBase64ToHexResult)) {
                    self.continueButton.enabled = YES;
                    [MBProgressHUD hideCustormLoadingWithView:self.view];
                    [MBProgressHUD showError:GCLocalizedString(@"singlePsbtToHex error") toView:self.view];
                    return;
                }
                NSMutableDictionary *sendPara = [NSMutableDictionary dictionary];
                [sendPara setValue:psbtBase64ToHexResult forKey:@"transaction"];
                [sendPara setValue:@(2) forKey:@"coinType"];
                [self sendTransactionWithPara:sendPara];
            }];

        }
    }else
    {
        [self popViewController];
    }
}
#pragma mark -- 4.0 发送交易
- (void)sendTransactionWithPara:(NSDictionary *)para {
    MJWeakSelf
    [[SHWalletNetManager shared] sendBroadcastWithSignPara:para succes:^(NSString * _Nonnull hash) {
//        [weakSelf storageLocalModelWithDict:@{t_hash : hash}];
        self.continueButton.enabled = YES;
        if (!IsEmpty(hash)) {
            SHTransferSucceseViewController *transferSucceseViewController = [[SHTransferSucceseViewController alloc]init];
            transferSucceseViewController.transferInfoModel = self.transferInfoModel;
            transferSucceseViewController.isPrimaryToken = self.isPrimaryToken;
            [self.navigationController pushViewController:transferSucceseViewController animated:YES];
            //存储模型
            SHTransactionListModel *model = [[SHTransactionListModel alloc]init];
            model.amount = self.transferInfoModel.valueString;
            model.fromAddress = [SHKeyStorage shared].currentWalletModel.address;
            model.toAddress = self.transferInfoModel.addressString;
            model.t_hash = hash;
            model.timestamp = [NSString getTimestampFromTime];
            model.status = SHTransactionStatusPending;
            model.type = 2;
            [[SHKeyStorage shared] updateModelBlock:^{
                [self.tokenModel.pendingList insertObject:model atIndex:0];
            }];
        }
    } fail:^(NSInteger errorCode, NSString * _Nonnull errorMessage) {
        self.continueButton.enabled = YES;
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
#pragma mark tableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68*FitHeight;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80*FitHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = SHTheme.appWhightColor;
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [SHKeyStorage shared].currentWalletModel.policySureCount;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHMultipleSignatureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHMultipleSignatureTableViewCell"];
    if (!cell) {
        cell = [[SHMultipleSignatureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHMultipleSignatureTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row <= self.haveSureNum-1) {
        cell.signedIndexNameLabel.text = [NSString stringWithFormat:GCLocalizedString(@"co_signer"),indexPath.row + 1];
        cell.backView.backgroundColor = SHTheme.intensityGreenWithAlphaColor;
        cell.signStatusImageView.image = [UIImage imageNamed:@"multipleSignatureCell_succese"];
        cell.signStatusBackView.backgroundColor = SHTheme.intensityGreenColor;

    }else
    {
        cell.signedIndexNameLabel.text = [NSString stringWithFormat:GCLocalizedString(@"co_signer_isnt_signed"),indexPath.row + 1];
        cell.backView.backgroundColor = SHTheme.errorTipsRedAlphaColor;
        cell.signStatusImageView.image = [UIImage imageNamed:@"multipleSignatureCell_faile"];
        cell.signStatusBackView.backgroundColor = SHTheme.errorTipsRedColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 按钮事件

#pragma mark 懒加载
-(UITableView *)signedTableView
{
    if (_signedTableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.allowsMultipleSelection = YES;
        tableView.allowsSelectionDuringEditing = YES;
        tableView.allowsMultipleSelectionDuringEditing = YES;
        tableView.tableFooterView  =  [[UIView alloc]init];
        tableView.showsVerticalScrollIndicator = NO;
        [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if (@available(iOS 15.0, *)) {
            tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:tableView];
        _signedTableView = tableView;
//        _signedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        }];
//        _signedTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        }];
    }
    return _signedTableView;
}
-(UILabel *)signatureStatusLabel
{
    if (_signatureStatusLabel == nil) {
        _signatureStatusLabel = [[UILabel alloc]init];
        _signatureStatusLabel.font = kCustomMontserratMediumFont(14);
        _signatureStatusLabel.textColor = SHTheme.appBlackColor;
        _signatureStatusLabel.text = GCLocalizedString(@"signature_status");
        [self.view addSubview:_signatureStatusLabel];
    }
    return _signatureStatusLabel;
}
-(UIButton *)continueButton
{
    if (_continueButton == nil) {
        _continueButton = [[UIButton alloc]init];
        _continueButton.layer.cornerRadius = 26*FitHeight;
        _continueButton.layer.masksToBounds = YES;
        [_continueButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _continueButton.titleLabel.font = kMediunFont(14);
        [_continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_continueButton];
    }
    return _continueButton;
}
-(SHTransferValidationTopView *)transferValidationTopView
{
    if (_transferValidationTopView == nil) {
        _transferValidationTopView = [[SHTransferValidationTopView alloc]init];
        [self.view addSubview:_transferValidationTopView];
    }
    return _transferValidationTopView;
}
-(void)dealloc
{
    self.wkWebView.navigationDelegate = nil;
    [self.wkWebView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RateChangePushNoticeKey object:nil];
}
@end
