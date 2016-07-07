//
//  AttributedStringVC.m
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/7.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import "AttributedStringVC.h"

/**
 写在前面：
 1. NSMutableAttributedString 用来处理字符串或者文本非常的强大
 2. 处理时可以为某一范围内文字一下添加多个属性（你用字典存起来的属性），或者是添加一个属性
    使用方法:
    1)为某一范围内文字设置多个属性
    - (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range;
    
    2)为某一范围内文字添加某个属性
    - (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
    
    3)为某一范围内文字添加多个属性
    - (void)addAttributes:(NSDictionary *)attrs range:(NSRange)range;
 
    4)移除某范围内的某个属性
    - (void)removeAttribute:(NSString *)name range:(NSRange)range;

 3. 常见属性及说明
 NSFontAttributeName                --- 字体
 NSParagraphStyleAttributeName      --- 段落格式
 NSForegroundColorAttributeName     --- 字体颜色
 NSBackgroundColorAttributeName     --- 背景颜色
 NSStrikethroughStyleAttributeName  --- 删除线格式
 NSUnderlineStyleAttributeName      --- 下划线格式
 NSStrokeColorAttributeName         --- 删除线颜色
 NSStrokeWidthAttributeName         --- 删除线宽度
 NSShadowAttributeName              --- 阴影

 4. 请看示例使用
 */


@interface AttributedStringVC ()
@property (weak, nonatomic) IBOutlet UILabel *oldLB;

@property (weak, nonatomic) IBOutlet UILabel *showLB;

@end

@implementation AttributedStringVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)hitMeAction:(UIButton *)sender {
    
    _showLB.attributedText = [self changeLabelText:_oldLB.text withUnitFont:XSFont(18)];
    
}

/* 比如我有这么一段文字---> @"10.5%+(1%或2%)，原字体50号，小字体18号，'~'和'-'30号"
    我要处理成：1.'+'号后面的全变小，且颜色变为橙色； 2.汉字或变小，且颜色为蓝色，3.只要是'%'全变小
    我的做法，1.先找出字符串中的'%'的位置,用集合存起来，然后处理相应位置的'%'添加字体属性变小
            2.遇到'+'后，'+'号后的范围添加字体属性和字体颜色属性，变小，橙色
            3.找到'或',添加字体属性和字体颜色属性，变小，蓝色
 */
- (NSMutableAttributedString*)changeLabelText:(NSString*)text withUnitFont:(UIFont*)font
{
    //存储%位置的数组
    NSMutableArray *array = [NSMutableArray array];
    NSString *temp = nil;
    //遍历找出%的位置
    for (NSInteger i = 0; i < text.length; i++) {
        temp = [text substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@"%"]) {
            [array addObject:[NSNumber numberWithInteger:i]];
        }
    }
    //只要是%都处理变小
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSRange tempRange = NSMakeRange([obj integerValue], 1);
        [str addAttribute:NSFontAttributeName value:font range:tempRange];
    }];
    
    if ([text rangeOfString:@"+"].location !=NSNotFound) {
        //属性字典--字体属性和字体颜色属性
        NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,[UIColor orangeColor], NSForegroundColorAttributeName, nil];
        NSRange range1 = [text rangeOfString:@"+"];
        NSRange subRange = NSMakeRange(range1.location, text.length-range1.location);
        [str addAttributes:attrDict range:subRange];
        
    } else if([text rangeOfString:@"~"].location !=NSNotFound || [text rangeOfString:@"-"].location !=NSNotFound)
    {
        NSRange range1 = NSMakeRange(text.length-1, 1);
        NSRange range2 = [text rangeOfString:@"~"];
        NSRange range3 = [text rangeOfString:@"-"];
        [str addAttribute:NSFontAttributeName value:font range:range1];
        [str addAttribute:NSFontAttributeName value:XSFont(30) range:range2];
        [str addAttribute:NSFontAttributeName value:XSFont(30) range:range3];
    }
    
    //或的处理
    if ([text rangeOfString:@"或"].location != NSNotFound) {
        NSRange range = [text rangeOfString:@"或"];
        //一个一个属性的添加
        [str addAttribute:NSFontAttributeName value:font range:range];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
    }
    return str;
}

@end
