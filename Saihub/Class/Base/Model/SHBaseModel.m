//
//  SHBaseModel.m
//  MasterTrading
//
//  Created by 周松 on 2020/6/1.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHBaseModel.h"
#import <YYKit.h>

@implementation SHBaseModel
// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; }
- (NSUInteger)hash { return [self modelHash]; }
- (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }
- (NSString *)description { return [self modelDescription]; }

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end


@implementation SHBaseResponseModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data" : [SHBaseResponseDataModel class]};
}

@end


@implementation SHBaseResponseDataModel



@end
