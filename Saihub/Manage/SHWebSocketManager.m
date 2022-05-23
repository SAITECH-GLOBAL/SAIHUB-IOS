//
//  SHWebSocketManager.m
//  TokenOne
//
//  Created by 周松 on 2020/11/12.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHWebSocketManager.h"
#import <SRWebSocket.h>
#import "SHReachabilityManager.h"
#import <NSTimer+YYAdd.h>


@interface SHWebSocketManager () <SRWebSocketDelegate>


@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, SHSocketNetworkAPI *> *apiDictionary;//保存所有的订阅的请求的可变字典
@property (nonatomic, strong) NSTimer *heartTimer;//心跳包的定时器
@property (nonatomic, strong) NSTimer *timeoutTimer;//判断是否超时的定时器
@property (nonatomic, assign) NSInteger reconnectTimes;//重连次数
@property (nonatomic, assign) BOOL closedByUser;//是否手动关闭
@property (nonatomic, copy) dispatch_block_t closeCompletionBlock;
@property (nonatomic, assign) BOOL isConnecting;//是否正在连接


@end

@implementation SHWebSocketManager

- (void)dealloc {
    [self closeSocketWithCompletionBlock:nil];
    [self invalidateTimeoutTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

+ (instancetype)sharedManager {
    static SHWebSocketManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        MJWeakSelf
        _apiDictionary = @{}.mutableCopy;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [RACObserve(SHReachabilityManager.shared, netStatus) subscribeNext:^(id  _Nullable x) {
            if ([x boolValue] && weakSelf.socket.readyState != SR_OPEN && !weakSelf.isConnecting) {
                weakSelf.reconnectTimes = 0;
                [weakSelf reconnect];
            }
        }];
    }
    return self;
}

- (void)openSocket {
    if (self.socket.readyState == SR_OPEN || self.isConnecting) return;
    
    self.isConnecting = YES;
    self.closedByUser = NO;
    self.socket = nil;

    self.socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:SOCKETURL]];
    
    self.socket.delegate = self;
    [self.socket open];
}

- (void)closeSocketWithCompletionBlock:(dispatch_block_t)completionBlock {
    self.closeCompletionBlock = completionBlock;
    [self.socket close];
    [self cancelSendHeartBeatData];
    self.closedByUser = YES;
}

- (void)querySubscribeDataWithApi:(SHSocketNetworkAPI *)api {
    [self sendDataWithApi:api];
}

- (void)queryDataWithApi:(SHSocketNetworkAPI *)api {
    [self sendDataWithApi:api];
}

- (void)subscribeDataWithApi:(SHSocketNetworkAPI *)api {
    [self sendDataWithApi:api];
}

- (void)unsubscribeDataWithApi:(SHSocketNetworkAPI *)api {
    [self sendDataWithApi:api];
}

- (void)reconnect {
    //最多重试7次，每次间隔时间为指数级增长
    if (self.reconnectTimes > 256 || self.isConnecting || self.socket.readyState == SR_OPEN) {
        return;
    }
    if (self.reconnectTimes == 0) {
        self.reconnectTimes = 2;
    }
    else {
        self.reconnectTimes *= 2;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reconnectTimes * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openSocket];
    });
}

- (void)sendPing {
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendString:[@{@"ws_type":@"ping"} modelToJSONString] error:nil];
    }
}

- (void)sendDataWithApi:(SHSocketNetworkAPI *)api {
    if (self.socket.readyState == SR_OPEN) {
        if ([NSJSONSerialization isValidJSONObject:api.sendPara]) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:api.sendPara options:NSJSONWritingPrettyPrinted error:NULL];
            NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self.socket sendString:dataString error:nil];
            if (api.identifier) {
                if (api.handleType == SocketQuerySubscribeType) {
                    [self.apiDictionary setObject:api forKey:api.identifier];
                } else {
                    [self.apiDictionary removeObjectForKey:api.identifier];
                }
            }
        }
    } else {
        NSDictionary *response = [NSDictionary dictionary];
        if (api.delegate && [api.delegate respondsToSelector:@selector(socketDidRecievedResponse:)]) {
            [api.delegate socketDidRecievedResponse:response];
        }
        if (api.completionBlock) {
            api.completionBlock(response);
        }
    }
}

- (void)startSendHeartBeatData {
    [self cancelSendHeartBeatData];
    __weak typeof(self) weakself = self;
    _heartTimer =[NSTimer scheduledTimerWithTimeInterval:30 block:^(NSTimer * _Nonnull timer) {
        [weakself sendPing];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_heartTimer forMode:NSRunLoopCommonModes];
}

- (void)cancelSendHeartBeatData {
    [_heartTimer invalidate];
    _heartTimer = nil;
}

- (void)invalidateTimeoutTimer {
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
}

- (void)handleApplicationDidBecomeActive:(NSNotification *)notification {
    if (self.socket.readyState != SR_OPEN && !self.isConnecting) {
        self.reconnectTimes = 0;
        [self reconnect];
    }
}

- (void)handleApplicationDidEnterBackground:(NSNotification *)notification {
//    [self closeSocketWithCompletionBlock:nil];
}

#pragma mark SRWebSocketDelegates
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    if (self.isOpen) return;
    NSLog(@"连接成功");
    self.isOpen = YES;
    self.isConnecting = NO;
    self.reconnectTimes = 0;
    [self startSendHeartBeatData];
//    for (SHSocketNetworkAPI *api in self.apiDictionary.allValues) {
//        [self sendDataWithApi:api];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidOpenNotification object:nil];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSString *pongString = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:pongPayload options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"接收到pong数据 -- %@ -- %@",pongString,dict);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"断开连接 == %@",error);
    self.isOpen = NO;
    self.isConnecting = NO;
    [self cancelSendHeartBeatData];
    [self reconnect];
}
#pragma mark -- 接收到数据
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSString *dataString = [NSString stringWithFormat:@"%@",message];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    NSLog(@"接收到数据 -- %@",dictionary);
    [self.apiDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SHSocketNetworkAPI * _Nonnull api, BOOL * _Nonnull stop) {
        if (api.delegate && [api.delegate respondsToSelector:@selector(socketDidRecievedResponse:)]) {
            [api.delegate socketDidRecievedResponse:dictionary];
        }
        if (api.completionBlock) {
            api.completionBlock(dictionary);
        }
    }];
}
   
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self.apiDictionary removeAllObjects];
    self.isOpen = NO;
    self.isConnecting = NO;
    [self reconnect];
}

- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket {
    return YES;
}


@end
