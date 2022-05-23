//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showMessag:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showInLoad:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showNewMessag:(NSString *)message toView:(UIView *)view;


+ (void)hideLoadingWithView:(UIView *)view;

+ (void)showLoadingWithView:(UIView *)view;

+ (void)hideCustormLoadingWithView:(UIView *)view;

+ (MBProgressHUD *)showCustormLoadingWithView:(UIView *)view withLabelText:(NSString *)labelText;
@end
