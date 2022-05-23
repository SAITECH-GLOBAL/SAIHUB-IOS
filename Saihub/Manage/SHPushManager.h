//
//  SHPushManager.h
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"
#import "SHPushListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHPushManager : NSObject

singleton_interface(SHPushManager)

///初始化sdk
- (void)SHSetupPushSDKWith:(NSDictionary *)launchOptions;

///后台推送
- (void)SHSlientPushWithApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

///注册token
- (void)SHPushRegistDeviceToken:(NSData *)deviceToken;

//进入前台
- (void)SHApplicationWillEnterForeground:(UIApplication *)application;

///进入后台
- (void)SHApplicationDidEnterBackground:(UIApplication *)application;

///添加本地推送
- (void)SHAddLocalNotificationPushWithTitle:(NSString *)title content:(NSString *)content model:(SHPushListModel *)pushModel;

@end

NS_ASSUME_NONNULL_END
