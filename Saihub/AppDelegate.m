//
//  AppDelegate.m
//  Saihub
//
//  Created by 周松 on 2022/2/15.
//

#import "AppDelegate.h"
#import "SHTabBarController.h"
#import "SHKeyStorage.h"
#import "BTPeerManager.h"
#import "SHAgreeMentFirsViewController.h"
#import "SHFaceOrTouchCheckViewController.h"
#import "SHPassWordCheckViewController.h"
#import "SHFileManage.h"
#import "AppDelegate+AppServiceManager.h"
#import "MJRefreshConfig.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    MJRefreshConfig.defaultConfig.languageCode = KAppSetting.lang;
    [self categoryApplication:application didFinishLaunchingWithOptions:launchOptions];
    sleep(1);
    [[BTPeerManager instance] initAddress];
    self.window = [[UIWindow alloc]initWithFrame:kSCREEN];
    self.window.backgroundColor = [UIColor whiteColor];
    if (!IsEmpty(KAppSetting.isOpenFaceID)){
        SHFaceOrTouchCheckViewController *mianVc = [[SHFaceOrTouchCheckViewController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mianVc];
        self.window.rootViewController = navi;
        [self.window makeKeyAndVisible];
    }else if (!IsEmpty(KAppSetting.unlockedPassWord)){
        SHPassWordCheckViewController *mianVc = [[SHPassWordCheckViewController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mianVc];
        self.window.rootViewController = navi;
        [self.window makeKeyAndVisible];
    }else {
        if (IsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:FirstCreaatOrImportWalletKey])) {
            SHAgreeMentFirsViewController *mianVc = [[SHAgreeMentFirsViewController alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mianVc];
            self.window.rootViewController = navi;
            [self.window makeKeyAndVisible];
        }else
        {
            SHTabBarController *tabbarVc = [[SHTabBarController alloc]init];
            self.window.rootViewController = tabbarVc;
            [self.window makeKeyAndVisible];
        }
    }
    [[SHKeyStorage shared] initializeData];
    
    [self requestRate];
        
    return YES;
}

#pragma mark -- 获取汇率
- (void)requestRate {
    [[NetWorkTool shareNetworkTool] requestHttpWithPath:@"/rest/asset/rate" withMethodType:Get withParams:@{} result:^(SHBaseResponseModel * _Nullable responseModel, NSInteger code, NSString *message) {
        if (responseModel.data.status == 0) {
            NSDictionary *result = responseModel.data.result;
            if ([result[@"btcCny"] doubleValue] != 0) {
                [SHFileManage savePreferencesData:responseModel.data.result forKey:kRateDictKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:RateChangePushNoticeKey object:nil];
            }
        }
    }];
    
    [self performSelector:@selector(requestRate) afterDelay:60];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self categoryApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self categoryApplicationWillEnterForeground:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self categoryApplicationDidEnterBackground:application];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self categoryApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}


@end
