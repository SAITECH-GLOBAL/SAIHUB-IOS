//
//  NSString+Tools.h
//  WalletLite
//
//  Created by 周松 on 2021/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Tools)

/// 签名
+ (NSString *)signString:(NSDictionary *)dictionary;

+ (NSString *)sha1:(NSString *)inPutText;

/// 格式化数值.展示位数 2.56000 格式化后2.56   2.12345678=> 2.123456
+ (NSString *)formStringWithValue:(NSString *)value count:(NSInteger)count;

/// 向上取整
- (NSString *)to_roundUpWithPrecision:(NSInteger)precision;

///去掉小数点末尾零
- (NSString *)removeDecimalLastZero;

/// 去掉空格和换行
+ (NSString *)trimmingWrapWithString:(NSString *)string;

/// 将小数字符串转成整数字符串
+ (NSString *)convertDoubleStrToIntStr:(NSString *)doubleStr;

/// 填充64位字符
+ (NSString *)fillZeroWithValue:(NSString *)value;

/// 裁剪空格
- (NSString *)trimmingCharacters;

/// 判断密码强弱
+ (NSInteger) judgePasswordStrength:(NSString*) _password;

/// 获取当前时间戳
+ (NSInteger)getNowTimeTimestamp;

/// 处理小数 count 为2 , 3.4 -> 3.40 ,5.6666 -> 5.66
+ (NSString *)digitStringWithValue:(NSString *)value count:(NSInteger)count;

/// 校验地址格式
+ (BOOL)isTrueAdress:(NSString *)adress withStatus:(NSString *)status;

/// 将时间戳转化为时间
+ (NSString *)dateStringFromTimestampWithTimeTamp:(long long)time;

/// 将时间戳转化为时间 按传入的格式转化
+ (NSString *)dateStringFromTimestampWithTimeTamp:(long long)time withFormat:(NSString *)Format;

/// 忽略大小写比较字符串是否相等
+ (BOOL)caseInsensitiveCompareFirstStr:(NSString *)firstStr secondStr:(NSString *)secondStr;

/// 格式化地址 前6后4
- (NSString *)formatAddressStrLeft:(NSInteger)left right:(NSInteger)right;

/// 比较两个字符串数值大小
+ (NSComparisonResult)comparStr1:(NSString *)str1 str2:(NSString *)str2;

/// 加
- (NSString *)to_addingWithStr:(NSString *)str;
/// 减
- (NSString *)to_subtractingWithStr:(NSString *)str;
/// 乘
- (NSString *)to_multiplyingWithStr:(NSString *)str;
/// 除
- (NSString *)to_dividingWithStr:(NSString *)str;

/// 校验是否是数字
+ (BOOL)valiedateNumberStr:(NSString *)string;

/// 小于等于 返回yes
- (BOOL)lessThanOrEqualToStr:(NSString *)str;

/// 去掉0x
- (NSString *)removeHexPrefix;

/// 16进制转字符串
+ (NSString *)stringFromHexData:(NSData *)data;

/// 密码格式校验
+ (BOOL)judgePassWordFormat:(NSString *)pass;

/// 验证密码格式 8-20位
+ (BOOL)validePasswordFormat:(NSString *)password;
/**
 转换精度

 @param value 原值
 @param decimal 精度
 @param isPositive 正 负
 @return 返回值
 */
+ (NSDecimalNumber *)numberValueString:(NSString *)value decimal:(NSString *)decimal isPositive:(BOOL)isPositive ;
///获取当前时间的时间戳
+ (NSInteger)getTimestampFromTime;

+(NSString *)randomStringWithLength:(NSInteger)len ;

+ (NSString*)removeFloatAllZeroByString:(NSString *)testNumber;

@end

NS_ASSUME_NONNULL_END
