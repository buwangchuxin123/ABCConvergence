//
//  HomeModel.h
//  Convergence
//
//  Created by admin001 on 2017/9/4.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
@property(strong,nonatomic)NSArray *hotArr;//热门会所编号数组
@property(strong,nonatomic)NSArray *upgradedArr;//热门城市编号数组
//体验劵
@property(strong,nonatomic)NSString *experienceId;//体验劵id
@property(strong,nonatomic)NSString *logo;//体验券图片地址
@property(strong,nonatomic)NSString *name;//体验券名称
@property(strong,nonatomic)NSString *orginPrice;//体验券原价 60
//@property(strong,nonatomic)NSString *Price;//体验券价格 1
@property(strong,nonatomic)NSString *sellNumber;//体验券售出数量
//会所
@property(strong,nonatomic)NSString *address;//地址
@property(strong,nonatomic)NSString *distance;//距离
@property(strong,nonatomic)NSString *clubID;//会所id
@property(strong,nonatomic)NSString *Image;//会所图片地址
@property(strong,nonatomic)NSString *clubName;//会所名字
-(instancetype)initWithExperience:(NSDictionary *)dict;
-(instancetype)initWithClub:(NSDictionary *)dict;
@end
