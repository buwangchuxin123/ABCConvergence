//
//  MyOrderTableViewController.m
//  Convergence
//
//  Created by admin1 on 2017/9/7.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "MyOrderTableViewController.h"
#import "MyOrderTableViewCell.h"
#import "OrderModel.h"
@interface MyOrderTableViewController ()
@property(strong,nonatomic)NSMutableArray *arr;
@property(strong,nonatomic)UIActivityIndicatorView *avi;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation MyOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self naviConfig];
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
    //设置标题文字
    self.navigationItem.title = @"我的订单";
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 124, 236);
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    
    
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    //为导航条左上角创建一个按钮
   // UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];UIBarButtonSystemItemStop
   // self.navigationItem.leftBarButtonItem = left;
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}
//网络请求
-(void)request{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para = @{@"memberId":[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"],@"type":@0};
    [RequestAPI requestURL:@"/orderController/orderList" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
       // NSLog(@"responseObject:%@",responseObject);
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSArray *array = responseObject[@"result"][@"orderList"];
            for(NSDictionary *dict in array){
                OrderModel *model = [[OrderModel alloc]initWithOrder:dict];
                [_arr addObject:model];
            }
             [_tableview reloadData];
        }
        
        else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //业务逻辑失败的情况下
    }];
    
   

}

#pragma mark - Table view data source
//设置每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.f;
}
//设置表格视图一共有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
  
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;//_arr.count;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor darkGrayColor];
    header.textLabel.font = [UIFont systemFontOfSize:13];
    header.contentView.backgroundColor = UIColorFromRGB(240, 239, 245);
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
       OrderModel *Model = _arr[section];
    NSString *upper = [Model.orderNum uppercaseString];
    NSString *string = [NSString stringWithFormat:@"订单号:%@",upper];
    return string;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"forIndexPath:indexPath];
    OrderModel *Model = _arr[indexPath.section];
    NSURL *url = [NSURL URLWithString: Model.imgUrl];
    [cell.OrderImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认"]];
    cell.OrderName.text = Model.productName;
    cell.clubName.text = Model.clubName;
    cell.price.text = [NSString stringWithFormat:@"%@元",Model.shouldpay];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
