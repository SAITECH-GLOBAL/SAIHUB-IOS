//
//  SHPowerController.m
//  Saihub
//
//  Created by 周松 on 2022/2/15.
//

#import "SHPowerController.h"
#import "SHPoolTableViewCell.h"
#import "SHNOPoolTableViewCell.h"
#import "SHPowerDetailViewController.h"
#import "SHSetWalletPassWordViewController.h"
#import "SHCreatNewPowerViewController.h"
#import "SHPowerListModel.h"
#import "SHPowerSaveStorage.h"
@interface SHPowerController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *appLicationTableView;
@property (strong, nonatomic)  NSArray *dataSourt;


@end

@implementation SHPowerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHTheme.appWhightColor;
    self.backButton.hidden = YES;
    self.titleLabel.text = GCLocalizedString(@"power_system");
    [self.rightButton setTitle:GCLocalizedString(@"+_Add") forState:UIControlStateNormal];
    [self.rightButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"addIcon_green"] forState:UIControlStateNormal];
    self.rightButton.imagePosition = JLButtonImagePositionLeft;
    self.rightButton.spacingBetweenImageAndTitle = 5;
    self.rightButton.titleLabel.font = kCustomMontserratMediumFont(12);
    [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self layoutScale];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataSourt = [[SHPowerSaveStorage shared] getPowerArray];
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
        return 128*FitHeight;
    }
    return 196*FitHeight;
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
    MJWeakSelf;
    if (self.dataSourt.count) {
        SHPoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHPoolTableViewCell"];
        if (!cell) {
            cell = [[SHPoolTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHPoolTableViewCell"];
        }
        cell.cellType = SHPowerCellType;
        SHPowerListModel *powerModel = self.dataSourt[indexPath.row];
        cell.powerModel = powerModel;
        cell.moreClickBlock = ^{
            SHBottomAlertView *bottomAlerView = [[SHBottomAlertView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT) withcontainerHeight:214*FitHeight + SafeAreaBottomHeight withBottomAlertType:bottomAlertPowerType];
            bottomAlerView.poolMoreClickBlock = ^(NSInteger tag) {
                switch (tag) {
                    case 0:
                    {
                        SHCreatNewPowerViewController *powerCreatVc = [[SHCreatNewPowerViewController alloc]init];
                        powerCreatVc.powerModel = powerModel;
                        [weakSelf.navigationController pushViewController:powerCreatVc animated:YES];
                    }
                        break;
                    case 1:
                    {
                        SHAlertView *alertView = [[SHAlertView alloc]initWithTitle:GCLocalizedString(@"dialog_delete_confirm_title") alert:GCLocalizedString(@"dialog_delete_confirm_hint") sureTitle:GCLocalizedString(@"Yes") sureBlock:^(NSString * _Nonnull str) {
                            [[SHPowerSaveStorage shared] removeModel:powerModel];
                            self.dataSourt = [[SHPowerSaveStorage shared] getPowerArray];
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
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        SHNOPoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHNOPoolTableViewCell"];
        if (!cell) {
            cell = [[SHNOPoolTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHNOPoolTableViewCell"];
        }
        cell.cellType = SHPowerCellType;
        cell.addNowClickBlock = ^{
            RLMResults *result = [SHPowerListModel allObjects];
            if (result.count>=50) {
                [MBProgressHUD showError:GCLocalizedString(@"list_is_full") toView:self.view];
                return;
            }
            [self.navigationController pushViewController:[SHCreatNewPowerViewController new] animated:YES];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSourt.count) {
        SHPowerListModel *powerModel = self.dataSourt[indexPath.row];
        SHPowerDetailViewController * powerDetailViewController = [[SHPowerDetailViewController alloc]init];
        powerDetailViewController.powerListModel = powerModel;
        [self.navigationController pushViewController:powerDetailViewController animated:YES];
    }
}
#pragma mark 按钮事件
-(void)rightButtonAction:(UIButton *)btn
{
    RLMResults *result = [SHPowerListModel allObjects];
    if (result.count>=50) {
        [MBProgressHUD showError:GCLocalizedString(@"list_is_full") toView:self.view];
        return;
    }
    [self.navigationController pushViewController:[SHCreatNewPowerViewController new] animated:YES];
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
