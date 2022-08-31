//
//  SHLNLocationWalletListViewController.m
//  Saihub
//
//  Created by macbook on 2022/6/24.
//

#import "SHLNLocationWalletListViewController.h"
#import "SHLNLocationWalletListTableViewCell.h"
@interface SHLNLocationWalletListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *appLicationTableView;
@property (strong, nonatomic)  NSArray *dataSourt;

@end

@implementation SHLNLocationWalletListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHTheme.appWhightColor;
    self.titleLabel.text = GCLocalizedString(@"wallet_list");
    [self layoutScale];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataSourt = [[SHKeyStorage shared] queryWalletCanTransfer];
    [self.appLicationTableView reloadData];
}
#pragma  mark 布局页面
-(void)layoutScale
{
    self.appLicationTableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.navBar, 8).bottomEqualToView(self.view);
    [self.view layoutIfNeeded];
}
#pragma mark tableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94*FitHeight;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourt.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHLNLocationWalletListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHLNLocationWalletListTableViewCell"];
    if (!cell) {
        cell = [[SHLNLocationWalletListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHLNLocationWalletListTableViewCell"];
    }
    SHWalletModel *cellModel = self.dataSourt[indexPath.row];
    cell.walletModel = cellModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SHWalletModel *cellModel = self.dataSourt[indexPath.row];
    [SHKeyStorage shared].currentWalletModel = cellModel;
    [self popViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectLocationWalletToTradingKey" object:nil];
}
#pragma mark 懒加载
-(UITableView *)appLicationTableView
{
    if (_appLicationTableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
        _appLicationTableView = tableView;
    }
    return _appLicationTableView;
}
@end
