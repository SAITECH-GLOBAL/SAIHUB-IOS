//
//  SHWalletManagerController.m
//  Saihub
//
//  Created by 周松 on 2022/2/24.
//

#import "SHWalletManagerController.h"
#import "SHWalletManagerCell.h"
#import "SHModifyPasswordController.h"
#import "SHAddressManagerController.h"
#import "SHVerifyPasswordController.h"
#import "SHExportRecoveryTipController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "SHSetOptionalPassWordViewController.h"
#import "SHCompleteView.h"
#import "SHExportPrivateKeyController.h"
#import "SHSetPassphraseController.h"
#import "SHNavigationController.h"

@interface SHWalletManagerController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) NSArray *cellTypeArray;

@end

@implementation SHWalletManagerController

- (NSArray *)titleArray {
    NSArray *titleArray;
    
    SHWalletImportType importType = [SHKeyStorage shared].currentWalletModel.importType;
    
    switch (importType) {
        case SHWalletImportTypeMnemonic: {
            titleArray = @[GCLocalizedString(@"wallet_name"),GCLocalizedString(@"backup_recovery_phrase"),GCLocalizedString(@"modify_password"), GCLocalizedString(@"touch_id"), GCLocalizedString(@"passphrase_desc"), GCLocalizedString(@"address_manager")];
        }
            break;
        case SHWalletImportTypePrivateKey: {
            titleArray = @[GCLocalizedString(@"wallet_name"),GCLocalizedString(@"backup_private_key"), GCLocalizedString(@"modify_password"), GCLocalizedString(@"touch_id")];
        }
            break;
        case SHWalletImportTypePublicKey: {
            titleArray = @[GCLocalizedString(@"wallet_name"),GCLocalizedString(@"address_manager")];
        }
            break;
        case SHWalletImportTypeAddress: {
            titleArray = @[GCLocalizedString(@"wallet_name")];
        }
            break;
        default:
            break;
    }

    return titleArray;
}

- (NSArray *)cellTypeArray {
    NSArray *cellTypeArray;
    
    SHWalletImportType importType = [SHKeyStorage shared].currentWalletModel.importType;
    
    switch (importType) {
        case SHWalletImportTypeMnemonic:{
            cellTypeArray = @[@(SHManageWalletNoneCellType),@(SHManageWalletNoneCellType),@(SHManageWalletNoneCellType),@(SHManageWalletSwitchCellType),@(SHManageWalletNoneCellType),@(SHManageWalletNoneCellType)];
        }
            break;
        case SHWalletImportTypePrivateKey: {
            cellTypeArray = @[@(SHManageWalletNoneCellType),@(SHManageWalletNoneCellType),@(SHManageWalletNoneCellType),@(SHManageWalletSwitchCellType)];
        }
            break;
        case SHWalletImportTypePublicKey: {
            cellTypeArray = @[@(SHManageWalletNoneCellType),@(SHManageWalletNoneCellType)];
        }
            break;
        case SHWalletImportTypeAddress: {
            cellTypeArray = @[@(SHManageWalletNoneCellType)];
        }
            break;
        default:
            break;
    }
    
    return cellTypeArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SHWalletManagerCell class] forCellReuseIdentifier:@"SHWalletManagerCellID"];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.rowHeight = 68;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubviews];
}

- (void)setSubviews {
    self.titleLabel.text = GCLocalizedString(@"wallet_settings");
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom).offset(4);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHWalletManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHWalletManagerCellID" forIndexPath:indexPath];
        
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.cellType = [self.cellTypeArray[indexPath.row] integerValue];
    cell.switchButton.on = [SHKeyStorage shared].currentWalletModel.isNoSecret;
    if (indexPath.row == 0) {
        cell.rightValueLabel.hidden = NO;
        cell.rightValueLabel.text = [SHKeyStorage shared].currentWalletModel.name;
    }
    MJWeakSelf
    cell.switchButtonClickBlock = ^(UISwitch * _Nonnull button) {
        [weakSelf pushVerifyPasswordControllerWithButton:button];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.titleArray[indexPath.row];
    
    if ([title isEqualToString:GCLocalizedString(@"backup_private_key")]) { // 导出私钥
        [self pushPrivateKey];
    } else if ([title isEqualToString:GCLocalizedString(@"modify_password")]) { // 修改密码
        [self pushModifyPassword];
    } else if ([title isEqualToString:GCLocalizedString(@"passphrase_desc")]) { // 钱包密语
        [self pushPassphrase];
    } else if ([title isEqualToString:GCLocalizedString(@"backup_recovery_phrase")]) { // 导出助记词
        [self pushRecoveryPhrase];
    } else if ([title isEqualToString:GCLocalizedString(@"address_manager")]) { // 地址管理
        [self pushAddressManager];
    }else if ([title isEqualToString:GCLocalizedString(@"wallet_name")]) { // 钱包名称
        [self changeWaleltName];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    CGFloat height = kScreenHeight - kNavBarHeight - kStatusBarHeight - self.titleArray.count * 68;
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [SHTheme.errorTipsRedColor colorWithAlphaComponent:0.1];
    deleteButton.layer.cornerRadius = 8;
    deleteButton.layer.masksToBounds = YES;
    [deleteButton setTitle:GCLocalizedString(@"delete_wallet") forState:UIControlStateNormal];
    [deleteButton setTitleColor:SHTheme.errorTipsRedColor forState:UIControlStateNormal];
    deleteButton.titleLabel.font = kCustomMontserratMediumFont(14);
    [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:deleteButton];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 *FitWidth);
        make.right.mas_equalTo(-20 *FitWidth);
        make.height.mas_equalTo(52);
        
        if (self.titleArray.count == 0) {
            make.top.mas_equalTo(20);
        } else {
            make.bottom.mas_equalTo(-SafeAreaBottomHeight - 16);
        }
    }];
        
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    CGFloat height = kScreenHeight - kNavBarHeight - kStatusBarHeight - self.titleArray.count * 68;
    
    if (self.titleArray.count == 0) {
        height = 72;
    }
    
    return height;
}
#pragma mark -- 修改钱包密码
-(void)changeWaleltName
{
    MJWeakSelf;
    SHAlertView *alertView = [[SHAlertView alloc]initChangeWalletNameWithTitle:GCLocalizedString(@"wallet_name") alert:[SHKeyStorage shared].currentWalletModel.name sureTitle:GCLocalizedString(@"Yes") sureBlock:^(NSString * _Nonnull str) {
        if (!IsEmpty(str)) {
            [[SHKeyStorage shared] updateModelBlock:^{
                [SHKeyStorage shared].currentWalletModel.name = str;
            }];
            [self.tableView reloadData];
            [MBProgressHUD showSuccess:GCLocalizedString(@"Saved") toView:self.view];
        }
    } cancelTitle:GCLocalizedString(@"No") cancelBlock:^(NSString * _Nonnull str) {
        
    }];
    alertView.subTitleLabel.textColor = SHTheme.errorTipsRedColor;
    alertView.clooseButton.hidden = YES;
    [KeyWindow addSubview:alertView];
}
#pragma mark -- 导出私钥
- (void)pushPrivateKey {
    MJWeakSelf
    SHVerifyPasswordController *verifyPwsVc = [[SHVerifyPasswordController alloc]init];
    verifyPwsVc.controllerType = SHVerifyPasswordControllerTypeOther;
    verifyPwsVc.verifyPasswordBlock = ^{
        SHExportPrivateKeyController *exportPrivateKeyVc = [[SHExportPrivateKeyController alloc]init];
        exportPrivateKeyVc.address = [SHKeyStorage shared].currentWalletModel.address;
        exportPrivateKeyVc.privateKey = [SHKeyStorage shared].currentWalletModel.privateKey;
        [weakSelf.navigationController pushViewController:exportPrivateKeyVc animated:YES];
    };
    [self.navigationController pushViewController:verifyPwsVc animated:YES];
    
}

#pragma mark -- 导出助记词
- (void)pushRecoveryPhrase {
    MJWeakSelf
    
    SHVerifyPasswordController *verifyPwdVc = [[SHVerifyPasswordController alloc]init];
    verifyPwdVc.controllerType = SHVerifyPasswordControllerTypeOther;
    verifyPwdVc.verifyPasswordBlock = ^{
        SHExportRecoveryTipController *exportRecoveryVc = [[SHExportRecoveryTipController alloc]init];
        [weakSelf.navigationController pushViewController:exportRecoveryVc animated:YES];
    };
    [self.navigationController pushViewController:verifyPwdVc animated:YES];

}

#pragma mark -- 钱包密语
- (void)pushPassphrase {
    
    MJWeakSelf
    
    SHVerifyPasswordController *verifyPwdVc = [[SHVerifyPasswordController alloc]init];
    verifyPwdVc.controllerType = SHVerifyPasswordControllerTypeOther;
    verifyPwdVc.verifyPasswordBlock = ^{
        SHSetPassphraseController *setPassphraseVc = [[SHSetPassphraseController alloc]init];
        setPassphraseVc.selectedNestedSegWitButton = ![[[SHKeyStorage shared].currentWalletModel.address substringToIndex:3]isEqualToString:@"bc1"];
        setPassphraseVc.passWord = [SHKeyStorage shared].currentWalletModel.password;
        setPassphraseVc.mnemonicArray = [[SHKeyStorage shared].currentWalletModel.mnemonic componentsSeparatedByString:@" "];
        setPassphraseVc.walletName = [SHKeyStorage shared].currentWalletModel.name;
        [weakSelf.navigationController pushViewController:setPassphraseVc animated:YES];
    };
    [self.navigationController pushViewController:verifyPwdVc animated:YES];

}

#pragma mark -- 修改密码
- (void)pushModifyPassword {
    SHModifyPasswordController *modifyPasswordVc = [[SHModifyPasswordController alloc]init];
    [self.navigationController pushViewController:modifyPasswordVc animated:YES];
}

#pragma mark -- 地址管理
- (void)pushAddressManager {
    SHAddressManagerController *addressManagerVc = [[SHAddressManagerController alloc]init];
    [self.navigationController pushViewController:addressManagerVc animated:YES];
}

#pragma mark -- 删除钱包
- (void)deleteButtonClick {
    MJWeakSelf
    if ([SHKeyStorage shared].currentWalletModel.importType != SHWalletImportTypeMnemonic) {
        SHAlertView *alertView = [[SHAlertView alloc]initWithTitle:GCLocalizedString(@"dialog_delete_confirm_title") alert:GCLocalizedString(@"Backup_delete_confirm_title") sureTitle:GCLocalizedString(@"Yes") sureBlock:^(NSString * _Nonnull str) {
            [weakSelf deleatWalletAction];
        } cancelTitle:GCLocalizedString(@"No") cancelBlock:^(NSString * _Nonnull str) {
            
        }];
        alertView.clooseButton.hidden = YES;
        [KeyWindow addSubview:alertView];
    }else
    {
        SHAlertView *alertView = [[SHAlertView alloc]initBackUpWithTitle:GCLocalizedString(@"dialog_delete_confirm_title") alert:GCLocalizedString(@"Backup_delete_confirm_title") sureTitle:GCLocalizedString(@"Yes") sureBlock:^(NSString * _Nonnull str) {
            [weakSelf deleatWalletAction];
        } cancelTitle:GCLocalizedString(@"No") cancelBlock:^(NSString * _Nonnull str) {
            
        } backUpBlock:^{
            [self pushRecoveryPhrase];
        }];
        alertView.clooseButton.hidden = YES;
        [KeyWindow addSubview:alertView];
    }
    
   
}
#pragma mark -- 删除钱包
-(void)deleatWalletAction
{
    if (self.titleArray.count == 1 || [SHKeyStorage shared].currentWalletModel.importType == SHWalletImportTypePublicKey) {
        [[SHKeyStorage shared] deleteWalletWithModel:[SHKeyStorage shared].currentWalletModel];
        if (IsEmpty([SHKeyStorage shared].currentWalletModel) && [SHKeyStorage shared].currentLNWalletModel) {//有ln钱包
            [self changehdTolnWalletAction];
        }
        SHCompleteView *completeView = [[SHCompleteView alloc]init];
        completeView.completeViewType = CompleteViewSucceseType;
        completeView.completeBlock = ^{
            if (IsEmpty([SHKeyStorage shared].currentWalletModel)) {
                KAppSetting.unlockedPassWord = @"";
                KAppSetting.isOpenFaceID = @"";
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
        [completeView presentInView:self.view];
        
    } else {
        SHVerifyPasswordController *verifyPwdVc = [[SHVerifyPasswordController alloc]init];
        verifyPwdVc.changeWalletBlock = ^{
            [self changehdTolnWalletAction];
        };
        verifyPwdVc.controllerType = SHVerifyPasswordControllerDelete;
        [self.navigationController pushViewController:verifyPwdVc animated:YES];
    }
}
-(void)changehdTolnWalletAction
{
    [SHKeyStorage shared].currentLNWalletModel = [SHKeyStorage shared].currentLNWalletModel;
}
#pragma mark -- 开启关闭touchID
- (void)pushVerifyPasswordControllerWithButton:(UISwitch *)sender {
    
    if (sender.isOn == YES) { // 此时开启
        SHVerifyPasswordController *verifyPwdVc = [[SHVerifyPasswordController alloc]init];
        verifyPwdVc.controllerType = SHVerifyPasswordControllerTypeOther;
        verifyPwdVc.verifyPasswordBlock = ^{
            [SHTouchOrFaceUtil selectTouchIdOrFaceIdWithSucessedBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [[SHKeyStorage shared] updateModelBlock:^{
                        [SHKeyStorage shared].currentWalletModel.isNoSecret = YES;
                    }];
                    
                    [self.tableView reloadData];
                }
            } WithSelectPassWordBlock:^{
                
            } WithErrorBlock:^(NSError * _Nonnull error) {
                if (error.code == LAErrorAuthenticationFailed) {
                    [MBProgressHUD showError:GCLocalizedString(@"biometric_not_recognized") toView:self.view];
                } else if (error.code == LAErrorBiometryLockout) {
                    [MBProgressHUD showError:GCLocalizedString(@"input_error_pwd_locked") toView:self.view];
                }
            } withBtn:nil];
        };
        [self.navigationController pushViewController:verifyPwdVc animated:YES];
    } else {
        [[SHKeyStorage shared] updateModelBlock:^{
            [SHKeyStorage shared].currentWalletModel.isNoSecret = NO;
        }];
    }
    
}


@end
