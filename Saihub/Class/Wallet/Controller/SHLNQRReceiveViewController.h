//
//  SHLNQRReceiveViewController.h
//  Saihub
//
//  Created by macbook on 2022/6/22.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHLNQRReceiveViewController : SHBaseViewController
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSString *amountString;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, assign) long timeCreat;

@end

NS_ASSUME_NONNULL_END
