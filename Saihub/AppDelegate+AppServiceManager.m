//
//  AppDelegate+AppServiceManager.m
//  EducationForTeacher
//
//  Created by 周松 on 2020/7/9.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "AppDelegate+AppServiceManager.h"
#import "SHPushManager.h"
#import <IQKeyboardManager.h>
#import "SHReachabilityManager.h"
#import "SHFileManage.h"


@interface AppDelegate ()

@end

@implementation AppDelegate (AppServiceManager)

///主程序入口
- (void)categoryApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册管理类
    [[SHPushManager sharedSHPushManager]SHSetupPushSDKWith:launchOptions];
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = GCLocalizedString(@"iqkeyboard_done");
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //网络监听
    [[SHReachabilityManager shared] startNotifier];
    
    //如果是从点击推送进入的应用
    if ([launchOptions.allKeys containsObject:@"UIApplicationLaunchOptionsLocalNotificationKey"]) { //本地推送
        [SHFileManage savePreferencesData:@"1" forKey:kClickPushSaveKey];
    } else {
        [SHFileManage removePreferencesDataForkey:kClickPushSaveKey];
    }
    
    [self configRealm];
}

#pragma mark -- 1.0 数据库迁移配置 当数据结构发生改变需要执行 测试阶段不用调用
- (void)configRealm {
    
}

//后台静默推送
- (void)categoryApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[SHPushManager sharedSHPushManager]SHSlientPushWithApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

///进入前台
- (void)categoryApplicationWillEnterForeground:(UIApplication *)application {
    [[SHPushManager sharedSHPushManager]SHApplicationWillEnterForeground:application];
}

//进入后台
- (void)categoryApplicationDidEnterBackground:(UIApplication *)application {
    [[SHPushManager sharedSHPushManager] SHApplicationDidEnterBackground:application];
}

- (void)categoryApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[SHPushManager sharedSHPushManager]SHPushRegistDeviceToken:deviceToken];
}


@end
