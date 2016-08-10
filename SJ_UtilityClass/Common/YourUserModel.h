//
//  YourUserModel.h
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/13.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YourUserModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobile;


- (instancetype)initWithDict:(NSDictionary *)dict;

@end
