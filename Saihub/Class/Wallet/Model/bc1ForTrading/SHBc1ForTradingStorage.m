//
//  SHBc1ForTradingStorage.m
//  Saihub
//
//  Created by macbook on 2022/3/17.
//

#import "SHBc1ForTradingStorage.h"
#import "SHBcqForTradingModel.h"
static id _bc1ForTradingStorage;
@implementation SHBc1ForTradingStorage
- (RLMRealm *)realm {
    return [RLMRealm defaultRealm];
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bc1ForTradingStorage = [[SHBc1ForTradingStorage alloc]init];
    });
    return _bc1ForTradingStorage;
}
//获取地址列表数组
- (NSArray *)getPoolArray {
    RLMResults *results = [SHPoolListModel allObjects];
    NSMutableArray *modelsArray = [NSMutableArray array];
    for (NSInteger index = 0; index < results.count; index ++) {
        SHBcqForTradingModel *poolBookModel = [results objectAtIndex:index];
        [modelsArray insertObject:poolBookModel atIndex:0];
    }
    return modelsArray.copy;
}

/// 添加地址
- (BOOL)addModel:(RLMObject *)model {
    BOOL addSuccese = YES;
    SHBcqForTradingModel *addModel = model;
    RLMResults *result = [SHPoolListModel allObjects];
    for (NSInteger index = 0; index < result.count; index ++) {
        SHBcqForTradingModel *bc1ForTradingModel = [result objectAtIndex:index];
        if ([bc1ForTradingModel.txid isEqualToString:addModel.txid]) {
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
    SHBcqForTradingModel *addModel = model;
    RLMResults *result = [SHPoolListModel allObjects];
    for (NSInteger index = 0; index < result.count; index ++) {
        SHBcqForTradingModel *bc1ForTradingModel = [result objectAtIndex:index];
        if ([bc1ForTradingModel.txid isEqualToString:addModel.txid]) {
            [self.realm beginWriteTransaction];
            [self.realm deleteObject:bc1ForTradingModel];
            [self.realm commitWriteTransaction];
        }
    }
}

/// 更新
- (void)updateModelBlock:(void (^)(void))block {
    [self.realm transactionWithBlock:block];
}
@end
