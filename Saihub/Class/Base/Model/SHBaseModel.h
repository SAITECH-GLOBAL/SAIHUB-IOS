//
//  SHBaseModel.h
//  MasterTrading
//
//  Created by 周松 on 2020/6/1.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHBaseResponseDataModel;
NS_ASSUME_NONNULL_BEGIN

/**
 "code": 0,
 "msg": "success",
 "data": {
     "status": 0,
     "message": "success",
     "result": true
 }
 
 */

@interface SHBaseModel : NSObject <NSSecureCoding,NSCoding>

@end

//基础响应model
@interface SHBaseResponseModel : SHBaseModel

@property (nonatomic,assign) NSInteger code;

@property (nonatomic,copy) NSString *msg;

@property (nonatomic,strong) SHBaseResponseDataModel *data;

@end

@interface SHBaseResponseDataModel : SHBaseModel

@property (nonatomic,assign) NSInteger status;

@property (nonatomic,copy) NSString *message;

@property (nonatomic,strong) id result;

@end


NS_ASSUME_NONNULL_END
