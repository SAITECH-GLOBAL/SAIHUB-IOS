//
//  SHImportCheckTypeManage.h
//  Saihub
//
//  Created by macbook on 2022/3/4.
//

#import <Foundation/Foundation.h>
//c
NS_ASSUME_NONNULL_BEGIN
@interface SHImportCheckTypeManage : NSObject
+ (NSInteger)importWalletCheckTypeWithCheckString:(NSString *)checkString;
+ (BOOL)importWalletCheckHaveSameWalletWithCheckString:(NSString *)checkString WithImportType:(NSInteger)importType;

@end

NS_ASSUME_NONNULL_END
