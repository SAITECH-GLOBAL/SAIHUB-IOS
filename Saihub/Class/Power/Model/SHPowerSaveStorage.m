//
//  SHPowerSaveStorage.m
//  Saihub
//
//  Created by macbook on 2022/3/1.
//

#import "SHPowerSaveStorage.h"

static id _powerSaveStorage;
@implementation SHPowerSaveStorage
- (RLMRealm *)realm {
    return [RLMRealm defaultRealm];
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _powerSaveStorage = [[SHPowerSaveStorage alloc]init];
    });
    return _powerSaveStorage;
}
//获取地址列表数组
- (NSArray *)getPowerArray {
    RLMResults *results = [SHPowerListModel allObjects];
    NSMutableArray *modelsArray = [NSMutableArray array];
    for (NSInteger index = 0; index < results.count; index ++) {
        SHPowerListModel *powerBookModel = [results objectAtIndex:index];
        [modelsArray insertObject:powerBookModel atIndex:0];
    }
    return modelsArray.copy;
}

/// 添加地址
- (BOOL)addModel:(RLMObject *)model {
    BOOL addSuccese = YES;
    SHPowerListModel *addModel = model;
    RLMResults *result = [SHPowerListModel allObjects];
    for (NSInteger index = 0; index < result.count; index ++) {
        SHPowerListModel *PowerModel = [result objectAtIndex:index];
        if ([PowerModel.powerValue isEqualToString:addModel.powerValue]) {
            addSuccese = NO;
        }
    }
    if (addSuccese) {
        [self updateModelBlock:^{
            [self.realm addObject:addModel];
        }];
    }
    return addSuccese;

}
/// 删除地址
- (void)removeModel:(RLMObject *)model {
    SHPowerListModel *addModel = model;
    RLMResults *result = [SHPowerListModel allObjects];
    for (NSInteger index = 0; index < result.count; index ++) {
        SHPowerListModel *PowerModel = [result objectAtIndex:index];
        if ([PowerModel.powerValue isEqualToString:addModel.powerValue]) {
            [self.realm beginWriteTransaction];
            [self.realm deleteObject:PowerModel];
            [self.realm commitWriteTransaction];
        }
    }
    [self updateModelBlock:^{

    }];
}
/// 更新
- (void)updateModelBlock:(void (^)(void))block {
    [self.realm transactionWithBlock:block];
}
@end
