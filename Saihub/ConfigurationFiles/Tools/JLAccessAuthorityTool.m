//
//  JLAccessAuthorityTool.m
//  AiDouVideo
//
//  Created by 周松 on 2019/8/25.
//  Copyright © 2019 zhaohong. All rights reserved.
//

#import "JLAccessAuthorityTool.h"
#import <Photos/Photos.h>

@interface JLAccessAuthorityTool ()
/**
 *  状态
 */
@property (nonatomic, assign) NSString* audioStatus;
@property (nonatomic, assign) NSString* videoStatus;
@property (nonatomic, assign) NSString* photoLibraryStatus;
@end

@implementation JLAccessAuthorityTool

//授权相机
+(BOOL)videoAuthAction {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
    }];
    
    if ([JLAccessAuthorityTool checkVideoStatus]) {
        return YES;
    } else {
        return NO;
    }
}


+(BOOL) checkVideoStatus{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启相机
            return NO;
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            return NO;
            break;
        case AVAuthorizationStatusDenied:
            //未授权
            return NO;
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
            return YES;
            break;
        default:
            break;
    }
}

/**
 *  是否开启了相机权限
 *
 *  @return bool
 */
+ (BOOL)isOpenCameraAuthority{
    
    if([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined){
        return YES;
    }
    
    if( [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized){
        return YES;
    }else{
        [JLAccessAuthorityTool alertHint:[NSString stringWithFormat:@"请打开系统设置中\"隐私➝相机-照片\"，允许\"%@\"使用您的相机和照片。",App_name]];
    }
    return NO;
}


/**
 *  是否开启了相册权限
 *
 *  @return bool
 */
+ (BOOL)isOpenAlbumAuthority{
    
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
        return YES;
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined){//用户还没有设置权限,先提示
        return YES;
    } else {
        [JLAccessAuthorityTool alertHint:[NSString stringWithFormat:@"请打开系统设置中\"隐私➝照片\"，允许\"%@\"使用您的照片。",App_name]];
        return NO;
    }
}


/**
 *  提示打开权限
 */
+ (void)alertHint:(NSString *)hint{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:hint preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (@available (iOS 10.0, *)) {
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL  success) {

                }];
            }
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[CTMediator sharedInstance].topViewController.navigationController popViewControllerAnimated:YES];
    }];
    [alertVc addAction:sureAction];
    [alertVc addAction:cancelAction];
    [KeyWindow.rootViewController presentViewController:alertVc animated:YES completion:nil];
}


@end
