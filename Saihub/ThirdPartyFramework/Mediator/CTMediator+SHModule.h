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
@end

NS_ASSUME_NONNULL_END
