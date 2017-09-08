//
//  eDetailTableViewCell.h
//  Convergence
//
//  Created by admin001 on 2017/9/8.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *count;

@end
