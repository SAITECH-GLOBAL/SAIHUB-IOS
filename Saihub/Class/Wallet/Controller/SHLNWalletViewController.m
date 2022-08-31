//
//  SHLNWalletViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/16.
//

#import "SHLNWalletViewController.h"
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
#import "SHBottomSelectViewController.h"
#import "SHCreatLNWalletViewController.h"
#import "SHLNWalletHeaderView.h"
#import "SHLNWalletTableViewCell.h"
#import "SHReceiveAddressController.h"
#import "SHLNQRReceiveViewController.h"
#import "SHLNLocationWalletListViewController.h"
@interface SHLNWalletViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) SHLNWalletHeaderView *headerView;

@end

@implementation SHLNWalletViewController

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
        _tableView.rowHeight = 60*FitHeight;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"wallet_addButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.rightButton);
    }];
    
    SHLNWalletHeaderView *headerView = [[SHLNWalletHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 288*FitHeight)];
    self.headerView = headerView;
    self.headerView.lnWalletModel = [SHKeyStorage shared].currentLNWalletModel;
    self.tableView.tableHeaderView = headerView;
    headerView.topUpButtonClickBlock = ^{
        SHBottomSelectViewController *selectVc = [[SHBottomSelectViewController alloc]init];
        selectVc.bottomSelectType = SHBottomSelectWalletSelectType;
        selectVc.titleArray = @[GCLocalizedString(@"Refill_Local_Wallet"),GCLocalizedString(@"Refill_External_Wallet")];
        [self presentPanModal:selectVc];
        selectVc.selectTitleBlock = ^(NSString * _Nonnull select, NSInteger index) {
            if (index == 0) {
                NSArray *wallets = [[SHKeyStorage shared] queryWalletCanTransfer];
                if (wallets.count) {
                    [self.navigationController pushViewController:[SHLNLocationWalletListViewController new] animated:YES];
                }else{
                    [MBProgressHUD showError:GCLocalizedString(@"No_Wallet") toView:self.view];
                }
                
            }else
            {
                SHReceiveAddressController *receiveAddressVc = [[SHReceiveAddressController alloc]init];
                receiveAddressVc.address = [SHKeyStorage shared].currentLNWalletModel.btcAddress;
                receiveAddressVc.isLnAddress = YES;
                [self.navigationController pushViewController:receiveAddressVc animated:YES];
            }
        };
    };
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.equalTo(self.view);
    }];

    MJWeakSelf
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self getLNWalletBalance];
    [self addRACObserve];
    
}
-(void)loadData
{
    self.headerView.lnWalletModel = [SHKeyStorage shared].currentLNWalletModel;
    [self.tableView reloadData];
    [self getLNWalletInvoiceList];
    [self getLNWalletBalance];
}
#pragma mark //获取ln余额
-(void)getLNWalletBalance
{
    NSString *requestWalletString = [NSString stringWithFormat:@"%@%@%@",[SHKeyStorage shared].currentLNWalletModel.WalletName,[SHKeyStorage shared].currentLNWalletModel.UserAccount,[SHKeyStorage shared].currentLNWalletModel.UserPassWord];
    [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpwithHeader:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",[SHKeyStorage shared].currentLNWalletModel.access_token]} WithPath:[NSString stringWithFormat:@"%@/balance",[SHKeyStorage shared].currentLNWalletModel.hostUrl] withMethodType:Get withParams:@{} result:^(id  _Nullable resultData, NSInteger resultCode, NSString *resultMessage) {
        if (resultCode == 0) {
            if ([[resultData className] containsString:@"NSDictionary"]&&[[(NSDictionary *)resultData allKeys]containsObject:@"message"]) {
                if ([resultData[@"message"]isEqualToString:@"bad auth"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTokenKey" object:nil];
                    return;
                }
                [MBProgressHUD showError:resultData[@"message"] toView:self.view];
                return;
            }
            NSString *callBackWalletString = [NSString stringWithFormat:@"%@%@%@",[SHKeyStorage shared].currentLNWalletModel.WalletName,[SHKeyStorage shared].currentLNWalletModel.UserAccount,[SHKeyStorage shared].currentLNWalletModel.UserPassWord];
            if ([requestWalletString isEqualToString:callBackWalletString]) {
                [[SHKeyStorage shared] updateModelBlock:^{
                    [SHKeyStorage shared].currentLNWalletModel.balance =  [NSString stringWithFormat:@"%@",resultData[@"BTC"][@"AvailableBalance"]];
                }];
                self.headerView.lnWalletModel = [SHKeyStorage shared].currentLNWalletModel;
                
                [self.tableView reloadData];
            }

        }else
        {
//            [MBProgressHUD showError:resultMessage toView:nil];
        }
    }];
}
#pragma mark //获取ln交易订单
-(void)getLNWalletInvoiceList
{
//    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    __block BOOL isError = NO;
    __block NSMutableArray *invoiceListArray = [NSMutableArray new];
    __block NSString *requestWalletString = [NSString stringWithFormat:@"%@%@%@",[SHKeyStorage shared].currentLNWalletModel.WalletName,[SHKeyStorage shared].currentLNWalletModel.UserAccount,[SHKeyStorage shared].currentLNWalletModel.UserPassWord];

    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpwithHeader:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",[SHKeyStorage shared].currentLNWalletModel.access_token]} WithPath:[NSString stringWithFormat:@"%@/getuserinvoices?limit=200",[SHKeyStorage shared].currentLNWalletModel.hostUrl] withMethodType:Get withParams:@{
            } result:^(id  _Nullable resultData, NSInteger resultCode, NSString *resultMessage) {
                if (resultCode == 0) {
                    if ([[resultData className] containsString:@"NSDictionary"]&&[[(NSDictionary *)resultData allKeys]containsObject:@"message"]) {
                        isError = YES;
                        if ([resultData[@"message"]isEqualToString:@"bad auth"]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTokenKey" object:nil];
                            return;
                        }
                        [MBProgressHUD showError:resultData[@"message"] toView:self.view];
                        return;
                    }
                    for (NSDictionary *dic in resultData) {
                        SHLNInvoiceListModel *invoiceListModel = [[SHLNInvoiceListModel alloc]init];
                        invoiceListModel.type = dic[@"type"];
                        invoiceListModel.timestamp = [dic[@"timestamp"] longValue];
                        invoiceListModel.expire_time = [dic[@"expire_time"] longValue];
                        invoiceListModel.amount = [NSString stringWithFormat:@"%@",dic[@"amt"]];
                        invoiceListModel.prString = dic[@"pay_req"];
                        invoiceListModel.memo = dic[@"description"];
                        invoiceListModel.ispaid = [dic.allKeys containsObject:@"ispaid"]?[dic[@"ispaid"] boolValue]:false;
                        [invoiceListArray addObject:invoiceListModel];
                    }
                }else
                {
                    isError = YES;
//                    [MBProgressHUD showError:resultMessage toView:nil];
                }
                dispatch_semaphore_signal(semaphore);
            }];
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NetWorkTool shareNetworkTool] requestBaseUrlForCheckContractHttpwithHeader:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",[SHKeyStorage shared].currentLNWalletModel.access_token]} WithPath:[NSString stringWithFormat:@"%@/gettxs?limit=200&offset=0",[SHKeyStorage shared].currentLNWalletModel.hostUrl] withMethodType:Get withParams:@{} result:^(id  _Nullable resultData, NSInteger resultCode, NSString *resultMessage) {
                if (resultCode == 0) {
                    if ([[resultData className] containsString:@"NSDictionary"]&&[[(NSDictionary *)resultData allKeys]containsObject:@"message"]) {
                        isError = YES;
                        if ([resultData[@"message"]isEqualToString:@"bad auth"]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTokenKey" object:nil];
                            return;
                        }
                        [MBProgressHUD showError:resultData[@"message"] toView:self.view];
                        return;
                    }
                    for (NSDictionary *dic in resultData) {
                        SHLNInvoiceListModel *invoiceListModel = [[SHLNInvoiceListModel alloc]init];
                        invoiceListModel.type = dic[@"type"];
                        if ([invoiceListModel.type isEqualToString:@"bitcoind_tx"]) {
                            invoiceListModel.timestamp = [dic[@"time"] longValue];
                            invoiceListModel.amount = [NSString stringWithFormat:@"%@",dic[@"amount"]];
                            invoiceListModel.bc1Address = dic[@"address"];
                        }else
                        {
                            invoiceListModel.timestamp = [dic[@"timestamp"] longValue];
                            invoiceListModel.amount = [NSString stringWithFormat:@"%@",dic[@"value"]];
                            invoiceListModel.prString = dic[@"pay_req"];
                            invoiceListModel.memo = dic[@"memo"];
                        }
                        invoiceListModel.ispaid = true;
                        [invoiceListArray addObject:invoiceListModel];
                    }
                }else
                {
                    isError = YES;
//                    [MBProgressHUD showError:resultMessage toView:nil];
                }
                dispatch_semaphore_signal(semaphore);
            }];
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (!isError) {
            NSArray *dataSourtArray = [invoiceListArray sortedArrayUsingComparator:^(SHLNInvoiceListModel *obj1, SHLNInvoiceListModel *obj2) {
                if (obj1.timestamp > obj2.timestamp) {
                    return NSOrderedDescending;

                } else {
                    return NSOrderedAscending;
                }
            }];
            NSString *callBackWalletString = [NSString stringWithFormat:@"%@%@%@",[SHKeyStorage shared].currentLNWalletModel.WalletName,[SHKeyStorage shared].currentLNWalletModel.UserAccount,[SHKeyStorage shared].currentLNWalletModel.UserPassWord];

            if ([requestWalletString isEqualToString:callBackWalletString]) {
                [[SHKeyStorage shared] updateModelBlock:^{
                        [[SHKeyStorage shared].currentLNWalletModel.invoiceList removeAllObjects];
                        for (SHLNInvoiceListModel *invoiceModel in dataSourtArray) {
                            [[SHKeyStorage shared].currentLNWalletModel.invoiceList insertObject:invoiceModel atIndex:0];
                        }
                }];
            }
    //        [MBProgressHUD hideCustormLoadingWithView:self.view];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            }
            
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SHKeyStorage shared].currentLNWalletModel.invoiceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHLNWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHLNWalletTableViewCell"];
    if (!cell) {
        cell = [[SHLNWalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHLNWalletTableViewCell"];
    }
    cell.lnInvoiceListModel = [[SHKeyStorage shared].currentLNWalletModel.invoiceList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SHLNInvoiceListModel *lnInvoiceListModel = [[SHKeyStorage shared].currentLNWalletModel.invoiceList objectAtIndex:indexPath.row];
    if (!lnInvoiceListModel.ispaid && lnInvoiceListModel.timestamp + lnInvoiceListModel.expire_time >=[NSString getNowTimeTimestamp]/1000)
    {
        //待处理
        SHLNQRReceiveViewController *LNQRReceiveViewController = [SHLNQRReceiveViewController new];
        LNQRReceiveViewController.address = lnInvoiceListModel.prString;
        LNQRReceiveViewController.amountString = [NSString stringWithFormat:@"%@ %@",lnInvoiceListModel.amount,GCLocalizedString(@"sats")];
        LNQRReceiveViewController.memo = lnInvoiceListModel.memo;
        LNQRReceiveViewController.timeCreat = lnInvoiceListModel.timestamp;
        [self.navigationController pushViewController:LNQRReceiveViewController animated:YES];
    }
}

#pragma mark -- 1.0 切换抽屉
- (void)leftButtonClick {
    CWLateralSlideConfiguration *config = [CWLateralSlideConfiguration defaultConfiguration];
    config.distance = kScreenWidth *0.8;
    SHAddWalletController *personalVc = [[SHAddWalletController alloc]init];
    personalVc.addWalletClickBlock = ^(NSInteger addType){
        if (addType == 1) {
            SHBottomSelectViewController *selectVc = [[SHBottomSelectViewController alloc]init];
            selectVc.titleArray = @[GCLocalizedString(@"BTC_Wallet"),GCLocalizedString(@"Lightning_Network")];
            [self presentPanModal:selectVc];
            selectVc.selectTitleBlock = ^(NSString * _Nonnull select, NSInteger index) {
                if (index == 0) {
                    if ([SHWalletModel allObjects].count >=10) {
                        [MBProgressHUD  showError:GCLocalizedString(@"wallet_num_tip") toView:nil];
                        return;
                    }
                    [self.navigationController pushViewController:[SHSetWalletPassWordViewController new] animated:YES];;
                }else
                {
                    if ([SHLNWalletModel allObjects].count >=10) {
                        [MBProgressHUD  showError:GCLocalizedString(@"wallet_num_tip") toView:nil];
                        return;
                    }
                    [self.navigationController pushViewController:[SHCreatLNWalletViewController new] animated:YES];
                }

            };
        }else if (addType == 2)
        {
            if ([SHWalletModel allObjects].count >=10) {
                [MBProgressHUD  showError:GCLocalizedString(@"wallet_num_tip") toView:nil];
                return;
            }
            [self.navigationController pushViewController:[SHSetWalletPassWordViewController new] animated:YES];;
        }else if (addType == 3)
        {
            if ([SHLNWalletModel allObjects].count >=10) {
                [MBProgressHUD  showError:GCLocalizedString(@"wallet_num_tip") toView:nil];
                return;
            }
            [self.navigationController pushViewController:[SHCreatLNWalletViewController new] animated:YES];
        }
    };
    SHNavigationController *nav = [[SHNavigationController alloc]initWithRootViewController:personalVc];
    [self cw_showDrawerViewController:nav animationType:CWDrawerAnimationTypeMask configuration:config];
}

#pragma mark -- 2.0 添加监听
- (void)addRACObserve {
    
    // 切换钱包
    @weakify(self);
//    [RACObserve([SHKeyStorage shared], currentLNWalletModel) subscribeNext:^(SHLNWalletModel *_Nullable x) {
//        @strongify(self);
//
//        self.tableView.hidden = x == nil;
//
//        if (x == nil) {
//            SHWalletEmptyView *emptyView = [[SHWalletEmptyView alloc]init];
//            [self.view addSubview:emptyView];
//            [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(20);
//                make.right.mas_equalTo(-20);
//                make.top.equalTo(self.navBar.mas_bottom).offset(20);
//                make.height.mas_equalTo(168);
//            }];
//
//            return;
//        }
//        [self getLNWalletInvoiceList];
//        NSEnumerator *subviewsEnum = [self.view.subviews reverseObjectEnumerator];
//        for (UIView *subview in subviewsEnum) {
//            if ([subview isKindOfClass:[SHWalletEmptyView class]]) {
//                [subview removeFromSuperview];
//            }
//        }
//
//        self.headerView.lnWalletModel = x;
//
//        [self.tableView reloadData];
//
//    }];
     //余额请求成功
    [RACObserve([SHKeyStorage shared].currentLNWalletModel, balance) subscribeNext:^(id  _Nullable x) {
        @strongify(self);

        if ([SHKeyStorage shared].currentLNWalletModel.isInvalidated == YES) {
            return;
        }

        if ([x boolValue] == YES) {

            self.headerView.lnWalletModel = [SHKeyStorage shared].currentLNWalletModel;

            [self.tableView reloadData];

            [self.tableView.mj_header endRefreshing];
        }
    }];
    [[RACObserve(KAppSetting, currency) skip:0] subscribeNext:^(id  _Nullable x) {
        self.headerView.lnWalletModel = [SHKeyStorage shared].currentLNWalletModel;
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
    }];
}


@end
