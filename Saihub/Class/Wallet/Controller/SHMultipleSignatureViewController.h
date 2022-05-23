//
//  SHMultipleSignatureViewController.h
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import "SHBaseViewController.h"
#import "SHTransferInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHMultipleSignatureViewController : SHBaseViewController
@property (nonatomic, strong) SHTransferInfoModel *transferInfoModel;
@property (nonatomic, assign) NSInteger haveSureNum;
@property (nonatomic, strong) NSString *URPsbtString;
@property (nonatomic, strong) SHWalletTokenModel *tokenModel;
///是否是主币
@property (nonatomic,assign) BOOL isPrimaryToken;


@end

NS_ASSUME_NONNULL_END
