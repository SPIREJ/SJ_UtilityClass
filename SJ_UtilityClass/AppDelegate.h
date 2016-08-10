//
//  AppDelegate.h
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/7.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YourUserModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) YourUserModel *currentUserModel;
@end

