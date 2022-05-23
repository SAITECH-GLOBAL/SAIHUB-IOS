//
//  SHWalletViewModel.h
//  Saihub
//
//  Created by 周松 on 2022/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHWalletViewModel : NSObject

/// 请求完成 监听刷新列表
@property (nonatomic,assign,readonly) BOOL endRefresh;

/// 获取余额
- (void)requestWalletBalanceData;

/// 遍历获取余额, 不请求接口
- (void)traverseCellGetBalance;

@end

NS_ASSUME_NONNULL_END
