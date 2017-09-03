//
//  FindModel.m
//  Convergence
//
//  Created by admin on 2017/9/3.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "FindModel.h"

@implementation FindModel
-(instancetype)initWithArr:(NSDictionary *)dict{
 
    _hotArr = [dict[@"hot"] isKindOfClass:[NSNull class]] ? @[] :dict[@"hot"];
    _upgradedArr = [dict[@"upgraded"] isKindOfClass:[NSNull class]] ?@[]:dict[@"upgraded"];
    return self;
}
-(instancetype)initWithClub:(NSDictionary *)dict{
    _clubName = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
    _Image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@""];
    _address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
    _distance= [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
    return self;
}
@end
