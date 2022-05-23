//
//  SHApplicationStorageManage.m
//  NewExchange
//
//  Created by 周松 on 2021/11/22.
//

#import "SHApplicationStorageManage.h"
#import "SHFileManage.h"
#import "NSBundle+Language.h"

@interface SHApplicationStorageManage ()

@property (nonatomic,copy,readwrite) NSString *languageSymbol;

@property (nonatomic,copy,readwrite) NSString *lang;

@property (nonatomic,copy,readwrite) NSString *currencySymbol;

@property (nonatomic,copy,readwrite) NSString *currencyName;

@end

static id _storageManage;

@implementation SHApplicationStorageManage

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _storageManage = [[SHApplicationStorageManage alloc]init];
    });
    return _storageManage;
}

- (void)setLanguage:(SHApplicationLanguage)language {
    [SHFileManage savePreferencesData:@(language) forKey:@"language"];
    
    NSString *str = [SHFileManage loadLocalResourceName:@"language.json"];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]  options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dict = array[language];
    [NSBundle setLanguage:dict[@"symbol"]];
}

- (SHApplicationLanguage)language {
    return [[SHFileManage readPreferencesDataForKey:@"language"] integerValue];
}

- (NSString *)lang {
    NSDictionary *dict = [self getLanguageDict];
    return dict[@"lang"];
}

- (NSString *)languageName {
    NSDictionary *dict = [self getLanguageDict];
    return dict[@"language"];
}

- (NSString *)languageSymbol {
    NSDictionary *dict = [self getLanguageDict];
    return dict[@"symbol"];
}

- (void)setCurrency:(SHApplicationCurrency)currency {
    [SHFileManage savePreferencesData:@(currency) forKey:@"currency"];
}

- (SHApplicationCurrency)currency {
    return [[SHFileManage readPreferencesDataForKey:@"currency"] integerValue];
}
-(void)setUnlockedPassWord:(NSString * _Nonnull)unlockedPassWord
{
    [SHFileManage savePreferencesData:unlockedPassWord forKey:@"unlockedPassWord"];
}
-(NSString *)unlockedPassWord
{
    return [SHFileManage readPreferencesDataForKey:@"unlockedPassWord"];
}
-(void)setIsOpenFaceID:(NSString * _Nonnull)isOpenFaceID
{
    [SHFileManage savePreferencesData:isOpenFaceID forKey:@"isOpenFaceID"];
}
-(NSString *)isOpenFaceID
{
    return [SHFileManage readPreferencesDataForKey:@"isOpenFaceID"];
}
- (NSString *)currencyName {
    NSDictionary *dict = [self getCurrencyDict];
    return dict[@"name"];
}

- (NSString *)currencySymbol {
    NSDictionary *dict = [self getCurrencyDict];
    return dict[@"symbol"];
}

- (NSString *)currencyKey {
    NSDictionary *dict = [self getCurrencyDict];
    return dict[@"key"];
}

- (NSDictionary *)getCurrencyDict {
    NSString *str = [SHFileManage loadLocalResourceName:@"currency.json"];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]  options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dict = array[self.currency];
    return dict;
}

- (NSDictionary *)getLanguageDict {
    NSString *str = [SHFileManage loadLocalResourceName:@"language.json"];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]  options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dict = array[self.language];
    return dict;
}


@end
