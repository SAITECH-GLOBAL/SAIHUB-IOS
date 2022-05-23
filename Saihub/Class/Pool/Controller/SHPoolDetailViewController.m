//
//  SHPoolDetailViewController.m
//  Saihub
//
//  Created by macbook on 2022/3/4.
//

#import "SHPoolDetailViewController.h"
#import "SHPowerDetaiPowerStatusView.h"
#import "SHURLErrorView.h"
@interface SHPoolDetailViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) SHPowerDetaiPowerStatusView *powerDetaiPowerStatusView;
@property (nonatomic, strong) SHURLErrorView *URLErrorView;
@end

@implementation SHPoolDetailViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showCustormLoadingWithView:nil withLabelText:@""];
    self.titleLabel.text = _TitleString;
    self.powerDetaiPowerStatusView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.navBar, -12*FitHeight).heightIs(90*FitHeight);
    [self.powerDetaiPowerStatusView layoutScale];
    [self.view bringSubviewToFront:self.navBar];
    self.powerDetaiPowerStatusView.powerStatusImageView.hidden = YES;
    self.powerDetaiPowerStatusView.powerStatusLabel.text = self.poolValue;
    self.powerDetaiPowerStatusView.powerStatusLabel.textColor = SHTheme.walletNameLabelColor;
    self.powerDetaiPowerStatusView.powerNameLabel.text = self.poolName;
//    UIView *backView = [[UIView alloc]init];
//    [self.view addSubview:backView];
//    backView.sd_layout.leftSpaceToView(self.view, 20*FitWidth).rightSpaceToView(self.view, 20*FitWidth).bottomSpaceToView(self.view, 20*FitHeight + SafeAreaBottomHeight).topSpaceToView(self.powerDetaiPowerStatusView, 0);
//    backView.backgroundColor = SHTheme.addressTypeCellBackColor;
//    backView.userInteractionEnabled = YES;
//    backView.layer.cornerRadius = 16;
//    backView.layer.masksToBounds = YES;
    self.webView = [[WKWebView alloc]init];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
//    self.webView.backgroundColor = SHTheme.addressTypeCellBackColor;
//    self.webView.scrollView.backgroundColor = SHTheme.addressTypeCellBackColor;
//    self.webView.layer.cornerRadius = 16;
//    self.webView.layer.masksToBounds = YES;
    self.webView.hidden = YES;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.webView];
        self.webView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.powerDetaiPowerStatusView, 0).bottomEqualToView(self.view);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.URLErrorView.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(kWIDTH).heightIs(105*FitHeight);
    [self.view layoutIfNeeded];
    [self.URLErrorView layoutScale];
}
#pragma mark - WKNavigationDelegate
//在开始加载WKWebVie添加一个加载框
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}
//网页加载完成 延时0.2秒展示网页
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#ffffff\"" completionHandler:nil];
     [self performSelector:@selector(showWebView) withObject:self afterDelay:0.2];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    self.URLErrorView.hidden = NO;
    [MBProgressHUD hideCustormLoadingWithView:nil];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [MBProgressHUD hideCustormLoadingWithView:nil];
}

- (void)showWebView{
    self.webView.hidden = NO;
    [MBProgressHUD hideCustormLoadingWithView:nil];
}
- (void) webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{
    if(navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
-(SHPowerDetaiPowerStatusView *)powerDetaiPowerStatusView
{
    if (_powerDetaiPowerStatusView == nil) {
        _powerDetaiPowerStatusView = [[SHPowerDetaiPowerStatusView alloc]init];
        [self.view addSubview:_powerDetaiPowerStatusView];
    }
    return _powerDetaiPowerStatusView;
}
-(void)popViewController
{
    [super popViewController];
    [MBProgressHUD hideCustormLoadingWithView:nil];
}
-(SHURLErrorView *)URLErrorView
{
    if (_URLErrorView == nil) {
        _URLErrorView = [SHURLErrorView new];
        _URLErrorView.hidden = YES;
        [self.view addSubview:_URLErrorView];
    }
    return _URLErrorView;
}
@end
