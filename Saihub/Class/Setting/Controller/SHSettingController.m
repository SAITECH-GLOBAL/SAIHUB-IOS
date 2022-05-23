//
//  SHSettingController.m
//  Saihub
//
//  Created by 周松 on 2022/2/15.
//

#import "SHSettingController.h"
#import "SHSettingTableViewCell.h"
#import "SHChangeLanguagesViewController.h"
#import "SHChangeUnitViewController.h"
#import "SHAdressBookViewController.h"
#import "SHUnlockSettingViewController.h"
#import "SHAppVersionViewController.h"
#import "SHSetWalletPassWordViewController.h"
@interface SHSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *appLicationTableView;
@property (strong, nonatomic)  NSArray *dataSourt;
@property (strong, nonatomic)  UIImageView *firtstImageView;
@property (strong, nonatomic)  UIImageView *secondImageView;
@property (strong, nonatomic)  UILabel *emailLabel;
@property (strong, nonatomic)  UILabel *appCodeLabel;

@end

@implementation SHSettingController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.appLicationTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHTheme.appWhightColor;
    self.backButton.hidden = YES;
    self.titleLabel.text = GCLocalizedString(@"main_item_settings");
    self.dataSourt = @[GCLocalizedString(@"Language"),GCLocalizedString(@"currency_unit"),GCLocalizedString(@"address_book"),GCLocalizedString(@"unlock_setting"),GCLocalizedString(@"app_version")];
    [self layoutScale];
}
#pragma  mark 布局页面
-(void)layoutScale
{
    self.appLicationTableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.navBar, 8).bottomEqualToView(self.view);
    [self.view layoutIfNeeded];
    self.firtstImageView.sd_layout.rightSpaceToView(self.view, kWIDTH/2.0 + 12*FitWidth).bottomSpaceToView(self.view, SafeAreaBottomHeight + 49 + 70*FitHeight).widthIs(32*FitWidth).heightEqualToWidth();
    self.secondImageView.sd_layout.leftSpaceToView(self.view, kWIDTH/2.0 + 12*FitWidth).bottomSpaceToView(self.view, SafeAreaBottomHeight + 49 + 70*FitHeight).widthIs(32*FitWidth).heightEqualToWidth();
    self.emailLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.firtstImageView, 8*FitHeight).heightIs(22*FitHeight);
    [self.emailLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    self.appCodeLabel.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.emailLabel, 2*FitHeight).heightIs(22*FitHeight);
    [self.appCodeLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
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
    SHSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHSettingTableViewCell"];
    if (!cell) {
        cell = [[SHSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHSettingTableViewCell"];
    }
    cell.settingTipsLabel.text = self.dataSourt[indexPath.row];
    cell.rightButton.enabled = NO;
    [cell.rightButton setTitle:@"" forState:UIControlStateNormal];
    switch (indexPath.row) {
        case 0:
        {
            if (KAppSetting.language == SHApplicationLanguageEn) {
                [cell.rightButton setTitle:GCLocalizedString(@"English") forState:UIControlStateNormal];
            }else if (KAppSetting.language == SHApplicationLanguageZhHans)
            {
                [cell.rightButton setTitle:GCLocalizedString(@"简体中文") forState:UIControlStateNormal];
            }else if (KAppSetting.language == SHApplicationLanguageZhHant)
            {
                [cell.rightButton setTitle:GCLocalizedString(@"繁体中文") forState:UIControlStateNormal];
            }else
            {
                [cell.rightButton setTitle:GCLocalizedString(@"Русский") forState:UIControlStateNormal];
            }
        }
            break;
        case 1:
        {
            [cell.rightButton setTitle:KAppSetting.currencyKey.uppercaseString forState:UIControlStateNormal];
        }
            break;
        case 2:
        {

        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[SHChangeLanguagesViewController new] animated:YES];
        }
            break;
        case 1:
        {
            [self.navigationController pushViewController:[SHChangeUnitViewController new] animated:YES];
        }
            break;
        case 2:
        {
            SHAdressBookViewController *adressBookViewController = [[SHAdressBookViewController alloc]init];
            adressBookViewController.inputType = 0;
            [self.navigationController pushViewController:adressBookViewController animated:YES];
        }
            break;
        case 3:
        {
            [self.navigationController pushViewController:[SHUnlockSettingViewController new] animated:YES];
        }
            break;
        case 4:
        {
            [self.navigationController pushViewController:[SHAppVersionViewController new] animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark 按钮事件

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
-(UIImageView *)firtstImageView
{
    if (_firtstImageView == nil) {
        _firtstImageView = [[UIImageView alloc]init];
        _firtstImageView.image = [UIImage imageNamed:@"settingVc_firstImageView"];
        [self.view addSubview:_firtstImageView];
    
        _firtstImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/SAI2TECH"] options:@{} completionHandler:^(BOOL success) {
                            
            }];
        }];
        [_firtstImageView addGestureRecognizer:tap];
    }
    return _firtstImageView;
}
-(UILabel *)emailLabel
{
    if (_emailLabel == nil) {
        _emailLabel = [[UILabel alloc]init];
        _emailLabel.font = kCustomMontserratRegularFont(14);
        _emailLabel.textColor = SHTheme.pageUnselectColor;
        _emailLabel.text = @"Email:service@sai.tech";
        [self.view addSubview:_emailLabel];
    }
    return _emailLabel;
}
-(UIImageView *)secondImageView
{
    if (_secondImageView == nil) {
        _secondImageView = [[UIImageView alloc]init];
        _secondImageView.image = [UIImage imageNamed:@"settingVc_secondImageView"];
        [self.view addSubview:_secondImageView];
        
        _secondImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://discord.gg/JM68xXPs7E"] options:@{} completionHandler:^(BOOL success) {
                            
            }];
        }];
        [_secondImageView addGestureRecognizer:tap];

    }
    return _secondImageView;
}
-(UILabel *)appCodeLabel
{
    if (_appCodeLabel == nil) {
        _appCodeLabel = [[UILabel alloc]init];
        _appCodeLabel.font = kCustomMontserratRegularFont(12);
        _appCodeLabel.textColor = SHTheme.pageUnselectColor;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _appCodeLabel.text = [NSString stringWithFormat:@"%@ %@",GCLocalizedString(@"SAIHUB APP"),appVersion];
        [self.view addSubview:_appCodeLabel];
    }
    return _appCodeLabel;
}
@end
