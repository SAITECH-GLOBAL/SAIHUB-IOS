//
//  SHWebViewController.m
//  NewExchange
//
//  Created by 周松 on 2021/12/14.
//

#import "SHWebViewController.h"
#import <WebKit/WebKit.h>
 
@interface SHWebViewController () <WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,weak) UIButton *closeButton;

@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation SHWebViewController

- (UIButton *)reloadButton {
    if (_reloadButton == nil) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadButton setTitle:GCLocalizedString(@"networkErrorTitle") forState:UIControlStateNormal];
        [_reloadButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _reloadButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_reloadButton addTarget:self action:@selector(controllerEmptyViewReloadData) forControlEvents:UIControlEventTouchUpInside];
        [self.webView addSubview:_reloadButton];
    }
    return _reloadButton;
}

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc]init];
        _webView.navigationDelegate = self;
        //添加观察者,观察进度
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options: NSKeyValueObservingOptionNew context:nil];
        [self.view insertSubview:self.webView belowSubview:self.navBar];
        _webView.backgroundColor = [UIColor whiteColor];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(kNavBarHeight + kStatusBarHeight);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, kNavBarHeight + kStatusBarHeight, self.view.bounds.size.width, 2)];
        _progressView.tintColor = SHTheme.agreeButtonColor;
        //轨道颜色
        _progressView.trackTintColor = UIColorHex(0xf0f0f0);
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    if ([self.fileUrl hasPrefix:@"http"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.fileUrl]]];
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.fileUrl]]];
    }
    
    self.titleLabel.text = self.titleStr;
    self.titleLabel.font = kCustomMediunFont(16);
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KScreenWidth * 0.5);
    }];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"webView_closeButton"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton = closeButton;
    [self.navBar addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right);
        make.centerY.equalTo(self.backButton);
    }];
    self.closeButton.hidden = YES;
    
    self.reloadButton.hidden = YES;
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-30);
    }];
    
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        [self.progressView setProgress:newprogress animated:YES];
        if (newprogress == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                self.progressView.progress = 0;
            });
        } else  {
            self.progressView.hidden = NO;
        }
    } else if (self.isNeedWebviewTitle == YES && [keyPath isEqualToString:@"title"]) {
        if ([object isEqual:self.webView] && [self.webView canGoBack]) {
            self.titleLabel.text = self.webView.title;
        }
    }
}

/// 加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    self.reloadButton.hidden = NO;
}

/// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"%d -- 数量 == %zd",[webView canGoBack],webView.backForwardList.backList.count);
//        if (self.isNeedCloseButton == YES && [webView canGoBack]) {
//            self.closeButton.hidden = NO;
//        } else {
//            self.closeButton.hidden = YES;
//        }
//    });
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.reloadButton.hidden = NO;
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self.webView reload];
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title" context:nil];
    //清除缓存
    if (@available (iOS 9.0,*)) { //iOS 9之后才有的
        NSArray *types = @[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache];
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:websiteDataTypes modifiedSince:date completionHandler:^{
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
        NSString *cookiePath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager]removeItemAtPath:cookiePath error:nil];
    }
}

#pragma mark -- 响应事件
/// 关闭
- (void)closeButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
/// 返回
- (void)popViewController {

    if ([self.webView canGoBack]) {
        
        if (self.webView.backForwardList.backList.count > 1) {
            [self.webView goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)controllerEmptyViewReloadData {
    self.reloadButton.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.fileUrl]]];
}


@end
