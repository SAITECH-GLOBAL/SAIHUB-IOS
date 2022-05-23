//
//  SHPostAddressModel.h
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHPostAddressModel : RLMObject

///地址
@property (nonatomic,copy) NSString *address;

///币种名
@property (nonatomic,copy) NSString *coin;

@end

NS_ASSUME_NONNULL_END
