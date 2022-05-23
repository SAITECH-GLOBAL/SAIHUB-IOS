//
//  SHPowerListModel.h
//  Saihub
//
//  Created by macbook on 2022/3/1.
//

#import "SHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHPowerListModel : RLMObject
@property (nonatomic, strong) NSString *powerName;
@property (nonatomic, strong) NSString *powerValue;
@end

NS_ASSUME_NONNULL_END
