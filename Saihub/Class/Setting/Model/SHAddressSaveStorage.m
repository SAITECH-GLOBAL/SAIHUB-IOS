//
//  SHAddressSaveStorage.m
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import "SHAddressSaveStorage.h"
#import "SHAddressBookModel.h"
static id _addressSaveStorage;
@implementation SHAddressSaveStorage
- (RLMRealm *)realm {
    return [RLMRealm defaultRealm];
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _addressSaveStorage = [[SHAddressSaveStorage alloc]init];
    });
    return _addressSaveStorage;
}
//获取地址列表数组
- (NSArray *)getAddressArray {
    RLMResults *results = [SHAddressBookModel allObjects];
    NSMutableArray *modelsArray = [NSMutableArray array];
    for (NSInteger index = 0; index < results.count; index ++) {
        SHAddressBookModel *addressBookModel = [results objectAtIndex:index];
        [modelsArray insertObject:addressBookModel atIndex:0];
    }
    return modelsArray.copy;
}

/// 添加地址
- (BOOL)addModel:(RLMObject *)model {
    BOOL addSuccese = YES;
    SHAddressBookModel *addModel = model;
    RLMResults *result = [SHAddressBookModel allObjects];
    for (NSInteger index = 0; index < result.count; index ++) {
        SHAddressBookModel *AddressModel = [result objectAtIndex:index];
        if ([AddressModel.addressValue isEqualToString:addModel.addressValue]) {
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
    SHAddressBookModel *addModel = model;
    RLMResults *result = [SHAddressBookModel allObjects];
    for (NSInteger index = 0; index < result.count; index ++) {
        SHAddressBookModel *AddressModel = [result objectAtIndex:index];
        if ([AddressModel.addressValue isEqualToString:addModel.addressValue]) {
            [self.realm beginWriteTransaction];
            [self.realm deleteObject:AddressModel];
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
