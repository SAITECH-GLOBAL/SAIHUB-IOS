//
//  SHGetUUID.m
//  Saihub
//
//  Created by 周松 on 2022/2/15.
//

#import "SHGetUUID.h"

#define keyChain_service @"com.app.Saihub"

@implementation SHGetUUID

+ (NSString *)getUUID {
    NSString * strUUID = [YYKeychain getPasswordForService:keyChain_service account:keyChain_service];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [YYKeychain setPassword:strUUID forService:keyChain_service account:keyChain_service];
    }
    
    return strUUID;
}

@end
