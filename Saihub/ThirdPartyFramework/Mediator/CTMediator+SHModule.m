//
//  CTMediator+SHModule.m
//  EducationForTeacher
//
//  Created by 周松 on 2020/7/8.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "CTMediator+SHModule.h"
#import "SHNavigationController.h"
#import "SHTabBarController.h"


@implementation CTMediator (SHModule)


///获取最上层控制器
- (UIViewController *)topViewController {
    UIWindow *window;
    if (@available(iOS 13.0,*)) {
        window = [UIApplication sharedApplication].windows[0];
    } else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    UIViewController *topVC = window.rootViewController;

    UIViewController *tempVC = topVC;
    while (1) {
        if ([topVC isKindOfClass:[UITabBarController class]]) {
            topVC = ((UITabBarController*)topVC).selectedViewController;
        }
        if ([topVC isKindOfClass:[UINavigationController class]]) {
            topVC = ((UINavigationController*)topVC).visibleViewController;
        }
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        //如果两者一样，说明循环结束了
        if ([tempVC isEqual:topVC]) {
            break;
        } else {
        //如果两者不一样，继续循环
            tempVC = topVC;
        }
    }
    return topVC;

}

- (UIViewController *)topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (BOOL)containController:(Class )controllerClass {
    UIWindow *window;
    if (@available(iOS 13.0,*)) {
        window = [UIApplication sharedApplication].windows[0];
    } else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    UIViewController *rootVc = window.rootViewController;
    
    BOOL isContain = NO;
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        rootVc = (UINavigationController *)rootVc;
        for (UIViewController *vc in rootVc.childViewControllers) {
            if ([vc isKindOfClass:controllerClass]) {
                isContain = YES;
            }
        }
    } else if ([rootVc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nav = [(UITabBarController *)rootVc selectedViewController];
        for (UIViewController *vc in nav.viewControllers) {
            if ([vc isKindOfClass:controllerClass]) {
                isContain = YES;
            }
        }
    }  else { // 其他情况 走NO
        isContain = NO;
    }
    return isContain;
}

@end
