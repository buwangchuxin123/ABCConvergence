//
//  HomeViewController.m
//  Convergence
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "HomeViewController.h"
#import "ClubTableViewCell.h"
#import "ExperienceTableViewCell.h"
#import "HomeModel.h"
@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self switchAction];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)switchAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSwitch" object:nil];
}

@end
