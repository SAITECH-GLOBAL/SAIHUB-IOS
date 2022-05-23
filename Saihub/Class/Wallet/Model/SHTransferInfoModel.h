//
//  SHTransferInfoModel.h
//  Saihub
//
//  Created by macbook on 2022/3/10.
//

#import "SHBaseModel.h"
#import "BTCTransaction.h"
#import "BTTx.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHTransferInfoModel : SHBaseModel
@property (nonatomic, strong) NSString *valueString;
@property (nonatomic, strong) NSString *coinString;
@property (nonatomic, strong) NSString *moneyString;
@property (nonatomic, strong) NSString *addressString;
@property (nonatomic, strong) NSString *gasLimit;
@property (nonatomic, strong) NSString *gasPrice;
@property (nonatomic, strong) NSString *trueFee;
@property (nonatomic,strong) BTCTransaction *transaction;
@property (nonatomic,strong) BTTx *tx;
@end

NS_ASSUME_NONNULL_END
