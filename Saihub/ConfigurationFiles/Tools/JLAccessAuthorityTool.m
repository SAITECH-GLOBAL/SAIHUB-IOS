//
//  JLAccessAuthorityTool.m
//  AiDouVideo
//
//  Created by 周松 on 2019/8/25.
//  Copyright © 2019 zhaohong. All rights reserved.
//

#import "JLAccessAuthorityTool.h"
#import <Photos/Photos.h>
#import <CoreLocation/CLLocationManager.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

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

//授权麦克风
+(BOOL)audioAuthAction {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        
    }];
    
    if ([JLAccessAuthorityTool checkAudioStatus]) {
        return YES;
    } else {
        return NO;
    }
}

//检查麦克风权限
+(BOOL) checkAudioStatus{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风
            return NO;
            break;
        case AVAuthorizationStatusRestricted:
            return NO;
            break;
        case AVAuthorizationStatusDenied:
            //玩家未授权
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

//检查麦克风权限
+ (BOOL) isOpenMicoAuthority{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风

             [JLAccessAuthorityTool alertHint:[NSString stringWithFormat:@"请打开系统设置中\"隐私➝麦克风\"，允许\"%@\"使用您的麦克风。",App_name]];
            return YES;
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
             [JLAccessAuthorityTool alertHint:[NSString stringWithFormat:@"请打开系统设置中\"隐私➝麦克风\"，允许\"%@\"使用您的麦克风。",App_name]];
            return NO;
            break;
        case AVAuthorizationStatusDenied:
             [JLAccessAuthorityTool alertHint:[NSString stringWithFormat:@"请打开系统设置中\"隐私➝麦克风\"，允许\"%@\"使用您的麦克风。",App_name]];
            //玩家未授权
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
 *  是否开启了定位权限
 *  @return bool
 */
+ (BOOL)isOpenLocationAuthority{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        return YES;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        //弹出提示
        [JLAccessAuthorityTool alertHint:[NSString stringWithFormat:@"请打开系统设置中\"隐私➝定位服务\"，允许\"%@\"使用您的位置。",App_name]];
        return NO;
    }
    return YES;
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

+(void)requestAuthorizationAddressBookWithBlock:(SucessedBlock)sucessedBlock
{
    // 判断是否授权
    if(@available (iOS 9.0, *)){
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
            sucessedBlock(YES);
            return;//授权成功直接返回
        }

        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusDenied) {
            [JLAccessAuthorityTool alertHint:[NSString stringWithFormat:@"请打开系统设置中\"隐私➝通讯录\"，允许\"%@\"访问您的通讯录。",App_name]];
        }
        CNContactStore *store = [[CNContactStore alloc] init];
        
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) { // 授权成功
                NSLog(@"授权成功");
                sucessedBlock(YES);
            } else {  // 授权失败
                sucessedBlock(NO);
            }
        }];
    }
}

@end
