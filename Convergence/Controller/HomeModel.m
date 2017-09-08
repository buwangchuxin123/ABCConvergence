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
    if (self) {
    _clubID  = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""]integerValue];
    _clubName = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
    _Image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@""];
    _address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
    _distance= [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
    _experience = [dict[@"experience"] isKindOfClass:[NSNull class]] ?@[@"",@""] :dict[@"experience"];
//        NSMutableArray *experiences = [NSMutableArray new];
//        if (![dict[@"experience"]isKindOfClass:[NSNull class]]){
//            for (NSDictionary *experience in dict[@"experience"]){
//            
//            }
//            self.experience = experiences;
//        }else{
//            self.experience = @[];
//        }
        
    }
    return self;
}
-(instancetype)initWithexperience:(NSDictionary *)dict{
    if (self) {
    _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
    _logo = [Utilities nullAndNilCheck:dict[@"logo"] replaceBy:@""];
    _Price = [Utilities nullAndNilCheck:dict[@"price"] replaceBy:@""];
    _sellNumber = [Utilities nullAndNilCheck:dict[@"sellNumber"] replaceBy:@""];
    _categoryName = [Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@""];
    _experienceId = [Utilities nullAndNilCheck:dict[@"experienceId"] replaceBy:@""];
    }
    return self;
}



-(instancetype)initWithPhoto:(NSDictionary *)dict{
    _imgurl = [Utilities nullAndNilCheck:dict[@"imgurl"] replaceBy:@""];
    return self;
}
@end
