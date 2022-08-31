//
//  SHLNWalletModel.h
//  Saihub
//
//  Created by macbook on 2022/6/16.
//
#import "SHLNWalletModel.h"
#import "SHLNInvoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN
RLM_COLLECTION_TYPE(SHLNInvoiceListModel)
@interface SHLNWalletModel : RLMObject
/// 是否当前选中
@property (nonatomic,assign) BOOL isCurrent;

@property (nonatomic, strong) NSString *WalletName;
@property (nonatomic, strong) NSString *UserAccount;
@property (nonatomic, strong) NSString *UserPassWord;
@property (nonatomic, strong) NSString *refresh_token;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *btcAddress;
@property (nonatomic, strong) NSString *hostUrl;
/// 钱包创建时间
@property (nonatomic,assign) NSInteger createTimestamp;
/// 缓存的余额
@property (nonatomic,copy) NSString *balance;
/// 钱包的交易记录
@property (nonatomic,strong) RLMArray <SHLNInvoiceListModel *><SHLNInvoiceListModel> *invoiceList;

///是否开启faceId
@property (nonatomic,assign) BOOL isOpenFaceId;

///是否单位为btc
@property (nonatomic,assign) BOOL isBTCCoin;

/// 钱包密码
@property (nonatomic,copy) NSString *walletPassWord;
@end

NS_ASSUME_NONNULL_END
