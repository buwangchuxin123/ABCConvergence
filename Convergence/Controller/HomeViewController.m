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
#import "ClubDetailViewController.h"
#import "HomeModel.h"
#import "ZLImageViewDisplayView.h"
#import <CoreLocation/CoreLocation.h>//使用该框架才可以使用定位
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    //BOOL isLoding;//判断是不是在加载
   // BOOL firstVisit;
    BOOL flag;
    NSInteger pageNum;//页码
    NSInteger pageSize;//每页多少内容
    NSInteger totalPage;//多少页
    NSInteger firstPage;
    NSInteger isLastPage;
}
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong,nonatomic)UIActivityIndicatorView *avi;
@property (strong, nonatomic)NSString *cityName;
@property (strong, nonatomic)NSString *cityJing;
@property (strong, nonatomic)NSString *cityWei;
@property (strong, nonatomic)NSMutableArray *arr;
//@property (strong, nonatomic)NSMutableArray *arr2;
@property (strong, nonatomic)NSMutableArray *arr3;
@property (weak, nonatomic) IBOutlet UIView *CycleAdView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _cityName = @"无锡";
    _cityWei = @" 31.570000";
    _cityJing = @"120.300000";
    flag = YES;
    firstPage = 1;
    _arr = [NSMutableArray new];
    //_arr2 = [NSMutableArray new];
    _arr3 = [NSMutableArray new];
    [self switchAction];
    [self naviConfig];
    [self InitializeData];
    [self setRefreshControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
    self.navigationItem.title = @"首页";
    //设置导航条颜色
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 124, 236);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}
-(void) addZLImageViewDisPlayView:(NSArray *)arr{
    CGRect frame = CGRectMake(0,0, UI_SCREEN_W, 150);
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = arr;
    imageViewDisplay.scrollInterval = 3;
    imageViewDisplay.animationInterVale = 0.6;
    [_CycleAdView addSubview:imageViewDisplay];
    
}
//创建刷新指示器的方法
- (void)setRefreshControl{
    //已获取列表的刷新指示器
    UIRefreshControl *Ref = [UIRefreshControl new];
    [Ref addTarget:self action:@selector(Ref) forControlEvents:UIControlEventValueChanged];
    Ref.tag = 10001;
    [_homeTableView addSubview:Ref];
}
- (void)Ref{
    pageNum = 1;
    [self netRequest];
}
- (void)InitializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self netRequest];
}
//下拉刷新
- (void)refreshRequest{
    pageNum = 1;
    [self netRequest];
}

-(void)netRequest{
    NSDictionary *para =@{@"city":_cityName,@"jing":_cityJing,@"wei":_cityWei,@"page":@(pageNum),@"perPage":@"14"};
    //NSLog(@"para%@", para);
    [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
  // NSLog(@"responseObject:%@", responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[_homeTableView viewWithTag:10001];
        [ref endRefreshing];
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            NSDictionary*result = responseObject[@"result"];
            NSArray *advertisement =   responseObject[@"advertisement"];
            NSArray*models = result[@"models"];
            //NSArray *experience = result[@"models"][@"experience"];
            NSDictionary *pagingInfo = result[@"pagingInfo"];
            totalPage = [pagingInfo[@"totalPage"]integerValue];
            if (pageNum ==1) {
                //清空数据
                [_arr removeAllObjects];
               // [_arr2 removeAllObjects];
            }
            for (NSDictionary *dict3 in advertisement) {
                HomeModel *homeModel3 = [[HomeModel alloc]initWithPhoto:dict3];
                [_arr3 addObject:homeModel3.imgurl];
                //NSLog(@"图片地址是：%@",homeModel3.imgurl);
            }
            for (NSDictionary *dict in models) {
                HomeModel *homeModel = [[HomeModel alloc]initWithClub:dict];
                [_arr addObject:homeModel];
        }
//            for (NSDictionary *dict2 in experience) {
//                HomeModel*homeModel2 = [[HomeModel alloc]initWithexperience:dict2];
//                [_arr2 addObject:homeModel2];
//            }
              if (flag) {
                flag = NO;
                [self addZLImageViewDisPlayView:_arr3];
            }

            //刷新数据
            [self.homeTableView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
    return 220.f;
    }
    else{
        ExperienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"experienceCell"];
        HomeModel *homemodel = _arr[indexPath.section];
        CGSize maxSize = CGSizeMake(UI_SCREEN_W - 30, 1000);
        CGSize contentSize = [homemodel.name boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.experLab.font} context:nil].size;
        return contentSize.height + 144;
    }

    
}
//设置细胞有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie{
    //会所列表中所存会所的总数量，一个组代表一个会所信息
    return _arr.count;
}
//设置细胞有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //当前正在渲染的数组中的第section组
    HomeModel*homeModel=_arr[section];
    //Model中会所中的体验劵数量加第一行的会所（每组有多少行）
//    NSLog(@"数组的个数：%lu",(unsigned long)homeModel.experience.count);
//    for(NSDictionary *dict in homeModel.experience){
//       NSLog(@"东东%@",dict);
//    }
    return homeModel.experience.count + 1;
}
//设置细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据当前正在渲染的组的组号当做数组的下标，拿到对应的存在数组里Model
    HomeModel *homeModel = _arr[indexPath.section];
    if(indexPath.row == 0){
    //
    ClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clubCell" forIndexPath:indexPath];
        //将http请求的字符串转换为NSURL
        NSURL *URL1=[NSURL URLWithString:homeModel.Image];
        [cell.shopFrontImage sd_setImageWithURL:URL1 placeholderImage:[UIImage imageNamed:@"Home"]];
        cell.shopNameLab.text = homeModel.clubName;
        cell.addressLab.text = homeModel.address;
        cell.distanceLab.text = [NSString stringWithFormat:@"%@米",homeModel.distance];
        return cell;
    }
    else{
        //将homeModel里的体验劵添加到新建的experiences数组中
        NSArray *experiences = homeModel.experience;
//        for (NSDictionary *dict in experiences) {
//           // NSLog(@"dict = %@",dict.allValues);
//        }
        ExperienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"experienceCell" forIndexPath:indexPath];
        //行数减去第一行就是体验劵的数量并存在字典中
        NSDictionary *experience= experiences[indexPath.row-1];
        NSURL *URL2=[NSURL URLWithString:experience[@"logo"]];
        //NSLog(@"%@",URL2);
        [cell.leftImage sd_setImageWithURL:URL2 placeholderImage:[UIImage imageNamed:@"默认"]];
        cell.experLab.text =experience[@"name"];
        //NSLog(@"%@",homeModel.name);
        cell.comLab.text = [experience[@"categoryName"]isKindOfClass:[NSNull class]]?@"综合券":experience[@"categoryName"];
        cell.priceLab.text = [NSString stringWithFormat:@"%@元",experience[@"price"]];
        cell.numberLab.text = [NSString stringWithFormat:@"已售: %@",experience[@"sellNumber"]];
        return cell;
    }
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeModel *model = _arr[indexPath.section];
    NSString *Id =  [NSString stringWithFormat:@"%ld",model.clubID];
    //NSLog(@"id是：%@",Id);
    [[StorageMgr singletonStorageMgr] addKey:@"clubId" andValue:Id];
      if(indexPath.row == 0){
           [self performSegueWithIdentifier:@"clubToDetail" sender:nil];
    }else {
        NSArray *array = model.experience;
        NSDictionary *dict = array[indexPath.row-1];
        NSString *eId =  dict[@"id"];
        [[StorageMgr singletonStorageMgr] addKey:@"eId" andValue:eId];
    }
}
//细胞将要出现时调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断将要出现的细胞是不是当前最后一行
    if (indexPath.row == _arr.count - 1) {
        //当存在下一页的时候，页码自增，请求下一页数据
        if (firstPage < isLastPage) {
            firstPage ++;
            [self netRequest];
        }
    }
}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    //当从首页到详情页的这个跳转要发生的时候，获取要传递下一页的数据
//    if ([segue.identifier isEqualToString:@"clubToDetail"]) {
//        NSIndexPath *indexPath = [_homeTableView indexPathForSelectedRow];
//        HomeModel *home = _arr[indexPath.section];
//        //获取下一页的实例
//        ClubDetailViewController *detailVC = segue.destinationViewController;
//        //把数据给下一页预备好的接收容器
//        detailVC.home= home;
//    }
//}
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
