//
//  SHTransferValidationForTouchOrFaceViewController.h
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHBaseViewController.h"
#import "SHTransferInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHTransferValidationForTouchOrFaceViewController : SHBaseViewController
@property (nonatomic, strong) SHWalletTokenModel *tokenModel;
@property (nonatomic, strong) NSString *bc1Hex;
@property (nonatomic, strong) SHTransferInfoModel *transferInfoModel;
///是否是主币
@property (nonatomic,assign) BOOL isPrimaryToken;
@end

NS_ASSUME_NONNULL_END
