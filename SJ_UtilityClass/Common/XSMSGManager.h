//
//  XSMSGManager.h
//  XiangshangClub
//
//  Created by luohuichao on 15/12/8.
//  Copyright © 2015年 zendaiUp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XSMSGManager : NSObject

/**
 *  在window上显示一个提示语
 */
+ (void)showTextInWindow:(NSString *)text;

/**
 *  在当前的View显示提示语，默认显示在 View的中心
 */
+ (void)showText:(NSString *)text inView:(UIView *)view;

@end
