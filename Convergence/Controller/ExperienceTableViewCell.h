//
//  ExperienceTableViewCell.h
//  Convergence
//
//  Created by admin001 on 2017/9/4.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExperienceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *experLab;
@property (weak, nonatomic) IBOutlet UILabel *comLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;

@end
