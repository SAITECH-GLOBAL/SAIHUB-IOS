//
//  SHSetPassWordViewController.h
//  Saihub
//
//  Created by macbook on 2022/2/24.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHSetPassWordViewController : SHBaseViewController
@property (nonatomic, strong) NSString *importKeyString;
@property (nonatomic, strong) NSString *walletName;
@property (nonatomic, assign) BOOL selectedNestedSegWitButton;

@end

NS_ASSUME_NONNULL_END
