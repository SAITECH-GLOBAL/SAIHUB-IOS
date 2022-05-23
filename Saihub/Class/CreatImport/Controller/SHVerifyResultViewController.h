//
//  SHVerifyResultViewController.h
//  Saihub
//
//  Created by macbook on 2022/2/23.
//

#import "SHBaseViewController.h"
#import "SHShowMnemonicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHVerifyResultViewController : SHBaseViewController
@property (nonatomic, assign) BOOL selectedNestedSegWitButton;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSArray *mnemonicArray;
@property (nonatomic, strong) NSString *walletName;
@property (nonatomic, assign) SHShowMnemonicViewControllerType controllerType;
@end

NS_ASSUME_NONNULL_END
