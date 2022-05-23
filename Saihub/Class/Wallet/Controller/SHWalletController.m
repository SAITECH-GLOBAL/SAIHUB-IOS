//
//  SHWalletController.m
//  Saihub
//
//  Created by 周松 on 2022/2/15.
//

#import "SHWalletController.h"
#import "SHPowerDetailViewController.h"
#import "SHSetWalletPassWordViewController.h"
#import "SHWalletHeaderView.h"
#import "SHWalletTableViewCell.h"
#import "SHTransactionRecordTotalController.h"
#import "SHKeyStorage.h"
#import <UIViewController+CWLateralSlide.h>
#import "SHAddWalletController.h"
#import "SHNavigationController.h"
#import "SHWalletEmptyView.h"
#import "SHBtcCreatOrImportWalletManage.h"
#import "SHWalletViewModel.h"
#import "SHRefreshHeader.h"
#import "SHTransferViewController.h"

@interface SHWalletController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) SHWalletHeaderView *headerView;

@property (nonatomic, strong) SHWalletViewModel *viewModel;

@end

@implementation SHWalletController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SHWalletTableViewCell class] forCellReuseIdentifier:@"SHWalletTableViewCellID"];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.rowHeight = 94;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.headerView.addressLabel.text = [[SHKeyStorage shared].currentWalletModel.address formatAddressStrLeft:6 right:6];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"wallet_addButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.rightButton);
    }];
    
    SHWalletHeaderView *headerView = [[SHWalletHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    MJWeakSelf
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.viewModel requestWalletBalanceData];
    }];
    
    self.viewModel = [[SHWalletViewModel alloc]init];
    
    [self addRACObserve];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SHKeyStorage shared].currentWalletModel.tokenList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHWalletTableViewCellID" forIndexPath:indexPath];
    cell.tokenModel = [[SHKeyStorage shared].currentWalletModel.tokenList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SHTransactionRecordTotalController *recordVc = [[SHTransactionRecordTotalController alloc]init];
    recordVc.tokenModel = [[SHKeyStorage shared].currentWalletModel.tokenList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:recordVc animated:YES];
}

#pragma mark -- 1.0 切换抽屉
- (void)leftButtonClick {
    CWLateralSlideConfiguration *config = [CWLateralSlideConfiguration defaultConfiguration];
    config.distance = kScreenWidth *0.8;
    SHAddWalletController *personalVc = [[SHAddWalletController alloc]init];
    SHNavigationController *nav = [[SHNavigationController alloc]initWithRootViewController:personalVc];
    [self cw_showDrawerViewController:nav animationType:CWDrawerAnimationTypeMask configuration:config];
}

#pragma mark -- 2.0 添加监听
- (void)addRACObserve {
    
    // 切换钱包
    @weakify(self);
    [RACObserve([SHKeyStorage shared], currentWalletModel) subscribeNext:^(SHWalletModel *_Nullable x) {
        @strongify(self);
        
        self.tableView.hidden = x == nil;

        if (x == nil) {
            SHWalletEmptyView *emptyView = [[SHWalletEmptyView alloc]init];
            [self.view addSubview:emptyView];
            [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                make.top.equalTo(self.navBar.mas_bottom).offset(20);
                make.height.mas_equalTo(168);
            }];

            return;
        }
        
        NSEnumerator *subviewsEnum = [self.view.subviews reverseObjectEnumerator];
        for (UIView *subview in subviewsEnum) {
            if ([subview isKindOfClass:[SHWalletEmptyView class]]) {
                [subview removeFromSuperview];
            }
        }
        
        // 每次切换先刷新缓存
        [self.viewModel traverseCellGetBalance];
        
        // 然后再请求接口
        [self.viewModel requestWalletBalanceData];
        
        self.headerView.walletModel = x;
        
        [self.tableView reloadData];

    }];
    
    // 余额请求成功
    [RACObserve(self.viewModel, endRefresh) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([SHKeyStorage shared].currentWalletModel.isInvalidated == YES) {
            return;
        }
        
        if ([x boolValue] == YES) {
            
            self.headerView.walletModel = [SHKeyStorage shared].currentWalletModel;
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
        }
    }];
    
    [[RACObserve(KAppSetting, currency) skip:0] subscribeNext:^(id  _Nullable x) {
        [self.viewModel traverseCellGetBalance];
        
        self.headerView.walletModel = [SHKeyStorage shared].currentWalletModel;
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
    }];
}

@end

