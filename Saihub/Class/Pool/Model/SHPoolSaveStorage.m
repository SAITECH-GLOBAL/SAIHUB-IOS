//
//  SHPoolSaveStorage.m
//  Saihub
//
//  Created by macbook on 2022/3/1.
//

#import "SHPoolSaveStorage.h"
static id _poolSaveStorage;
@implementation SHPoolSaveStorage
- (RLMRealm *)realm {
    return [RLMRealm defaultRealm];
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _poolSaveStorage = [[SHPoolSaveStorage alloc]init];
    });
    return _poolSaveStorage;
}
//获取地址列表数组
- (NSArray *)getPoolArray {
    RLMResults *results = [SHPoolListModel allObjects];
    NSMutableArray *modelsArray = [NSMutableArray array];
    for (NSInteger index = 0; index < results.count; index ++) {
        SHPoolListModel *poolBookModel = [results objectAtIndex:index];
        [modelsArray insertObject:poolBookModel atIndex:0];
    }
    return modelsArray.copy;
}

/// 添加地址
- (BOOL)addModel:(RLMObject *)model {
    BOOL addSuccese = YES;
    SHPoolListModel *addModel = model;
//    RLMResults *result = [SHPoolListModel allObjects];
//    for (NSInteger index = 0; index < result.count; index ++) {
//        SHPoolListModel *PoolModel = [result objectAtIndex:index];
//        if ([PoolModel.poolUrl isEqualToString:addModel.poolUrl]) {
//            addSuccese = NO;
//        }
//    }
    if (addSuccese) {
        [self updateModelBlock:^{
            [self.realm addObject:addModel];
        }];
    }
    return addSuccese;

}
/// 删除地址
- (void)removeModel:(RLMObject *)model {
    SHPoolListModel *deleatModel = model;
    [self updateModelBlock:^{
        [self.realm deleteObject:deleatModel];
    }];
}

/// 更新
- (void)updateModelBlock:(void (^)(void))block {
    [self.realm transactionWithBlock:block];
}
@end
