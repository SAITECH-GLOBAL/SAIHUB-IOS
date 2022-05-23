//
//  SHTransactionRecordTotalController.m
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import "SHTransactionRecordTotalController.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
#import "JXCategoryView.h"
#import "SHTransactionRecordHeaderView.h"
#import "SHTransactionRecordController.h"
#import "SHReceiveAddressController.h"
#import "SHWebViewController.h"
#import "SHTransferViewController.h"


@interface SHTransactionRecordTotalController () <JXCategoryViewDelegate,JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate, SHTransactionRecordControllerDelegate>

@property (nonatomic, strong) JXPagerListRefreshView *pagingView;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

/// 顶部视图高度
@property (nonatomic, assign) CGFloat transactionHeaderHeight;

/// 背景图高度
@property (nonatomic, assign) CGFloat bgImageHeight;

/// 顶部视图
@property (nonatomic, strong) SHTransactionRecordHeaderView *headerView;

@property (nonatomic, strong) SHTransactionRecordController *allVc;

@property (nonatomic, strong) SHTransactionRecordController *inVc;

@property (nonatomic, strong) SHTransactionRecordController *outVc;

@property (nonatomic, strong) SHTransactionRecordController *failVc;

@property (nonatomic, strong) NSMutableArray *allArray;

@property (nonatomic, strong) NSMutableArray *outArray;

@property (nonatomic, strong) NSMutableArray *inArray;

@property (nonatomic, strong) NSMutableArray *failArray;

@property (nonatomic, strong) UIImageView           *headerBgImgView;

@property (nonatomic, strong) UIVisualEffectView    *effectView;

/// 选中的索引
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, weak) JLButton *receiveButton;

@property (nonatomic, weak) JLButton *sendButton;

@end

@implementation SHTransactionRecordTotalController

- (SHTransactionRecordController *)allVc {
    if (_allVc == nil) {
        _allVc = [[SHTransactionRecordController alloc]init];
        _allVc.controllerType = SHTransactionRecordControllerTypeAll;
        _allVc.tokenModel = self.tokenModel;
        _allVc.delegate = self;
    }
    return _allVc;
}

- (SHTransactionRecordController *)outVc {
    if (_outVc == nil) {
        _outVc = [[SHTransactionRecordController alloc]init];
        _outVc.controllerType = SHTransactionRecordControllerTypeOut;
        _outVc.tokenModel = self.tokenModel;
        _outVc.delegate = self;
    }
    return _outVc;
}

- (SHTransactionRecordController *)inVc {
    if (_inVc == nil) {
        _inVc = [[SHTransactionRecordController alloc]init];
        _inVc.controllerType = SHTransactionRecordControllerTypeIn;
        _inVc.tokenModel = self.tokenModel;
        _inVc.delegate = self;
    }
    return _inVc;
}

- (SHTransactionRecordController *)failVc {
    if (_failVc == nil) {
        _failVc = [[SHTransactionRecordController alloc]init];
        _failVc.controllerType = SHTransactionRecordControllerTypeFail;
        _failVc.tokenModel = self.tokenModel;
        _failVc.delegate = self;
    }
    return _failVc;
}

- (NSMutableArray *)allArray {
    if (_allArray == nil) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}

- (NSMutableArray *)outArray {
    if (_outArray == nil) {
        _outArray = [NSMutableArray array];
    }
    return _outArray;
}

- (NSMutableArray *)inArray {
    if (_inArray == nil) {
        _inArray = [NSMutableArray array];
    }
    return _inArray;
}

- (NSMutableArray *)failArray {
    if (_failArray == nil) {
        _failArray = [NSMutableArray array];
    }
    return _failArray;
}

- (UIImageView *)headerBgImgView {
    if (!_headerBgImgView) {
        _headerBgImgView = [UIImageView new];
        _headerBgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headerBgImgView.clipsToBounds = YES;
        _headerBgImgView.image = [UIImage imageNamed:@"transactionRecord_backImage"];
    }
    return _headerBgImgView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.alpha = 0;
    }
    return _effectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.backgroundColor = [UIColor clearColor];
    self.isLightContent = YES;
    self.titleLabel.text = self.tokenModel.tokenShort;
    self.view.backgroundColor = SHTheme.addressTypeCellBackColor;
    
    self.transactionHeaderHeight = 166 + kStatusBarHeight;
    self.headerView = [[SHTransactionRecordHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.transactionHeaderHeight)];
    self.headerView.tokenModel = self.tokenModel;
        
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    self.categoryView.titles = @[GCLocalizedString(@"record_all"),GCLocalizedString(@"record_out"),GCLocalizedString(@"record_in"),GCLocalizedString(@"record_failed")];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = SHTheme.agreeButtonColor;
    self.categoryView.titleColor = SHTheme.walletNameLabelColor;
    self.categoryView.titleFont = kCustomMontserratRegularFont(14);
    self.categoryView.titleSelectedFont = kCustomMontserratMediumFont(14);
    
    UIView *cornerView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, 64)];
    [self.categoryView insertSubview:cornerView atIndex:0];
    cornerView.layer.cornerRadius = 8;
    cornerView.backgroundColor = SHTheme.appWhightColor;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = SHTheme.agreeButtonColor;
    lineView.verticalMargin = 8;
    lineView.indicatorWidth = 16;
    self.categoryView.indicators = @[lineView];

    _pagingView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    _pagingView.pinSectionHeaderVerticalOffset = kNavBarHeight + kStatusBarHeight;
    [self.view insertSubview:self.pagingView belowSubview:self.navBar];
    self.pagingView.mainTableView.gestureDelegate = self;
    self.pagingView.mainTableView.backgroundColor = SHTheme.addressTypeCellBackColor;
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
        
    // 背景图
    self.bgImageHeight = 230 + kStatusBarHeight;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"transactionRecord_backImage"]];
    imageView.frame = CGRectMake(0, 0, kScreenWidth, self.bgImageHeight);
    [self.pagingView.mainTableView insertSubview:imageView atIndex:0];

    BOOL isShowSend = YES;
    
    if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypeAddress||([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey && IsEmpty([SHKeyStorage shared].currentWalletModel.zpubJsonString)&&IsEmpty([SHKeyStorage shared].currentWalletModel.zpubList))) {
        isShowSend = NO;
    }
    
    // 收款
    JLButton *receiveButton = [JLButton buttonWithType:UIButtonTypeCustom];
    self.receiveButton = receiveButton;
    receiveButton.backgroundColor = SHTheme.shareBackgroundColor;
    receiveButton.spacingBetweenImageAndTitle = 2;
    receiveButton.layer.cornerRadius = 26;
    receiveButton.layer.masksToBounds = YES;
    [receiveButton setTitle:GCLocalizedString(@"Receive") forState:UIControlStateNormal];
    [receiveButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
    receiveButton.titleLabel.font = kCustomMontserratMediumFont(14);
    [receiveButton setImage:[UIImage imageNamed:@"transactionRecord_receiveImage"] forState:UIControlStateNormal];
    [receiveButton addTarget:self action:@selector(receiveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:receiveButton];
    [receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(136, 52));
        make.bottom.mas_equalTo(-SafeAreaBottomHeight - 24);
        
        if (isShowSend == NO) {
            make.centerX.mas_equalTo(0);
        } else {
            make.right.equalTo(self.view.mas_centerX).offset(- 10 *FitWidth);
        }
    }];
    
    // 转账
    JLButton *sendButton = [JLButton buttonWithType:UIButtonTypeCustom];
    self.sendButton = sendButton;
    sendButton.backgroundColor = SHTheme.shareBackgroundColor;
    sendButton.spacingBetweenImageAndTitle = 2;
    sendButton.layer.cornerRadius = 26;
    sendButton.layer.masksToBounds = YES;
    [sendButton setTitle:GCLocalizedString(@"Send") forState:UIControlStateNormal];
    [sendButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:@"transactionRecord_sendImage"] forState:UIControlStateNormal];
    sendButton.titleLabel.font = kCustomMontserratMediumFont(14);
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(136, 52));
        make.bottom.mas_equalTo(-SafeAreaBottomHeight - 24);
        make.left.equalTo(self.view.mas_centerX).offset(10 *FitWidth);
    }];
    
    if (isShowSend == NO) {
        sendButton.hidden = YES;
    }
    
    // 推送刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushRefreshData:) name:kClickPushNoticeKey object:nil];
    
    // 转账成功刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeRefreshRecord) name:kTransferSuccessKey object:nil];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews]; // - SafeAreaBottomHeight - 52 - 24
    self.pagingView.frame = CGRectMake(0, 0, kScreenWidth , KScreenHeight);
}

#pragma mark - JXPagerViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.transactionHeaderHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 64;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        return self.allVc;
    } else if (index == 1) {
        return self.outVc;
    } else if (index == 2) {
        return self.inVc;
    }
    return self.failVc;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.selectIndex = index;
    
    [self showControllerData];
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0) {
        
        CGFloat alpha = 0.0f;
        if (offsetY < 20) {
            alpha = offsetY / 20;
        } else {
            alpha = 1;
        }
        
        self.headerView.balanceLabel.alpha = 1-alpha;
        self.headerView.convertLabel.alpha = 1-alpha;
    }
    
}

#pragma mark -- 收款
- (void)receiveButtonClick {
    SHReceiveAddressController *receiveAddressVc = [[SHReceiveAddressController alloc]init];
    receiveAddressVc.address = [SHKeyStorage shared].currentWalletModel.address;
    [self.navigationController pushViewController:receiveAddressVc animated:YES];
}

#pragma mark -- 转账
- (void)sendButtonClick {
    // bc1不支持omni转账
    if (([[SHKeyStorage shared].currentWalletModel.address hasPrefix:@"bc1"] ||[SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey) && self.tokenModel.isPrimaryToken == NO) {
        [MBProgressHUD showError:GCLocalizedString(@"Omni_not_transfer") toView:self.view];
        return;
    }
    
    SHTransferViewController *transferVc = [[SHTransferViewController alloc]init];
    transferVc.tokenModel = self.tokenModel;
    [self.navigationController pushViewController:transferVc animated:YES];
}

#pragma mark -- 下拉刷新的代理
- (void)requestRecordWithType:(SHTransactionRecordControllerType)controllerType {
    MJWeakSelf
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:[SHKeyStorage shared].currentWalletModel.subAddressStr forKey:@"address"];
    
    NSString *path = @"/rest/asset/record/list/btc";
    if (self.tokenModel.isPrimaryToken == NO) {
        [para setValue:@(31) forKey:@"propertyId"];
        path = @"/rest/asset/record/list/omni";
    }
    
    [para setValue:@(1) forKey:@"pageNo"];
    [para setValue:@(30) forKey:@"pageSize"];
    
    [[NetWorkTool shareNetworkTool] requestHttpWithPath:path withMethodType:Get withParams:para result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        
        if (code == 0) {
            NSArray *dataArray = [NSArray modelArrayWithClass:[SHTransactionListModel class] json:responseModel.data.result[@"records"]];
            
            [weakSelf filterRecordDataWithArray: dataArray.mutableCopy];
        }
        
        if (controllerType == SHTransactionRecordControllerTypeAll) {
            [weakSelf.allVc.tableView.mj_header endRefreshing];
        }
        
        if (controllerType == SHTransactionRecordControllerTypeOut) {
            [weakSelf.outVc.tableView.mj_header endRefreshing];
        }

        if (controllerType == SHTransactionRecordControllerTypeIn) {
            [weakSelf.inVc.tableView.mj_header endRefreshing];
        }

        if (controllerType == SHTransactionRecordControllerTypeFail) {
            [weakSelf.failVc.tableView.mj_header endRefreshing];
        }

    }];
    
}

#pragma mark -- 跳转到区块浏览器
- (void)pushBlockExpolor {
    NSString *url;
    
    if (self.tokenModel.isPrimaryToken) {
        url = [NSString stringWithFormat:@"https://btc.com/btc/address/%@",[SHKeyStorage shared].currentWalletModel.address];
    } else {
        url = [NSString stringWithFormat:@"https://www.omniexplorer.info/address/%@",[SHKeyStorage shared].currentWalletModel.address];
    }
    
    SHWebViewController *webVc = [[SHWebViewController alloc]init];
    webVc.fileUrl = url;
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark -- 过滤记录
- (void)filterRecordDataWithArray:(NSMutableArray *)dataArray {
    [self.allArray removeAllObjects];
    [self.outArray removeAllObjects];
    [self.inArray removeAllObjects];
    [self.failArray removeAllObjects];
        
    // 如果pending中交易成功了,要删除
    NSMutableArray *pendingArray = [NSMutableArray array];
    for (SHTransactionListModel *listModel in self.tokenModel.pendingList) {
        NSInteger pendingIndex = [self.tokenModel.pendingList indexOfObjectWhere:[NSString stringWithFormat:@"t_hash = '%@'",listModel.t_hash]];
        [pendingArray addObject:listModel];
        for (SHTransactionListModel *model in dataArray) {
            NSLog(@"交易的hash == %@ -- %@ -- 是否相等 == %d",listModel.t_hash, model.t_hash,[listModel.t_hash isEqual:model.t_hash]);
            if ([listModel.t_hash isEqual:model.t_hash]) {
                [[SHKeyStorage shared] updateModelBlock:^{
                    [self.tokenModel.pendingList removeObjectAtIndex:pendingIndex];
                }];
                [pendingArray removeObject:listModel];
            }
        }
    }
    
    [dataArray insertObjects:pendingArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, pendingArray.count)]];
    
    // 全部
    [self.allArray addObjectsFromArray:dataArray];
    
    [dataArray enumerateObjectsUsingBlock:^(SHTransactionListModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 转出
        if (obj.type == 2) {
            [self.outArray addObject:obj];
        } else if (obj.type == 1) { // 转入
            [self.inArray addObject:obj];
        }
        
        if (obj.status == SHTransactionStatusFailed) { // 失败
            [self.failArray addObject:obj];
        }
    }];
       
    [self showControllerData];
}

/// 展示页面数据
- (void)showControllerData {
    
    switch (self.selectIndex) {
        case 0:
            self.allVc.dataArray = self.allArray;
            break;
        case 1:
            self.outVc.dataArray = self.outArray;
            break;
        case 2:
            self.inVc.dataArray = self.inArray;
            break;
        case 3:
            self.failVc.dataArray = self.failArray;
            break;
        default:
            break;
    }

}

/// 通知刷新数据
- (void)noticeRefreshRecord {
    
    [self requestRecordWithType:self.selectIndex];
}

/// 点击推送刷新
- (void)pushRefreshData:(NSNotification *)notification {
    
    BOOL isShowSend = YES;
    
    if ([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypeAddress||([SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey && IsEmpty([SHKeyStorage shared].currentWalletModel.zpubJsonString)&&IsEmpty([SHKeyStorage shared].currentWalletModel.zpubList))) {
        isShowSend = NO;
    }
    
    if (isShowSend == NO) {
        self.sendButton.hidden = YES;
    } else {
        self.sendButton.hidden = NO;
    }
    
    [self.receiveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(136, 52));
        make.bottom.mas_equalTo(-SafeAreaBottomHeight - 24);
        
        if (isShowSend == NO) {
            make.centerX.mas_equalTo(0);
        } else {
            make.right.equalTo(self.view.mas_centerX).offset(- 10 *FitWidth);
        }
    }];

    [self.sendButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(136, 52));
        make.bottom.mas_equalTo(-SafeAreaBottomHeight - 24);
        make.left.equalTo(self.view.mas_centerX).offset(10 *FitWidth);
    }];

    SHWalletTokenModel *tokenModel = notification.object;
    self.tokenModel = tokenModel;
    
    self.headerView.tokenModel = tokenModel;
    
    self.titleLabel.text = tokenModel.tokenShort;
        
    [self requestRecordWithType:self.selectIndex];
}

@end
