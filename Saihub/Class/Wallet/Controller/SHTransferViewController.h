//
//  SHTransferViewController.h
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHTransferViewController : SHBaseViewController
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) SHWalletTokenModel *tokenModel;
@end

NS_ASSUME_NONNULL_END
