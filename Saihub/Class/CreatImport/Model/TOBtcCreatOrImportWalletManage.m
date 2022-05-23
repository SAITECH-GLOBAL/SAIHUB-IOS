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
@implementation SHBtcCreatOrImportWalletManage
+(SHBtcWallet *)creatBtcWalletWithPassWord:(NSString *)passWord  withEntropy:(NSData *)entropy
{
    SHBtcWallet *backBtcWalletModel = nil;
    BTHDAccount *account = [[BTHDAccount alloc] initWithMnemonicSeed:entropy password:passWord fromXRandom:YES andGenerationCallback:^(CGFloat p) {
        
    }];
    if (IsEmpty(account)) {
        return backBtcWalletModel;
    }
    backBtcWalletModel = [[SHBtcWallet alloc]init];
    NSArray *words = [account seedWords:passWord];
    [BTAddressManager instance].hdAccountHot = account;
    [[BTWordsTypeManager instance] saveWordsTypeValue:[words componentsJoinedByString:@" "]];
    NSError *error = nil;
    NSString *text = [ToCreatOrImportWalletManage creatBTCWalletWithMnemonics:[words componentsJoinedByString:@" "] error:&error];
    BTAddress *address = [BTAddressManager instance].hdAccountHot;
    backBtcWalletModel.hdAccountId = (int)[account getHDAccountId];
    backBtcWalletModel.mnemonics = [words componentsJoinedByString:@" "];
    backBtcWalletModel.ordinaryAddress = [address addressForPath:EXTERNAL_ROOT_PATH];
    backBtcWalletModel.segwitAddress = [address addressForPath:EXTERNAL_BIP49_PATH];
    backBtcWalletModel.ordinaryPrivateKey = [account privateKeyWithPath:EXTERNAL_ROOT_PATH index:[account addressForPath:EXTERNAL_ROOT_PATH atIndex:0].index password:passWord].key.privateKey;
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:words password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    BTCKeychain *masterKey = mnemonic.keychain;
    NSString *BIP32Path = [NSString stringWithFormat:@"%@/0",@"m/49'/0'/0'"];
    BTCKey * btcKey = [[masterKey derivedKeychainWithPath:BIP32Path] keyAtIndex:0];
    backBtcWalletModel.segwitPrivateKey = btcKey.WIF;
    
    NSString *BIP84Path = [NSString stringWithFormat:@"%@/0",@"m/84'/0'/0'"];
    BTCKey * btc84Key = [[masterKey derivedKeychainWithPath:BIP84Path] keyAtIndex:0];
    NSString *bip84PrivateKey =  btc84Key.WIF;
    return backBtcWalletModel;
}
+ (SHBtcWallet *)creatBtcSubAdressWithPassWord:(NSString *)passWord withAddressType:(TOWalletAddressType)addressType withNumber:(int )number withHdAddressId:(int)hdAddressId
{
    SHBtcWallet *backBtcWalletModel = nil;
    BTHDAccount *account;
    @try {
        account = [[BTHDAccount alloc] initWithSeedId:hdAddressId];
    } @catch (NSException *e) {
        return backBtcWalletModel;
    }
    backBtcWalletModel = [[SHBtcWallet alloc]init];
    NSArray *words = [account seedWords:passWord];
    backBtcWalletModel.mnemonics = [words componentsJoinedByString:@" "];
    NSError *error = nil;
    NSString *text = [ToCreatOrImportWalletManage creatBTCWalletWithMnemonics:[words componentsJoinedByString:@" "] error:&error];

    if (addressType == TOWalletAddressGeneralType) {
        BTHDAccountAddress *hdAccountAddress = [[BTHDAccountAddressProvider instance] getAddressByHDAccountId:hdAddressId path:EXTERNAL_ROOT_PATH index:number];
        backBtcWalletModel.ordinaryAddress = hdAccountAddress.address;
        backBtcWalletModel.ordinaryPrivateKey = [account privateKeyWithPath:EXTERNAL_ROOT_PATH index:number password:passWord].key.privateKey;

    }else if (addressType == TOWalletAddressSegWitType)
    {
        BTHDAccountAddress *hdAccountAddress = [[BTHDAccountAddressProvider instance] getAddressByHDAccountId:hdAddressId path:EXTERNAL_BIP49_PATH index:number];
        backBtcWalletModel.segwitAddress = hdAccountAddress.address;
        BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:words password:nil wordListType:BTCMnemonicWordListTypeEnglish];
        BTCKeychain *masterKey = mnemonic.keychain;
        NSString *BIP32Path = [NSString stringWithFormat:@"%@/0",@"m/49'/0'/0'"];
        BTCKey * btcKey = [[masterKey derivedKeychainWithPath:BIP32Path] keyAtIndex:number];
        backBtcWalletModel.segwitPrivateKey = btcKey.WIF;
    }
    return backBtcWalletModel;
}
+ (SHBtcWallet *)importBtcWalletWithMnemonics:(NSString *)mnemonics WithPassWord:(NSString *)passWord WithIsMigration:(BOOL)isMigration{
    NSArray *walletArray = [[TOKeyStorage shared]queryWalletWithType:TOWalletTypeBTC];
    NSArray *array = [[BTHDAccountProvider instance]getHDAccountSeeds];
    for (NSString *hdId in array) {
        BOOL haveHdId = NO;
        for (TOWalletModel *walletModel in walletArray) {
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
    account = [[BTHDAccount alloc] initWithMnemonicSeed:mnemonicCodeSeed password:passWord fromXRandom:YES andGenerationCallback:^(CGFloat p) {
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
            account = [[BTHDAccount alloc] initWithMnemonicSeed:mnemonicCodeSeed password:passWord fromXRandom:YES andGenerationCallback:^(CGFloat p) {
            }];
            return backBtcWalletModel;
        }
    backBtcWalletModel = [[SHBtcWallet alloc]init];
    [BTAddressManager instance].hdAccountHot = account;
    [[BTWordsTypeManager instance] saveWordsTypeValue:mnemonics];
    BTAddress *address = [BTAddressManager instance].hdAccountHot;
    backBtcWalletModel.hdAccountId = (int)[account getHDAccountId];
    backBtcWalletModel.mnemonics = mnemonics;
    backBtcWalletModel.ordinaryAddress = [address addressForPath:EXTERNAL_ROOT_PATH];
    backBtcWalletModel.segwitAddress = [address addressForPath:EXTERNAL_BIP49_PATH];
    backBtcWalletModel.ordinaryPrivateKey = [account privateKeyWithPath:EXTERNAL_ROOT_PATH index:[account addressForPath:EXTERNAL_ROOT_PATH atIndex:0].index password:passWord].key.privateKey;
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:wordlist password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    BTCKeychain *masterKey = mnemonic.keychain;
    NSString *BIP32Path = [NSString stringWithFormat:@"%@/0",@"m/49'/0'/0'"];
    BTCKey * btcKey = [[masterKey derivedKeychainWithPath:BIP32Path] keyAtIndex:0];
    backBtcWalletModel.segwitPrivateKey = btcKey.WIF;
    if (isMigration) {
        [[BTHDAccountProvider instance]deleteHDAccount:(int)[account getHDAccountId]];
    }
    return backBtcWalletModel;
}
+ (SHBtcWallet *)importBtcWalletWithPrivateKey:(NSString *)privateKey WithPassWord:(NSString *)passWord
{
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
//+(void)changeBtcHdWalletWithModel:(TOWalletModel *)walletModel
//{
//    if (IsEmpty(walletModel)||walletModel.walletType != TOWalletTypeBTC) {
//        [BTAddressManager instance].hdAccountHot = nil;
//    }else
//    {
//        BTHDAccount *subAccount = [[BTHDAccount alloc]initWithSeedId:walletModel.hdAccountId];F
//        [BTAddressManager instance].hdAccountHot = subAccount;
//    }
//}

@end
