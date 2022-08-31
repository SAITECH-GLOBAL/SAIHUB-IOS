//
//  SHReceiveAddressController.h
//  Saihub
//
//  Created by 周松 on 2022/2/23.
//  收款地址

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHReceiveAddressController : SHBaseViewController

@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) BOOL isLnAddress;
@end

NS_ASSUME_NONNULL_END
