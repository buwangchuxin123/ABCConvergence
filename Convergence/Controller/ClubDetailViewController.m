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
@property (strong,nonatomic)NSArray *arr1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger refreshTag;

@end

@implementation ClubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [self naviConfig];
  //  [self introduceViewHeight];
    
    [self setRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
   //[self introduceViewHeight];
     [self initilizedata];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //在其他离开该页面的方法同样加上下面代码
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
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

- (void)setRefreshControl{
    
    UIRefreshControl *acquireRef = [UIRefreshControl new];
    [acquireRef addTarget:self action:@selector(acquireRef) forControlEvents:UIControlEventValueChanged];
    acquireRef.tag = 10001;
   [self.scrollView addSubview:acquireRef];
    
    
}
- (void)acquireRef{
    
    [self netRequest];
}

-(void)initilizedata{
    _avi = [Utilities getCoverOnView:self.view];
    [self netRequest];

}

- (void)netRequest{
    //[_avi stopAnimating];
    NSString *ClubId = [[StorageMgr singletonStorageMgr]objectForKey:@"clubId"];
    NSDictionary *para = @{@"clubKeyId":ClubId};
    [RequestAPI requestURL:@"/clubController/getClubDetails" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
      //  NSLog(@"responseObject:%@", responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[self.scrollView viewWithTag:10001];
        [ref endRefreshing];

        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            NSDictionary *result = responseObject[@"result"];
           _Model  = [[ClubDetailModel alloc]initWithClubDetail:result];
            
            NSArray *array = result[@"experienceInfos"];
            //清空数组
            [_arr removeAllObjects];
            for(NSDictionary *dict in array)
            {
                ClubDetailModel *model = [[ClubDetailModel alloc]initWithExper:dict];
                [_arr addObject:model];
               // NSLog(@"dondong:%@",model.eName);
            }
            
             [self uiLaout];
             [self introduceViewHeight];
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
        UIRefreshControl *ref = (UIRefreshControl *)[self.scrollView viewWithTag:10001];
        [ref endRefreshing];

    }];
}
-(void)uiLaout{
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:_Model.clubLogo]placeholderImage:[UIImage imageNamed:@"clubLogo"]];
    _clubName.text = _Model.clubName;
    [_addressBtn setTitle:_Model.clubAddress forState:UIControlStateNormal];
     _addressBtn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    _timeLab.text = _Model.clubTime;
    _memberLab.text = _Model.clubMember;
    _placeLab.text =_Model.clubSite;
    _coachLab.text = _Model.clubPerson;
    
    _clubIntrodutioanView.text = _Model.clubIntroduce;
   // NSString *timeStr = [Utilities dateStrFromCstampTime:_Model.clubTime withDateFormat:@"HH:mm~HH:mm"];
    
    
}

-(void)introduceViewHeight{
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 30, 1000);
    //拿的已经显示在textView上的高度
    CGSize contentSize = [_clubIntrodutioanView.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_clubIntrodutioanView.font} context:nil].size;
    //将文字内容的尺寸给textView高度约束
    _introduceHeight.constant = contentSize.height + 36;
    //NSLog(@"内容高度是：%f",contentSize.height);
    _viewHeight.constant =_introduceHeight.constant + 10;
   
   /*
    _introduceHeight.constant = _clubIntrodutioanView.contentSize.height + 16;
    NSLog(@"内容高度是：%f",_clubIntrodutioanView.contentSize.height);
    _viewHeight.constant = _clubIntrodutioanView.contentSize.height + 25;
  */
   // _viewHeight.constant = 230.f;
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
   // NSLog(@"个数：%lu",(unsigned long)_arr.count);
    return _arr.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 100.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    eDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eExperienceCell" forIndexPath:indexPath];
    _tableviewHeight.constant = _arr.count * 100;
   ClubDetailModel *model = _arr[indexPath.row];
   NSURL *url = [NSURL URLWithString:model.eLogo];
    [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认"]];
   cell.name.text = model.eName;
   // NSLog(@"ename:%@",model.eName);
   // NSArray *array = _home.experience;
  //  NSDictionary *dict = array[indexPath.row];
  
  //  cell.type.text = [dict[@"categoryName"] isKindOfClass:[NSNull class]]?@"综合券":dict[@"categoryName"];
    cell.type.text = @"综合券";
    cell.price.text =[NSString stringWithFormat:@"%@元", model.price];
    cell.count.text = [NSString stringWithFormat:@"已售:%@",model.salaCount];
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClubDetailModel *model = _arr[indexPath.row];
    [[StorageMgr singletonStorageMgr]addKey:@"eId" andValue:model.eId];
}


- (IBAction)addressBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    [[StorageMgr singletonStorageMgr]addKey:@"weidu" andValue:_Model.wei];
    [[StorageMgr singletonStorageMgr]addKey:@"jingdu" andValue:_Model.jing];
    [[StorageMgr singletonStorageMgr]addKey:@"clubName" andValue:_Model.clubName];
    [[StorageMgr singletonStorageMgr]addKey:@"clubAddress" andValue:_Model.clubAddress];
}
- (IBAction)callBtn:(UIButton *)sender forEvent:(UIEvent *)event {

//    //配置电话APP的路径，并将要拨打的号码组合到路径中
  // NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_Model.clubTel];
//    NSURL *targetAppUrl = [NSURL URLWithString:targetAppStr];
//    //从当前APP跳转到其他指定的APP中
//    [[UIApplication sharedApplication] openURL:targetAppUrl];
    NSString *string = _Model.clubTel;
    //按逗号截取字符串
    _arr1 = [string componentsSeparatedByString:@","];
    //创建一个从底部弹出的弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:_arr1[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_arr1[0]];
            UIWebView *callWebview =[[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];

        }];
            [alert addAction:actionA];
    
    if (_arr1.count == 2) {
        UIAlertAction *actionB = [UIAlertAction actionWithTitle:_arr1[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_arr1[1]];
            UIWebView *callWebview =[[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            
        }];
        [alert addAction:actionB];
    }
    UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:actionC];
    // 由于它是一个控制器 直接modal出来就好了
    [self presentViewController:alert animated:YES completion:nil];
    
  
}
@end
