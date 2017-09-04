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
   self = [super init];
    if(self){ _hotArr = [dict[@"hot"] isKindOfClass:[NSNull class]] ? @[] :dict[@"hot"];
      _upgradedArr = [dict[@"upgraded"] isKindOfClass:[NSNull class]] ?@[]:dict[@"upgraded"];
    }
      return self;
}
-(instancetype)initWithClub:(NSDictionary *)dict{
    self = [super init];
    if(self){
    _clubID = [Utilities nullAndNilCheck:dict[@"clubId"] replaceBy:@""];
    _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@""];
    _Image = [Utilities nullAndNilCheck:dict[@"clubLogo"] replaceBy:@""];
    _address = [Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@""];
    _distance= [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
    }
    return self;
}
-(instancetype)initWithType:(NSDictionary *)dict{
      self = [super init];
    if(self){
        _fId = [Utilities nullAndNilCheck:dict[@"fId"] replaceBy:@""];
        _fName = [Utilities nullAndNilCheck:dict[@"fName"] replaceBy:@""];
        _total = [Utilities nullAndNilCheck:dict[@"total"] replaceBy:@""];
    
    }
    return self;
}
@end
