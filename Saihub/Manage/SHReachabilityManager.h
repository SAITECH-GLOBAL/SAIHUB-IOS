//
//  SHReachabilityManager.h
//  TokenOne
//
//  Created by 周松 on 2020/11/11.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability.h>

typedef NS_ENUM(NSInteger,BLNetStatus) {
    //不可用
    BLNetStatusNotReachable = 0,
    //可用
    BLNetStatusAvailable
};

NS_ASSUME_NONNULL_BEGIN

@interface SHReachabilityManager : NSObject
+ (instancetype)shared;

///开启监听
- (void)startNotifier;

///网络状态
@property (nonatomic,assign) BLNetStatus netStatus;

@end

NS_ASSUME_NONNULL_END
