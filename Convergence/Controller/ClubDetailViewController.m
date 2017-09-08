//
//  ClubDetailViewController.m
//  Convergence
//
//  Created by admin001 on 2017/9/7.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "ClubDetailViewController.h"
#import "eDetailTableViewCell.h"
#import "ClubDetailModel.h"
@interface ClubDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *clubName;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
- (IBAction)addressBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *memberLab;
@property (weak, nonatomic) IBOutlet UILabel *placeLab;
@property (weak, nonatomic) IBOutlet UILabel *coachLab;
@property (weak, nonatomic) IBOutlet UITextView *clubIntrodutioanView;
@property (weak, nonatomic) IBOutlet UITableView *experienceTableView;
@property (strong, nonatomic)UIActivityIndicatorView * avi;
@property (strong,nonatomic)ClubDetailModel *Model;
@property (strong,nonatomic)NSMutableArray *arr;
@end

@implementation ClubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self netRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
    //设置标题文字
    self.navigationItem.title = @"会所信息";
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

- (void)netRequest{
    //[_avi stopAnimating];
    NSDictionary *para = @{@"clubKeyId":@(_home.clubID)};
    [RequestAPI requestURL:@"/clubController/getClubDetails" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObject:%@", responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            NSDictionary *result = responseObject[@"result"];
           _Model  = [[ClubDetailModel alloc]initWithClubDetail:result];
            
            NSArray *array = result[@"experienceInfos"];
            for(NSDictionary *dict in array)
            {
                ClubDetailModel *model = [[ClubDetailModel alloc]initWithExper:dict];
                [_arr addObject:model];
                NSLog(@"dondong:%@",model.eName);
            }
            [self uiLaout];
            [_experienceTableView reloadData];
          //  NSArray *clubDetail =@[result];
     //       _home = [HomeModel alloc];
        }else{//业务逻辑失败的情况下
    NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
-(void)uiLaout{
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:_Model.clubLogo]placeholderImage:[UIImage imageNamed:@"clubLogo"]];
    _clubName.text = _Model.clubName;
    [_addressBtn setTitle:_Model.clubAddress forState:UIControlStateNormal];
    _timeLab.text = _Model.clubTime;
    _memberLab.text = _Model.clubMember;
    _placeLab.text =_Model.clubSite;
    _coachLab.text = _Model.clubPerson;
    _clubIntrodutioanView.text = _Model.clubIntroduce;
   // NSString *timeStr = [Utilities dateStrFromCstampTime:_Model.clubTime withDateFormat:@"HH:mm~HH:mm"];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"个数：%lu",(unsigned long)_arr.count);
    return _arr.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    eDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eExperienceCell" forIndexPath:indexPath];
   ClubDetailModel *model = _arr[indexPath.row];
   NSURL *url = [NSURL URLWithString:model.eLogo];
    [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认"]];
   cell.name.text = model.eName;
    NSLog(@"ename:%@",model.eName);
    NSArray *array = _home.experience;
    NSDictionary *dict = array[indexPath.row];
  
    cell.type.text = [dict[@"categoryName"] isKindOfClass:[NSNull class]]?@"综合券":dict[@"categoryName"];
    
    cell.price.text =[NSString stringWithFormat:@"%@元", model.price];
   cell.count.text = [NSString stringWithFormat:@"已售:%@",model.salaCount];
    return cell;
    
    
    
}




- (IBAction)addressBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)callBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
