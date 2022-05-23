//
//  SHExportRecoveryTipController.m
//  Saihub
//
//  Created by 周松 on 2022/3/4.
//

#import "SHExportRecoveryTipController.h"
#import "SHShowMnemonicViewController.h"

@interface SHExportRecoveryTipController ()

@end

@implementation SHExportRecoveryTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = GCLocalizedString(@"phrase_tip_0");
    titleLabel.textColor = SHTheme.walletTextColor;
    titleLabel.font = kCustomMontserratMediumFont(24);
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.navBar.mas_bottom).offset(20);
    }];
    
    UILabel *desLabel = [[UILabel alloc]init];
    desLabel.text = GCLocalizedString(@"phrase_tip_1");
    desLabel.textColor = SHTheme.appBlackColor;
    desLabel.font = kCustomMontserratRegularFont(14);
    desLabel.numberOfLines = 0;
    [self.view addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
    }];

    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueButton setTitle:GCLocalizedString(@"continue_desc") forState:UIControlStateNormal];
    [continueButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
    continueButton.titleLabel.font = kCustomMontserratMediumFont(14);
    continueButton.layer.cornerRadius = 26*FitWidth;
    continueButton.layer.masksToBounds = YES;
    [self.view addSubview:continueButton];
    [continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(52 *FitWidth);
        make.top.mas_equalTo(desLabel.mas_bottom).offset(80);
    }];
    [continueButton addTarget:self action:@selector(continueButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view layoutIfNeeded];
    [continueButton setBackgroundImage:[UIImage gradientImageWithBounds:continueButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];

}

- (void)continueButtonClick {
    SHShowMnemonicViewController *showMnemonicVc = [[SHShowMnemonicViewController alloc]init];
    showMnemonicVc.mnemonicArray = [[SHKeyStorage shared].currentWalletModel.mnemonic componentsSeparatedByString:@" "];
    showMnemonicVc.controllerType = SHShowMnemonicViewControllerTypeExport;
    [self.navigationController pushViewController:showMnemonicVc animated:YES];
}

@end
