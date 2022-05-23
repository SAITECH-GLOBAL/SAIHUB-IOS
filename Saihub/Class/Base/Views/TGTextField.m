//
//  TGTextField.m
//  Tago
//
//  Created by 周松 on 2019/1/11.
//  Copyright © 2019 wwyt. All rights reserved.
//

#import "TGTextField.h"

#define zsplaceholder @" "

@interface TGTextField () <UITextFieldDelegate>
///规则
@property (nonatomic,copy) NSString *pattern;
///replacementString
@property (nonatomic,copy) NSString *replacementString;
///记录当前输入的信息
@property (nonatomic,copy) NSString *currentStr;
///格式匹配
@property (nonatomic,assign) BOOL isRegexMatch;
///限制匹配
@property (nonatomic,assign) BOOL isLimitMatch;

//@property (nonatomic,copy) NSString *toBeStr;

@end
@implementation TGTextField {
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
}

@dynamic isQualified;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = (id<UITextFieldDelegate>)self;
        
        [self addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
        self.currentStr = @"";
        //默认文字长度无限
        self.maxLength = NSIntegerMax;
        //默认不做限制
        self.isRegexMatch = YES;
        self.isLimitMatch = YES;

        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        
        self.decimalCount = 2;
        
        self.tintColor = SHTheme.agreeButtonColor;
        
        self.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] && object == self) {
        [self textDidChanged:self];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -- UITextFieldDelegate
//监听正在输入
-(void)textDidChanged:(UITextField *)textfield{
   if ([textfield.text hasPrefix:@"0"]) {
       if (textfield.text.length > 1) {
           unichar single = [textfield.text characterAtIndex:1];
           if (single != '.') {
               if (self.limitType == TextFieldLimitDecimalType) {
                   textfield.text = [textfield.text substringFromIndex:1];
               }
           }
       }
   }
    NSString *toBeString = self.text;

    //获取高亮部分,对于系统键盘的限制
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position){
        //如果设置limitType再对输入内容进行限制
        if (self.limitType != 0) {
            [self limitVelidate];
        }
        if (toBeString.length > self.maxLength){
            
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
            if (rangeIndex.length == 1){

                self.text = [toBeString substringToIndex:self.maxLength];
            }
            else{

                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
                self.text = [toBeString substringWithRange:rangeRange];
            }
        }
        //当isLimitMatch == NO 并且文字内容不为空,对输入文字进行限制
        if ((self.isLimitMatch == NO && toBeString.length != 0)) {
            if (self.limitType == TextFieldLimitExpressionType) { //对于表情限制单独处理
                self.text = [self stringRemoveAllEmoji];
            } else {
                self.text = self.currentStr;
            }
        } else {
            self.currentStr = textfield.text;
        }
        if ([self.TGTextFieldDelegate respondsToSelector:@selector(editingTextField:text:)]) {
            [self.TGTextFieldDelegate editingTextField:self text:textfield.text];
        }
        if (self.regexType == TextFieldRegexTFFPhoneType) { //344格式
            NSString *str = self.text;
            NSString *phoneStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.pattern];
            self.isQualified = [predicate evaluateWithObject:phoneStr];
            
        } else if (self.regexType == TextFieldRegexVerifyCodeType) { //验证码
            self.isQualified = [self evaluateMatch];
        }
       
    } else {
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (self.regexType == TextFieldRegexTFFPhoneType) {
        return [self regexTFFPhoneNumTextField:textField range:range string:string];
    } else if (self.limitType == TextFieldLimitDecimalType) {
        return [self limitPriceWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.TGTextFieldDelegate respondsToSelector:@selector(TGtextFieldDidBeginEditing:)]) {
        [self.TGTextFieldDelegate TGtextFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.TGTextFieldDelegate respondsToSelector:@selector(TGTextFieldEndEditing:)]) {
        [self.TGTextFieldDelegate TGTextFieldEndEditing:self];
    }
}

#pragma mark -- set方法 ,枚举 设置键盘样式或限制字数
- (void)setRegexType:(TextFieldRegexType)regexType {
    self.isRegexMatch = YES;
    _regexType = regexType;
    switch (regexType) {
        case TextFieldRegexNoneType: //无规则
            break;
        case TextFieldRegexPhoneType:{//手机号规则
            [self setKeyboardType:UIKeyboardTypeNumberPad];
            self.maxLength = 11;
        }
            break;
        case TextFieldRegexEmailType:{ //邮箱校验
            [self setKeyboardType:UIKeyboardTypeEmailAddress];
        }
            break;
        case TextFieldRegexVerifyCodeType: { //验证码
            [self setKeyboardType:UIKeyboardTypeNumberPad];
            self.maxLength = 4;
        }
            break;
        case TextFieldRegexTFFPhoneType : {
            [self setKeyboardType:UIKeyboardTypeNumberPad];
        }
            break;
        default: {

        }
            break;
    }
}

- (void)setLimitType:(TextFieldLimitType)limitType {
    _limitType = limitType;
    switch (limitType) {
        case TextFieldLimitNumberType: { //纯数字
            [self setKeyboardType:UIKeyboardTypeNumberPad];
        }
            break;
       
        case TextFieldLimitDecimalType: { //小数点
            [self setKeyboardType:UIKeyboardTypeDecimalPad];
        }
            break;
        case TextFieldLimitPositiveIntegerberType:{ //正整数(0-100)
            [self setKeyboardType:UIKeyboardTypeNumberPad];
        }
            break;
        case TextFieldLimitIntegerType:{ //正整数
            [self setKeyboardType:UIKeyboardTypeNumberPad];
        }
            break;
        default:
            break;
    }
}
#pragma mark -- 手动生成get方法,用于格式校验提醒
- (BOOL)isQualified {
    if (self.regexType) {
        [self regexVelidate];
        return self.isRegexMatch;
    } else {
        [self limitVelidate];
        return !self.isLimitMatch;
    }
}

- (void)setIsQualified:(BOOL)isQualified {
    
}

#pragma mark -- 校验方法(身份证/表情/价格等)
///格式校验
- (void)regexVelidate {
    //如果不匹配,提示信息
    switch (self.regexType) {
        case TextFieldRegexNoneType: //无规则
            self.isRegexMatch = YES;
            break;
        case TextFieldRegexPhoneType:{//手机号规则
            self.pattern = @"^(1[3|5|6|7|8])\\d{9}$";
            self.isRegexMatch = [self evaluateMatch];
        }
            break;
        case TextFieldRegexEmailType:{ //邮箱校验
            self.pattern = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
            self.isRegexMatch = [self evaluateMatch];
        }
            break;
        case TextFieldRegexIDCardType: { //身份证校验
            self.maxLength = 18;
            self.isRegexMatch = [self validateIDCardNumber];
        }
            break;
        case TextFieldRegexVerifyCodeType: { //验证码
            self.pattern = @"^[0-9]{4}$";
            self.isRegexMatch = [self evaluateMatch];
        }
            break;
        case TextFieldRegexTFFPhoneType: { //344格式手机号
            self.pattern = @"^(1[3|5|6|7|8])\\d{9}$";
            NSString *str = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.pattern];
            self.isRegexMatch = [predicate evaluateWithObject:str];
//            self.isRegexMatch = [self evaluateMatch];
            }
            break;
        default: {
            self.isRegexMatch = YES;
        }
            break;
    }
}
///限制校验
- (void)limitVelidate {
    switch (self.limitType) {
        case TextFieldLimitLetterType: { //字母
            self.pattern = @"^[A-Za-z]+$";
            self.isLimitMatch = [self evaluateMatch];
        }
            break;
        case TextFieldLimitNumberType: { //纯数字
            [self setKeyboardType:UIKeyboardTypeNumberPad];
            self.pattern = @"^[0-9]*$";
            self.isLimitMatch = [self evaluateMatch];
        }
            break;
        case TextFieldLimitPositiveIntegerberType: //正整数(0-100)
            [self setKeyboardType:UIKeyboardTypeNumberPad];
            self.pattern = @"^[1-9][0-9]{0,2}";
            self.isLimitMatch = [self evaluateMatch];
            break;
        case TextFieldLimitChineseType: { //纯中文
            self.pattern = @"^[\u4e00-\u9fa5]{0,}$";
            self.isLimitMatch = [self evaluateMatch];
        }
            break;
        case TextFieldLimitExpressionType: { //表情
            [self LimitExpressionWithString:self.text];
        }
            break;
        case TextFieldLimitLetterAndNumberType: {
            self.pattern = @"^[A-Za-z0-9]+$";
            self.isLimitMatch = [self evaluateMatch];
        }
            break;
        case TextFieldLimitIntegerType: //正整数
            [self setKeyboardType:UIKeyboardTypeNumberPad];
            self.pattern = @"^[1-9][0-9]{0,}";
            self.isLimitMatch = [self evaluateMatch];
            break;
        default: {
            self.isLimitMatch = YES;
        }
            break;
    }
}

///匹配正则
- (BOOL)evaluateMatch {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.pattern];
    return [predicate evaluateWithObject:self.text];
}

//身份证校验
- (BOOL)validateIDCardNumber {
    NSString *value = self.text;
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[1,2][0,9][0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[1|2][0|9][0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}
///遍历字符串,将表情转化为空
- (NSString *)stringRemoveAllEmoji{
    NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self.text length]];
    
    [self.text enumerateSubstringsInRange:NSMakeRange(0, [self.text length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if (![self LimitExpressionWithString:substring]) {
                                  [buffer appendFormat:@""];
                              } else {
                                  [buffer appendFormat:@"%@", substring];
                              }
                          }];
    return buffer;
}

///统计输入的内容是否匹配表情
- (BOOL)LimitExpressionWithString:(NSString *)string {
    self.isLimitMatch = YES;
    if ([[[self textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[self textInputMode] primaryLanguage]) {
        self.isLimitMatch = NO;
    }
    
    //判断键盘是不是九宫格键盘
    if ([self isNineKeyBoard:string] ){
        self.isLimitMatch = YES;
    }else{
        if ([self hasEmoji:string] || [self stringContainsEmoji:string]){
            self.isLimitMatch = NO;
        }
    }
    return self.isLimitMatch;
}

/**
 判断字符串中是否存在emoji
 
 @param string 字符串
 @return YES   (含有表情)
 */
- (BOOL)hasEmoji:(NSString *)string {
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

/** 表情符号的判断 */
- (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            }else if (0x2100 <= hs && hs <= 0x27ff){
                returnValue =YES;
            }else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue =YES;
            }else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue =YES;
            }else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue =YES;
            }else{
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    if (ls == 0x20e3) {
                        returnValue =YES;
                    }
                }
            }
            if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0xd83e) {
                returnValue =YES;
            }
        }
    }];
    return returnValue;
}

/**
 判断是不是九宫格
 
 @param string  输入的字符
 @return YES    (是九宫格拼音键盘)
 */
- (BOOL)isNineKeyBoard:(NSString *)string {
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++) {
        if(!([other rangeOfString:string].location != NSNotFound)) return NO;
    }
    return YES;
}

///判断价格是否标准,小数点后两位
-(BOOL)limitPriceWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL isHaveDian;

    //判断是否有小数点
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }

    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        //不能输入.0~9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.')){
            return NO;
        }
        //只能有一个小数点
        if (isHaveDian && single == '.') {
            return NO;
        }
        //小数位数限制为0
        if (single == '.' && !self.decimalCount) {
            return NO;
        }
        
        //如果第一位是.则前面加上0
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        //如果第一位是0则后面必须输入.
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
//                    return NO;
                }
            }
        }
        //小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            //由于range.location是NSUInteger类型的，所以不能通过(range.location - ran.location) > 2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > self.decimalCount-1) {
                    return NO;
                }
            }
        }
        if (!isHaveDian && self.integerCount != 0 && ![string isEqualToString:@"."]) {
            if (textField.text.length > self.integerCount-1) {
                return NO;
            }
        }
//        NSLog(@"输入的文字 = %@ --%zd -- 长度 =%zd",string,range.location,range.length);
        if (isHaveDian && self.integerCount != 0 && range.location <= self.integerCount) { //防止中间插入字符
            NSArray *array = [textField.text componentsSeparatedByString:@"."];
            NSString *integerStr = array[0];
            if (integerStr.length >= self.integerCount ) {
                return NO;
            }
        }
    }
    return YES;
}

//粘贴 全选
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(paste:)) {
        return YES;
    }
    if (action == @selector(selectAll:)) {
        return YES;
    }
    if (action == @selector(select:)) {
        return YES;
    }
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}
#pragma mark -- 344格式校验
///344ge格式校验
- (BOOL)regexTFFPhoneNumTextField:(UITextField *)textField range:(NSRange)range string:(NSString *)string {
    NSString *phStr = zsplaceholder;
    unichar phChar = ' ';
    if (phStr.length) {
        phChar = [phStr characterAtIndex:0];
    }
    
    
    if (self) {
        NSString* text = self.text;
        //删除
        if([string isEqualToString:@""]){
            
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length - 1 ) {
                    if ([text characterAtIndex:text.length - 1] == phChar) {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == phChar && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [self _parseString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [self _parseString:textField.text];
                
                NSInteger offset = range.location;
                if (range.location == 3 || range.location  == 8) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        
        else if(string.length >0){
            
            //限制输入字符个数
            if (([self _noneSpaseString:textField.text].length + string.length - range.length > 11) ) {
                return NO;
            }
            
            //判断是否是纯数字(搜狗，百度输入法，数字键盘居然可以输入其他字符)
            if(![self _isNum:string]){
                return NO;
            }
            [textField insertText:string];
            textField.text = [self _parseString:textField.text];
            
            NSInteger offset = range.location + string.length;
            if (range.location == 3 || range.location  == 8) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
        
    }
    
    return YES;
}

- (NSString*)_parseString:(NSString*)string{
    
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:zsplaceholder withString:@""]];
    if (mStr.length >3) {
        [mStr insertString:zsplaceholder atIndex:3];
    }if (mStr.length > 8) {
        [mStr insertString:zsplaceholder atIndex:8];
        
    }
    
    return  mStr;
    
}

/** 获取正常电话号码（去掉空格） */
- (NSString*)_noneSpaseString:(NSString*)string{
    
    return [string stringByReplacingOccurrencesOfString:zsplaceholder withString:@""];
    
}

- (BOOL)_isNum:(NSString *)checkedNumString {
    
    if (!checkedNumString) {
        return NO;
    }
    
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(checkedNumString.length > 0) {
        return NO;
    }
    
    return YES;
    
}
//设置占位文字颜色
- (void)setTg_placeholderColor:(UIColor *)tg_placeholderColor {
    _tg_placeholderColor = tg_placeholderColor;
    if (self.placeholder.length == 0) {
        return;
    }
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.placeholder attributes:
    @{NSForegroundColorAttributeName:tg_placeholderColor }];
    self.attributedPlaceholder = attrString;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"text"];
}


@end
