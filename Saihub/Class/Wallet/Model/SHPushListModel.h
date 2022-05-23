//
//  SHPushListModel.h
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHPushListModel : SHBaseModel

@property (nonatomic,copy) NSString *blockHash;
@property (nonatomic,copy) NSString *blockNumber;
@property (nonatomic,copy) NSString *confirmations;
//合约地址
@property (nonatomic,copy) NSString *contractAddress;

@property (nonatomic,copy) NSString *cumulativeGasUsed;


@property (nonatomic,copy) NSString *fromAddress;
@property (nonatomic,copy) NSString *gas;
@property (nonatomic,copy) NSString *gasPrice;
@property (nonatomic,copy) NSString *gasUsed;
@property (nonatomic,copy) NSString *t_hash;
@property (nonatomic,copy) NSString *nonce;
@property (nonatomic,assign) long long timestamp;
@property (nonatomic,copy) NSString *toAddress;

@property (nonatomic,assign) NSInteger transactionIndex;

@property (nonatomic,assign) NSInteger txreceipt_status;

@property (nonatomic,copy) NSString *amount;

@property (nonatomic,strong) NSData *input;

// 交易状态
@property (nonatomic,assign) SHTransactionStatus status;
/// 钱包类型
@property (nonatomic,assign) SHWalletType walletType;
/// 是否已读
@property (nonatomic,assign) BOOL isRead;
/// 标题
@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *body;

@property (nonatomic,copy) NSString *content;

//主链币类型
@property (nonatomic,copy) NSString *coin;

///代币名称
@property (nonatomic,copy) NSString *contractName;

///标识  push  自定义
@property (nonatomic,copy) NSString *identify;
//1转入;2转出
@property (nonatomic,assign) NSInteger type;
///矿工费
@property (nonatomic,copy) NSString *fee;

/// trx独有的参数,可根据这个参数判断是否是trx交易
@property (nonatomic,copy) NSString *trxContractType;


@end

NS_ASSUME_NONNULL_END
