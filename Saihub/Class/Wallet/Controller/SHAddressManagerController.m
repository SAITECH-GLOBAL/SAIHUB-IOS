//
//  SHAddressManagerController.m
//  Saihub
//
//  Created by 周松 on 2022/3/3.
//

#import "SHAddressManagerController.h"
#import "SHAddressManagerCell.h"
#import "SHKeyStorage.h"
#import "SHReceiveAddressController.h"


@interface SHAddressManagerController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SHAddressManagerController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight + kStatusBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SHAddressManagerCell class] forCellReuseIdentifier:@"SHAddressManagerCellID"];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.rowHeight = 68;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.contentInset = UIEdgeInsetsMake(4, 0, 10 + SafeAreaBottomHeight, 0);
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = GCLocalizedString(@"Addresses");
    
    [self.view addSubview:self.tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SHKeyStorage shared].currentWalletModel.subAddressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHAddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHAddressManagerCellID" forIndexPath:indexPath];
    cell.numberLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
    cell.addressModel = [[SHKeyStorage shared].currentWalletModel.subAddressList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SHReceiveAddressController *receiveVc = [[SHReceiveAddressController alloc]init];
    receiveVc.address = [[SHKeyStorage shared].currentWalletModel.subAddressList objectAtIndex:indexPath.row].address;
    
    [self.navigationController pushViewController:receiveVc animated:YES];
}

@end
