//
//  YourUserModel.m
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/13.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import "YourUserModel.h"

@implementation YourUserModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        _mobile = [NSString stringWithFormat:@"%@",[dict objectForKey:@"mobile"]];
    }
    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
}

//解归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
    }
    return self;
}


@end
