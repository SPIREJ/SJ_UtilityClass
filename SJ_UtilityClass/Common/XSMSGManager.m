//
//  XSMSGManager.m
//  XiangshangClub
//
//  Created by luohuichao on 15/12/8.
//  Copyright © 2015年 zendaiUp. All rights reserved.
//

#import "XSMSGManager.h"

#define kMSGLABEL_TAG  9872102876732

@implementation XSMSGManager

/**
 *  在window上显示一个提示语
 */
+ (void)showTextInWindow:(NSString *)text {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [XSMSGManager showText:text inView:keyWindow];
}

/**
 *  在当前的View显示提示语，默认显示在 View的中心
 */
+ (void)showText:(NSString *)text inView:(UIView *)view {
    if (![text isKindOfClass:[NSString class]] || ([text isKindOfClass:[NSString class]] && text.length == 0)) {
        return;
    }
    CGRect viewTemp = view.frame;
    // 如果window 上有该提示，则删除
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *windowView = [keyWindow viewWithTag:kMSGLABEL_TAG];
    if (windowView) {
        [windowView removeFromSuperview];
    }
    UIView *tempView = [view viewWithTag:kMSGLABEL_TAG];
    if (tempView) {
        //当前的View有提示的View，删除
        [tempView removeFromSuperview];
    }
    UIView *bgView = [XSMSGManager msgBGView];
    UILabel *msgLB = [XSMSGManager msgLB];
    msgLB.text = text;
    [msgLB sizeToFit];
    [bgView addSubview:msgLB];
    bgView.bounds = CGRectMake(0, 0, msgLB.frame.size.width + 30, msgLB.frame.size.height + 30);
    CGRect temp = bgView.frame;
    CGRect temp2 = msgLB.frame;
    if (temp.size.width >= kDeviceWidth - 60) {
        //
        temp.size.width = kDeviceWidth - 60;
        bgView.frame = temp;
        
        temp2.size.width = temp.size.width - 30;
        msgLB.frame = temp2;
        
        [msgLB sizeToFit];
        bgView.bounds = CGRectMake(0, 0, temp2.size.width + 30, temp2.size.height + 30);
    }
    msgLB.center = CGPointMake(temp.size.width/2.0, temp.size.height/2.0);
    [view addSubview:bgView];
    bgView.center = CGPointMake(viewTemp.size.width/2.0, viewTemp.size.height/2.0);
    //三秒之后隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [bgView removeFromSuperview];
    });
}

//获取背景View
+ (UIView *)msgBGView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.tag = kMSGLABEL_TAG;
    bgView.backgroundColor = ColorWithHex(0x5a5a5a, 1);//ColorWithRGB(0, 0, 0, 0.7);
    bgView.layer.cornerRadius = 5;
    bgView.layer.shadowColor = ColorWithHex(0xa7a7a7, 1).CGColor;
    bgView.layer.shadowOffset = CGSizeMake(1,1);
    bgView.layer.shadowOpacity = 0.8;
    bgView.layer.shadowRadius = 5;
    return bgView;
}

//获取显示msg的label
+ (UILabel *)msgLB
{
    UILabel *msgLB = [[UILabel alloc] initWithFrame:CGRectZero];
    msgLB.tag = kMSGLABEL_TAG;
    msgLB.backgroundColor = [UIColor clearColor];
    msgLB.textAlignment = NSTextAlignmentCenter;
    msgLB.numberOfLines = 0;
    msgLB.textColor = [UIColor whiteColor];
    msgLB.font = XSFont(14);
    return msgLB;
}

@end
