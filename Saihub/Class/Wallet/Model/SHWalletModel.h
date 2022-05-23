//
//  SHWalletModel.h
//  Saihub
//
//  Created by macbook on 2022/2/16.
//

#import "SHTransactionListModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SHWalletTokenModel;
@class SHWalletSubAddressModel;
@class SHWalletZpubModel;

/// 导入类型
typedef NS_ENUM(NSInteger,SHWalletImportType) {
    /// 助记词导入
    SHWalletImportTypeMnemonic,
    /// 私钥导入
    SHWalletImportTypePrivateKey,
    /// 公钥导入
    SHWalletImportTypePublicKey,
    /// 地址导入
    SHWalletImportTypeAddress
};

/// 钱包类型
typedef NS_ENUM(NSInteger,SHWalletType) {
    SHWalletTypeBTC
};

RLM_COLLECTION_TYPE(SHWalletTokenModel)
RLM_COLLECTION_TYPE(SHWalletSubAddressModel)
RLM_COLLECTION_TYPE(SHWalletZpubModel)

@interface SHWalletModel : RLMObject

/// 钱包类型
@property (nonatomic, assign) SHWalletType walletType;

@property (nonatomic, readwrite) int hdAccountId;

/// 是否当前选中
@property (nonatomic,assign) BOOL isCurrent;

/// 导入类型
@property (nonatomic,assign) SHWalletImportType importType;

/// 钱包名称
@property (nonatomic,copy) NSString *name;

/// 地址
@property (nonatomic,copy) NSString *address;

/// 助记词
@property (nonatomic,copy) NSString *mnemonic;

/// 密码
@property (nonatomic,copy) NSString *password;

/// 私钥
@property (nonatomic,copy) NSString *privateKey;

/// 公钥
@property (nonatomic,copy) NSString *publicKey;

/// 盐
@property (nonatomic,copy) NSString *passPhrase;

/// 是否是免密模式
@property (nonatomic,assign) BOOL isNoSecret;

/// 缓存的余额
@property (nonatomic,copy) NSString *balance;

/// 钱包创建时间
@property (nonatomic,assign) NSInteger createTimestamp;

/// 上一次请求余额时间,因为接口限频
@property (nonatomic, assign) NSInteger lastRequestTimestamp;

/// 钱包的代币列表
@property (nonatomic,strong) RLMArray <SHWalletTokenModel *><SHWalletTokenModel> *tokenList;

/// 子地址列表
@property (nonatomic,strong) RLMArray <SHWalletSubAddressModel *><SHWalletSubAddressModel> *subAddressList;

/// 找零地址
@property (nonatomic,strong) RLMArray <SHWalletSubAddressModel *><SHWalletSubAddressModel> *changeAddressList;

/// 当前选中的子地址的索引
@property (nonatomic,assign) NSInteger selectSubIndex;

/// 所有子地址拼接成的字符串
@property (nonatomic, copy) NSString *subAddressStr;

// zpub 相关
/// 单签zpub字典json
@property (nonatomic, copy) NSString *zpubJsonString;
/// 确认数量
@property (nonatomic, assign) NSInteger policySureCount;

/// 总数量
@property (nonatomic, assign) NSInteger policyTotalCount;

/// 路径
@property (nonatomic, copy) NSString *derivation;

/// 类型
@property (nonatomic, copy) NSString *format;

/// zpub 数组
@property (nonatomic, strong) RLMArray <SHWalletZpubModel *><SHWalletZpubModel> *zpubList;

@end

#pragma mark -- 代币列表

RLM_COLLECTION_TYPE(SHTransactionListModel)
@interface SHWalletTokenModel : RLMObject

/// 合约地址
@property (nonatomic,copy) NSString * contractAddr;

@property (nonatomic,copy) NSString * logo;

@property (nonatomic,strong) NSData *imageData;

/// 全称
@property (nonatomic,copy) NSString * tokenFull;

/// 简称
@property (nonatomic,copy) NSString * tokenShort;

/// 小数位数
@property (nonatomic,assign) NSInteger places;

/// 余额
@property (nonatomic,copy) NSString *balance;

/// 是否是主币
@property (nonatomic,assign) BOOL isPrimaryToken;

/// pending状态的交易记录
@property (nonatomic,strong) RLMArray <SHTransactionListModel *><SHTransactionListModel> *pendingList;

@end

#pragma mark -- 子地址
@interface SHWalletSubAddressModel : RLMObject

/// 地址
@property (nonatomic,copy) NSString *address;

/// 私钥
@property (nonatomic,copy) NSString *privateKey;

/// path类型
@property (nonatomic,copy) NSString *pathString;

@property (nonatomic, readwrite) int hdAccountId;

/// 余额 (sat 为单位)
@property (nonatomic, copy) NSString *balance;

@end

/// ZPUB 模型
@interface SHWalletZpubModel : RLMObject

@property (nonatomic, copy) NSString *publicKey;

@property (nonatomic, copy) NSString *title;

@end


NS_ASSUME_NONNULL_END
