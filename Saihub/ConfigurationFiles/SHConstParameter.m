//
//  ConstParameter.m
//  TokenONE
//
//  Created by 1 on 2018/11/2.
//  Copyright © 2018 9linktech. All rights reserved.
//


#import "SHConstParameter.h"
#import "SHGetUUID.h"
#import <sys/utsname.h>//要导入头文件

static SHConstParameter *__constaParameter;

@implementation SHConstParameter

+ (SHConstParameter *)shareIntance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __constaParameter = [[SHConstParameter alloc] init];
    });
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;;

    CGFloat naviBarHeight = 44.0f;
   
    __constaParameter.naviBarHeight = naviBarHeight;
    if (IS_PAD) {
        __constaParameter.fitSize = screenWidth / 768.0f * 1.3;
    } else {
        __constaParameter.fitSize = screenWidth / 375.0f;
    }
    
    if (screenHeight == 896 || screenHeight == 844 || screenHeight == 926 || screenHeight == 780) {
        __constaParameter.statusBarHeight = 44.0f;
        __constaParameter.width = screenWidth/375.0;
        __constaParameter.height = screenHeight / 667.0f;
        __constaParameter.safeAreaBottomHeight = 34.0f;
        __constaParameter.netHeight = screenHeight - __constaParameter.statusBarHeight - 34.0f -naviBarHeight;
        __constaParameter.isFullScreen = YES;
    } else if (screenHeight == 812) {
        __constaParameter.width = screenWidth / 375.0f;
        __constaParameter.height = screenHeight / 667.0f;
        __constaParameter.safeAreaBottomHeight = 34.0f;
        __constaParameter.netHeight = [[UIScreen mainScreen] bounds].size.height - __constaParameter.statusBarHeight - 34.0f - naviBarHeight;
        __constaParameter.statusBarHeight = 44.0f;
        __constaParameter.isFullScreen = YES;
    } else {
        if (IS_PAD) {
            __constaParameter.safeAreaBottomHeight = 0.0f;
            __constaParameter.width = screenWidth / 768.0f * 1.3;
            __constaParameter.height = screenHeight / 1024.0f;
            __constaParameter.netHeight = screenHeight - 20.0f - naviBarHeight;
            __constaParameter.statusBarHeight = 20.0;
        } else {
            __constaParameter.safeAreaBottomHeight = 0.0f;
            __constaParameter.width = screenWidth / 375.0f;
            __constaParameter.height = screenHeight / 667.0f;
            __constaParameter.netHeight = screenHeight - 20.0f - naviBarHeight;
            __constaParameter.statusBarHeight = 20.0;
        }
    }
    
    if (__constaParameter.app_name.length == 0) {
        __constaParameter.app_name = @"bourse_ios_app";
    }
    if (__constaParameter.api_key.length == 0) {
        __constaParameter.api_key = API_KEY;
    }
    if (__constaParameter.app_version.length == 0) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        __constaParameter.app_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    
    if (__constaParameter.uuid.length == 0) {
        __constaParameter.uuid = [NSString stringWithFormat:@"%@",[SHGetUUID getUUID]];
    }
    
    if (__constaParameter.dinfo.length == 0) {
        __constaParameter.dinfo = [NSString stringWithFormat:@"%@:%@:%@",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    }

    return __constaParameter;
}


@end
