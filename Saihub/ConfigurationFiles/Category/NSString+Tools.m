//
//  NSString+Tools.m
//  WalletLite
//
//  Created by 周松 on 2021/8/29.
//

#import "NSString+Tools.h"
#import <CommonCrypto/CommonCryptor.h>
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (Tools)

- (NSString *)trimmingCharacters{

    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)signString:(NSDictionary *)dictionary {
    NSArray *keys = [dictionary allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableString *contentString  =[NSMutableString string];
    for (int i = 0; i< sortedArray.count; i++) {
        if (i == 0) {
//            [contentString appendString:[NSString stringWithFormat:@"%@=%@",sortedArray[i],[dictionary objectForKey:sortedArray[i]]  ]];
            [contentString appendString:[NSString stringWithFormat:@"%@=%@",sortedArray[i],[[dictionary objectForKey:sortedArray[i]] URLEncodedString]]];
        } else {
            id value = [dictionary objectForKey:sortedArray[i]];
            if ([value isKindOfClass:[NSNumber class]]) {
                NSNumber *number = (NSNumber *)value;
                value = [number stringValue];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)value;
                value = [dict modelToJSONString];
            }
//            [contentString appendString:[NSString stringWithFormat:@"&%@=%@",sortedArray[i],[[dictionary objectForKey:sortedArray[i]] URLEncodedString]]];
            //后台确定需要编码!!!!   2021-1-29 修改
            [contentString appendString:[NSString stringWithFormat:@"&%@=%@",sortedArray[i],[value URLEncodedString]]];//西安确定参数不编译
//            [contentString appendString:[NSString stringWithFormat:@"&%@=%@",sortedArray[i],value]];

        }
    }
    NSString *stringUTF8 = [contentString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@" \"#%/:<>?@[\\]^`{|}"] invertedSet]];
    return contentString;
}

- (NSString *)URLEncodedString
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

+ (NSString *)sha1:(NSString *)inPutText {

    
    const char *cstr = [inPutText cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:inPutText.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes,(CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *)formStringWithValue:(NSString *)value count:(NSInteger)count {
    if (!value||[value isEqualToString:@""]) {
        value = @"0";
        return @"0";
    }
    if (![value isKindOfClass:[NSString class]]) {
        value = [NSString stringWithFormat:@"%@", value];
    }
    NSArray *keysArray = [value componentsSeparatedByString:@"."];
    NSString *keyL1 = [keysArray firstObject];
    NSString *keyR1 = [keysArray lastObject];
    if (keysArray.count == 1) {
        keyR1 = @"0";
    }
    if (count == 0) {
        return [NSString stringWithFormat:@"%@",keyL1];
    } else if (keyR1.length == count) {
        if ([[NSString removeLastZero:keyR1] isEqual:@"0"]) { //如果小数点后都是0
            return keyL1;
        }
        return [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@.%@", keyL1, [NSString removeLastZero:keyR1]]];
    } else if (keyR1.length > count) {
        if ([[NSString removeLastZero:[keyR1 substringToIndex:count]] isEqual:@"0"]) {
            return keyL1;
        }
        return [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@.%@", keyL1, [NSString removeLastZero:[keyR1 substringToIndex:count]]]];
    } else if (keyR1.length < count) {
        if ([[NSString removeLastZero:[keyR1 substringToIndex:keyR1.length]] isEqual:@"0"]) {
            return keyL1;
        }
        return [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@.%@", keyL1, [NSString removeLastZero:[keyR1 substringToIndex:keyR1.length]]]];
    }
    return [NSString stringWithFormat:@"%@",value];
}

- (NSString *)to_roundUpWithPrecision:(NSInteger)precision {
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:precision raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSString *str = self;
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:str];
    num = [num decimalNumberByRoundingAccordingToBehavior:roundUp];
    return num.stringValue;
}


///去掉末尾零
+ (NSString *)removeLastZero:(NSString *)newStr {
    NSString *temp = nil;
    for(NSInteger i = newStr.length -1; i >= 0; i--){
        temp = [newStr substringWithRange:NSMakeRange(i, 1)];
        if (![temp isEqual:@"0"]) {
            temp = [newStr substringToIndex:i + 1];
            break;
        }
    }
    return temp;
}

///去掉小数点末尾零
- (NSString *)removeDecimalLastZero {
    NSString *value = self;
    NSArray *keysArray = [value componentsSeparatedByString:@"."];
    NSString *keyL1 = [keysArray firstObject];
    NSString *keyR1 = [keysArray lastObject];
    NSString *temp = @"";
    if (keysArray.count > 1) { //说明是小数
        for(NSInteger i = keyR1.length -1; i >= 0; i--){
            temp = [keyR1 substringWithRange:NSMakeRange(i, 1)];
            if (![temp isEqual:@"0"]) {
                temp = [keyR1 substringToIndex:i + 1];
                break;
            }
        }
        if ([temp isEqual:@"0"]) {
            keyR1 = @"";
        } else {
            keyR1 = [NSString stringWithFormat:@".%@",temp];
        }
        return [NSString stringWithFormat:@"%@%@",keyL1,keyR1];
    } else {
        return value;
    }
}

+ (NSString *)trimmingWrapWithString:(NSString *)string {
    NSString *str = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    return str;
}

+ (NSString *)convertDoubleStrToIntStr:(NSString *)doubleStr {
    if (!doubleStr||[doubleStr isEqualToString:@""]) {
        doubleStr = @"0";
    }
    if (![doubleStr isKindOfClass:[NSString class]]) {
        doubleStr = [NSString stringWithFormat:@"%@", doubleStr];
    }
    if ([doubleStr containsString:@"."] == NO) {
        return doubleStr;
    }
    NSArray *keysArray = [doubleStr componentsSeparatedByString:@"."];
    NSString *leftStr = [keysArray firstObject];
    return leftStr;
}

+ (NSString *)fillZeroWithValue:(NSString *)value {
    
    if (!value||[value isEqualToString:@""]) {
        value = @"0.0";
    }
    if (![value isKindOfClass:[NSString class]]) {
        value = [NSString stringWithFormat:@"%@", value];
    }
    NSInteger count = value.length;
    if (count > 64) {
        return [value substringToIndex:64];
    } else if (count < 64) {
        for (NSInteger i=0; i < 64 - count; i ++) {
            value = [NSString stringWithFormat:@"0%@", value];
        }
        return value;
    }
    return value;
}

+(NSInteger)getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;

       [formatter setDateStyle:NSDateFormatterMediumStyle];

       [formatter setTimeStyle:NSDateFormatterShortStyle];

       [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

       //设置时区,这个对于时间的处理有时很重要

       NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

       [formatter setTimeZone:timeZone];

       NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

       NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];

       return [timeSp longValue];
}

+ (NSInteger) judgePasswordStrength:(NSString*) _password

{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];

    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];

    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];

    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];

    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];

    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];

    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];

    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];

    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];

    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    
    int intResult=0;

    for (int j=0; j<[resultArray count]; j++)

    {

        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])

        {

            intResult++;

        }

    }
    return intResult;

}
+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password

{

  NSRange range;

   BOOL result =NO;

   for(int i=0; i<[_termArray count]; i++)

    {

        range = [_password rangeOfString:[_termArray objectAtIndex:i]];

       if(range.location != NSNotFound)

        {

            result =YES;

        }

    }

   return result;
}

+ (NSString *)digitStringWithValue:(NSString *)value count:(NSInteger)count {
    if (!value||[value isEqualToString:@""]) {
        value = @"0.0";
    }
    if (![value isKindOfClass:[NSString class]]) {
        value = [NSString stringWithFormat:@"%@", value];
    }
    NSArray *keysArray = [value componentsSeparatedByString:@"."];
    NSString *keyL1 = [keysArray firstObject];
    NSString *keyR1 = [keysArray lastObject];
    if (keysArray.count == 1) {
        keyR1 = @"";
    }
    if (count == 0) {
        return keyL1;
    } else if (keyR1.length == count) {
        return [NSString stringWithFormat:@"%@.%@", keyL1, keyR1];
    } else if (keyR1.length > count) {
        return [NSString stringWithFormat:@"%@.%@", keyL1, [keyR1 substringToIndex:count]];
    } else {
        NSString *priceKey = [NSString stringWithFormat:@"%@.%@", keyL1, keyR1];
        for (NSInteger i=0; i < count - keyR1.length; i ++) {
            priceKey = [NSString stringWithFormat:@"%@0", priceKey];
        }
        return priceKey;
    }
}

+ (BOOL)isTrueAdress:(NSString *)adress withStatus:(NSString *)status {
    if ([status isEqualToString:@"BTC"])
    {
        NSString *emailRegex = @"^(1|3)[a-zA-Z\\d]{24,33}$";
//        NSString *emailRegexTwo = @"^[^0OlI]{25,34}$";//慧杰让注掉了
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        if ([emailTest evaluateWithObject:adress]) {
            return YES;
        }
        return NO;
    } else if ([status isEqualToString:@"EOS"]) {
        NSString *emailRegex = @" (^[1-5]{12}$)|(^[a-z]{12}$)|(^[1-5a-z]{12}$)";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:adress];
    }else if ([status isEqualToString:@"TRX"]||[status isEqualToString:@"TRON"])
    {
        NSString *emailRegex = @"^[T][a-km-zA-HJ-NP-Z1-9]{33}$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject:adress]) {
            return YES;
        }
        return NO;
    } else {
        NSString *emailRegex = @"^(0x)?[0-9a-fA-F]{40}$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:adress];
    }
}


+ (NSString *)dateStringFromTimestampWithTimeTamp:(long long)time {
    
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

+ (NSString *)dateStringFromTimestampWithTimeTamp:(long long)time withFormat:(NSString *)Format {
    NSString *timeString = [NSString stringWithFormat:@"%lld",time];
    if (timeString.length > 13) {
        timeString = [timeString substringToIndex:13];
    }
    time = [timeString longLongValue];
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:Format];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

+ (BOOL)caseInsensitiveCompareFirstStr:(NSString *)firstStr secondStr:(NSString *)secondStr {
    if (firstStr == nil || secondStr == nil) {
        return NO;
    }
    firstStr = [firstStr lowercaseString];
    secondStr = [secondStr lowercaseString];
    return [firstStr compare:secondStr options:NSCaseInsensitiveSearch] == NSOrderedSame;
}

- (NSString *)formatAddressStrLeft:(NSInteger)left right:(NSInteger)right {
    NSString *str = self;
    if (str.length < left + right + 3) {
        return str;
    }
    NSString *leftStr = [str substringToIndex:left];
    NSString *rightStr = [str substringFromIndex:str.length - right];
    
    return [NSString stringWithFormat:@"%@...%@",leftStr,rightStr];
}

+ (NSComparisonResult)comparStr1:(NSString *)str1 str2:(NSString *)str2 {
    NSString *leftStr = str1;
    NSString *rightStr = str2;
    if (IsEmpty(leftStr)) {
        leftStr = @"0";
    }
    if (IsEmpty(rightStr)) {
        rightStr = @"0";
    }
    
    NSDecimalNumber *leftNum = [NSDecimalNumber decimalNumberWithString:leftStr];
    NSDecimalNumber *rightNum = [NSDecimalNumber decimalNumberWithString:rightStr];
    return [leftNum compare:rightNum];
}

#pragma mark -- 公式计算
- (NSString *)to_addingWithStr:(NSString *)str {
    NSString *firstStr = self;
    if ([NSString valiedateNumberStr:firstStr] == NO || firstStr.length == 0 ) {
        firstStr = @"0";
    }
    if ([NSString valiedateNumberStr:str] == NO || str.length == 0) {
        str = @"0";
    }
    NSDecimalNumber *firstNum = [NSDecimalNumber decimalNumberWithString:firstStr];
    NSDecimalNumber *secondNum = [NSDecimalNumber decimalNumberWithString:str];
    return [firstNum decimalNumberByAdding:secondNum].stringValue;
}

- (NSString *)to_subtractingWithStr:(NSString *)str {
    NSString *firstStr = self;
    if ([NSString valiedateNumberStr:firstStr] == NO || firstStr.length == 0 ) {
        firstStr = @"0";
    }
    if ([NSString valiedateNumberStr:str] == NO || str.length == 0) {
        str = @"0";
    }
    NSDecimalNumber *firstNum = [NSDecimalNumber decimalNumberWithString:firstStr];
    NSDecimalNumber *secondNum = [NSDecimalNumber decimalNumberWithString:str];
    return [firstNum decimalNumberBySubtracting:secondNum].stringValue;
}

- (NSString *)to_multiplyingWithStr:(NSString *)str {
    NSString *firstStr = self;
    if ([NSString valiedateNumberStr:firstStr] == NO || firstStr.length == 0 ) {
        firstStr = @"0";
        return @"0";
    }
    if ([NSString valiedateNumberStr:str] == NO || str.length == 0) {
        str = @"0";
        return @"0";
    }
    NSDecimalNumber *firstNum = [NSDecimalNumber decimalNumberWithString:firstStr];
    NSDecimalNumber *secondNum = [NSDecimalNumber decimalNumberWithString:str];
    return [firstNum decimalNumberByMultiplyingBy:secondNum].stringValue;
}

- (NSString *)to_dividingWithStr:(NSString *)str {
    NSString *firstStr = self;
    if ([NSString valiedateNumberStr:firstStr] == NO || firstStr.length == 0 ) {
        firstStr = @"0";
        return @"0";
    }
    if ([NSString valiedateNumberStr:str] == NO || str.length == 0 || [str isEqualToString:@"0"]) {
        str = @"0";
        return @"0";
    }
    NSDecimalNumber *firstNum = [NSDecimalNumber decimalNumberWithString:firstStr];
    NSDecimalNumber *secondNum = [NSDecimalNumber decimalNumberWithString:str];
    if ([secondNum isEqualToNumber:@(0)]) {
        return @"0";
    }
    return [firstNum decimalNumberByDividingBy:secondNum].stringValue;
}

+ (BOOL)valiedateNumberStr:(NSString *)string {
    if (string == nil) {
        return NO;
    }
    NSString *pattern = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [predicate evaluateWithObject:string];
}

- (BOOL)lessThanOrEqualToStr:(NSString *)str {
    NSString *firstStr = self;
    if ([NSString valiedateNumberStr:firstStr] == NO || firstStr.length == 0 ) {
        firstStr = @"0";
    }
    if ([NSString valiedateNumberStr:str] == NO || str.length == 0) {
        str = @"0";
    }
    NSDecimalNumber *firstNum = [NSDecimalNumber decimalNumberWithString:firstStr];
    NSDecimalNumber *secondNum = [NSDecimalNumber decimalNumberWithString:str];
    
    NSComparisonResult result = [firstNum compare:secondNum];
    if (result == NSOrderedAscending || result == NSOrderedSame) {
        return YES;
    }
    return NO;
}

- (NSString *)removeHexPrefix {
    NSString *str = self;
    if ([str hasPrefix:@"0x"]) {
        str = [str substringFromIndex:2];
    }
    return str;
}

+ (NSString *)stringFromHexData:(NSData *)data {
 
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr = @"";
    for(int i=0;i<[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1){
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    hexStr = [hexStr uppercaseString];
    return hexStr;

}

///判断密码正确类型
+ (BOOL)judgePassWordFormat:(NSString *)pass {
    
    BOOL result ;
    
    // 判断长度大于8位后再接着判断是否同时包含数字和大小写字母
    
    NSString * regex =@"(?![0-9A-Z]+$)(?![0-9a-z]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    result = [pred evaluateWithObject:pass];
    
    return result;
}

+ (BOOL)validePasswordFormat:(NSString *)password {
    if (password.length >= 8 && password.length <= 20) {
        return YES;
    }
    return NO;
}
+ (NSDecimalNumber *)numberValueString:(NSString *)value decimal:(NSString *)decimal isPositive:(BOOL)isPositive {
    if (![value isKindOfClass:[NSString class]]) {
        value = [NSString stringWithFormat:@"%@",value];
    }
    NSDecimalNumber *valueNum = [NSDecimalNumber decimalNumberWithString:value];
    NSDecimalNumber *decimalNum = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:decimal.integerValue*(isPositive?1:-1) isNegative:NO];
    NSDecimalNumber *result = [valueNum decimalNumberByMultiplyingBy:decimalNum];
    return result;
}
+ (NSInteger)getTimestampFromTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];// ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要

    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.

    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?

    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    return [datenow timeIntervalSince1970]*1000.0;
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//
//    return timeSp;

}
@end
