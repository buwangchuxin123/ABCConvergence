//
//  FindModel.h
//  Convergence
//
//  Created by admin on 2017/9/3.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject
@property(strong,nonatomic)NSArray *hotArr;//热门会所编号数组
@property(strong,nonatomic)NSArray *upgradedArr;//热门城市编号数组

//体验券
@property(strong,nonatomic)NSString *experienceId;//体验券id
@property(strong,nonatomic)NSString *logo;//体验券图片地址
@property(strong,nonatomic)NSString *name;//体验券名称
@property(strong,nonatomic)NSString *orginPrice;//体验券原价 60
@property(strong,nonatomic)NSString *Price;//体验券价格 1
@property(strong,nonatomic)NSString *sellNumber;//体验券售出数量
//会所
@property(strong,nonatomic)NSString *address;//地址
@property(strong,nonatomic)NSString *distance;//距离
@property(strong,nonatomic)NSString *clubID;//会所id
@property(strong,nonatomic)NSString *Image;//会所图片地址
@property(strong,nonatomic)NSString *clubName;//会所名字
@property(strong,nonatomic)NSString *clubLogo;//会所图片地址
//筛选类型
@property(strong,nonatomic)NSString *fId;//健身类型id
@property(strong,nonatomic)NSString *fName;//健身类型名称
@property(strong,nonatomic)NSString *total;//包含该健身类型的健身会所数量


-(instancetype)initWithArr:(NSDictionary *)dict;
-(instancetype)initWithClub:(NSDictionary *)dict;
-(instancetype)initWithType:(NSDictionary *)dict;
@end
