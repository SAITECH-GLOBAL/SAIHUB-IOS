//
//  SHBtcCreatOrImportWalletManage.m
//  TokenOne
//
//  Created by macbook on 2020/10/29.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHBtcCreatOrImportWalletManage.h"
#import "BTHDAccount.h"
#import "BTAddressManager.h"
#import "BTWordsTypeManager.h"
#import "BTHDAccountAddressProvider.h"
#import "BTHDAccountProvider.h"
#import "BTEncryptData.h"
#import "BTPrivateKeyUtil.h"
#import "BTAddressProvider.h"
#import "SHKeyStorage.h"
#import "SHWalletController.h"
@implementation SHBtcCreatOrImportWalletManage
+(SHBtcWallet *)creatBtcWalletWithPassWord:(NSString *)passWord withPassphrase:passphrase  withEntropy:(NSData *)entropy
{
    SHBtcWallet *backBtcWalletModel = nil;
    BTHDAccount *account = [[BTHDAccount alloc] initWithMnemonicSeed:entropy withPassphrase:passphrase password:passWord  fromXRandom:YES andGenerationCallback:^(CGFloat p) {
        
    }];
    if (IsEmpty(account)) {
        return backBtcWalletModel;
    }
    backBtcWalletModel = [[SHBtcWallet alloc]init];
    NSArray *words = [account seedWords:passWord];
    [BTAddressManager instance].hdAccountHot = account;
    [[BTWordsTypeManager instance] saveWordsTypeValue:[words componentsJoinedByString:@" "]];
    backBtcWalletModel.hdAccountId = (int)[account getHDAccountId];
    backBtcWalletModel.mnemonics = [words componentsJoinedByString:@" "];
    backBtcWalletModel.publick = [[account xPub:passWord withPurposePathLevel:P2SHP2WPKH] serializePubB58];
    return backBtcWalletModel;
}
//+ (SHBtcWallet *)creatBtcSubAdressWithPassWord:(NSString *)passWord withAddressType:(SHWalletAddressType)addressType withNumber:(int )number withHdAddressId:(int)hdAddressId
//{
//    SHBtcWallet *backBtcWalletModel = nil;
//    BTHDAccount *account;
//    @try {
//        account = [[BTHDAccount alloc] initWithSeedId:hdAddressId];
//    } @catch (NSException *e) {
//        return backBtcWalletModel;
//    }
//    backBtcWalletModel = [[SHBtcWallet alloc]init];
//    NSArray *words = [account seedWords:passWord];
//    backBtcWalletModel.mnemonics = [words componentsJoinedByString:@" "];
//    if (addressType == TOWalletAddressGeneralType) {
//        BTHDAccountAddress *hdAccountAddress = [[BTHDAccountAddressProvider instance] getAddressByHDAccountId:hdAddressId path:EXTERNAL_ROOT_PATH index:number];
//        backBtcWalletModel.ordinaryAddress = hdAccountAddress.address;
//        backBtcWalletModel.ordinaryPrivateKey = [account privateKeyWithPath:EXTERNAL_ROOT_PATH index:number password:passWord].key.privateKey;
//
//    }else if (addressType == TOWalletAddressSegWitType)
//    {
//        BTHDAccountAddress *hdAccountAddress = [[BTHDAccountAddressProvider instance] getAddressByHDAccountId:hdAddressId path:EXTERNAL_BIP49_PATH index:number];
//        backBtcWalletModel.segwitAddress = hdAccountAddress.address;
//        BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:words password:nil wordListType:BTCMnemonicWordListTypeEnglish];
//        BTCKeychain *masterKey = mnemonic.keychain;
//        NSString *BIP32Path = [NSString stringWithFormat:@"%@/0",@"m/49'/0'/0'"];
//        BTCKey * btcKey = [[masterKey derivedKeychainWithPath:BIP32Path] keyAtIndex:number];
//        backBtcWalletModel.segwitPrivateKey = btcKey.WIF;
//    }
//    return backBtcWalletModel;
//}
+ (SHBtcWallet *)importBtcWalletWithMnemonics:(NSString *)mnemonics WithPassWord:(NSString *)passWord withPassphrase:passphrase{
//    NSArray *walletArray = [[SHKeyStorage shared]queryWalletWithType:SHWalletTypeBTC];
    RLMResults<SHWalletModel *> *walletArray = [SHWalletModel allObjects];
    NSArray *array = [[BTHDAccountProvider instance]getHDAccountSeeds];
    for (NSString *hdId in array) {
        BOOL haveHdId = NO;
        for (SHWalletModel *walletModel in walletArray) {
            if ([[NSString stringWithFormat:@"%d",walletModel.hdAccountId]isEqualToString:hdId]) {
                haveHdId = YES;
            }
            if (!haveHdId) {
                [[BTHDAccountAddressProvider instance]deleteHDAccountAddress:[hdId intValue]];
                [[BTHDAccountProvider instance]deleteHDAccount:[hdId intValue]];
            }
        }
    }

    SHBtcWallet *backBtcWalletModel = nil;
    NSArray *wordlist = [mnemonics componentsSeparatedByString:@" "];
    BTBIP39 *btbip39 = [BTBIP39 sharedInstance];
    NSString *code = [btbip39 toMnemonicWithArray:wordlist];
    NSData *mnemonicCodeSeed = [btbip39 toEntropy:code];
    if (IsEmpty(mnemonicCodeSeed)) {
        return backBtcWalletModel;
    }
    __block  NSInteger haveSameAcount = 0;
    BTHDAccount *account = nil;
    account = [[BTHDAccount alloc] initWithMnemonicSeed:mnemonicCodeSeed withPassphrase:passphrase password:passWord  fromXRandom:YES andGenerationCallback:^(CGFloat p) {
        if (p == -100) {
            haveSameAcount = p;
        }
    }];
        if (haveSameAcount == -100) {
            [[BTHDAccountAddressProvider instance]deleteHDAccountAddress:(int)[[BTAddressManager instance].hdAccountHot getHDAccountId]];
            [[BTHDAccountProvider instance]deleteHDAccount:(int)[[BTAddressManager instance].hdAccountHot getHDAccountId]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"BTUserDefaultsWordsType"];
            [userDefaults synchronize];
            account = [[BTHDAccount alloc] initWithMnemonicSeed:mnemonicCodeSeed withPassphrase:passphrase password:passWord  fromXRandom:YES andGenerationCallback:^(CGFloat p) {
            }];
            return backBtcWalletModel;
        }
    backBtcWalletModel = [[SHBtcWallet alloc]init];
    [BTAddressManager instance].hdAccountHot = account;
    [[BTWordsTypeManager instance] saveWordsTypeValue:mnemonics];
    backBtcWalletModel.hdAccountId = (int)[account getHDAccountId];
    backBtcWalletModel.mnemonics = mnemonics;
    backBtcWalletModel.publick = [[account xPub:passWord withPurposePathLevel:P2SHP2WPKH] serializePubB58];
    return backBtcWalletModel;
}
+ (SHBtcWallet *)importBtcWalletWithPrivateKey:(NSString *)privateKey WithPassWord:(NSString *)passWord withPassphrase:(NSString *)passphrase{
    SHBtcWallet *backBtcWalletModel = nil;
    BTKey *key = [BTKey keyWithPrivateKey:privateKey];
    if (IsEmpty(key)) {
        return backBtcWalletModel;
    }
    BTAddress *address;
    NSString *encryptKey = [BTPrivateKeyUtil getPrivateKeyString:key passphrase:passWord];
    if (encryptKey != nil) {
        address = [[BTAddress alloc] initWithKey:key encryptPrivKey:encryptKey isSyncComplete:NO isXRandom:NO];
    }
    if (IsEmpty(address)) {
        return backBtcWalletModel;
    }
    BOOL haveAccount = NO;
    NSArray *allAddresses = [[BTAddressProvider instance] getAddresses];
    for (BTAddress *subAddress in allAddresses) {
        if ([subAddress.address isEqualToString:address.address]) {
            haveAccount = YES;
        }
    }
    if (!haveAccount) {
        [[BTAddressManager instance] addAddress:address];
    }
    backBtcWalletModel = [[SHBtcWallet alloc]init];
    backBtcWalletModel.ordinaryAddress = key.address;
    backBtcWalletModel.segwitAddress = [key toSegwitAddress];
    backBtcWalletModel.ordinaryPrivateKey = key.privateKey;
    backBtcWalletModel.segwitPrivateKey = key.privateKey;
    return backBtcWalletModel;
}
+ (SHWalletModel *)importBtcWalletWithAddress:(NSString *)address withWalletName:(NSString *)walletName{
//存储钱包信息
    SHWalletModel *model = [[SHWalletModel alloc]init];
    model.importType = SHWalletImportTypeAddress;
    model.isCurrent = YES;
    model.name = walletName;
    model.createTimestamp = [NSString getNowTimeTimestamp];
    model.address = address;
    SHWalletSubAddressModel *address3SubModel = [[SHWalletSubAddressModel alloc]init];
    address3SubModel.address = address;
    [model.subAddressList addObject:address3SubModel];
    return model;
}
+ (SHWalletModel *)importBtcWalletWithPub:(NSString *)pubKey withWalletName:(NSString *)walletName
{
    //存储钱包信息
    SHWalletModel *model = [[SHWalletModel alloc]init];
    model.importType = SHWalletImportTypePublicKey;
    model.isCurrent = YES;
    model.name = walletName;
    model.publicKey = pubKey;
    model.createTimestamp = [NSString getNowTimeTimestamp];
    //添加地址列表
    NSError *error = nil;
    for (int index = 0; index < 20; index ++ ) {
        NSDictionary *addressDic = [SHCreatOrImportManage creatBTCAdressWithPublicWalletWithPublicKey: pubKey index:index error:&error];
        if ([[[pubKey substringToIndex:4]lowercaseString]isEqualToString:@"ypub"]) {
            //3地址
            SHWalletSubAddressModel *address3SubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *general3Path = [NSString stringWithFormat:@"m/49'/0'/0'/0/%d",index];
            address3SubModel.pathString = general3Path;
            address3SubModel.address = addressDic[@"firstAddressAddress"];
            [model.subAddressList addObject:address3SubModel];

            //3找零地址
            SHWalletSubAddressModel *address3ChangeSubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *general3ChangePath = [NSString stringWithFormat:@"m/49'/0'/0'/1/%d",index];
            address3ChangeSubModel.pathString = general3ChangePath;
            address3ChangeSubModel.address = addressDic[@"firstChangeAddress"];
            [model.changeAddressList addObject:address3ChangeSubModel];
            if (index == 0) {
                model.address = addressDic[@"firstAddressAddress"];
            }
        }else if ([[[pubKey substringToIndex:4]lowercaseString]isEqualToString:@"zpub"])
        {
            //bc1地址
            SHWalletSubAddressModel *addressBc1SubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *generalPath = [NSString stringWithFormat:@"m/84'/0'/0'/0/%d",index];
            addressBc1SubModel.pathString = generalPath;
            addressBc1SubModel.address = addressDic[@"firstAddressAddress"];
            [model.subAddressList addObject:addressBc1SubModel];

            //bc1找零地址
            SHWalletSubAddressModel *addressBc1ChangeSubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *generalChangePath = [NSString stringWithFormat:@"m/84'/0'/0'/1/%d",index];
            addressBc1ChangeSubModel.pathString = generalChangePath;
            addressBc1ChangeSubModel.address = addressDic[@"firstChangeAddress"];
            [model.changeAddressList addObject:addressBc1ChangeSubModel];
            if (index == 0) {
                model.address = addressDic[@"firstAddressAddress"];
            }
        }else if ([[[pubKey substringToIndex:4]lowercaseString]isEqualToString:@"xpub"])
        {
            //1地址
            SHWalletSubAddressModel *address1SubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *generalPath = [NSString stringWithFormat:@"m/44'/0'/0'/0/%d",index];
            address1SubModel.pathString = generalPath;
            address1SubModel.address = addressDic[@"firstAddressAddress"];
            [model.subAddressList addObject:address1SubModel];

            //1找零地址
            SHWalletSubAddressModel *address1ChangeSubModel = [[SHWalletSubAddressModel alloc]init];
            NSString *generalChangePath = [NSString stringWithFormat:@"m/44'/0'/0'/1/%d",index];
            address1ChangeSubModel.pathString = generalChangePath;
            address1ChangeSubModel.address = addressDic[@"firstChangeAddress"];
            [model.changeAddressList addObject:address1ChangeSubModel];
            if (index == 0) {
                model.address = addressDic[@"firstAddressAddress"];
            }
        }
    }
    if (IsEmpty(model.address)) {
        return nil;
    }
    return model;
}
+ (SHWalletModel *)importBtcWalletWithPubs:(NSArray *)pubKeyArray WithPubDic:(NSDictionary *)pubDic WithPubTitles:(NSArray *)pubKeyTitleArray withWalletName:(NSString *)walletName
{
    //存储钱包信息
    SHWalletModel *model = [[SHWalletModel alloc]init];
    model.importType = SHWalletImportTypePublicKey;
    model.isCurrent = YES;
    model.name = walletName;
    model.createTimestamp = [NSString getNowTimeTimestamp];
    model.policySureCount = [pubDic[@"policySureCount"] intValue];
    model.policyTotalCount = [pubDic[@"policyTotalCount"] intValue];
    model.derivation = pubDic[@"derivation"];
    model.format = pubDic[@"format"];
    //添加地址列表
    NSError *error = nil;
    for (NSInteger i=0; i<pubKeyArray.count; i++) {
        NSString *pubKey = pubKeyArray[i];
        NSString *pubTitle = pubKeyTitleArray[i];
        SHWalletZpubModel *walletZpubModel = [[SHWalletZpubModel alloc]init];
        walletZpubModel.publicKey = pubKey;
        walletZpubModel.title = pubTitle;
        [model.zpubList addObject:walletZpubModel];
    }

    return model;
}

+(void)changeBtcHdWalletWithModel:(SHWalletModel *)walletModel
{
    if (IsEmpty(walletModel)||walletModel.walletType != SHWalletTypeBTC) {
        [BTAddressManager instance].hdAccountHot = nil;
    }else
    {
        BTHDAccount *subAccount = [[BTHDAccount alloc]initWithSeedId:walletModel.hdAccountId];
        [BTAddressManager instance].hdAccountHot = subAccount;
    }
}


@end
