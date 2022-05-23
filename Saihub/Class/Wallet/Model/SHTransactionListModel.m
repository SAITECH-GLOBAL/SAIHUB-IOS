//
//  SHTransactionListModel.m
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import "SHTransactionListModel.h"

@implementation SHTransactionListModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"t_hash" : @"hash"};
}

@end
