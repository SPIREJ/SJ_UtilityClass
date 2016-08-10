//
//  CountdownViewController.m
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/7.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import "CountdownViewController.h"

@interface CountdownViewController (){
    NSInteger longTime;
    BOOL timeStart;
}

@property (weak, nonatomic) IBOutlet UIButton *countdownBtn;

- (IBAction)countdownAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textTF;

- (IBAction)nstimerAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *showLB;
- (IBAction)startAction:(UIButton *)sender;
@end

@implementation CountdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)codeCountdown:(UIButton *)button time:(int)time finish:(void (^)())finishBlock
{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
                //倒计时成功回调
                finishBlock();
                
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%ds",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setBackgroundColor:[UIColor lightGrayColor]];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@后重新获取",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (IBAction)countdownAction:(UIButton *)sender {
    [self codeCountdown:self.countdownBtn time:60 finish:^{
        [sender setBackgroundColor:ColorWithHex(0x3399FF, 1)];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }];
}

- (IBAction)startAction:(UIButton *)sender {
    NSString *time = self.textTF.text;
    if (![SJTools stringValid:time]) {
        [XSMSGManager showText:@"时间不能为空" inView:self.view];
        return;
    }
    [self gcdCountdownWithTime:[time integerValue]];
}

- (IBAction)nstimerAction:(UIButton *)sender {
    NSString *time = self.textTF.text;
    if (![SJTools stringValid:time]) {
        [XSMSGManager showText:@"时间不能为空" inView:self.view];
        return;
    }
    [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

//第一种gcd
- (void)gcdCountdownWithTime:(NSInteger)time {
    __block NSInteger timeout = time;//可以假设time等于60秒
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //主线程中处理UI
                //xxx
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //主线程中处理UI
                self.showLB.text = [self dateFormatDays_Hours_MinsWith:timeout];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

//第二种 NSTimer
- (void)timerFireMethod:(NSTimer *)theTimer
{
    if (longTime <= 1) {
        self.showLB.hidden = YES;
        //注①
        [theTimer invalidate];
    }else {
        //注②这里在简书中有标注为什么要写runloop
        [[NSRunLoop currentRunLoop] addTimer:theTimer forMode:NSRunLoopCommonModes];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.showLB setText:[self dateFormatDays_Hours_MinsWith:longTime]];
        });
        longTime--;
    }
}


//NSTimer的第二种写法
- (void)timerFireMethod2:(NSTimer *)theTimer
{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...
    NSDate *today = [NSDate date];    //得到当前时间
    NSDate *date = [NSDate dateWithTimeInterval:80 sinceDate:today];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    static int year;
    static int month;
    static int day;
    static int hour;
    static int minute;
    static int second;
    if(timeStart) {//从NSDate中取出年月日，时分秒，但是只能取一次
        year = [[dateString substringWithRange:NSMakeRange(0, 4)] intValue];
        month = [[dateString substringWithRange:NSMakeRange(5, 2)] intValue];
        day = [[dateString substringWithRange:NSMakeRange(8, 2)] intValue];
        hour = [[dateString substringWithRange:NSMakeRange(11, 2)] intValue];
        minute = [[dateString substringWithRange:NSMakeRange(14, 2)] intValue];
        second = [[dateString substringWithRange:NSMakeRange(17, 2)] intValue];
        timeStart= NO;
    }
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:day];
    [endTime setHour:hour];
    [endTime setMinute:minute];
    [endTime setSecond:second];
    NSDate *todate = [cal dateFromComponents:endTime]; //把目标时间装载入date
    //用来得到具体的时差，是为了统一成北京时间
    unsigned int unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit| NSHourCalendarUnit| NSMinuteCalendarUnit| NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:todate options:0];
    NSString *h = [NSString stringWithFormat:@"%ld",(long)[d hour]];
    
    NSString *fen = [NSString stringWithFormat:@"%ld", (long)[d minute]];
    if([d minute] < 10) {
        fen = [NSString stringWithFormat:@"%ld",[d minute]];
    }
    NSString *miao = [NSString stringWithFormat:@"%ld", (long)[d second]];
    if([d second] < 10) {
        miao = [NSString stringWithFormat:@"0%ld",(long)[d second]];
    }
    if([d second] >= 0) {
        //计时尚未结束，do_something
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSRunLoop currentRunLoop] addTimer:theTimer forMode:NSRunLoopCommonModes];
            [self.showLB setText:[NSString stringWithFormat:@"%ld时%ld分%ld秒",[h integerValue],[fen integerValue], [miao integerValue]]];
        });
    } else{
        //倒计时结束，do something
        [theTimer invalidate];
    }
}



//倒计时处理方法
- (NSString *)dateFormatDays_Hours_MinsWith:(NSInteger)time
{
    NSInteger days = 0,hours = 0,minutes = 0,second = 0;
    NSInteger daySeconds = 24*60*60;
    //获取天数
    if (time >= daySeconds) {
        days = time/daySeconds;
        time = time%daySeconds;
    }
    //获取小时数
    if(time>=60*60){
        hours = time/3600;
        time = time%3600;
    }
    //获取分钟数
    if (time>=60) {
        minutes = time/60;
        time = time%60;
    }
    //获取秒数
    second = time;
    if (days>0) {
        return [NSString stringWithFormat:@"%ld天%ld时%ld分",(long)days,(long)hours,(long)minutes];
    }else{
        return [NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)hours,(long)minutes,(long)second];
    }
}


@end
