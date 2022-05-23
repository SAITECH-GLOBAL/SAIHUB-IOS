//
//  SHWalletViewModel.m
//  Saihub
//
//  Created by 周松 on 2022/3/7.
//

#import "SHWalletViewModel.h"

@interface SHWalletViewModel ()

@property (nonatomic,strong) NSMutableArray *taskArray;

@property (nonatomic,assign,readwrite) BOOL endRefresh;

@end

@implementation SHWalletViewModel

- (NSMutableArray *)taskArray {
    if (_taskArray == nil) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

- (void)requestWalletBalanceData {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestWalletBalanceData) object:nil];
    
    // 将之前的任务取消
    [self.taskArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj != nil) {
            [obj cancel];
        }
        [self.taskArray removeObjectAtIndex:idx];
    }];

    // 没有钱包 return
    if ([SHKeyStorage shared].currentWalletModel == nil) {
        return;
    }
    
    // 选中的单地址
    SHWalletSubAddressModel *subAddressModel = [[SHKeyStorage shared].currentWalletModel.subAddressList objectAtIndex:[SHKeyStorage shared].currentWalletModel.selectSubIndex];
    
    SHWalletTokenModel *usdtTokenModel = [SHKeyStorage shared].currentWalletModel.tokenList.lastObject;
    
    // 所有地址字符串
    NSString *totalAddress = [SHKeyStorage shared].currentWalletModel.subAddressStr;
    
    NSString *usdtAddress = subAddressModel.address;
    
    NSInteger timestamp = [SHKeyStorage shared].currentWalletModel.lastRequestTimestamp;
            
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    
    // 请求BTC余额
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSURLSessionDataTask *task = [[SHWalletNetManager shared] getBtcBalanceWithAddresses:totalAddress timestamp: timestamp  result:^(NSInteger code, NSString * _Nonnull message) {
            dispatch_semaphore_signal(semaphore);
        }];

        if (task != nil) {
            [self.taskArray addObject:task];
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    // 请求USDT余额
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSURLSessionDataTask *task = [[SHWalletNetManager shared] getBtcUsdtBalanceWithAddress:usdtAddress result:^(NSString * _Nullable balance, NSInteger code, NSString * _Nonnull message) {
            if (usdtTokenModel.isInvalidated == YES) {
                dispatch_semaphore_signal(semaphore);
                return;
            }
            
            if (code == 0) {
                [[SHKeyStorage shared] updateModelBlock:^{
                    usdtTokenModel.balance = [SHWalletUtils coin_lowTohighWithAmount:balance decimal:usdtTokenModel.places];
                }];
            }
            
            dispatch_semaphore_signal(semaphore);

        }];
        
        if (task != nil) {
            [self.taskArray addObject:task];
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.endRefresh = YES;
        
        [self traverseCellGetBalance];
    });
    
    [self performSelector:@selector(requestWalletBalanceData) afterDelay:70];
}

#pragma mark -- 遍历获取总余额
- (void)traverseCellGetBalance {
    NSString *balance = @"0";

    if ([SHKeyStorage shared].currentWalletModel.isInvalidated == YES) {
        
        self.endRefresh = YES;
        
        return;
    }
    
    NSInteger count = [SHKeyStorage shared].currentWalletModel.tokenList.count;
    
    for (NSInteger index = 0; index < count; index ++) {
        SHWalletTokenModel *tokenModel = [[SHKeyStorage shared].currentWalletModel.tokenList objectAtIndex:index];
        
        if (tokenModel.isPrimaryToken == YES) {
            balance = [NSString formStringWithValue:[[SHWalletUtils coin_highToLowWithAmount:tokenModel.balance decimal:tokenModel.places] to_multiplyingWithStr:[SHKeyStorage shared].btcRate] count:2];
        } else {
            balance = [NSString formStringWithValue:[balance to_addingWithStr: [[SHWalletUtils coin_highToLowWithAmount:tokenModel.balance decimal:tokenModel.places] to_multiplyingWithStr:[SHKeyStorage shared].usdtRate]] count:2];
        }
        
    }
    
    [[SHKeyStorage shared] updateModelBlock:^{
        [SHKeyStorage shared].currentWalletModel.balance = balance;
    }];
    
    self.endRefresh = YES;
}

@end
