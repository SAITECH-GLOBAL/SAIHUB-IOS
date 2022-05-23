//
//  JLQRCodeTool.m
//  AiDouVideo
//
//  Created by 周松 on 2019/8/26.
//  Copyright © 2019 zhaohong. All rights reserved.
//

#import "JLQRCodeTool.h"

@implementation JLQRCodeTool

+ (UIImage *)qrcodeImageWithInfo:(NSString *)info withSize:(CGFloat)size {
    if (size <= 0) {
        size = 200;
    }
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认设置
    [filter setDefaults];
    // 3. 给过滤器添加数据
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    return [JLQRCodeTool createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
}
/// 转成高清图片
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


+ (UIImage *)createImgQRCodeWithString:(NSString *)QRString centerImage:(UIImage *)centerImage size:(CGFloat)size {
    // 创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 将字符串转换成 NSdata
    NSData *dataString = [QRString dataUsingEncoding:NSUTF8StringEncoding];
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:dataString forKey:@"inputMessage"];
    
    // 获得滤镜输出的图像
    
    CIImage *outImage = [filter outputImage];

    // 图片小于(27,27),我们需要放大
    outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(27, 27)];
    
    // 将CIImage类型转成UIImage类型
    UIImage *startImage = [UIImage imageWithCIImage:outImage];
    // 开启绘图, 获取图形上下文
    UIGraphicsBeginImageContext(startImage.size);
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [startImage drawInRect:CGRectMake(0, 0, startImage.size.width, startImage.size.height)];
    // 再把小图片画上去
    CGFloat icon_imageW = 200;

    CGFloat icon_imageH = icon_imageW;

    CGFloat icon_imageX = (startImage.size.width - icon_imageW) * 0.5;

    CGFloat icon_imageY = (startImage.size.height - icon_imageH) * 0.5;

    [centerImage drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    // 获取当前画得的这张图片
    UIImage *qrImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    //返回二维码图像
    return qrImage;
}

@end
