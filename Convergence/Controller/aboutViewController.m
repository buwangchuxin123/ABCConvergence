//
//  aboutViewController.m
//  Convergence
//
//  Created by admin001 on 2017/9/12.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "aboutViewController.h"

@interface aboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secendLab;

@end

@implementation aboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _firstLab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:55];
    _secendLab.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:55];
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

@end
