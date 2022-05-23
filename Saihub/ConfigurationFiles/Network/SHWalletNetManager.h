//
//  SHWalletNetManager.h
//  TokenOne
//
//  Created by 周松 on 2020/10/14.
//  Copyright © 2020 zhaohong. All rights reserved.
//  BTC 请求调用了多个第三方接口


#import <Foundation/Foundation.h>
#import "NetWorkTool.h"
#import "SHPostAddressModel.h"
#import <BTTx.h>
#import "BTHDAccountAddress.h"

NS_ASSUME_NONNULL_BEGIN
//请求成功的block类型
typedef void(^SuccessdBlock)(SHBaseResponseModel *result);
//请求失败的block类型
typedef void(^FailBlock)(NSInteger errorCode, NSString *errorMessage);
@interface SHWalletNetManager : NSObject

+ (instancetype)shared;

- (NSURLSessionDataTask *)requestBtcHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(NSMutableDictionary *)params success:(void(^)(id  _Nullable responseObject))successBlok fail:(void(^)(NSInteger errorCode,NSString *errorMessage))failBlock;

- (NSURLSessionDataTask *)btcRequestHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(NSMutableDictionary *)params success:(void(^)(id responseObjc))successBlok fail:(void(^)(NSInteger errorCode,NSString *errorMessage))failBlock;

/// 上报地址
- (void)postAddressArray:(NSArray <SHPostAddressModel *> *)array ;

/// 获取BTC余额
- (NSURLSessionDataTask *)getBtcBalanceWithAddresses:(NSString *)addresses timestamp:(NSInteger)walletTimestamp result:(void (^)(NSInteger code, NSString * _Nonnull message))resultBlock;

/// 获取USDT 余额
- (NSURLSessionDataTask *)getBtcUsdtBalanceWithAddress:(NSString *)address result:(void(^)(NSString *__nullable balance, NSInteger code, NSString *message))resultBlock;

/// 获取交易记录
- (void)getTransactionTxListWithPara:(NSMutableDictionary *)para result:(ResponseResultBlock)resultBlock;

/// 发送广播
- (void)sendBroadcastWithSignPara:(NSDictionary *)para result:(void(^)(NSString *__nullable hash, NSInteger code, NSString *message))resultBlock;

/// 获取代币汇率
- (NSURLSessionTask *)requestTokenRateWithToken:(NSString *)token type:(NSInteger)type resultBlock:(ResponseResultBlock)resultBlock;

/// 批量查询汇率
- (NSURLSessionTask *)requestBatchTokensRate:(NSString *)tokens type:(NSInteger)type resultBlock:(ResponseResultBlock)resultBlock;

/// 上报pending中的交易
- (void)requestPostPendingTransactionWithPara:(NSDictionary *)para result:(void (^)(id __nullable result, NSInteger code, NSString *message))resultBlock;

//获取gas推荐值
- (void)getGasPriceSuccess:(SuccessdBlock)success fail:(FailBlock)fail;

///查询btc 账户下 utxo
- (void)getBtcUtxoWithArray:(NSArray <NSString *> *)addresses succes:(void(^)(id result))success fail:(FailBlock)fail;

#pragma mark -- BTC 私钥生成的交易对象(推荐矿工费,自定义矿工费不做逻辑修改)
- (void)creatBtcPrivateKeyTransactionWithToAddress:(NSString *)toAddress FromeAddress:(NSString *)fromeAddress withValue:(uint64_t)value withOmniValue:(NSString *)omnivalue withomniId:(NSString *)omniId sat:(NSString *)sat bytes:(int64_t)bytes PrivateKey:(NSString *)privateKey isSegwit:(BOOL)segwit transactionCallBack:(void(^)(NSError *error, BTCTransaction *transaction,uint64_t realBytes))transactionCallBack;


#pragma mark -- BTC 助记词生成的交易对象(推荐矿工费)
- (void)createBtcMnemonicTransactionWithToAddress:(NSString *)toAddress withValue:(uint64_t)value pathType:(PathType)pathType sat:(NSString *)sat bytes:(uint64_t)bytes password:(NSString *)password transactionCallBack:(void (^)(NSError * _Nonnull, BTTx * _Nonnull, uint64_t realBytes))transactionCallBack;
#pragma mark -- BTC 助记词生成Bc1地址的交易对象(推荐矿工费)
- (void)createBtcMnemonicBc1TransactionWithToAddress:(NSString *)toAddress withValue:(uint64_t)value withOuts:(NSArray *)outs pathType:(PathType)pathType sat:(NSString *)sat bytes:(uint64_t)bytes password:(NSString *)password transactionCallBack:(void (^)(NSError * _Nonnull, BTTx * _Nonnull, uint64_t realBytes))transactionCallBack;

#pragma mark -- 获取btcUTXOForsegwit
- (void)segwitQueryBtcUnspentUtxoWithAddress:(NSString *)address succes:(void (^)(NSArray *array))success fail:(FailBlock)fail;
///查询btcUTXO
- (void)queryBtcUnspentUtxoWithAddress:(NSMutableArray *)array WithblockchairUtxos:(NSMutableArray *)blockchairUtxos succes:(void(^)(id result))success fail:(FailBlock)fail;
///查询btcUTXO
- (void)queryBtcUnspentUtxoBc1WithAddress:(NSMutableArray *)array WithblockchairUtxos:(NSMutableArray *)blockchairUtxos succes:(outsBackResponseBlock)success fail:(FailBlock)fail;

#pragma mark - 构造交易私钥隔离验证
- (void)createTransactionFrom:(NSString *)fromAddress
                           to:(NSString *)toAddress
                       amount:(int64_t)amount
                          fee:(int64_t)fee
                       omniId:(NSString *)omniId
                    omniValue:(NSString *)omniValue
                        utxos:(NSArray *)utxos
                       segwit:(BOOL)segwit
          transactionCallBack:(void(^)(NSError *error, BTCTransaction *transaction))transactionCallBack;
//存储btc交易信息
-(void)saveBtcTransactionsWithBlockchair:(NSArray *)blockchairUtxos succes:(void (^)(id _Nonnull))success;
//存储btc bc1交易信息
-(void)saveBtcTransactionsBc1WithBlockchair:(NSArray *)blockchairUtxos succes:(outsBackResponseBlock)success;

- (void)getUnspentTransactionsForBlockchair:(NSArray *)blockchairUtxos beginIndex:(NSUInteger)beginIndex endIndex:(NSUInteger)endIndex blockCount:(uint32_t)blockCount utxoAddresses:(NSMutableArray *)utxoAddresses callback:(TxResponseBlock)callback;
#pragma mark - 签名交易
- (void)signTransaction:(BTCTransaction *)tx
                 btcKey:(BTCKey *)key
                 segwit:(BOOL)segwit
    transactionCallBack:(void(^)(NSError *error, BTCTransaction *transaction))transactionCallBack;
///发送广播
- (void)sendBroadcastWithSignPara:(NSDictionary *)para succes:(void(^)(NSString * hash))success fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
