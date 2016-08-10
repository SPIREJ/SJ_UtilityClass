//
//  LoginViewController.m
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/15.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import "LoginViewController.h"
#import "YourUserModel.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)finishedAction:(UIButton *)sender {
    if (![SJTools stringValid:_nameTF.text]) {
        [XSMSGManager showText:@"Name不能为空" inView:self.view];
        return;
    }
    
    if (![SJTools stringValid:_mobileTF.text]) {
        [XSMSGManager showText:@"Mobile不能为空" inView:self.view];
        return;
    }
    
    [XSMSGManager showTextInWindow:@"正在登录"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //模拟网络延迟
        
        YourUserModel *model = [YourUserModel new];
        model.name   = _nameTF.text;
        model.mobile = _mobileTF.text;
        [SJTools archiveUserInfo:model];
        
       [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
