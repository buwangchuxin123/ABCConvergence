//
//  MyOrderTableViewCell.h
//  Convergence
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *OrderImageView;
@property (weak, nonatomic) IBOutlet UILabel *OrderName;
@property (weak, nonatomic) IBOutlet UILabel *clubName;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
