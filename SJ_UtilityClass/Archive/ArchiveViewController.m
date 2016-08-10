//
//  ArchiveViewController.m
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/15.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import "ArchiveViewController.h"
#import "LoginViewController.h"
#import "YourUserModel.h"

@interface ArchiveViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *mobileLB;
@end

@implementation ArchiveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    YourUserModel *model = [SJTools currentArchiveUserInfo];
    _nameLB.text = model.name;
    _mobileLB.text = model.mobile;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)loginAction:(UIButton *)sender {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController presentViewController:loginVC animated:YES completion:nil];
}


@end
