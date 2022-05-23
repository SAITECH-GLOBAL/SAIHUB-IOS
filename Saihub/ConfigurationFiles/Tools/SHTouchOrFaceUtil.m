//
//  SHTouchOrFaceUtil.m
//  TokenOne
//
//  Created by macbook on 2020/10/27.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHTouchOrFaceUtil.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation SHTouchOrFaceUtil
+(void)selectTouchIdOrFaceIdWithSucessedBlock:(SucessedBlock)sucessedBlock WithSelectPassWordBlock:(SelectPassWordBlock)selectPassWordBlock WithErrorBlock:(ErrorBlock)errorBlock withBtn:(UIButton *)btn;
{
    if ([UIDevice currentDevice].systemVersion.floatValue<8.0) {
        NSLog(@"ios8.0以后才支持指纹识别");
        return;
    }
    //IOS11之后如果支持faceId也是走同样的逻辑，faceId和TouchId只能选一个
    LAContext *context = [[LAContext alloc] init];
    if (@available(iOS 11.0, *)) {
        if (context.biometryType == LABiometryTypeTouchID) {
            
        }else if (context.biometryType == LABiometryTypeFaceID){
            
        }
    } else {
        // Fallback on earlier versions
    }
    context.localizedFallbackTitle = @"";//不展示输入密码
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持 localizedReason为alert弹框的message内容
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:GCLocalizedString(@"Please_verify_fingerprint") reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    sucessedBlock(YES);
                }];
            } else {
                NSLog(@"验证失败:%@",error.description);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"系统取消授权，如其他APP切入");
                        //系统取消授权，如其他APP切入
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                            errorBlock(error);
                        }];
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        //用户取消验证Touch ID
                        NSLog(@"用户取消验证Touch ID");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                            errorBlock(error);
                        }];
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        //授权失败
                        NSLog(@"授权失败");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                            errorBlock(error);
                        }];
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        //系统未设置密码
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorBiometryNotAvailable:
                    {
                        //设备Touch ID不可用，例如未打开
                        NSLog(@"设备Touch ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorBiometryNotEnrolled:
                    {
                        //设备Touch ID不可用，用户未录入
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                           NSLog(@"用户选择输入密码，切换主线程处理");
                            selectPassWordBlock();
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                            NSLog(@"其他情况，切换主线程处理");
                            errorBlock(error);
                        }];
                        break;
                    }
                }
            }
        }];
    } else {
        NSLog(@"不支持指纹识别");
        NSLog(@"error : %@",error.localizedDescription);
        NSString *errorDescripString = error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{

            LAContext*myContext=[[LAContext alloc] init];

            NSError*error=nil;

            if([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
                if (@available(iOS 11.0, *)) {
                    if ([errorDescripString containsString:@"Biometry is locked out"]) {
                        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:GCLocalizedString(@"Please_verify_password") reply:^(BOOL success, NSError*_Nullable error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //成功操作
                                sleep(1);
                                if (!IsEmpty(btn)) {
                                    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                                }
                            });
                            
                        }];

                    }else
                    {
                        if (context.biometryType == LABiometryTypeTouchID) {
                            
                            [MBProgressHUD showNewMessag:GCLocalizedString(@"open_touchid_hint") toView:nil];

                        }else if (context.biometryType == LABiometryTypeFaceID){

                            [MBProgressHUD showNewMessag:GCLocalizedString(@"open_faceid_hint") toView:nil];
                        }
                    }

                } else {
                    
                    // Fallback on earlier versions
                    
                }


            }


        });
        
    }
}
+(void)GetTouchIdOrFaceIdTypeWithFaceIdTypeBlock:(FaceIdTypeBlock)faceIdTypeBlock WithTouchIdTypeBlock:(TouchIdTypeBlock)touchIdTypeBlock WithValidationBackBlock:(ValidationBackBlock)validationBackBlock
{
    if([UIDevice currentDevice].systemVersion.doubleValue >= 8.0){

        LAContext *context = [LAContext new];
        
        if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]){
            if (@available(iOS 11.0, *)) {
                
                if (context.biometryType == LABiometryTypeTouchID) {
                    touchIdTypeBlock();
                }else if (context.biometryType == LABiometryTypeFaceID){
                    faceIdTypeBlock();
                }
                
            } else {
                
                // Fallback on earlier versions
                
            }
        }else {
            NSLog(@"不支持指纹识别");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                LAContext*myContext=[[LAContext alloc] init];
                
                NSError*error=nil;
                
                if([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
                    if (context.biometryType == LABiometryTypeTouchID) {
                        
                        [MBProgressHUD showNewMessag:GCLocalizedString(@"open_touchid_hint") toView:nil];

                    }else if (context.biometryType == LABiometryTypeFaceID){

                        [MBProgressHUD showNewMessag:GCLocalizedString(@"open_faceid_hint") toView:nil];
                    }
                }
                
            });
        }
    }
}
@end
