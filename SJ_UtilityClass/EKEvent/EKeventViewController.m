//
//  EKeventViewController.m
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/12.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import "EKeventViewController.h"
#import <EventKit/EventKit.h>

@interface EKeventViewController ()
@property (weak, nonatomic) IBOutlet UIButton *remindMeBtn;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;

@end

@implementation EKeventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"日历提醒测试";
}

- (IBAction)remindMeAction:(UIButton *)sender {
    if (![SJTools stringValid:self.timeTF.text]) {
        [XSMSGManager showText:@"时间不能为空" inView:self.view];
        return;
    }
    //请求访问日历
    //在 iOS6 及以后版本，你必须在事件库初始化后，使用 requestAccessToEntityType:completion: 方法请求使用用户的日历数据库。请求访问某个实体类型会异步提示用户允许或禁止你的应用使用他们的日历信息。你应该处理用户授权或禁止你的应用访问权的各种状况.
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //得到了访问日历修改日历的权限
            //创建事件
            EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
            event.title     = @"今天晚上七点要和女神共进晚餐";
            
            event.startDate = [NSDate dateWithTimeIntervalSinceNow:[self.timeTF.text integerValue]];
            event.endDate = [NSDate dateWithTimeIntervalSinceNow:[self.timeTF.text integerValue]];
            
            //添加提醒
            [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -5.0f]];
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            NSError *err;
            [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
            if (err == nil) {
                
            }else{
                
            }

        }else {
            //用户否决了得到访问日历的权限
        }
    }];
}


//查询日历中是否已存在某事件(比如说在处理显示问题上会用到，已经添加过提醒的就显示为 "已提醒" 类型的字样)
- (void) searchEvents {
    
    //这是你要查询的事件名称
    NSString *evevtName = @"今天晚上七点要和女神共进晚餐";
    
    NSArray *array = [SJTools selectCalendarRemindWithAgo:30 after:30];
    if (array.count > 0) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[EKEvent class]]) {
                EKEvent *events = (EKEvent *)obj;
                NSString *eventsTitle = events.title;
                if ([eventsTitle isEqualToString:evevtName]) {
                    *stop = YES;
                }
            }
        }];
    }
}

@end
