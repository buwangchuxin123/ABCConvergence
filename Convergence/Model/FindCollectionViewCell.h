//
//  FindCollectionViewCell.h
//  Convergence
//
//  Created by admin on 2017/9/3.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *clubImage;
@property (weak, nonatomic) IBOutlet UILabel *clubName;
@property (weak, nonatomic) IBOutlet UILabel *clubDistance;
@property (weak, nonatomic) IBOutlet UILabel *clubAddress;

@end
