//
//  SHTransactionRecordController.m
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import "SHTransactionRecordController.h"
#import "SHTransactionRecordCell.h"
#import "SHRefreshHeader.h"
#import "SHRefreshFooter.h"
#import "SHWebViewController.h"

@interface SHTransactionRecordController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, assign) CGFloat tableViewMargin;

@end

@implementation SHTransactionRecordController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - kNavBarHeight - kStatusBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = SHTheme.addressTypeCellBackColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(self.tableViewMargin, 0, self.tableViewMargin + SafeAreaBottomHeight + 52 + 24, 0);
        [_tableView registerClass:[SHTransactionRecordCell class] forCellReuseIdentifier:@"SHTransactionRecordCellID"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.rowHeight = 52;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.hidden = YES;

    self.tableViewMargin = 16;

    [self.view addSubview:self.tableView];
    self.stackView.backgroundColor = SHTheme.addressTypeCellBackColor;
    
    MJWeakSelf
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingBlock:^{
        if ([weakSelf.delegate respondsToSelector:@selector(requestRecordWithType:)]) {
            [weakSelf.delegate requestRecordWithType:weakSelf.controllerType];
        }
    }];
            
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = self.tableViewMargin;
    
    if (self.controllerType == SHTransactionRecordControllerTypeAll) {
        [self.tableView.mj_header beginRefreshing];
    }

}

#pragma mark -- UIScrollViewDelegate & JXPagerViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHTransactionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTransactionRecordCellID" forIndexPath:indexPath];
    cell.listModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SHTransactionListModel *listModel = self.dataArray[indexPath.row];
    
    if (listModel.status != SHTransactionStatusPending) {
        
        NSString *url;
        if (self.tokenModel.isPrimaryToken) {
            url = [NSString stringWithFormat:@"https://btc.com/zh-CN/btc/transaction/%@",listModel.t_hash];
        } else {
            url = [NSString stringWithFormat:@"https://www.omniexplorer.info/search/%@",listModel.t_hash];
        }
        SHWebViewController *webVc = [[SHWebViewController alloc]init];
        webVc.fileUrl = url;
        [self.navigationController pushViewController:webVc animated:YES];

    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    JLButton *moreButton = [JLButton buttonWithType:UIButtonTypeCustom];
    moreButton.imagePosition = JLButtonImagePositionRight;
    [moreButton setTitle:GCLocalizedString(@"more_desc") forState:UIControlStateNormal];
    [moreButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
    moreButton.titleLabel.font = kCustomMontserratMediumFont(14);
    [moreButton setImage:[UIImage imageNamed:@"record_moreButton"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(8);
    }];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 52;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

/// 跳转到区块浏览器
- (void)moreButtonClick {
    if ([self.delegate respondsToSelector:@selector(pushBlockExpolor)]) {
        [self.delegate pushBlockExpolor];
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}

@end
