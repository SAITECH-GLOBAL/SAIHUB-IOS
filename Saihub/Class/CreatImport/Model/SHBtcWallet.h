//
//  SHBtcWallet.h
//  TokenOne
//
//  Created by macbook on 2020/10/29.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHBtcWallet : SHBaseModel
///钱包id
@property (nonatomic,assign) int hdAccountId;
///普通地址
@property (nonatomic,copy) NSString *ordinaryAddress;//1开头
///普通地址私钥
@property (nonatomic,copy) NSString *ordinaryPrivateKey;
///隔离见证地址
@property (nonatomic,copy) NSString *segwitAddress;//3开头
///隔离见证地址私钥
@property (nonatomic,copy) NSString *segwitPrivateKey;
///bc1地址
@property (nonatomic,copy) NSString *nativeAddress;//bc1开头
///bc1地址私钥
@property (nonatomic,copy) NSString *nativePrivateKey;
///助记词
@property (nonatomic,copy) NSString *mnemonics;

///公钥
@property (nonatomic,copy) NSString *publick;
@end

NS_ASSUME_NONNULL_END
