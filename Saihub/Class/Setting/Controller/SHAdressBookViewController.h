//
//  SHAdressBookViewController.h
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHAdressBookViewController : SHBaseViewController
@property (copy) void(^selectAddressClickBlock)(SHAddressBookModel *addressModel);
@property (nonatomic, assign) NSInteger inputType;//0:设置 1：交易
@end

NS_ASSUME_NONNULL_END
