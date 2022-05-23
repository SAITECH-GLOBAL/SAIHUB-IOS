//
//  SHUnlockSettingViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHUnlockSettingViewController.h"
#import "SHUnlockSettingTableViewCell.h"
#import "SHSetPassWordLoginViewController.h"
#import "SHSetFaceIDPassWordViewController.h"
@interface SHUnlockSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *appLicationTableView;
@property (strong, nonatomic)  NSArray *dataSourt;

@end

@implementation SHUnlockSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHTheme.appWhightColor;
    self.titleLabel.text = GCLocalizedString(@"unlock_setting");
    self.dataSourt = @[GCLocalizedString(@"unlocked_password"),GCLocalizedString(@"touch_id")];
    [self layoutScale];
}

-(void)viewWillAppear:(BOOL)animated
{
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
    return 68*FitHeight;
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
    SHUnlockSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHUnlockSettingTableViewCell"];
    if (!cell) {
        cell = [[SHUnlockSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHUnlockSettingTableViewCell"];
    }
    cell.settingTipsLabel.text = self.dataSourt[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if (IsEmpty(KAppSetting.unlockedPassWord)) {
                cell.rightButton.selected = NO;
            }else
            {
                cell.rightButton.selected = YES;
            }
        }
            break;
        case 1:
        {
            if (!IsEmpty(KAppSetting.unlockedPassWord)) {
                [cell.rightButton setImage:[UIImage imageNamed:@"setPassWordVc_passPhraseButton_normal"] forState:UIControlStateNormal];
            }else
            {
                [cell.rightButton setImage:[UIImage imageNamed:@"setPassWordVc_passPhraseButton_disable"] forState:UIControlStateNormal];
            }
            if (IsEmpty(KAppSetting.isOpenFaceID)) {
                cell.rightButton.selected = NO;
            }else
            {
                cell.rightButton.selected = YES;
            }
        }
            break;
        default:
            break;
    }
    cell.rightButtonClickBlock = ^(UIButton * _Nonnull btn) {
        switch (indexPath.row) {
            case 0:
            {
                MJWeakSelf;
                if (btn.selected) {
                    SHSetFaceIDPassWordViewController *setFaceIDPassWordViewController = [[SHSetFaceIDPassWordViewController alloc]init];
                    setFaceIDPassWordViewController.intoType = 0;
                    [self.navigationController pushViewController:setFaceIDPassWordViewController animated:YES];
//                    KAppSetting.unlockedPassWord = @"";
//                    [self.appLicationTableView reloadData];
                }else
                {
                    NSLog(@"%@",self.navigationController.viewControllers);
                    if (IsEmpty([SHKeyStorage shared].currentWalletModel)) {
                        SHAlertView *alertView = [[SHAlertView alloc]initWithTitle:GCLocalizedString(@"Please_add_wallet") alert:GCLocalizedString(@"Create_wallet_lock") sureTitle:GCLocalizedString(@"Create") sureBlock:^(NSString * _Nonnull str) {
                            [weakSelf.navigationController pushViewController:[SHSetWalletPassWordViewController new] animated:YES];
                        } cancelTitle:GCLocalizedString(@"Skip") cancelBlock:^(NSString * _Nonnull str) {
                            
                        }];
                        alertView.clooseButton.hidden = YES;
                        [KeyWindow addSubview:alertView];
                        return;
                    }
                    [self.navigationController pushViewController:[SHSetPassWordLoginViewController new] animated:YES];
                }
            }
                break;
            case 1:
            {
                if (btn.selected) {
                    SHSetFaceIDPassWordViewController *setFaceIDPassWordViewController = [[SHSetFaceIDPassWordViewController alloc]init];
                    setFaceIDPassWordViewController.intoType = 2;
                    [self.navigationController pushViewController:setFaceIDPassWordViewController animated:YES];
//                    KAppSetting.isOpenFaceID = @"";
//                    [self.appLicationTableView reloadData];
                }else
                {
                    if (!IsEmpty(KAppSetting.unlockedPassWord)) {
                        [SHTouchOrFaceUtil GetTouchIdOrFaceIdTypeWithFaceIdTypeBlock:^{
                            SHSetFaceIDPassWordViewController *setFaceIDPassWordViewController = [[SHSetFaceIDPassWordViewController alloc]init];
                            setFaceIDPassWordViewController.intoType = 1;
                            [self.navigationController pushViewController:setFaceIDPassWordViewController animated:YES];
                        } WithTouchIdTypeBlock:^{
                            SHSetFaceIDPassWordViewController *setFaceIDPassWordViewController = [[SHSetFaceIDPassWordViewController alloc]init];
                            setFaceIDPassWordViewController.intoType = 1;
                            [self.navigationController pushViewController:setFaceIDPassWordViewController animated:YES];
                        } WithValidationBackBlock:^{

                        }];
                    }else
                    {
                        [self.navigationController pushViewController:[SHSetPassWordLoginViewController new] animated:YES];
                    }
                }
            }
                break;
            default:
                break;
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 按钮事件
-(void)rightButtonAction:(UIButton *)btn
{
    
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
