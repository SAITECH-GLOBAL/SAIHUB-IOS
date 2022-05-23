//
//  NSBundle+Language.h
//  Saihub
//
//  Created by 周松 on 2022/2/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define GCLocalizedString(KEY) [[NSBundle mainBundle] localizedStringForKey:KEY value:nil table:@"Localizable"]

#define NSLocalizedFormatString(fmt, ...) [NSString stringWithFormat:GCLocalizedString(fmt), __VA_ARGS__]

@interface NSBundle (Language)

+ (void)setLanguage:(NSString *)language;

@end

NS_ASSUME_NONNULL_END
