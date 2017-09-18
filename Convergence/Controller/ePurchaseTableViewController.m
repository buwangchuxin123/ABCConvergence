//
//  ePurchaseTableViewController.m
//  Convergence
//
//  Created by admin on 2017/9/11.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "ePurchaseTableViewController.h"
#import "ePayTableViewCell.h"
@interface ePurchaseTableViewController (){
    NSInteger flag;
}

@property (weak, nonatomic) IBOutlet UILabel *clubName;
@property (weak, nonatomic) IBOutlet UILabel *useClub;
@property (weak, nonatomic) IBOutlet UILabel *singlePrice;
@property (weak, nonatomic) IBOutlet UILabel *Number;
@property (weak, nonatomic) IBOutlet UIStepper *addUIStepper;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (strong,nonatomic)NSArray *arr;
@property (nonatomic)NSString *sum;
- (IBAction)addNumAction:(UIStepper *)sender forEvent:(UIEvent *)event;


@end

@implementation ePurchaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [[NSArray alloc]initWithObjects:@"支付宝支付",@"微信支付",@"银联支付", nil];
    [self uiLayout];
    [self naviconfig];
     self.tableView.tableFooterView = [UIView new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //注册一个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResultAction:) name:@"AlipayResult" object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviconfig{

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"支付" style:UIBarButtonItemStylePlain target:self action:@selector(payAction)];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)uiLayout{
    
    //将表格视图设置为“编辑中”
    self.tableView.editing = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表格视图的某个细胞
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    _clubName.text = _Model.eName;
    _useClub.text = [NSString stringWithFormat:@"用于 %@",_Model.clubName];
    _singlePrice.text = [NSString stringWithFormat:@"单价：%@元",_Model.currentPrice];
    _Number.text = @"1";
    _price.text = [NSString stringWithFormat:@"%@元",_Model.currentPrice];
    
}
-(void)payAction{
    switch (self.tableView.indexPathForSelectedRow.row) {
        case 0:{
            NSString *tradeNo = [GBAlipayManager generateTradeNO];
            [GBAlipayManager alipayWithProductName:_Model.eName amount:_sum tradeNO:tradeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@购买费",_Model.eName] itBPay:@"30"];
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }


}


-(void)purchaseResultAction:(NSNotification *)note{
    NSString *result = note.object;
    if ([result isEqualToString:@"9000"]) {
        //成功
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"支付成功" message:@"恭喜您，你已成功完成报名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        //失败
        [Utilities popUpAlertViewWithMsg:[result isEqualToString:@"4000"] ? @"未能成功支付，请保持账户余额充足" : @"您已取消支付" andTitle:@"支付失败" onView:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ePayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"forIndexPath:indexPath];
    cell.payType.text = _arr[indexPath.row];
    // Configure the cell...
    
    return cell;
}
//设置每一组中每一行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

//设置组的头标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"支付方式";
}
//按住细胞以后（取消选择）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"flag:%ld",(long)flag);
    if (indexPath.row != flag) {
        flag = indexPath.row;
        //遍历表格视图中所有选中状态下的细胞
        for (NSIndexPath *eschIP in tableView.indexPathsForSelectedRows) {
            //当选中的细胞不是当前正在按得这个细胞的情况下
            if (eschIP != indexPath) {
                //将细胞从选中状态改为不选中状态
                [tableView deselectRowAtIndexPath:eschIP animated:YES];
            }
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"flag11:%ld",(long)flag);
    if (indexPath.row == flag) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
}/*
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

- (IBAction)addNumAction:(UIStepper *)sender forEvent:(UIEvent *)event {
    _Number.text = [NSString stringWithFormat:@"%g",sender.value];
    NSString *Number = [NSString stringWithFormat:@"%g",sender.value];
    NSInteger N=[Number integerValue];
    NSString *Price=[NSString stringWithFormat:@"%@元",_Model.currentPrice];
    float P =[Price floatValue];
    
    float sum1=N*P;
    _sum = [NSString stringWithFormat:@"%f",sum1];
    _price.text=[NSString stringWithFormat:@"%0.1f元",sum1];
   
}
@end
