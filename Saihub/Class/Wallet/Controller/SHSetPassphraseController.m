//
//  SHSetPassphraseController.m
//  Saihub
//
//  Created by 周松 on 2022/3/25.
//

#import "SHSetPassphraseController.h"
#import "SHBtcWallet.h"
#import "SHTextFieldView.h"
#import "BTBIP39.h"
#import "SHBtcCreatOrImportWalletManage.h"


@interface SHSetPassphraseController () <TGTextFieldDelegate>

@property (nonatomic, weak) SHTextFieldView *textFieldView;

@property (nonatomic, weak) SHTextFieldView *sureTextFieldView;

@property (nonatomic, weak) UIButton *sureButton;

@property (nonatomic, strong) UILabel *errorTipLabel;

@property (nonatomic, weak) UILabel *tipLabel;

@end

@implementation SHSetPassphraseController

- (UILabel *)errorTipLabel {
    if (_errorTipLabel == nil) {
        _errorTipLabel = [[UILabel alloc]init];
        _errorTipLabel.textColor = SHTheme.errorTipsRedColor;
        _errorTipLabel.numberOfLines = 0;
        _errorTipLabel.font = kCustomMontserratRegularFont(12);
        [self.stackView addSubview:_errorTipLabel];
    }
    return _errorTipLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = GCLocalizedString(@"add_passphrase");
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = GCLocalizedString(@"please_input_a_passphrase");
    titleLabel.textColor = SHTheme.walletTextColor;
    titleLabel.font = kCustomMontserratMediumFont(24);
    titleLabel.numberOfLines = 0;
    [self.stackView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.stackView.mas_top).offset(kNavBarHeight + kStatusBarHeight + 20);
        make.right.mas_equalTo(-20);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.text = GCLocalizedString(@"add_passphrase_hint2");
    subTitleLabel.textColor = SHTheme.appBlackColor;
    subTitleLabel.font = kCustomMontserratRegularFont(14);
    subTitleLabel.textAlignment = NSTextAlignmentLeft;
    subTitleLabel.numberOfLines = 0;
    [self.stackView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
    }];
    
    SHTextFieldView *textFieldView = [[SHTextFieldView alloc]init];
    self.textFieldView = textFieldView;
    textFieldView.textField.placeholder = GCLocalizedString(@"add_phassphrase_et_hint1");
    textFieldView.textField.TGTextFieldDelegate = self;
    textFieldView.textField.tg_placeholderColor = SHTheme.pageUnselectColor;
    [self.stackView addSubview:textFieldView];
    [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(subTitleLabel.mas_bottom).offset(28);
        make.height.mas_equalTo(46);
    }];
    
    SHTextFieldView *sureTextFieldView = [[SHTextFieldView alloc]init];
    self.sureTextFieldView = sureTextFieldView;
    sureTextFieldView.textField.placeholder = GCLocalizedString(@"enter_passphrase_again");
    sureTextFieldView.textField.TGTextFieldDelegate = self;
    sureTextFieldView.textField.tg_placeholderColor = SHTheme.pageUnselectColor;
    [self.stackView addSubview:sureTextFieldView];
    [sureTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 );
        make.right.mas_equalTo(-20);
        make.top.equalTo(textFieldView.mas_bottom).offset(28);
        make.height.mas_equalTo(46);
    }];

    UILabel *tipLabel = [[UILabel alloc]init];
    self.tipLabel = tipLabel;
    tipLabel.text = GCLocalizedString(@"add_passphrase_hint3");
    tipLabel.textColor = SHTheme.setPasswordTipsColor;
    tipLabel.font = kCustomMontserratRegularFont(12);
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [self.stackView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLabel);
        make.top.equalTo(sureTextFieldView.mas_bottom).offset(12).priorityMedium();
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureButton = sureButton;
    [sureButton setTitle:GCLocalizedString(@"Confirm") forState:UIControlStateNormal];
    [sureButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
    sureButton.titleLabel.font = kCustomMontserratMediumFont(14);
    sureButton.layer.cornerRadius = 26*FitWidth;
    sureButton.layer.masksToBounds = YES;
    [self.stackView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(52 *FitWidth);
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(80);
    }];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stackView layoutIfNeeded];
    [sureButton setBackgroundImage:[UIImage gradientImageWithBounds:sureButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    sureButton.userInteractionEnabled = NO;

    [self.errorTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sureTextFieldView);
        make.top.equalTo(sureTextFieldView.mas_bottom).offset(8);
    }];
    
    if (CGRectGetMaxY(sureButton.frame) + 50 > 667) {
        self.baseScrollView.contentSize = CGSizeMake(0, kScreenHeight + 40);
    }
}

#pragma mark -- 确认
- (void)sureButtonClick {
    
    if ([self.textFieldView.textField.text isEqualToString:self.sureTextFieldView.textField.text] == NO) {

        self.errorTipLabel.text = GCLocalizedString(@"pasaphrase_does_not_match");
        self.sureTextFieldView.viewType = SHTextFieldViewTypeError;
        [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sureTextFieldView.mas_bottom).offset(50);
        }];
        
        return;
    }
    
    if (self.textFieldView.textField.text.length > 128) {
        self.errorTipLabel.text = GCLocalizedString(@"passphrase_cannot_exceed_128_characters");
        self.sureTextFieldView.viewType = SHTextFieldViewTypeError;
        [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sureTextFieldView.mas_bottom).offset(50);
        }];

        return;
    }
    
    [MBProgressHUD showCustormLoadingWithView:self.view withLabelText:@""];
    
    NSString *passPhrase = self.textFieldView.textField.text;
    dispatch_async(dispatch_queue_create("CreatBTCWalletWithPassWord", DISPATCH_QUEUE_SERIAL),^{//DISPATCH_QUEUE_SERIAL:串行队列DISPATCH_QUEUE_CONCURRENT：并发队列
        [self CreatBTCWalletWithPassWord:passPhrase];
    });

}

#pragma mark 创建btc钱包
-(void)CreatBTCWalletWithPassWord:(NSString *)passWord {
    BTBIP39 *btbip39 = [BTBIP39 sharedInstance];
    NSString *code = [btbip39 toMnemonicWithArray:self.mnemonicArray];
    NSData *mnemonicCodeSeed = [btbip39 toEntropy:code];
    
    SHBtcWallet *btcWalletModel = [SHBtcCreatOrImportWalletManage creatBtcWalletWithPassWord:self.passWord withPassphrase:passWord withEntropy:mnemonicCodeSeed];
    if (IsEmpty(btcWalletModel)||IsEmpty(btcWalletModel.mnemonics)) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showError:GCLocalizedString(@"wallet_import_error") toView:self.view];
        });
        return;
    }

    //存储钱包信息
    SHWalletModel *model = [[SHWalletModel alloc]init];
    model.importType = SHWalletImportTypeMnemonic;
    model.isCurrent = YES;
    model.name = self.walletName;
    model.mnemonic = [self.mnemonicArray componentsJoinedByString:@" "];
    model.password = self.passWord;
    model.publicKey = btcWalletModel.publick;
    model.passPhrase = passWord;
    if ([self.mnemonicArray isEqualToArray:[[SHKeyStorage shared].currentWalletModel.mnemonic componentsSeparatedByString:@" "]]) {
        model.createTimestamp = [SHKeyStorage shared].currentWalletModel.createTimestamp;
    }else
    {
        model.createTimestamp = [NSString getNowTimeTimestamp];
    }
    model.hdAccountId = btcWalletModel.hdAccountId;
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:self.mnemonicArray password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    BTCKeychain *masterKey = mnemonic.keychain;
    //添加地址列表
    NSError *error = nil;
    for (int index = 0; index < 20; index ++ ) {
       NSDictionary *addressOrPriveKeyDic = [SHCreatOrImportManage creatBTCAdressOrPriveKeyWalletWithMnemonics:btcWalletModel.mnemonics passphrase:passWord index:index error:&error];
        if (self.selectedNestedSegWitButton) {
            //3地址
            SHWalletSubAddressModel *address3SubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *general3Path = [NSString stringWithFormat:@"m/49'/0'/0'/0/%d",index];
            BTCKey * btc3Key = [[masterKey derivedKeychainWithPath:@"m/49'/0'/0'/0"] keyAtIndex:index];
            address3SubModel.pathString = general3Path;
            address3SubModel.address = addressOrPriveKeyDic[@"firstAddress49Address"];
            address3SubModel.privateKey = btc3Key.WIF;
            [model.subAddressList addObject:address3SubModel];

            //3找零地址
            SHWalletSubAddressModel *address3ChangeSubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *general3ChangePath = [NSString stringWithFormat:@"m/49'/0'/0'/1/%d",index];
            BTCKey * btc3ChangeKey = [[masterKey derivedKeychainWithPath:@"m/49'/0'/0'/1"] keyAtIndex:index];
            address3ChangeSubModel.pathString = general3ChangePath;
            address3ChangeSubModel.address = addressOrPriveKeyDic[@"changeAddress49Address"];
            address3ChangeSubModel.privateKey = btc3ChangeKey.WIF;
            [model.changeAddressList addObject:address3ChangeSubModel];
            if (index == 0) {
                model.address = addressOrPriveKeyDic[@"firstAddress49Address"];
                model.privateKey = addressOrPriveKeyDic[@"firstAddress49PriveKey"];
            }
        }else
        {
            //bc1地址
            SHWalletSubAddressModel *addressBc1SubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *generalPath = [NSString stringWithFormat:@"m/84'/0'/0'/0/%d",index];
            BTCKey * btcBc1Key = [[masterKey derivedKeychainWithPath:@"m/84'/0'/0'/0"] keyAtIndex:index];
            addressBc1SubModel.pathString = generalPath;
            addressBc1SubModel.address = addressOrPriveKeyDic[@"firstAddress84Address"];
            addressBc1SubModel.privateKey = btcBc1Key.WIF;
            [model.subAddressList addObject:addressBc1SubModel];

            //bc1找零地址
            SHWalletSubAddressModel *addressBc1ChangeSubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *generalChangePath = [NSString stringWithFormat:@"m/84'/0'/0'/1/%d",index];
            BTCKey * btcBc1ChangeKey = [[masterKey derivedKeychainWithPath:@"m/84'/0'/0'/1"] keyAtIndex:index];
            addressBc1ChangeSubModel.pathString = generalChangePath;
            addressBc1ChangeSubModel.address = addressOrPriveKeyDic[@"changeAddress84Address"];
            addressBc1ChangeSubModel.privateKey = btcBc1ChangeKey.WIF;
            [model.changeAddressList addObject:addressBc1ChangeSubModel];
            if (index == 0) {
                model.address = addressOrPriveKeyDic[@"firstAddress84Address"];
                model.privateKey = addressOrPriveKeyDic[@"firstAddress84PriveKey"];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.mnemonicArray isEqualToArray:[[SHKeyStorage shared].currentWalletModel.mnemonic componentsSeparatedByString:@" "]]) {
            [[SHKeyStorage shared] removeArray:@[[SHKeyStorage shared].currentWalletModel]];
        }
        [[SHKeyStorage shared] createWalletsWithWalletModel:model];
        [MBProgressHUD hideCustormLoadingWithView:self.view];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    });

}


#pragma mark -- 监听输入
- (void)editingTextField:(TGTextField *)textField text:(NSString *)str {
    if (IsEmpty(self.textFieldView.textField.text) || IsEmpty(self.sureTextFieldView.textField.text)) {
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.sureButton.userInteractionEnabled = NO;
    } else {
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionLeftToRight] forState:UIControlStateNormal];
        self.sureButton.userInteractionEnabled = YES;
    }
    
    if (self.textFieldView.textField == textField) {
        self.textFieldView.clearButton.hidden = IsEmpty(str);
    } else if (self.sureTextFieldView.textField == textField) {
        self.sureTextFieldView.clearButton.hidden = IsEmpty(str);
    }
    
    if (self.sureTextFieldView.viewType == SHTextFieldViewTypeError) {
        [self resetTextFiledState];
    }
}

/// 重置输入框状态
- (void)resetTextFiledState {
    self.errorTipLabel.text = @"";
    self.sureTextFieldView.viewType = SHTextFieldViewTypeNormal;
    [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureTextFieldView.mas_bottom).offset(12);
    }];
}



@end
