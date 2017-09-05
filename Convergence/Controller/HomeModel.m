//
//  HomeModel.m
//  Convergence
//
//  Created by admin001 on 2017/9/4.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
-(instancetype)initWithClub:(NSDictionary *)dict{
    _clubName = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
    _Image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@""];
    _address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
    _distance= [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
    return self;
}
-(instancetype)initWithExperience:(NSDictionary *)dict{
    _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
    _logo = [Utilities nullAndNilCheck:dict[@"logo"] replaceBy:@""];
    _orginPrice = [Utilities nullAndNilCheck:dict[@"price"] replaceBy:@""];
    return self;
}
-(instancetype)initWithPhoto:(NSDictionary *)dict{
    _imgurl = [Utilities nullAndNilCheck:dict[@"imgurl"] replaceBy:@""];
    return self;
}
@end
