//
//  SHCompleteView.h
//  Saihub
//
//  Created by 周松 on 2022/3/1.
//

#import "HWPanContainerView.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,CompleteViewType) {
    CompleteViewSucceseType,
    CompleteViewFailType,
    CompleteViewAddressExistsFailType
};
@interface SHCompleteView : HWPanModalContentView

@property (nonatomic, copy) void (^completeBlock)(void);
@property (nonatomic, assign) CompleteViewType completeViewType;
@end

NS_ASSUME_NONNULL_END
