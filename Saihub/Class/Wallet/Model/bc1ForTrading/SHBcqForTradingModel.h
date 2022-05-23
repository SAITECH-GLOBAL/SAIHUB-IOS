//
//  SHBcqForTradingModel.h
//  Saihub
//
//  Created by macbook on 2022/3/17.
//

#import "SHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHBcqForTradingModel : RLMObject
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *txhex;
@end

NS_ASSUME_NONNULL_END
