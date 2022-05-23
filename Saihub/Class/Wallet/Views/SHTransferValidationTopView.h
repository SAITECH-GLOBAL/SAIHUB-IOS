//
//  SHTransferValidationTopView.h
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import <UIKit/UIKit.h>
#import "SHTransferInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHTransferValidationTopView : UIView
@property (nonatomic, strong) SHTransferInfoModel *transferInfoModel;
@property (nonatomic,assign) BOOL isPrimaryToken;
-(void)layoutScale;
-(void)loadFeeLabelValue;
@end

NS_ASSUME_NONNULL_END
