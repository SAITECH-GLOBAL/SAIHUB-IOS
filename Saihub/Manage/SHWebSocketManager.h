//
//  SHWebSocketManager.h
//  TokenOne
//
//  Created by 周松 on 2020/11/12.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHSocketNetworkAPI.h"
NS_ASSUME_NONNULL_BEGIN


@interface SHWebSocketManager : NSObject

/**
 单例

 @return FTWebSocketManager的单例对象
 */
+ (instancetype)sharedManager;

/**
 WebSocket是否已经连接成功，外界可以通过Rac监听这个属性在连接成功后才发送接口数据
 */
@property (nonatomic, assign) BOOL isOpen;

/**
 打开socket长连接
 */
- (void)openSocket;

/**
 手动关闭socket
 
 @param completionBlock 关闭成功之后的回调
 */
- (void)closeSocketWithCompletionBlock:(dispatch_block_t)completionBlock;

///发送订阅
- (void)querySubscribeDataWithApi:(SHSocketNetworkAPI *)api;

@end

NS_ASSUME_NONNULL_END
