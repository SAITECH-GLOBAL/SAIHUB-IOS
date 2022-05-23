//
//  SHImportCheckTypeManage.m
//  Saihub
//
//  Created by macbook on 2022/3/4.
//r

#import "SHImportCheckTypeManage.h"
#import "BTHDAccount.h"
#import "BTAddressManager.h"
#import "BTWordsTypeManager.h"
#import "BTHDAccountAddressProvider.h"
#import "BTHDAccountProvider.h"
#import "BTEncryptData.h"
#import "BTPrivateKeyUtil.h"
#import "BTAddressProvider.h"
//#import "SHWalleRtModel.h"

@implementation SHImportCheckTypeManage
+ (NSInteger)importWalletCheckTypeWithCheckString:(NSString *)checkString
{
    NSArray *mnemonicArray = [checkString componentsSeparatedByString:@" "];
    NSString *addressRegex = @"^(3|b)[a-zA-Z\\d]{24,62}$";
    NSPredicate *addressTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", addressRegex];
    BTKey *key = [BTKey keyWithPrivateKey:checkString];
    BTAddress *address;
    BOOL isMultipleeSignature = [checkString containsString:@"Name:"]&&[checkString containsString:@"Policy:"]&&[checkString containsString:@"Derivation:"]&&[checkString containsString:@"Format:"];
    BOOL isSingleSignature = [checkString containsString:@"ExtPubKey"]&&[checkString containsString:@"MasterFingerprint"]&&[checkString containsString:@"AccountKeyPath"]&&([checkString containsString:@"zpub"]||[checkString containsString:@"ypub"]);

    NSString *encryptKey = [BTPrivateKeyUtil getPrivateKeyString:key passphrase:@""];
    if (encryptKey != nil) {
        address = [[BTAddress alloc] initWithKey:key encryptPrivKey:encryptKey isSyncComplete:NO isXRandom:NO];
    }
    if (mnemonicArray.count == 12 || mnemonicArray.count == 24) {
        return 0;
    }else if ([addressTest evaluateWithObject:checkString]) {
        return 3;
    }else if (!IsEmpty(key)&&!IsEmpty(address)) {
        return 1;
    }else if (checkString.length == 111 && ([[[checkString substringToIndex:4]lowercaseString]isEqualToString:@"xpub"]||[[[checkString substringToIndex:4]lowercaseString]isEqualToString:@"ypub"]||[[[checkString substringToIndex:4]lowercaseString]isEqualToString:@"zpub"])) {
        return 2;
    }else if (isMultipleeSignature) {
        return 4;
    }else if (isSingleSignature) {
        return 6;
    }else
    {
        return 5;
    }
}
+ (BOOL)importWalletCheckHaveSameWalletWithCheckString:(NSString *)checkString WithImportType:(NSInteger)importType
{
    RLMResults<SHWalletModel *> *wallets = [SHWalletModel objectsWhere:[NSString stringWithFormat:@"importType=%zd",importType]];
    for (SHWalletModel *walletModel in wallets) {
        if (importType == SHWalletImportTypeMnemonic) {
            if ([walletModel.mnemonic isEqualToString:checkString]) {
                return YES;
            }
        }else if (importType == SHWalletImportTypePrivateKey)
        {
            if ([walletModel.privateKey isEqualToString:checkString]) {
                return YES;
            }
        }

    }
    return NO;
}

@end
