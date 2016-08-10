//
//  SJTools.h
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/12.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YourUserModel.h"

@interface SJTools : NSObject
#pragma mark - 校验类

/** 检查字符串的合法性 */
+ (BOOL)stringValid:(NSString *)str;

/** 检查手机号码是否合法 */
+ (BOOL)mobileValid:(NSString *)mobileNum;

/** 检查邮箱是否合法 */
+ (BOOL)emailValid:(NSString *)mail;

/** 判断输入的是否全部是汉字 */
+ (BOOL)isAllChineseInString:(NSString*)str;

/** 判断字符串是否全为数字 */
+ (BOOL)isAllNumberInString:(NSString *)str;

/** 检测字符串中有几个小数点*/
+ (NSInteger)checkDotFromText:(NSString *)textStr;

#pragma mark - 用户相关
/** 获取当前内存中的用户信息 */
+ (YourUserModel *)memoryUserInfo;

/** 获取当前磁盘中的用户信息 */
+ (YourUserModel *)currentArchiveUserInfo;

/** 保存用户信息至本地 */
+ (void)archiveUserInfo:(YourUserModel *)model;

/** 清空归档信息 */
+ (void)clearUserInfo;


#pragma mark - 功能类
/** 查询日历中的提醒事件 
 param1: 查询的初始日期距现在多少天
 param2: 查询的结束日期距现在多少天
 */
+ (NSArray *)selectCalendarRemindWithAgo:(NSInteger)ago after:(NSInteger)after;

/** 替换字符串某一范围为 '*' */
+ (NSString *)replaceString:(NSString *)str withRange:(NSRange)range;

/** 替换字符串某一范围为另一字符串 */
+ (NSString *)replaceString:(NSString *)str withRange:(NSRange)range withSubString:(NSString *)subString;

/** 数字格式化 保留两位小数*/
+ (NSString *)formatterNumberWithComma:(id)number;

/**
 *  改变UILabel内容行间距
 *
 *  @param label  UILabel
 *  @param text  内容
 *  @param value 间距值
 */
+ (void)labelLineSpace:(UILabel *)label text:(NSString *)text Value:(CGFloat)value;

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
+ (UILabel *)buildLabelWithFrame:(CGRect) frame bgColor:(UIColor *)bgColor textColor:(UIColor *)tColor font:(UIFont *)f text:(NSString *)textStr alignment:(NSTextAlignment)alignment;

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
+ (UITextField *)buildTextFieldWithFrame:(CGRect)rect delegate:(id)delegate bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor font:(UIFont *)font clearBtn:(UITextFieldViewMode)clearBtn isSecureEntry:(BOOL)isSecureEntry keyboardType:(UIKeyboardType)keyboardType placeholder:(NSString *)placeholder;

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
+ (UIButton *)buildButtonWithFrame:(CGRect)frame bgColor:(UIColor *)bgC title:(NSString *)titleS font:(CGFloat)f textColor:(UIColor *)textC corner:(CGFloat)c;

/**
 *
 *  修改button圆角属性
 *
 *  @param button      要修改的button
 *  @param corner      圆角值
 *  @param boederColor 边框颜色
 *  @param borderWidth 边框宽度
 *  @param mask        
 *
 */
+ (void)setCornerRadiusWithButton:(UIButton *)button corner:(float)corner BorderColor:(UIColor *)boederColor borderWidth:(float)borderWidth  masksToBounds:(BOOL)mask;

/**
 *
 *  设置cell被点击时的背景颜色
 *
 *  @return
 */
+(UIView *)selectedBackgroundViewWithColor:(UIColor *)color;


#pragma mark - 设备相关


@end
