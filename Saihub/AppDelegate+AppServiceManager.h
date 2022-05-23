//
//  AppDelegate+AppServiceManager.h
//  EducationForTeacher
//
//  Created by 周松 on 2020/7/9.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN
///将第三方配置从AppDelegate中剥离出来,因为以后会用到很多SDk
@interface AppDelegate (AppServiceManager)

///主程序入口
- (void)categoryApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

///后台接收到推送消息
- (void)categoryApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

///进入前台
- (void)categoryApplicationWillEnterForeground:(UIApplication *)application;

///进入后台
- (void)categoryApplicationDidEnterBackground:(UIApplication *)application;

//注册deviceToken
- (void)categoryApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

@end

NS_ASSUME_NONNULL_END
