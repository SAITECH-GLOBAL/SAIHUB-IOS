//
//  SHBottomAlertView.h
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import "HWPanModalContainerView.h"
#import <HWPanModal/HWPanModal.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,bottomAlertType) {
    bottomAlertPoolType,//pool  cell
    bottomAlertPowerType,//power cell
    bottomAlertAdressBookType//power cell
};
@interface SHBottomAlertView : HWPanModalContentView
@property (copy) void(^closeClickBlock)(void);
@property (copy) void(^poolMoreClickBlock)(NSInteger tag);

@property (nonatomic,strong) UIView *whightBackView;
@property (nonatomic,assign) float containerHeight;
- (instancetype)initWithFrame:(CGRect)frame withcontainerHeight:(float)containerHeight withBottomAlertType:(bottomAlertType)alerType;
- (void)removeChnageWalletView;
@end

NS_ASSUME_NONNULL_END
