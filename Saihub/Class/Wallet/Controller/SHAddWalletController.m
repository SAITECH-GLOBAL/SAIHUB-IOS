//
//  SHAddWalletController.m
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import "SHAddWalletController.h"
#import "SHAddWalletCell.h"
#import "SHKeyStorage.h"
#import <UIViewController+CWLateralSlide.h>


@interface SHAddWalletController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/// 页面宽度
@property (nonatomic, assign) CGFloat drawerWidth;

/// 观察钱包数量
@property (nonatomic, assign) NSInteger watchWalletCount;

/// 其余类型钱包数量
@property (nonatomic, assign) NSInteger otherWalletCount;

/// 正常钱包集合
@property (nonatomic, strong) RLMResults *walletResult;

/// 观察者钱包集合
@property (nonatomic, strong) RLMResults *watchWalletResult;

@end

@implementation SHAddWalletController

- (RLMResults *)walletResult {
    return [[SHWalletModel objectsWhere:[NSString stringWithFormat:@"importType != %zd AND importType != %zd",SHWalletImportTypeAddress,SHWalletImportTypePublicKey]] sortedResultsUsingKeyPath:@"createTimestamp" ascending:NO];
}

- (RLMResults *)watchWalletResult {
    return [[SHWalletModel objectsWhere:[NSString stringWithFormat:@"importType == %zd OR importType == %zd",SHWalletImportTypeAddress,SHWalletImportTypePublicKey]] sortedResultsUsingKeyPath:@"createTimestamp" ascending:NO];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SHAddWalletCell class] forCellReuseIdentifier:@"SHAddWalletCellID"];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.rowHeight = 96;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10 + SafeAreaBottomHeight, 0);
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SHTheme.appWhightColor;
    self.navBar.hidden = YES;
    
    self.drawerWidth = self.view.width * 0.8;
    
    NSInteger totalCount = [SHWalletModel allObjects].count;

    self.watchWalletCount = self.watchWalletResult.count;
    
    self.otherWalletCount = totalCount - self.watchWalletCount;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = GCLocalizedString(@"wallet_list");
    titleLabel.textColor = SHTheme.walletTextColor;
    titleLabel.font = kCustomMontserratMediumFont(24);
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(34 + kStatusBarHeight);
    }];
    
    YYLabel *addLabel = [[YYLabel alloc]init];
    addLabel.backgroundColor = SHTheme.labelBackgroundColor;
    addLabel.text = GCLocalizedString(@"add_wallet");
    addLabel.textColor = SHTheme.agreeButtonColor;
    addLabel.font = kCustomMontserratMediumFont(12);
    addLabel.layer.cornerRadius = 17;
    addLabel.textContainerInset = UIEdgeInsetsMake(9, 31, 9, 12);
    [self.view addSubview:addLabel];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(titleLabel);
    }];
        
    UIImageView *addImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addIcon_green"]];
    [addLabel addSubview:addImageView];
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.centerY.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
//    UIView *line1 = [[UIView alloc]init];
//    line1.backgroundColor = SHTheme.agreeButtonColor;
//    line1.layer.cornerRadius = 1;
//    [addLabel addSubview:line1];
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(16);
//        make.centerY.equalTo(addLabel);
//        make.size.mas_equalTo(CGSizeMake(2, 9.7));
//    }];
//
//    UIView *line2 = [[UIView alloc]init];
//    line2.backgroundColor = SHTheme.agreeButtonColor;
//    line2.layer.cornerRadius = 1;
//    [addLabel addSubview:line2];
//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(line1);
//        make.size.mas_equalTo(CGSizeMake(9.7, 2));
//    }];
    
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addWalletEvent)];
    [addLabel addGestureRecognizer:addTap];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.drawerWidth);
        make.top.equalTo(titleLabel.mas_bottom).offset(12);
        make.bottom.mas_equalTo(0);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    if (section == 0) {
        if (self.otherWalletCount == 0) {
            return 1;
        }
        return self.otherWalletCount;
    }
    
    if (self.watchWalletCount == 0) {
        return 1;
    }
    return self.watchWalletCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHAddWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHAddWalletCellID" forIndexPath:indexPath];

    if (indexPath.section == 0) {
        cell.isEmpty = self.otherWalletCount == 0;
    } else {
        cell.isEmpty = self.watchWalletCount == 0;
    }
    
    if (cell.isEmpty == NO) {
        if (indexPath.section == 0) {
            cell.walletModel = [self.walletResult objectAtIndex:indexPath.row];
        } else {
            cell.walletModel = [self.watchWalletResult objectAtIndex:indexPath.row];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { // 正常钱包
        if (self.otherWalletCount == 0) { // 跳转到创建.导入
            [self addWalletEvent];
        } else { // 选中当前钱包
            [SHKeyStorage shared].currentWalletModel = [self.walletResult objectAtIndex:indexPath.row];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else { // 观察者钱包
        if (self.watchWalletCount == 0) {
            [self addWalletEvent];
        } else {
            [SHKeyStorage shared].currentWalletModel = [self.watchWalletResult objectAtIndex:indexPath.row];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[GCLocalizedString(@"wallet_btc"),GCLocalizedString(@"wallet_ob")];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.drawerWidth, 36)];
    headerView.backgroundColor = SHTheme.appWhightColor;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = titles[section];
    titleLabel.textColor = SHTheme.appBlackColor;
    titleLabel.font = kCustomMontserratMediumFont(14);
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(8);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

#pragma mark -- 跳转到添加
- (void)addWalletEvent {
    if ([SHWalletModel allObjects].count >=10) {
        [MBProgressHUD  showError:GCLocalizedString(@"wallet_num_tip") toView:nil];
        return;
    }
    [self cw_pushViewController:[SHSetWalletPassWordViewController new]];
}

@end
