//
//  SHPushManager.m
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import "SHPushManager.h"
#import <UserNotifications/UserNotifications.h>
#import "SHFileManage.h"
#import "SHAgreeMentFirsViewController.h"
#import "SHKeyStorage.h"
#import "SHTransactionRecordTotalController.h"
#import "SHTransactionRecordController.h"
#import "SHAddWalletController.h"

@interface SHPushManager () <JPUSHRegisterDelegate>

@end

@implementation SHPushManager

singleton_implementation(SHPushManager)

- (void)SHSetupPushSDKWith:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionSound | JPAuthorizationOptionBadge;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    BOOL isProduction = NO;
    if (JR_IS_PUBLISH == 3) { //正式环境
        isProduction = YES;
    }
    [JPUSHService setDebugMode]; //在 application 里面调用，设置开启 JPush 日志

    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:isProduction ? @"App Store" : @"dev"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];

    [JPUSHService setBadge:0];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // 点击推送进入应用
    if ([launchOptions.allKeys containsObject:@"UIApplicationLaunchOptionsLocalNotificationKey"]) { // 推送
        UILocalNotification *localNotification = launchOptions[@"UIApplicationLaunchOptionsLocalNotificationKey"];
        if (localNotification.userInfo) {
            SHPushListModel *pushModel = [SHPushListModel modelWithJSON:localNotification.userInfo];
            if (pushModel != nil) {
                [SHFileManage saveArchiveObject:pushModel byFileName:kLocalPushModelKey];
            }
        }
    }
}

#pragma mark-- JPUSHRegisterDelegate 极光推送代理
///前台推送 如果后台推送设置了content-available ,应用处于前台,此代理方法会和BLSlientPushWithApplication同时接收消息,
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler {
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//点击推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;

    [self clickPushToDetailVcWithUserInfo:userInfo];

    [JPUSHService handleRemoteNotification:userInfo];
}

// 静默推送
- (void)SHSlientPushWithApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //刷新数据
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)SHPushRegistDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)SHApplicationWillEnterForeground:(UIApplication *)application
{
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)SHApplicationDidEnterBackground:(UIApplication *)application
{
}

#pragma mark-- 应用内点击推送跳转详情
- (void)clickPushToDetailVcWithUserInfo:(NSDictionary *)userInfo
{
    SHPushListModel *pushListModel = [SHPushListModel modelWithJSON:userInfo];

    // 0. 判断当前页是否指纹 faceid验证页面
    BOOL isAuthVc = [[CTMediator sharedInstance] containController:SHAgreeMentFirsViewController.class];
    if (isAuthVc) {
        [SHFileManage saveArchiveObject:pushListModel byFileName:kLocalPushModelKey];
        return;
    }

    NSString *address;
    if (pushListModel.type == 2) {
        address = pushListModel.fromAddress;
    } else {
        address = pushListModel.toAddress;
    }

    // 1.转出判断fromAddress  转入判断toAddress,找到这个地址的钱包 , 切换钱包
    
    SHWalletModel *walletModel ;
    
    if ([[SHKeyStorage shared].currentWalletModel.subAddressStr containsString:address]) { // 判断是否是当前钱包
        walletModel = [SHKeyStorage shared].currentWalletModel;
    } else {
        for (NSInteger index = 0; index < [SHWalletModel allObjects].count; index ++) {
            SHWalletModel *objModel = [[SHWalletModel allObjects] objectAtIndex:index];
            
            if ([objModel.subAddressStr containsString:address]) {
                walletModel = objModel;

                if (objModel.importType == SHWalletImportTypeMnemonic || objModel.importType == SHWalletImportTypePrivateKey) {
                    continue;
                }
            }
        }
    }

    // 没有该钱包不做操作
    if (walletModel == nil) {
        return;
    }
    
    [SHKeyStorage shared].currentWalletModel = walletModel;

    SHWalletTokenModel *tokenModel = walletModel.tokenList.firstObject;
    if ([pushListModel.coin isEqualToString:@"USDT"]) {
        tokenModel = walletModel.tokenList.lastObject;
    }
    
    // 2.判断当前栈中是否有交易记录控制器,没有 -> 交易记录, 有 -> 刷新数据
    BOOL isContian = [[CTMediator sharedInstance] containController:SHTransactionRecordTotalController.class];
    UIViewController *currentVc = [CTMediator sharedInstance].topViewController;
    if (isContian == NO) {
        // 判断当前控制器是否是push出来的,不是的话要dismiss
        UIViewController *topVc = [CTMediator sharedInstance].topViewController;
        
        if (topVc.isPanModalPresented == YES || topVc.navigationController.viewControllers.count == 0 || [topVc isKindOfClass:[SHAddWalletController class]]) {
            [topVc dismissViewControllerAnimated:YES completion:^{
                SHTransactionRecordTotalController *recordVc = [[SHTransactionRecordTotalController alloc] init];
                recordVc.tokenModel = tokenModel;
                [[CTMediator sharedInstance].topViewController.navigationController pushViewController:recordVc animated:YES];
            }];
            
            return;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SHTransactionRecordTotalController *recordVc = [[SHTransactionRecordTotalController alloc] init];
            recordVc.tokenModel = tokenModel;
            [currentVc.navigationController pushViewController:recordVc animated:YES];
        });

    } else {
        
        
        if (![currentVc isKindOfClass:[SHTransactionRecordTotalController class]]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [currentVc.navigationController popViewControllerAnimated:YES];
            });
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kClickPushNoticeKey object:tokenModel];
        });
    }
}

#pragma mark-- 点击推送进入应用后跳转
- (void)clickPushAssetRecordVcWithPushModel:(SHPushListModel *)pushListModel
{
    NSString *address;
    if (pushListModel.type == 2) {
        address = pushListModel.fromAddress;
    } else {
        address = pushListModel.toAddress;
    }

    // 1.转出判断fromAddress  转入判断toAddress,找到这个地址的钱包, 然后 切换钱包
    
//    SHWalletModel *walletModel = [[SHWalletModel allObjects] objectsWhere:[NSString stringWithFormat:@"address CONTAINS[c] '%@' AND walletType = %zd", address, pushListModel.walletType]].firstObject;
//    // 没有该钱包不做操作
//    if (walletModel == nil) {
//        return;
//    }
//    [SHKeyStorage shared].currentWalletModel = walletModel;
//
//    // 2.找到对应的tokenModel
//    SHWalletTokenModel *tokenModel;
//    // 主链币
//    if (pushListModel.contractAddress.length == 0) {
//        tokenModel = [SHKeyStorage shared].currentWalletModel.tokenList.firstObject;
//    } else {
//        // 代币 找到该代币合约地址在tokenList中对应的tokenModel
//        RLMResults *result = [[BLKeyStorage shared].currentWalletModel.tokenList objectsWhere:[NSString stringWithFormat:@"contractAddr CONTAINS[c] '%@'", [NSString stringWithFormat:@"%@", pushListModel.contractAddress]]];
//        if (result.count == 0) {
//            return;
//        }
//        tokenModel = result.firstObject;
//    }

//    BLAssetRecordViewController *assetRecordVc = [[BLAssetRecordViewController alloc] init];
//    assetRecordVc.tokenModel = tokenModel;
//    [[CTMediator sharedInstance].topViewController.navigationController pushViewController:assetRecordVc animated:YES];
}

- (void)SHAddLocalNotificationPushWithTitle:(NSString *)title content:(NSString *)content model:(SHPushListModel *)pushModel
{
    JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
    request.requestIdentifier = [NSString stringWithFormat:@"%zd%@", [NSString getNowTimeTimestamp], title];
    //触发方法
    JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
    trigger.timeInterval = [[NSDate dateWithTimeIntervalSinceNow:1] timeIntervalSinceNow];
    JPushNotificationContent *pushContent = [[JPushNotificationContent alloc] init];
    pushContent.title = title;
    pushContent.body = content;
    pushContent.userInfo = [pushModel modelToJSONObject];
    request.trigger = trigger;
    request.content = pushContent;
    request.completionHandler = ^(id result) {
    };
    [JPUSHService addNotification:request];
}


@end
