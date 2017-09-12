//
//  OrderModel.m
//  Convergence
//
//  Created by admin on 2017/9/12.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
-(instancetype)initWithOrder:(NSDictionary *)dict{
    self = [super self];
    if(self){
    _imgUrl = [Utilities nullAndNilCheck:dict[@"imgUrl"] replaceBy:@""];
    _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@""];
    _productName = [Utilities nullAndNilCheck:dict[@"productName"] replaceBy:@""];
    _shouldpay = [Utilities nullAndNilCheck:dict[@"shouldpay"] replaceBy:@""];
    }
    return self;
}
@end
//@interface OrderModel : NSObject
//@property(strong,nonatomic)NSString *cardId;
//@property(strong,nonatomic)NSString *cardName;
//@property(strong,nonatomic)NSString *imgUrl;
//@property(strong,nonatomic)NSString *orderId;
//@property(strong,nonatomic)NSString *orderNum;
//@property(strong,nonatomic)NSString *productName;
//@property(strong,nonatomic)NSString *clubName;
