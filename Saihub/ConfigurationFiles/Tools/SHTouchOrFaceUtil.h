//
//  SHTouchOrFaceUtil.h
//  TokenOne
//
//  Created by macbook on 2020/10/27.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SucessedBlock)(BOOL isSuccess);
typedef void(^SelectPassWordBlock)(void);
typedef void(^ErrorBlock)(NSError *error);
typedef void(^FaceIdTypeBlock)(void);
typedef void(^TouchIdTypeBlock)(void);
typedef void(^ValidationBackBlock)(void);


@interface SHTouchOrFaceUtil : NSObject
+(void)selectTouchIdOrFaceIdWithSucessedBlock:(SucessedBlock)sucessedBlock WithSelectPassWordBlock:(SelectPassWordBlock)selectPassWordBlock WithErrorBlock:(ErrorBlock)errorBlock withBtn:(UIButton *)btn;
+(void)GetTouchIdOrFaceIdTypeWithFaceIdTypeBlock:(FaceIdTypeBlock)faceIdTypeBlock WithTouchIdTypeBlock:(TouchIdTypeBlock)touchIdTypeBlock WithValidationBackBlock:(ValidationBackBlock)validationBackBlock;

@end

NS_ASSUME_NONNULL_END
