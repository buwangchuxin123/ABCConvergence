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
}

-(void)request{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para = @{@"memberId":[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"],@"type":@0};
    [RequestAPI requestURL:@"/orderController/orderList" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
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
    }];
    
   

}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"forIndexPath:indexPath];
    OrderModel *Model = _arr[indexPath.row];
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
