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
 *  授权麦克风
 */
+(BOOL)audioAuthAction;
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


+(BOOL)isOpenMicoAuthority;

/**
 *  提示打开权限
 */
+ (void)alertHint:(NSString *)hint;
@end

NS_ASSUME_NONNULL_END
