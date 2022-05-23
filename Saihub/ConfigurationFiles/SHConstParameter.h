//
//  ConstParameter.h
//  TokenONE
//
//  Created by 1 on 2018/11/2.
//  Copyright © 2018 9linktech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHConstParameter : NSObject

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat netHeight;
@property (nonatomic, assign) CGFloat statusBarHeight;
@property (nonatomic, assign) CGFloat safeAreaBottomHeight;
@property (nonatomic, assign) CGFloat naviBarHeight;
@property (nonatomic, assign) CGFloat fitSize;
@property (nonatomic, assign) CGFloat fitVertical;

///是否是全面屏
@property (nonatomic,assign) BOOL isFullScreen;

@property (nonatomic, copy) NSString * app_name;
@property (nonatomic, copy) NSString * app_version;
@property (nonatomic, copy) NSString * uuid;
@property (nonatomic, copy) NSString * api_key;
@property (nonatomic, copy) NSString * dinfo;

+ (SHConstParameter *)shareIntance;

+ (NSString *)getCurrentDeviceModel;

@end

NS_ASSUME_NONNULL_END
