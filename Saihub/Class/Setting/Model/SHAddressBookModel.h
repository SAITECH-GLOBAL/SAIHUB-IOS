//
//  SHAddressBookModel.h
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHAddressBookModel : RLMObject
@property (nonatomic, strong) NSString *addressName;
@property (nonatomic, strong) NSString *addressValue;
@end

NS_ASSUME_NONNULL_END
