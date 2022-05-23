//
//  SHForgetPwdPopController.h
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHForgetPwdPopController : UIViewController

@property (nonatomic, copy) void (^pushResetPwdBlock)(void);

@end

NS_ASSUME_NONNULL_END
