//
//  UserModel.h
//  Convergence
//
//  Created by admin001 on 2017/9/4.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (strong, nonatomic)NSString *memberId;
@property (strong, nonatomic)NSString *phone;
@property (strong, nonatomic)NSString *nickname;
@property (strong, nonatomic)NSString *age;
@property (strong, nonatomic)NSString *dob;
@property (strong, nonatomic)NSString *idCardNo;
@property (strong, nonatomic)NSString *gender;
@property (strong, nonatomic)NSString *avatarUrl;
@property (strong, nonatomic)NSString *credit;
@property (strong, nonatomic)NSString *tokenKey;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
