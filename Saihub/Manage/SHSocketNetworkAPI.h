//
//  SHSocketNetworkAPI.h
//  TokenOne
//
//  Created by 周松 on 2020/11/12.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SocketHandleType) {
    SocketQuerySubscribeType = 1,//查询加订阅
    SocketUnsubscribeType = 2,//取消订阅
};

@protocol SHSocketNetworkingResponseProtocol <NSObject>

@optional

- (void)socketDidRecievedResponse:(id)response;

@end

typedef void (^NetworkingCompletionBlock) (id response);

@interface SHSocketNetworkAPI : NSObject

@property (nonatomic, weak) id<SHSocketNetworkingResponseProtocol> delegate;//获取到response之后的delegate回调
@property (nonatomic, copy) NetworkingCompletionBlock completionBlock;//获取到response之后的block回调

///发送数据
@property (nonatomic,strong) NSMutableDictionary *sendPara;

///发送出去时的时间，用于查询订阅和单纯查询Type时判断是否超时
@property (nonatomic, strong) NSDate *sendDate;
///ws类型
@property (nonatomic,copy) NSString *ws_type;

///标识,每次创建都要不一样
@property (nonatomic,copy) NSString *identifier;

@property (nonatomic,assign) SocketHandleType handleType;

@end

NS_ASSUME_NONNULL_END
