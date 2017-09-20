//
//  MyInfoViewController.m
//  Convergence
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "MyInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserModel.h"
@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic)NSArray *arr;
@property(strong,nonatomic)NSString *string;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self uiLayout];
    [self dataInitialize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([Utilities loginCheck]){
        //已登录
        _loginBtn.hidden = YES;
        _usernameLabel.hidden = NO;
        
        UserModel *usermodel = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:usermodel.avatarUrl] placeholderImage:[UIImage imageNamed:@"Avatar"]];
       
      //  NSLog(@"ssss %@",usermodel.avatarUrl);
           _usernameLabel.text = usermodel.nickname;
    }else{
        //未登录
        _loginBtn.hidden = NO;
        _usernameLabel.hidden = YES;
        
        _avatarImageView.image = [UIImage imageNamed:@"Avatar"];
       // _usernameLabel.text = @"游客";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)uiLayout{
 _avatarImageView.layer.borderColor = [[UIColor lightGrayColor]CGColor];

}
-(void)dataInitialize{
    _arr =@[@{@"title":@"我的设置"},@{@"title":@"我的推广"},@{@"title":@"积分中心"},@{@"title":@"我的订单"},@{@"title":@"意见反馈"},@{@"title":@"关于我们"}];
}
//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
    NSDictionary *dict = _arr[indexPath.section];
    cell.textLabel.text = dict[@"title"];
        return cell;
}
//设置组的底部视图高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return 15.f;
//    }
//    return 0.f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}
//按住细胞以后（取消选择）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
        if ([Utilities loginCheck]) {
            // if (indexPath.section == 0)
         switch (indexPath.section){
                case 0:
                    [self performSegueWithIdentifier:@"MyInfo2Setting" sender:self];
                    
                    break;
                case 1:
                   [self performSegueWithIdentifier:@"MyInfo2Promote" sender:self];
                    break;
                case 2:[self netRequest1];
                    break;
                case 3:[self performSegueWithIdentifier:@"MyInfo2MyOrder" sender:self];
                    break;
                case 4: [self performSegueWithIdentifier:@"MyInfo2Feedback" sender:self];
                    break;
             default:[self performSegueWithIdentifier:@"MyInfo2About" sender:self];
                 
                    break;
                    
            }
        }
     else{
            UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Login" byIdentity:@"LoginNavi"];
            [self presentViewController:signNavi animated:YES completion:nil];
           }
    
}
-(void)netRequest1{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"] forKey:@"memberId"];
    [RequestAPI requestURL:@"/score/memberScore" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"resposeObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            NSString *integral = responseObject[@"result"];
            _string  =[NSString stringWithFormat:@"当前积分:%@",integral];
            [Utilities popUpAlertViewWithMsg:@"积分商城即将登录，准备好了吗，亲！" andTitle:_string onView:self];
            }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情
        NSLog(@"statusCode = %ld",(long)statusCode);
        
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //获取要跳转过去的那个页面
    UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Login" byIdentity:@"LoginNavi"];
    //执行跳转
    [self presentViewController:signNavi animated:YES completion:nil];
    

}
@end
