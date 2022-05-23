//
//  SHTransactionListModel.h
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SHTransactionStatus) {
    SHTransactionStatusPending = 0,
    SHTransactionStatusSuccess,
    SHTransactionStatusFailed,
    SHTransactionStatusUnknown
};

@interface SHTransactionListModel : RLMObject

@property (nonatomic,copy) NSString *amount;

@property (nonatomic,copy) NSString *blockHash;
@property (nonatomic,copy) NSString *blockNumber;
@property (nonatomic,copy) NSString *confirmations;
//合约地址
@property (nonatomic,copy) NSString *contractAddress;

//详情数据
@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *fromAddress;
@property (nonatomic,copy) NSString *gas;
@property (nonatomic,copy) NSString *gasPrice;
@property (nonatomic,copy) NSString *gasUsed;
/// 交易hash
@property (nonatomic,copy) NSString *t_hash;
@property (nonatomic,assign) long long timestamp;
@property (nonatomic,copy) NSString *toAddress;

@property (nonatomic,assign) NSInteger transactionIndex;

@property (nonatomic,assign) NSInteger txreceipt_status;

@property (nonatomic,copy) NSString *value;
/// 0是成功
@property (nonatomic,copy) NSString *isError;

@property (nonatomic,strong) NSData *input;

/// 交易状态
@property (nonatomic,assign) SHTransactionStatus status;

/// 代币 全称
@property (nonatomic,copy) NSString *tokenName;
/// 简称
@property (nonatomic,copy) NSString *tokenSymbol;
/// 小数位数
@property (nonatomic,assign) NSInteger tokenDecimal;

/// 1充币 2提币
@property (nonatomic,assign) NSInteger type;

/// 矿工费
@property (nonatomic,copy) NSString *fee;

/// 币种
@property (nonatomic,copy) NSString *coin;

@end

NS_ASSUME_NONNULL_END
