//
//  CTMediator+SHModule.h
//  EducationForTeacher
//
//  Created by 周松 on 2020/7/8.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (SHModule)

//获取顶层控制器
- (UIViewController *)topViewController;

/// 判断栈中是否包含该控制器
- (BOOL)containController:(Class )controllerClass;

/// 切换到本地钱包
/// @param currentVc 当前控制器
- (void)mediator_changeHDWalletController:(UIViewController *)currentVc;


/// 切换到LN钱包
/// @param currentVc 当前控制器
- (void)mediator_changeCloudWalletController:(UIViewController *)currentVc;
@end

NS_ASSUME_NONNULL_END
