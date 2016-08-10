//
//  SJTools.m
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/12.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import "SJTools.h"
#import <EventKit/EventKit.h>

@implementation SJTools


/** 检查字符串的合法性 */
+ (BOOL)stringValid:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        return NO;
    }
    if ([[str lowercaseString] isEqualToString:@"(null)"]) {
        return NO;
    }
    if ([[str lowercaseString] isEqualToString:@"<null>"]) {
        return NO;
    }
    if ([[str lowercaseString] isEqualToString:@"null"]) {
        return NO;
    }
    if (str != nil && [str length] >0 && ![@"" isEqualToString:str]) {
        return YES;
    }else {
        return NO;
    }
}

/** 检查手机号码是否合法 */
+ (BOOL)mobileValid:(NSString *)mobileNum {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    if ([mobileNum hasPrefix:@"1"] && [mobileNum length] == 11) {
        NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        return [regextestmobile evaluateWithObject:mobileNum];
    }else {
        return NO;
    }
}

/** 检查邮箱是否合法 */
+ (BOOL)emailValid:(NSString *)mail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
}

/** 判断输入的是否全部是汉字 */
+ (BOOL)isAllChineseInString:(NSString*)str
{
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (!(0x4e00 <= ch  && ch <= 0x9fff)) {
            return NO;
        }//有不是汉字的
    }
    return YES;//全部都是汉字
}

/** 判断字符串是否全为数字 */
+ (BOOL)isAllNumberInString:(NSString *)str{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (str.length > 0) {
        return NO;
    }
    return YES;
}

/** 检测字符串中有几个小数点*/
+ (NSInteger)checkDotFromText:(NSString *)textStr{
    NSArray *dotArr = [textStr componentsSeparatedByString:@"."];
    return dotArr.count-1;
}



/** 获取当前内存中的用户信息 */
+ (YourUserModel *)memoryUserInfo {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.currentUserModel;
}

/** 获取当前磁盘中的用户信息 */
+ (YourUserModel *)currentArchiveUserInfo {
    //如果内存中有，直接读取，否则，去磁盘读取
    if ([SJTools memoryUserInfo] != nil) {
        return [SJTools memoryUserInfo];
    }
    return [SJTools unArchiveWithFileName:@"yourFileName.db" dataName:@"userInfo"];
}

/** 保存用户信息至本地 */
+ (void)archiveUserInfo:(YourUserModel *)model {
    [SJTools archiveModel:model fileName:@"yourFileName.db" dataName:@"userInfo"];
}

//归档类数据
+ (void)archiveModel:(NSObject *)model fileName:(NSString *)fileName dataName:(NSString *)dataName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:model forKey:dataName];
    [archiver finishEncoding];
    [data writeToFile:dataFilePath atomically:YES];
}

//解档类数据
+ (id)unArchiveWithFileName:(NSString *)fileName dataName:(NSString *)dataName {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id model = [unarchiver decodeObjectForKey:dataName];
    [unarchiver finishDecoding];
    if (model == nil) {
        NSLog(@"读档信息为空");
    }
    return model;
}

+ (void)clearUserInfo {
    YourUserModel *model = [SJTools currentArchiveUserInfo];
    model.name = @"";
    model.mobile = @"";
    [SJTools archiveUserInfo:model];
}


+ (NSArray *)selectCalendarRemindWithAgo:(NSInteger)ago after:(NSInteger)after {
    //连接到事件库
    EKEventStore *store = [[EKEventStore alloc] init];
    //获取适当的日期（当前日期）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //初始化起始日期组件
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -ago;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    //初始化结束日期组件
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.day = after;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    //用事件库的实例方法创建谓词
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneYearFromNow
                                                          calendars:nil];
    //获取所有匹配该谓词的事件
    return [store eventsMatchingPredicate:predicate];
}

/** 替换字符串某一范围为 '*' */
+ (NSString *)replaceString:(NSString *)str withRange:(NSRange)range {
    NSMutableString *tempStr = [NSMutableString string];
    for (NSInteger i = 0; i < range.length; i++) {
        [tempStr appendString:@"*"];
    }
    return [str stringByReplacingCharactersInRange:range withString:tempStr];
}

/** 替换字符串某一范围为另一字符串 */
+ (NSString *)replaceString:(NSString *)str withRange:(NSRange)range withSubString:(NSString *)subString {
    return [str stringByReplacingCharactersInRange:range withString:subString];
}

/** 数字格式化 */
+(NSString *)formatterNumberWithComma:(id)number
{
    NSString *numString;
    if ([number isKindOfClass:[NSNumber class]]) {
        numString = [NSString stringWithFormat:@"%lf",[number doubleValue]];
    }else{
        numString = (NSString *)number;
    }
    
    numString = [NSString stringWithFormat:@"%.2lf",[numString doubleValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    
    NSNumber *num = [NSNumber numberWithDouble:[numString doubleValue]];
    NSString *result = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:num]];
    
    return  result;
}

/** 改变label内容的行间距 */
+ (void)labelLineSpace:(UILabel *)label text:(NSString *)text Value:(CGFloat)value
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:value];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}


/**
 *
 *  统一创建label
 *
 *  @param frame     frame
 *  @param bgColor   背景色
 *  @param tColor    字体色
 *  @param f         字体大小
 *  @param textStr   标题
 *  @param alignment 标题显示格式
 *
 *  @return UILabel
 */
+(UILabel *)buildLabelWithFrame:(CGRect) frame bgColor:(UIColor *)bgColor textColor:(UIColor *)tColor font:(UIFont *)f text:(NSString *)textStr alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    if (bgColor) {
        label.backgroundColor = bgColor;
    }
    label.textColor = tColor;
    label.text = textStr;
    label.textAlignment = alignment;
    label.font = [UIFont systemFontOfSize:14];
    if (f) {
        label.font = f;
    }
    return label;
}

/**
 *
 *  统一创建textField
 *
 *  @param rect          frame
 *  @param delegate      delegate
 *  @param bgColor       背景色
 *  @param textColor     字体颜色
 *  @param font          字体大小
 *  @param clearBtn      clear按钮作用方式
 *  @param isSecureEntry 是否是密码形式显示
 *  @param keyboardType  弹出键盘风格
 *  @param placeholder   默认提示语
 *
 *  @return textField
 */
+ (UITextField *)buildTextFieldWithFrame:(CGRect)rect delegate:(id)delegate bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor font:(UIFont *)font clearBtn:(UITextFieldViewMode)clearBtn isSecureEntry:(BOOL)isSecureEntry keyboardType:(UIKeyboardType)keyboardType placeholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.delegate = delegate;
    textField.backgroundColor = bgColor;
    textField.textColor = textColor;
    
    textField.clearButtonMode = clearBtn;
    textField.placeholder = placeholder;
    textField.secureTextEntry = isSecureEntry;
    //默认风格 UITextBorderStyleNone
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = keyboardType;
    if (textColor) {
        textField.textColor = textColor;
    }
    if (font) {
        textField.font = font;
    }
    //默认NSTextAlignmentLeft
    textField.textAlignment = NSTextAlignmentLeft;
    return textField;
}

/**
 *  统一创建button
 *
 *  @param frame  frame
 *  @param bgC    背景色
 *  @param titleS 标题
 *  @param f      标题字体大小
 *  @param textC  标题字体颜色
 *  @param c      圆角大小
 *
 *  @return button
 */
+ (UIButton *)buildButtonWithFrame:(CGRect)frame bgColor:(UIColor *)bgC title:(NSString *)titleS font:(CGFloat)f textColor:(UIColor *)textC corner:(CGFloat)c{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = bgC;
    [button setTitle:titleS forState:UIControlStateNormal];
    [button setTitleColor:textC forState:UIControlStateNormal];
    button.titleLabel.font = XSFont(f);
    button.clipsToBounds = YES;
    button.layer.cornerRadius = c;
    
    return button;
}

+ (void)setCornerRadiusWithButton:(UIButton *)button corner:(float)corner BorderColor:(UIColor *)boederColor borderWidth:(float)borderWidth  masksToBounds:(BOOL)mask{
    button.layer.borderColor = boederColor.CGColor;
    button.layer.borderWidth = borderWidth;
    button.layer.cornerRadius = corner;
    button.layer.masksToBounds = mask;
}

+(UIView *)selectedBackgroundViewWithColor:(UIColor *)color {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = color;
    return bgView;
}


@end
