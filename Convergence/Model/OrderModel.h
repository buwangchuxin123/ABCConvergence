//
//  OrderModel.h
//  Convergence
//
//  Created by admin on 2017/9/12.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property(strong,nonatomic)NSString *cardId;
@property(strong,nonatomic)NSString *cardName;
@property(strong,nonatomic)NSString *imgUrl;
@property(strong,nonatomic)NSString *orderId;
@property(strong,nonatomic)NSString *orderNum;
@property(strong,nonatomic)NSString *productName;
@property(strong,nonatomic)NSString *clubName;
@property(strong,nonatomic)NSString *shouldpay;
-(instancetype)initWithOrder:(NSDictionary *)dict;

@end