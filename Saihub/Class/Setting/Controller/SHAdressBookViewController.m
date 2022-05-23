//
//  SHAdressBookViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHAdressBookViewController.h"
#import "SHAdressBookTableViewCell.h"
#import "SHNoAdressBookTableViewCell.h"
#import "SHAddAddressViewController.h"
@interface SHAdressBookViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *appLicationTableView;
@property (strong, nonatomic)  NSArray *dataSourt;

@end

@implementation SHAdressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHTheme.appWhightColor;
    self.titleLabel.text = GCLocalizedString(@"address_book");
    [self.rightButton setTitle:GCLocalizedString(@"+_Add") forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"addIcon_green"] forState:UIControlStateNormal];
    self.rightButton.imagePosition = JLButtonImagePositionLeft;
    self.rightButton.spacingBetweenImageAndTitle = 5;
    [self.rightButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = kCustomMontserratMediumFont(12);
    [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self layoutScale];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.dataSourt = [[SHAddressSaveStorage shared] getAddressArray];
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
    if (self.dataSourt.count) {
        return 94*FitHeight;
    }
    return 96*FitHeight;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSourt.count) {
        return self.dataSourt.count;
    }
    return 1;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourt.count) {
        SHAdressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHAdressBookTableViewCell"];
        if (!cell) {
            cell = [[SHAdressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHAdressBookTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.addressBookModel = self.dataSourt[indexPath.row];
        return cell;
    }else
    {
        SHNoAdressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHNoAdressBookTableViewCell"];
        if (!cell) {
            cell = [[SHNoAdressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHNoAdressBookTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MJWeakSelf;
    SHAddressBookModel *addressModel = self.dataSourt[indexPath.row];
    if (self.inputType == 1) {
        if (self.selectAddressClickBlock) {
            self.selectAddressClickBlock(addressModel);
        }
        [self popViewController];
        return;
    }
    SHBottomAlertView *bottomAlerView = [[SHBottomAlertView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT) withcontainerHeight:262*FitHeight + SafeAreaBottomHeight withBottomAlertType:bottomAlertAdressBookType];
    bottomAlerView.poolMoreClickBlock = ^(NSInteger tag) {
        switch (tag) {
            case 0:
            {
                UIPasteboard *paste = [UIPasteboard generalPasteboard];
                [paste setString:addressModel.addressValue];
                [MBProgressHUD showSuccess:GCLocalizedString(@"Copy_successfully") toView:self.view];
            }
                break;
            case 1:
            {
                SHAddAddressViewController *addAddressVc = [[SHAddAddressViewController alloc]init];
                addAddressVc.addressModel = addressModel;
                [self.navigationController pushViewController:addAddressVc animated:YES];
            }
                break;
            case 2:
            {
                SHAlertView *alertView = [[SHAlertView alloc]initWithTitle:GCLocalizedString(@"dialog_delete_confirm_title") alert:GCLocalizedString(@"dialog_delete_confirm_hint") sureTitle:GCLocalizedString(@"Yes") sureBlock:^(NSString * _Nonnull str) {
                    [[SHAddressSaveStorage shared] removeModel:addressModel];
                    self.dataSourt = [[SHAddressSaveStorage shared] getAddressArray];
                    [weakSelf.appLicationTableView reloadData];
                } cancelTitle:GCLocalizedString(@"No") cancelBlock:^(NSString * _Nonnull str) {
                    
                }];
                alertView.clooseButton.hidden = YES;
                [KeyWindow addSubview:alertView];
            }
                break;
            default:
                break;
        }
    };
    [bottomAlerView presentInView:KeyWindow];
}
#pragma mark 按钮事件
-(void)rightButtonAction:(UIButton *)btn
{
    RLMResults *result = [SHAddressBookModel allObjects];
    if (result.count>=20) {
        [MBProgressHUD showError:GCLocalizedString(@"up_to_20_addresses") toView:self.view];
        return;
    }
    [self.navigationController pushViewController:[SHAddAddressViewController new] animated:YES];
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
//        _appLicationTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        }];
//        _appLicationTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        }];
    }
    return _appLicationTableView;
}
@end
