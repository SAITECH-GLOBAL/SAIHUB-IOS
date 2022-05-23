//
//  SHPowerDetailModel.m
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHPowerDetailModel.h"

@implementation SHPowerDetailModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"hourDataList": HourDataListItem.class};
}
@end
@implementation HourDataListItem
@end
