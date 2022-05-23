//
//  SHBtcCreatOrImportWalletManage.h
//  TokenOne
//
//  Created by macbook on 2020/10/29.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TOWalletModel.h"
#import "SHBtcWallet.h"
#import "SHWalletModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SHWalletAddressType) {
    ///普通地址
    TOWalletAddressGeneralType,
    ///隔离见证
    TOWalletAddressSegWitType,
    ///找零普通
    TOWalletAddressInternalGeneralType,
    ///找零隔离
    TOWalletAddressInternalSegWitType
};
@interface SHBtcCreatOrImportWalletManage : NSObject
+ (SHBtcWallet *)creatBtcWalletWithPassWord:(NSString *)passWord withPassphrase:(NSString *)passphrase withEntropy:(NSData *)entropy;
//+ (SHBtcWallet *)creatBtcSubAdressWithPassWord:(NSString *)passWord withAddressType:(SHWalletAddressType)addressType withNumber:(int)number withHdAddressId:(int)hdAddressId;
+ (SHBtcWallet *)importBtcWalletWithMnemonics:(NSString *)mnemonics WithPassWord:(NSString *)passWord withPassphrase:(NSString *)passphrase;
+ (SHBtcWallet *)importBtcWalletWithPrivateKey:(NSString *)privateKey WithPassWord:(NSString *)passWord withPassphrase:(NSString *)passphrase;
+ (SHWalletModel *)importBtcWalletWithAddress:(NSString *)address withWalletName:(NSString *)walletName;
+ (SHWalletModel *)importBtcWalletWithPub:(NSString *)pubKey withWalletName:(NSString *)walletName;
+ (SHWalletModel *)importBtcWalletWithPubs:(NSArray *)pubKeyArray WithPubDic:(NSDictionary *)pubDic WithPubTitles:(NSArray *)pubKeyTitleArray withWalletName:(NSString *)walletName;

+(void)changeBtcHdWalletWithModel:(SHWalletModel *)walletModel;

@end

NS_ASSUME_NONNULL_END
