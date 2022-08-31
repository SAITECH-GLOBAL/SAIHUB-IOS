//
//  SHLNWalletSetPassWordViewController.h
//  Saihub
//
//  Created by macbook on 2022/6/23.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHLNWalletSetPassWordViewController : SHBaseViewController
@property (nonatomic, copy) void (^setPassWordBlock)(void);

@end

NS_ASSUME_NONNULL_END
