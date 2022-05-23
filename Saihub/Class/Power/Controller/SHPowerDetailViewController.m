//
//  SHPowerDetailViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import "SHPowerDetailViewController.h"
#import "SHPowerDetaiPowerStatusView.h"
#import "SHPowerDetailChartLineView.h"
#import "SHPowerDetailInOrOutLetView.h"
#import "SHPowerDetailTempValueView.h"
#import "SHPowerDetailModel.h"
#import "SHCompleteView.h"
#import "SHDeveceOffline.h"
@interface SHPowerDetailViewController ()
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) SHPowerDetaiPowerStatusView *powerDetaiPowerStatusView;
@property (nonatomic, strong) SHPowerDetailChartLineView *powerDetailChartLineView;
@property (nonatomic, strong) SHPowerDetailInOrOutLetView *powerDetailInOrOutLetView;
@property (nonatomic, strong) SHPowerDetailTempValueView *powerDetailTempValueView;
@property (nonatomic, strong) SHDeveceOffline *deveceOffline;
@end

@implementation SHPowerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = SHTheme.appWhightColor;
    self.titleLabel.text = GCLocalizedString(@"power_system");
    [self layoutScale];
    [self.view bringSubviewToFront:self.navBar];
    [self loadData];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.backScrollView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).topSpaceToView(self.navBar, 0);
    self.powerDetaiPowerStatusView.sd_layout.leftEqualToView(self.backScrollView).rightEqualToView(self.backScrollView).topSpaceToView(self.backScrollView, -12*FitHeight).heightIs(90*FitHeight);
    self.powerDetailChartLineView.sd_layout.leftEqualToView(self.backScrollView).rightEqualToView(self.backScrollView).topSpaceToView(self.powerDetaiPowerStatusView, 0).heightIs(265*FitHeight);
    self.powerDetailInOrOutLetView.sd_layout.leftEqualToView(self.backScrollView).rightEqualToView(self.backScrollView).topSpaceToView(self.powerDetailChartLineView, 0).heightIs(200*FitHeight);
    self.powerDetailTempValueView.sd_layout.leftEqualToView(self.backScrollView).rightEqualToView(self.backScrollView).topSpaceToView(self.powerDetailInOrOutLetView, 0).heightIs(196*FitHeight);
    [self.view layoutIfNeeded];
    [self.powerDetaiPowerStatusView layoutScale];
    [self.powerDetailChartLineView layoutScale];
    self.backScrollView.contentSize = CGSizeMake(0, 800*FitHeight);
    self.deveceOffline.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(kWIDTH).heightIs(83*FitHeight);
    [self.deveceOffline layoutScale];
}
-(void)setPowerListModel:(SHPowerListModel *)powerListModel
{
    _powerListModel = powerListModel;

}
#pragma mark 网络请求
-(void)loadData
{
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    [[NetWorkTool shareNetworkTool]requestHttpWithPath:@"/data/get/device/info" withMethodType:Get withParams:@{@"deviceCode":self.powerListModel.powerValue} result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        if (code == 0) {
            SHPowerDetailModel *powerDetailModel = [SHPowerDetailModel modelWithJSON:responseModel.data.result];
            self.powerDetaiPowerStatusView.powerDetailModel = powerDetailModel;
            self.powerDetailChartLineView.powerDetailModel = powerDetailModel;
            self.powerDetailInOrOutLetView.powerDetailModel = powerDetailModel;
            self.powerDetailTempValueView.powerDetailModel = powerDetailModel;
            self.powerDetaiPowerStatusView.powerNameLabel.text = self.powerListModel.powerName;

        }else
        {
            SHPowerDetailModel *powerDetailModel = [SHPowerDetailModel new];
            powerDetailModel.online = NO;
            self.powerDetaiPowerStatusView.powerDetailModel = powerDetailModel;
            self.powerDetaiPowerStatusView.powerNameLabel.text = self.powerListModel.powerName;
            self.deveceOffline.hidden = NO;
            MJWeakSelf;
            SHCompleteView *completeView = [[SHCompleteView alloc]init];
            completeView.completeViewType = CompleteViewFailType;
            completeView.completeBlock = ^{
                [weakSelf popViewController];
            };
            [completeView presentInView:self.view];
//            [MBProgressHUD showError:message toView:self.view];
        }
        [self.backScrollView.mj_header endRefreshing];
        [MBProgressHUD hideCustormLoadingWithView:self.view];
    }];
}
#pragma mark 懒加载
-(SHPowerDetaiPowerStatusView *)powerDetaiPowerStatusView
{
    if (_powerDetaiPowerStatusView == nil) {
        _powerDetaiPowerStatusView = [[SHPowerDetaiPowerStatusView alloc]init];
        [self.backScrollView addSubview:_powerDetaiPowerStatusView];
    }
    return _powerDetaiPowerStatusView;
}
-(SHPowerDetailChartLineView *)powerDetailChartLineView
{
    if (_powerDetailChartLineView == nil) {
        _powerDetailChartLineView = [[SHPowerDetailChartLineView alloc]init];
        _powerDetailChartLineView.backgroundColor = [UIColor clearColor];
        [self.backScrollView addSubview:_powerDetailChartLineView];
    }
    return _powerDetailChartLineView;
}
-(SHPowerDetailInOrOutLetView *)powerDetailInOrOutLetView
{
    if (_powerDetailInOrOutLetView == nil) {
        _powerDetailInOrOutLetView = [[SHPowerDetailInOrOutLetView alloc]init];
        _powerDetailInOrOutLetView.backgroundColor = [UIColor clearColor];
        [self.backScrollView addSubview:_powerDetailInOrOutLetView];
    }
    return _powerDetailInOrOutLetView;
}
-(UIScrollView *)backScrollView
{
    MJWeakSelf;
    if (_backScrollView == nil) {
        _backScrollView = [[UIScrollView alloc]init];
        _backScrollView.backgroundColor = SHTheme.appWhightColor;
        _backScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
        [self.view addSubview:_backScrollView];
    }
    return _backScrollView;
}
-(SHPowerDetailTempValueView *)powerDetailTempValueView
{
    if (_powerDetailTempValueView == nil) {
        _powerDetailTempValueView = [[SHPowerDetailTempValueView alloc]init];
        _powerDetailTempValueView.backgroundColor = [UIColor clearColor];
        [self.backScrollView addSubview:_powerDetailTempValueView];
    }
    return _powerDetailTempValueView;
}
-(SHDeveceOffline *)deveceOffline
{
    if (_deveceOffline == nil) {
        _deveceOffline = [[SHDeveceOffline alloc]init];
        _deveceOffline.hidden = YES;
        [self.view addSubview:_deveceOffline];
    }
    return _deveceOffline;
}
@end
