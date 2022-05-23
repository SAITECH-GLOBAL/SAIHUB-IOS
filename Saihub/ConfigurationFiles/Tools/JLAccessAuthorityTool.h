//
//  JLAccessAuthorityTool.h
//  AiDouVideo
//
//  Created by 周松 on 2019/8/25.
//  Copyright © 2019 zhaohong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SucessedBlock)(BOOL isSuccess);

//访问权限工具类
@interface JLAccessAuthorityTool : NSObject
/**
 *  授权相机
 */
+(BOOL)videoAuthAction;

/**
 *  授权麦克风
 */
+(BOOL)audioAuthAction;
/**
 *  麦克风权限
 */

+(BOOL) checkAudioStatus;
/**
 *  相机权限
 */

+(BOOL) checkVideoStatus;
/**
 *  是否开启了相机权限
 *
 *  @return bool
 */
+ (BOOL)isOpenCameraAuthority;

/**
 *  是否开启了相册权限
 *
 *  @return bool
 */
+ (BOOL)isOpenAlbumAuthority;
/**
 *  是否开启了定位权限
 *
 *  @return bool
 */
+ (BOOL)isOpenLocationAuthority;

+(void)requestAuthorizationAddressBookWithBlock:(SucessedBlock)sucessedBlock;


+(BOOL)isOpenMicoAuthority;

/**
 *  提示打开权限
 */
+ (void)alertHint:(NSString *)hint;
@end

NS_ASSUME_NONNULL_END
