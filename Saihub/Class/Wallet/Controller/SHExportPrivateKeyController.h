//
//  SHExportPrivateKeyController.h
//  Saihub
//
//  Created by 周松 on 2022/3/3.
//  导出私钥

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHExportPrivateKeyController : SHBaseViewController

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *privateKey;

@end

NS_ASSUME_NONNULL_END
