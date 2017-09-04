//
//  ClubTableViewCell.h
//  Convergence
//
//  Created by admin001 on 2017/9/4.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopFrontImage;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;

@end
