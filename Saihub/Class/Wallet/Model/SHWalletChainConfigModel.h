//
//  SHWalletChainConfigModel.h
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import <Foundation/Foundation.h>

@class SHWalletChainConfigTokenModel;
NS_ASSUME_NONNULL_BEGIN


@interface SHWalletChainConfigModel : SHBaseModel

@property (nonatomic,assign) NSInteger walletType;

/// 公链
@property (nonatomic,copy) NSString *publicChain;

/// 链名称
@property (nonatomic,copy) NSString *chainName;

/// 上报地址的参数
@property (nonatomic,copy) NSString *postCoin;

/// 订阅的参数
@property (nonatomic,copy) NSString *subCoin;

/// 矿工费币种
@property (nonatomic,copy) NSString *feeCoin;

@property (nonatomic,strong) NSArray <SHWalletChainConfigTokenModel *> *tokenList;

@end

@interface SHWalletChainConfigTokenModel : SHBaseModel

@property (nonatomic , copy) NSString              * tokenName;

@property (nonatomic , copy) NSString              * tokenFullName;

/// 小数位数
@property (nonatomic , assign) NSInteger              places;

@property (nonatomic , copy) NSString              * tokenImageName;

/// 地址
@property (nonatomic , copy) NSString              * address;

@property (nonatomic , copy) NSString              * logo;

@end

NS_ASSUME_NONNULL_END
