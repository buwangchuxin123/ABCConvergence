//
//  SettingViewController.m
//  Convergence
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "SettingViewController.h"
#import "SetUpTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserModel.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *setupImage;
- (IBAction)modificationBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *modificationBtn;
@property (weak, nonatomic) IBOutlet UITableView *SetUpTableView;
@property (strong, nonatomic) NSMutableArray *setupArr;
@property (strong,nonatomic) UIActivityIndicatorView *avi;
@property (strong,nonatomic)UserModel *user;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    //  _setupArr = [[NSMutableArray alloc]initWithObjects:@{@"nicknameLabel":@"昵称",@"infoLabel":_user.nickname},@{@"nicknameLabel":@"性别",@"infoLabel":_user.gender},@{@"nicknameLabel":@"生日",@"infoLabel":_user.dob},@{@"nicknameLabel":@"身份证号码",@"infoLabel":_user.idCardNo}, nil];
    if ([Utilities loginCheck]) {
        //已登录
        
        _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        NSLog(@"是：%@",_user.dob);
        _setupArr = [[NSMutableArray alloc]initWithObjects:@{@"nicknameLabel":@"昵称",@"infoLabel":_user.nickname},@{@"nicknameLabel":@"性别",@"infoLabel":_user.gender},@{@"nicknameLabel":@"生日",@"infoLabel":_user.dob},@{@"nicknameLabel":@"身份证号码",@"infoLabel":_user.idCardNo}, nil];
        [_setupImage sd_setImageWithURL:[NSURL URLWithString:_user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_user_head"]];
        
        
        
        
    }else{
          _setupImage.image=[UIImage imageNamed:@"ic_user_head"];
        
    }
    
    _SetUpTableView.tableFooterView = [UIView new];
    [self setFootViewForTableView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


-(void)naviConfig{
    self.navigationItem.title = @"设置";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(20, 124, 236);
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

//用Model的方式返回上一页
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//设置表格视图一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _setupArr.count;
}


//设置表格视图中每一组由多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetUpTableViewCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _setupArr[indexPath.section];
    
    cell.nicknameLabel.text = dict[@"nicknameLabel"];
    cell.infoLabel.text = dict[@"infoLabel"];
    return cell;
}

//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1.f;
    
}
//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消细胞的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"setting2nick" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"setting2gender" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"settingdob" sender:self];
            break;
        default:
            [self performSegueWithIdentifier:@"setting2IdNum" sender:self];
            break;
    }
}

//设置tableview的底部视图
- (void)setFootViewForTableView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 300)];
    view.backgroundColor = UIColorFromRGB(240, 235, 245);
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exitBtn.frame = CGRectMake(0, 30, UI_SCREEN_W, 40.f);
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    //设置按钮标题的字体大小
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [exitBtn setTitleColor:UIColorFromRGB(225.f, 0.f, 0.f) forState:UIControlStateNormal];
    exitBtn.backgroundColor = [UIColor whiteColor];
    [exitBtn addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:exitBtn];
    
    [_SetUpTableView setTableFooterView:view];
}
//按钮的点击事件
- (void)exitAction: (UIButton *)button{
    //NSLog(@"%@", @"退出");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self exit];
    }];
    UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionA];
    [alert addAction:actionB];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)exit{
    [self dismissViewControllerAnimated:YES completion:nil];
    /*UINavigationController *SignNavi=[Utilities getStoryboardInstance:@"SetUp" byIdentity:@"SignNavi"];
     [self presentViewController:SignNavi animated:YES completion:nil];*/
}

//设置组的底部视图颜色为透明
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (IBAction)modificationBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
