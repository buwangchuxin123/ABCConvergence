//
//  NickNameViewController.m
//  Convergence
//
//  Created by admin on 2017/9/13.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "NickNameViewController.h"
#import "UserModel.h"
#import "SetUpTableViewCell.h"
#import "SettingViewController.h"
@interface NickNameViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nickTextField;
@property (strong,nonatomic)UserModel *user;
@property (strong,nonatomic) UIActivityIndicatorView *avi;



@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    // Do any additional setup after loading the view.
    _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    _nickTextField.text=_user.nickname;
    [self setTextFieldLeftPadding:_nickTextField forWidth:15];
//    UIButton *button = [_nickTextField valueForKey:@"_clearButton"];
//    [button setImage:[UIImage imageNamed:@"CHA"] forState:UIControlStateNormal];
//    _nickTextField.clearButtonMode = UITextFieldViewModeAlways;
//     button.frame = CGRectMake(UI_SCREEN_W-60, UI_SCREEN_H-60, 120, 20);
//     [_nickTextField addSubview: button];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [_nickTextField becomeFirstResponder];

}
// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 100, 255);
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
-(void)save{
    NSString * nc  = _nickTextField.text;
   // [[StorageMgr singletonStorageMgr]addKey:@"NC" andValue:nc];
    
    _avi=[Utilities getCoverOnView:self.view];
    
    //NSLog(@"%@",_user.nickname);
    
    NSDictionary *para = @{@"memberId":_user.memberId,@"name":nc};
    [RequestAPI requestURL:@"/mySelfController/updateMyselfInfos" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObject:%@",responseObject);
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            //     NSDictionary *result= responseObject[@"result"];
            NSNotification *note = [NSNotification notificationWithName:@"refresh" object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
            [Utilities popUpAlertViewWithMsg:@"修改昵称成功" andTitle:nil onView:self];
            //延迟0.5秒返回上一页
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
           //[Utilities popUpAlertViewWithMsg:@"修改昵称成功" andTitle:nil onView:self];
           // [self dismissViewControllerAnimated:YES completion:nil];
              });
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络请求失败😂" andTitle:nil onView:self];
    }];
    
}
//文本框左侧空出一定的间距
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
//    UIView *rightview = [[UIView alloc]initWithFrame:frame];
//    textField.rightViewMode = UITextFieldViewModeAlways;
//    textField.rightView =rightview;
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
