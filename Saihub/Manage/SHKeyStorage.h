//
//  SHKeyStorage.h
//  Saihub
//
//  Created by macbook on 2022/2/16.
//  本地数据库管理类

#import <Foundation/Foundation.h>
#import "SHWalletModel.h"
#import "SHLNWalletModel.h"
#import "SHWalletController.h"
#import "SHLNWalletViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHKeyStorage : NSObject

+ (instancetype) shared;

/// 数据库操作对象
@property (nonatomic,strong) RLMRealm *realm;

/// 当前选中的钱包
@property (nonatomic,strong) SHWalletModel *currentWalletModel;

/// 当前选中的LN钱包
@property (nonatomic,strong) SHLNWalletModel *currentLNWalletModel;

/// BTC 的汇率
@property (nonatomic, copy, readonly) NSString *btcRate;

/// USDT汇率
@property (nonatomic, copy, readonly) NSString *usdtRate;
/// 是否是云端钱包 yes/no
@property (nonatomic,assign) BOOL isLNWallet;

/// LN钱包控制器
@property (nonatomic,strong) SHLNWalletViewController *lnWalletVc;

/// hd钱包控制器
@property (nonatomic,strong) SHWalletController *hdWalletVc;

/// 创建单个钱包
- (void)createWalletsWithWalletModel:(SHWalletModel *)walletModel;

/// 创建单个LN钱包
- (void)createLNWalletsWithWalletModel:(SHLNWalletModel *)walletModel;

/// 更新赋值操作
- (void)updateModelBlock:(void(^)(void))block;

/// 添加模型
- (void)addModel:(RLMObject *)model;

/// 删除钱包
- (void)deleteWalletWithModel:(SHWalletModel *)model;

/// 删除LN钱包
- (void)deleteLNWalletWithModel:(SHLNWalletModel *)model;

/// 删除模型集合
- (void)removeArray:(NSArray <RLMObject *> *) array;

/// 判重操作 ---  如果有重复的返回YES 没有返回NO
- (BOOL)checkWalletExistWithContent:(NSString *)content importType:(SHWalletImportType)importType;

/// 初始化
- (void)initializeData;
#pragma mark -- 1.4.1 查询全部可转账的本地钱包
- (NSArray<SHWalletModel *> *)queryWalletCanTransfer;
@end

NS_ASSUME_NONNULL_END
