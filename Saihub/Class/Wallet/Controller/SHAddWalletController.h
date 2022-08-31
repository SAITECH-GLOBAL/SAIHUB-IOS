//
//  SHAddWalletController.h
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHAddWalletController : SHBaseViewController
/// 选中的回调1://add 2:本地钱包 3：ln钱包
@property (nonatomic,copy) void (^addWalletClickBlock)(NSInteger addType);

@end

NS_ASSUME_NONNULL_END
