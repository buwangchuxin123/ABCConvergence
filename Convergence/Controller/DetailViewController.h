//
//  DetailViewController.h
//  Convergence
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"
@interface DetailViewController : UIViewController
//创建一个容器去接收别的页面传来的数据
@property (strong ,nonatomic) ActivityModel *activity;
@end
