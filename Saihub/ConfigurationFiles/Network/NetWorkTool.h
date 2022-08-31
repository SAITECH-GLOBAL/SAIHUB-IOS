//
//  NetWorkTool.h
//  TheHouseKeeper
//
//  Created by 王好帅 on 2017/1/16.
//  Copyright © 2017年 SYHL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^ResponseResultBlock)(SHBaseResponseModel *__nullable responseModel, NSInteger code, NSString *message);
typedef void(^ResultBlock)(id  _Nullable responseObject, NSInteger code, NSString *message);


typedef NS_ENUM(NSUInteger, NetworkMethod) {
    Get = 0,
    Post,
    FormData
};

@interface NetWorkTool : NSObject

///网络请求单例
+ (instancetype)shareNetworkTool;

/// baseUrl网络请求
/// @param path 路径
/// @param method 方式
/// @param params 参数

- (NSURLSessionDataTask *)requestBaseUrlHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(NSDictionary*)params result:(ResponseResultBlock)block;
/// baseUrlFor检查授权网络请求
/// @param path 路径
/// @param method 方式
/// @param params 参数

- (NSURLSessionDataTask *)requestBaseUrlForCheckContractHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(NSDictionary*)params result:(ResultBlock)block;

/// baseUrlFor检查授权网络请求
/// @param path 路径
/// @param method 方式
/// @param params 参数

- (NSURLSessionDataTask *)requestBaseUrlForCheckContractHttpwithHeader:(NSDictionary*)Header WithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(NSDictionary*)params result:(ResultBlock)block;
/// 网络请求
/// @param path 路径
/// @param method 方式
/// @param params 参数

- (NSURLSessionDataTask *)requestHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(id)params result:(ResponseResultBlock)block;


/// 上传图片(单张/多张(后台暂不支持))
/// @param path 路径
/// @param params 参数
/// @param imageArray 数组
/// @param uploadProgressBlock 进度
/// @param block 成功的回调
- (void)requestUploadImageWithPath:(NSString *)path params:(NSDictionary *)params imageArray:(NSArray <UIImage *>*)imageArray progress:(void(^)(CGFloat progress))uploadProgressBlock resultBlock:(ResponseResultBlock)block;

/// 错误请求上报
- (void)postErrorDataWithDict:(NSMutableDictionary *_Nullable)para;

@end


