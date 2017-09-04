//
//  ActivityCell.h
//  Convergence
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 EDucation. All rights reserved.
//

@interface ActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityInfLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityUnlikeLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoBtn;
@end
