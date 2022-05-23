//
//  SHQrScanningViewController.h
//  TokenOne
//
//  Created by macbook on 2020/10/23.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHQrScanningViewController : SHBaseViewController
@property (nonatomic,copy)void (^qrStringClickBlock)(NSString *qrString);
@property (nonatomic,strong)UIButton * photoButton;

@end

NS_ASSUME_NONNULL_END
