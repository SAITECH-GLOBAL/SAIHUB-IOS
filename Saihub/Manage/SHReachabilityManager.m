//
//  SHReachabilityManager.m
//  TokenOne
//
//  Created by 周松 on 2020/11/11.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHReachabilityManager.h"
#import "SHPostAddressModel.h"


@interface SHReachabilityManager ()

@property (nonatomic,strong) Reachability *hostReachability;

@end

static id _reachabilityManager;
@implementation SHReachabilityManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachabilityManager = [[SHReachabilityManager alloc]init];
        
    });
    return _reachabilityManager;
}

- (void)startNotifier{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.baidu.com";
    self.hostReachability = [Reachability reachabilityWithHostname:remoteHostName];
    [self.hostReachability startNotifier];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability *reach = [note object];
    if([reach currentReachabilityStatus] == ReachableViaWiFi || [reach currentReachabilityStatus] == ReachableViaWWAN){
        self.netStatus = BLNetStatusAvailable;
        [self repeatPostAddress];
    } else { //不可用
        self.netStatus = BLNetStatusNotReachable;
    }
}

#pragma mark -- 重新上报地址
- (void)repeatPostAddress {
    if ([SHPostAddressModel allObjects].count > 0) {
        NSMutableArray *addressM = [NSMutableArray array];
        for (NSInteger index = 0; index < [SHPostAddressModel allObjects].count; index ++) {
            [addressM addObject:[[SHPostAddressModel allObjects]objectAtIndex:index]];
        }
        
        [[SHWalletNetManager shared] postAddressArray:addressM];
    }
}

@end
