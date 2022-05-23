//
//  SHNotificationKey.h
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#ifndef SHNotificationKey_h
#define SHNotificationKey_h

/// 点击推送刷新
static NSString *const kClickPushNoticeKey = @"kClickPushNoticeKey";

/// 转账成功通知
static NSString *const kTransferSuccessKey = @"kTransferSuccessKey";

/// 地址或公钥导入钱包
static NSString *const AddresOrPubImportWithNotificationKey = @"AddresOrPubImportWithNotificationKey";

/// 第一次创建或导入钱包
static NSString *const FirstCreaatOrImportWalletKey = @"FirstCreaatOrImportWalletKey";
/// 汇率变化推送刷新
static NSString *const RateChangePushNoticeKey = @"RateChangePushNoticeKey";

#endif /* SHNotificationKey_h */
