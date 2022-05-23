//
//  SHPoolListModel.h
//  Saihub
//
//  Created by macbook on 2022/3/1.
//

#import "SHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHPoolListModel : RLMObject
@property (nonatomic, strong) NSString *poolName;
@property (nonatomic, strong) NSString *poolUrl;
@end

NS_ASSUME_NONNULL_END
