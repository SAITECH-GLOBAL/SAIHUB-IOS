//
//  SHLNInvoiceListModel.h
//  Saihub
//
//  Created by macbook on 2022/6/20.
//

#import "SHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHLNInvoiceListModel : RLMObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *prString;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, assign) long timestamp;
@property (nonatomic, assign) long expire_time;
@property (nonatomic, strong) NSString *bc1Address;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, assign) BOOL ispaid;
@end

NS_ASSUME_NONNULL_END
