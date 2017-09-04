//
//  UserModel.h
//  Convergence
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (strong ,nonatomic) NSString *memberId;           //id
@property (strong ,nonatomic) NSString *phone;            //电话
@property (strong ,nonatomic) NSString *nickname;        //姓名
@property (strong ,nonatomic) NSString *age;            //年龄
@property (strong ,nonatomic) NSString *dob;           //出生日期
@property (strong ,nonatomic) NSString *idCardNo;
@property (strong ,nonatomic) NSString *gender;      //性别
@property (strong ,nonatomic) NSString *avatarUrl;  //头像
@property (strong ,nonatomic) NSString *tokenKey;  //钥匙
@property (strong ,nonatomic) NSString *credit;   //积分
- (id) initWhitDictionary: (NSDictionary *)dict;

@end
