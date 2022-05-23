//
//  NetWorkTool.m
//  TheHouseKeeper
//
//  Created by 王好帅 on 2017/1/16.
//  Copyright © 2017年 SYHL. All rights reserved.
//

#import "NetWorkTool.h"
#import "SHConstParameter.h"
#import <Foundation/NSURLSession.h>
#import "NSString+Tools.h"
#import "SHGetUUID.h"

static id _networkTool;
@interface NetWorkTool ()

@end

@implementation NetWorkTool

+ (instancetype)shareNetworkTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkTool = [[NetWorkTool alloc]init];
    });
    return _networkTool;
}
///获取请求头
+ (NSMutableDictionary *)headerField {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    return dict;
}
//获取拼接签名参数
- (NSMutableDictionary *)signPara {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:API_KEY forKey:@"api_key"];
    [para setValue:[SHConstParameter shareIntance].app_name forKey:@"app_name"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [para setValue:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"app_ver"];
    [para setValue:[NSString stringWithFormat:@"%@%@%@",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]] forKey:@"dinfo"];
    [para setValue:KAppSetting.lang forKey:@"lang"];
    [para setValue:[NSString stringWithFormat:@"%zd",[NSString getNowTimeTimestamp]] forKey:@"ts"];
    [para setValue:[NSString stringWithFormat:@"%@",[SHGetUUID getUUID]] forKey:@"udid"];
    return para;
}

#pragma mark -- 新网络请求
/// baseUrl网络请求
/// @param path 路径
/// @param method 方式
/// @param params 参数

- (NSURLSessionDataTask *)requestBaseUrlHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(NSDictionary*)params result:(ResponseResultBlock)block
{
    if (!path || path.length <= 0) {
        return nil;
    }
    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    switch (method) {
        case Get: {
            AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
            [securityPolicy setAllowInvalidCertificates:YES];
            securityPolicy.validatesDomainName = NO;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager setSecurityPolicy:securityPolicy];
            //请求
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
                return parameters;
            }];
            //响应
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            //设置响应数据格式
            [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
            //拼接url
            NSMutableDictionary *signPara = [self signPara];
            [signPara addEntriesFromDictionary:params];
            
            NSMutableDictionary *xSignDict = [NSMutableDictionary dictionary];
            [signPara enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *value = @"";
                if ([obj isKindOfClass:[NSString class]]) {
                   value = [obj stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [xSignDict setValue:value forKey:key];
                } else {
                    [xSignDict setValue:obj forKey:key];
                }
            }];
            //url拼接的签名
            NSString *signString = [NSString signString:signPara];
            
            //xsign拼接(为了解决参数中有空格,所以多写了一个字典)
            NSString *xSignStr = [NSString signString:xSignDict];
            NSMutableString *xSignMStr = [NSMutableString stringWithString:xSignStr];
            [xSignMStr appendString:API_SECRET];
            NSString *xsign = [NSString sha1:xSignMStr];
//            NSString *url = [NSString stringWithFormat:@"%@%@?%@",@"https://h5.binana.top/invoker/",path,signString];
            NSString *url = [NSString stringWithFormat:@"%@?%@",path,signString];
            return [manager GET:url parameters:nil headers:@{@"x-sign":xsign} progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                SHBaseResponseModel *responseModel = [SHBaseResponseModel modelWithJSON:responseObject];
                if (responseModel != nil) { //如果是正确的数据格式
                    if (responseModel.data.status == 0) { // 真正的请求成功
                        if (block) {
                            block(responseModel,0,@"");
                        }
                    } else {
                        if (block) {
                            block(responseModel,responseModel.data.status,responseModel.data.message);
                        }
                    }
                } else {
                    if (block) {
                        block(nil,3840,@"未能读取到数据，因为不是正确的数据格式");
                    }
                }
                
                NSLog(@"网络请求成功 url =%@ 参数 =\n%@  响应 =\n%@",url,params,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"网络请求失败 url =%@ 参数 =\n%@  响应 =\n%@",url,params,error);
                
                if (block) {
                    block(nil,error.code,error.localizedDescription);
                }
            }];
        }
            break;
        case Post: {
            AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
            [securityPolicy setAllowInvalidCertificates:YES];
            securityPolicy.validatesDomainName = NO;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager setSecurityPolicy:securityPolicy];
            //请求
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            //响应
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            //设置响应数据格式
            [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
            //拼接url
            NSMutableDictionary *signPara = [self signPara];
            
            NSMutableDictionary *xSignDict = [NSMutableDictionary dictionary];
            [signPara enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *value = @"";
                if ([obj isKindOfClass:[NSString class]]) {
                   value = [obj stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [xSignDict setValue:value forKey:key];
                } else {
                    [xSignDict setValue:obj forKey:key];
                }
            }];
            //url拼接的签名
            NSString *signString = [NSString signString:signPara];
            NSMutableString *string = [NSMutableString stringWithString:signString];
            [string appendString:API_SECRET];
            
            //xsign拼接
            NSString *xSignStr = [NSString signString:xSignDict];
            NSMutableString *xSignMStr = [NSMutableString stringWithString:xSignStr];
            [xSignMStr appendString:API_SECRET];
            NSString *xsign = [NSString sha1:xSignMStr];

            NSString *url = [NSString stringWithFormat:@"%@",path];
            return [manager POST:url parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                SHBaseResponseModel *responseModel = [SHBaseResponseModel modelWithJSON:responseObject];
                
                if (responseObject) {
                    SHBaseResponseModel *newResponseModel = [SHBaseResponseModel new];
                    newResponseModel.code = 0;
                    SHBaseResponseDataModel *newResponseDataModel = [SHBaseResponseDataModel new];
                    newResponseDataModel.result = responseObject;
                    newResponseModel.data = newResponseDataModel;
                    if (responseModel != nil) { //如果是正确的数据格式
                        if (responseModel.data.status == 0) { // 真正的请求成功
                            if (block) {
                                block(responseModel,0,@"");
                            }
                        } else {
                            if (block) {
                                block(responseModel,responseModel.data.status,responseModel.data.message);
                            }
                        }
                    } else {
                        if (block) {
                            block(nil,3840,@"未能读取到数据，因为不是正确的数据格式");
                        }
                    }
                } else {
                    if (block) {
                        block(nil,3840,@"未能读取到数据，因为不是正确的数据格式");
                    }
                }
                
                NSLog(@"网络请求成功 url =%@ 参数 =\n%@  响应 =\n%@",url,params,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"网络请求失败 url =%@ 参数 =\n%@  响应 =\n%@",url,params,error);
                if (block) {
                    block(nil,error.code,error.localizedDescription);
                }
            }];
        }
            break;
        default:
            return nil;
            break;
    }
}
/// baseUrlFor检查授权网络请求
/// @param path 路径
/// @param method 方式
/// @param params 参数

- (NSURLSessionDataTask *)requestBaseUrlForCheckContractHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(NSDictionary*)params result:(ResultBlock)block
{
    if (!path || path.length <= 0) {
        return nil;
    }
    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    switch (method) {
        case Get:
        {
            AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
            [securityPolicy setAllowInvalidCertificates:YES];
            securityPolicy.validatesDomainName = NO;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager setSecurityPolicy:securityPolicy];
            //请求
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
                return parameters;
            }];
            //响应
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            //设置响应数据格式
            [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
            //拼接url
            NSMutableDictionary *signPara = [NSMutableDictionary new];
            [signPara addEntriesFromDictionary:params];
            
            NSMutableDictionary *xSignDict = [NSMutableDictionary dictionary];
            [signPara enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *value = @"";
                if ([obj isKindOfClass:[NSString class]]) {
                   value = [obj stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [xSignDict setValue:value forKey:key];
                } else {
                    [xSignDict setValue:obj forKey:key];
                }
            }];
            //url拼接的签名
            NSString *signString = [NSString signString:signPara];
            NSString *url = IsEmpty(signString)?[NSString stringWithFormat:@"%@",path]:[NSString stringWithFormat:@"%@?%@",path,signString];
            return [manager GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"网络请求成功 url =%@ 参数 =\n%@  响应 =\n%@",url,params,responseObject);
                if (responseObject != nil) { //如果是正确的数据格式
                    if (block) {
                        block(responseObject,0,@"");
                    }
            }else {
                if (block) {
                    block(nil,3840,@"未能读取到数据，因为不是正确的数据格式");
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"网络请求失败 url =%@ 参数 =\n%@  响应 =\n%@",url,params,error);
                if (block) {
                    block(nil,error.code,error.localizedDescription);
                }
            }];
        }
            break;
        case Post: {
            AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
            [securityPolicy setAllowInvalidCertificates:YES];
            securityPolicy.validatesDomainName = NO;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager setSecurityPolicy:securityPolicy];
            //请求
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            //响应
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            //设置响应数据格式
            [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
            //拼接url
            NSMutableDictionary *signPara = [self signPara];
            
            NSMutableDictionary *xSignDict = [NSMutableDictionary dictionary];
            [signPara enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *value = @"";
                if ([obj isKindOfClass:[NSString class]]) {
                   value = [obj stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [xSignDict setValue:value forKey:key];
                } else {
                    [xSignDict setValue:obj forKey:key];
                }
            }];
            //url拼接的签名
            NSString *signString = [NSString signString:signPara];
            NSMutableString *string = [NSMutableString stringWithString:signString];
            [string appendString:API_SECRET];
            
            //xsign拼接
            NSString *xSignStr = [NSString signString:xSignDict];
            NSMutableString *xSignMStr = [NSMutableString stringWithString:xSignStr];
            [xSignMStr appendString:API_SECRET];
            NSString *xsign = [NSString sha1:xSignMStr];

            NSString *url = [NSString stringWithFormat:@"%@",path];
            return [manager POST:url parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"网络请求成功 url =%@ 参数 =\n%@  响应 =\n%@",url,params,responseObject);

                if (responseObject != nil) { //如果是正确的数据格式
                    if (block) {
                        block(responseObject,0,@"");
                    }
                } else {
                    if (block) {
                        block(nil,3840,@"未能读取到数据，因为不是正确的数据格式");
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"网络请求失败 url =%@ 参数 =\n%@  响应 =\n%@",url,params,error);
                if (block) {
                    block(nil,error.code,error.localizedDescription);
                }
            }];
        }
            break;
        default:
            return nil;
            break;
    }
}
///网络请求(GET/POST)
- (NSURLSessionDataTask *)requestHttpWithPath:(NSString *)path withMethodType:(NetworkMethod)method withParams:(id)params result:(ResponseResultBlock)block {
    if (!path || path.length <= 0) {
        return nil;
    }
    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    switch (method) {
        case Get: {
            AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
            [securityPolicy setAllowInvalidCertificates:YES];
            securityPolicy.validatesDomainName = NO;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager setSecurityPolicy:securityPolicy];
            //请求
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
                return parameters;
            }];
            //响应
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            //设置响应数据格式
            [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
            manager.requestSerializer.timeoutInterval = 30;
            //拼接url
            NSMutableDictionary *signPara = [self signPara];
            [signPara addEntriesFromDictionary:params];
            
            NSMutableDictionary *xSignDict = [NSMutableDictionary dictionary];
            [signPara enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *value = @"";
                if ([obj isKindOfClass:[NSString class]]) {
                   value = [obj stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [xSignDict setValue:value forKey:key];
                } else {
                    [xSignDict setValue:obj forKey:key];
                }
            }];
            //url拼接的签名
            NSString *signString = [NSString signString:signPara];
            
            //xsign拼接(为了解决参数中有空格,所以多写了一个字典)
            NSString *xSignStr = [NSString signString:xSignDict];
            NSMutableString *xSignMStr = [NSMutableString stringWithString:xSignStr];
            [xSignMStr appendString:API_SECRET];
            NSString *xsign = [NSString sha1:xSignMStr];
            NSString *url = [NSString stringWithFormat:@"%@%@?%@",HOSTURL,path,signString];
            return [manager GET:url parameters:nil headers:@{@"x-sign":xsign} progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                SHBaseResponseModel *responseModel = [SHBaseResponseModel modelWithJSON:responseObject];
                if (responseModel != nil) { //如果是正确的数据格式
                    if (responseModel.data.status == 0) { // 真正的请求成功
                        if (block) {
                            block(responseModel,0,@"");
                        }
                    } else {
                        if (block) {
                            block(responseModel,responseModel.data.status,responseModel.data.message);
                        }
                    }
                } else {
                    if (block) {
                        block(nil,3840,@"未能读取到数据，因为不是正确的数据格式");
                    }
                }
                
                NSLog(@"网络请求成功 url =%@ 参数 =\n%@  响应 =\n%@",url,params,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"网络请求失败 url =%@ 参数 =\n%@  响应 =\n%@",url,params,error);
                
                if (block) {
                    block(nil,error.code,error.localizedDescription);
                }
            }];
        }
            break;
        case Post: {
            AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
            [securityPolicy setAllowInvalidCertificates:YES];
            securityPolicy.validatesDomainName = NO;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager setSecurityPolicy:securityPolicy];
            //请求
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.requestSerializer.timeoutInterval = 30;
            
            //响应
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            //设置响应数据格式
            [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
            //拼接url
            NSMutableDictionary *signPara = [self signPara];
            
            NSMutableDictionary *xSignDict = [NSMutableDictionary dictionary];
            [signPara enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *value = @"";
                if ([obj isKindOfClass:[NSString class]]) {
                   value = [obj stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [xSignDict setValue:value forKey:key];
                } else {
                    [xSignDict setValue:obj forKey:key];
                }
            }];
            //url拼接的签名
            NSString *signString = [NSString signString:signPara];
            NSMutableString *string = [NSMutableString stringWithString:signString];
            [string appendString:API_SECRET];
            
            //xsign拼接
            NSString *xSignStr = [NSString signString:xSignDict];
            NSMutableString *xSignMStr = [NSMutableString stringWithString:xSignStr];
            [xSignMStr appendString:API_SECRET];
            NSString *xsign = [NSString sha1:xSignMStr];

            NSString *url = [NSString stringWithFormat:@"%@%@?%@",HOSTURL,path,signString];
            return [manager POST:url parameters:params headers:@{@"x-sign":xsign} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                SHBaseResponseModel *responseModel = [SHBaseResponseModel modelWithJSON:responseObject];
                if (responseModel != nil) { //如果是正确的数据格式
                    if (responseModel.data.status == 0) { // 真正的请求成功
                        if (block) {
                            block(responseModel,0,@"");
                        }
                    } else {
                        if (block) {
                            block(responseModel,responseModel.data.status,responseModel.data.message);
                        }
                    }
                } else {
                    if (block) {
                        block(nil,3840,@"未能读取到数据，因为不是正确的数据格式");
                    }
                }
                
                if (responseModel.data.status != 0) {
                    NSMutableDictionary *postPara = [NSMutableDictionary dictionary];
                    [postPara setValue:@(responseModel.data.status) forKey:@"errorCode"];
                    [postPara setValue:responseModel.data.message forKey:@"errorMessage"];
                    [postPara setValue:path forKey:@"reqAddress"];
                    [postPara setValue:@"post" forKey:@"reqMethod"];
                    [postPara setValue:[params modelToJSONString] forKey:@"reqParms"];
//                    [self postErrorDataWithDict:postPara];
                }

                NSLog(@"网络请求成功 url =%@ 参数 =\n%@  响应 =\n%@",url,params,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"网络请求失败 url =%@ 参数 =\n%@  响应 =\n%@",url,params,error);
                
                if (block) {
                    block(nil,error.code,error.localizedDescription);
                }
            }];
        }
            break;
        default:
            return nil;
            break;
    }
}

//上传图片
- (void)requestUploadImageWithPath:(NSString *)path params:(NSDictionary *)params imageArray:(NSArray<UIImage *> *)imageArray progress:(void (^)(CGFloat))uploadProgressBlock resultBlock:(ResponseResultBlock)block {
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    securityPolicy.validatesDomainName = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    NSMutableDictionary *signPara = [self signPara];
    [signPara addEntriesFromDictionary:params];
    NSString *signString = [NSString signString:signPara];
    NSMutableString *string = [NSMutableString stringWithString:signString];
    [string appendString:API_SECRET];
    NSString *xsign = [NSString sha1:string];
    
    NSString *url = [NSString stringWithFormat:@"%@%@?%@",HOSTURL,path,signString];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager POST:url parameters:params headers:@{@"x-sign":xsign} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *image in imageArray) {
            //压缩
            NSData * imageData = UIImageJPEGRepresentation(image, 1);
            if (imageData.length > 1024*1024) {//大于1M
                imageData = UIImageJPEGRepresentation(image, 0.2);
            } else if (imageData.length > 512*1024) {//0.5M-1M
                imageData = UIImageJPEGRepresentation(image, 0.5);
            } else if (imageData.length > 200*1024) {//0.2M-0.5M
                imageData = UIImageJPEGRepresentation(image, 0.9);
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";   // 设置时间格式
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressBlock) {
            uploadProgressBlock(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SHBaseResponseModel *responseModel = [SHBaseResponseModel modelWithJSON:responseObject];
        if (responseModel != nil) { //如果是正确的数据格式
            if (responseModel.data.status == 0) { // 真正的请求成功
                if (block) {
                    block(responseModel,0,@"");
                }
            } else {
                if (block) {
                    block(responseModel,responseModel.data.status,responseModel.data.message);
                }
            }
        } else {
            if (block) {
                block(nil,3840,@"未能读取到数据，因为不是正确的数据格式");
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error.code,error.localizedDescription);
        }
    }];
}

@end
