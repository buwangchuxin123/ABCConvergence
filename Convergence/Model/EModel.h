//
//  EModel.h
//  Convergence
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EModel : NSObject
@property (strong,nonatomic)NSString *beginDate;
@property(strong,nonatomic)NSString *endDate;
@property(strong,nonatomic)NSString *userTime;
@property(strong,nonatomic)NSString *clubTel;
@property(strong,nonatomic)NSString *currentPrice;
@property(strong,nonatomic)NSString *orginPrice;
@property(strong,nonatomic)NSString *eName;
@property(strong,nonatomic)NSString *clubName;
@property(strong,nonatomic)NSString *eLogo;
@property(strong,nonatomic)NSString *latitude;
@property(strong,nonatomic)NSString *longitude;
@property(strong,nonatomic)NSString *rules;
@property(strong,nonatomic)NSString *saleCount;
@property(strong,nonatomic)NSString  * eAddress;
@property(strong,nonatomic)NSString  * ePromot;
-(instancetype)initWithexperience:(NSDictionary *)dict;


@end
