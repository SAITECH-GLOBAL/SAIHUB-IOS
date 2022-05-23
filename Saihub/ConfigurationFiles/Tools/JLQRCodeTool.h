//
//  JLQRCodeTool.h
//  AiDouVideo
//
//  Created by 周松 on 2019/8/26.
//  Copyright © 2019 zhaohong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLQRCodeTool : NSObject
/// 传入二维码需要包含的信息，返回一个二维码图片
+ (UIImage *)qrcodeImageWithInfo:(NSString * __nonnull)info withSize:(CGFloat)size ;

//生成二维码 (中间带图标的)
+ (UIImage *)createImgQRCodeWithString:(NSString *)QRString centerImage:(UIImage *)centerImage size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
