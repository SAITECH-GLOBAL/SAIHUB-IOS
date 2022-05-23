//
//  SHSetOptionalPassWordViewController.h
//  Saihub
//
//  Created by macbook on 2022/2/23.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHSetOptionalPassWordViewController : SHBaseViewController
@property (nonatomic, assign) BOOL selectedNestedSegWitButton;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSArray *mnemonicArray;
@property (nonatomic, strong) NSString *walletName;

@end

NS_ASSUME_NONNULL_END
