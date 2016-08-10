//
//  VerifyViewController.m
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/7.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import "VerifyViewController.h"

@interface VerifyViewController ()

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *phone = @"18817681265";
    phone = [SJTools replaceString:phone withRange:NSMakeRange(3, 4)];
    NSLog(@"phone --- %@",phone);
    
    NSString *string = @"Who are you?";
    string = [SJTools replaceString:string withRange:NSMakeRange(string.length-4, 3) withSubString:@"James"];
    NSLog(@"string --- %@", string);
    
    NSString *str = [SJTools formatterNumberWithComma:@"1982722.0"];
    NSLog(@"str --- %@", str);
}


@end
