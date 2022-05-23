//
//  SHVerifyPasswordController.h
//  Saihub
//
//  Created by 周松 on 2022/3/3.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SHVerifyPasswordControllerType) {
    /// 导出私钥
    SHVerifyPasswordControllerTypeExport,
    SHVerifyPasswordControllerTypeOther,
    /// 删除钱包
    SHVerifyPasswordControllerDelete,
};

@interface SHVerifyPasswordController : SHBaseViewController

@property (nonatomic, assign) SHVerifyPasswordControllerType controllerType;

@property (nonatomic, copy) void (^verifyPasswordBlock)(void);

@end

NS_ASSUME_NONNULL_END
