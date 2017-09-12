//
//  FindViewController.m
//  Convergence
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "FindViewController.h"
#import "FindCollectionViewCell.h"
#import "FindModel.h"
#import "SortTableViewCell.h"
#import "ClubDetailViewController.h"
@interface FindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>{
    NSInteger  flag;
    NSInteger pageNum;
    NSInteger totalPage;
    BOOL isLast;
    
    NSInteger pageSize;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *kindBtn;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
@property (weak, nonatomic) IBOutlet UIView *membraneView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightConstraint;
- (IBAction)CityAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)KindAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)DistanceAction:(UIButton *)sender forEvent:(UIEvent *)event;



@property (strong,nonatomic)UIActivityIndicatorView *avi;
@property (strong,nonatomic)NSMutableArray *ClubArr;
@property (strong,nonatomic)NSMutableArray *TypeArr;
@property (strong,nonatomic)NSArray *CityArr;
@property (strong,nonatomic)NSMutableArray  *KindArr;
@property (strong,nonatomic)NSArray *DistanceArr;
@property (strong,nonatomic)NSString *distance;
@property (strong,nonatomic)NSString *kindId;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _ClubArr = [NSMutableArray new];
    _TypeArr  = [NSMutableArray new];
   
    _CityArr = [[NSArray alloc]initWithObjects:@"全城",@"距离我1KM",@"距离我2KM",@"距离我3KM",@"距离我5KM",nil];
    _DistanceArr = [[NSArray alloc]initWithObjects:@"按距离",@"按人气", nil];
    // Do any additional setup after loading the view.
    //禁止被选中
  //  _collectionView.allowsSelection = NO;
    pageNum = 1;
    pageSize = 10;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView)];
    //监听名为@"refreshHome"的通知，监听到后执行refreshHome方法
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHome) name:@"refreshHome" object:nil];
     tapGesture.delegate = self;
    [self.membraneView addGestureRecognizer:tapGesture];
    [self setRefreshControl];
    [self naviConfig];
    //[self dataInitialize];
}
//- (void)refreshHome{
//    [self ClubRequest];
//  
//}

- (void)viewWillAppear:(BOOL)animated{
   [self dataInitialize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationItem.title = @"发现";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(20, 124, 236);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}

-(void)clickView{
    _membraneView.hidden = YES;
    //NSLog(@"view 被点击了");

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.tableView]) {
      //  NSLog(@"手势被中断了");
        return NO;
        
     }
    return YES;
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(flag == 1){
        return _CityArr.count;
    }
    if(flag == 2){
    return _KindArr.count;
    }
    if(flag == 3){
        return _DistanceArr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    if(flag == 1){
        cell.kindLbl.text = _CityArr[indexPath.row];
    }
    if(flag == 2){
        cell.kindLbl.text = _KindArr[indexPath.row];
       
            }
    if(flag == 3){
         cell.kindLbl.text = _DistanceArr[indexPath.row];
    }
    return cell;
   
}
//设置每一组中每一行被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(flag == 1){
        if(indexPath.row == 0){
            [self ClubRequest];//默认按距离请求
        }
        if(indexPath.row == 1){
            _distance = @"1000";
            [self KMClubRequest];
        }
        if(indexPath.row == 2){
            _distance = @"2000";
            [self KMClubRequest];
        }
        if(indexPath.row == 3){
            _distance = @"3000";
            [self KMClubRequest];
        }
        if(indexPath.row == 4){
            _distance = @"5000";
            [self KMClubRequest];
        }
        

           }
    if(flag == 2){
        
        if(indexPath.row == 0){
            [self ClubRequest];
        }
        if(indexPath.row == 1){
            _kindId = @"1";
            [self KindClubRequest];
        }
        if(indexPath.row == 2){
            _kindId = @"2";
            [self KindClubRequest];
        }
        if(indexPath.row == 3){
            _kindId = @"3";
            [self KindClubRequest];
        }
        if(indexPath.row == 4){
            _kindId = @"4";
            [self KindClubRequest];
        }

    }
    if(flag == 3){
        if(indexPath.row == 0){
            [self ClubRequest];
        }
        if(indexPath.row == 1){
            [self TypeClubRequest];
        }
        

    }

}


#pragma mark - collectionView
//每组有多少个items
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _ClubArr.count;
}
//每个items长什么样
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FindCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    FindModel *model = _ClubArr[indexPath.item];
    cell.clubName.text = model.clubName;
    cell.clubAddress.text = model.address;
    cell.clubDistance.text = [NSString stringWithFormat:@"%@米",model.distance];
    NSURL *URL = [NSURL URLWithString:model.Image];
    [cell.clubImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"默认"]];
//
    
//    //未选中时cell的背景视图
//    UIView *bv = [UIView new];
//    bv.backgroundColor = [UIColor blueColor];
//    cell.backgroundView = bv;
     // 选中时cell的背景视图
    UIView *sbv = [UIView new];
    sbv.backgroundColor = UIColorFromRGB(192, 192, 192);
    cell.selectedBackgroundView = sbv;
    return cell;
}
//设置每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_W - 5)/2,185);
}
//最小的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
    
}
////多少组
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 10;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setRefreshControl{
   
    UIRefreshControl *acquireRef = [UIRefreshControl new];
    [acquireRef addTarget:self action:@selector(acquireRef) forControlEvents:UIControlEventValueChanged];
       acquireRef.tag = 10001;
    [_collectionView addSubview:acquireRef];
    
}
//会所列表下拉刷新事件
- (void)acquireRef{
     pageNum = 1;
    if(flag == 1){
       // _distance = @"5000";
        
      [self KMClubRequest];
        return;
    }
    if(flag == 2){
        [self KindClubRequest];
        return;
    }
    if(flag == 3){
        [self TypeClubRequest];
        return;
    }else{
        [self ClubRequest];
    }
}
//细胞将要出现时调用
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row == _ClubArr.count -1){
        if(pageNum != totalPage){
            pageNum ++;
            if(flag == 1){
                [self KMClubRequest];
                return;
            }
            if(flag == 2){
                [self KindClubRequest];
                return;
            }
            if(flag == 3){
                [self TypeClubRequest];
                return;
            }
            else{
            [self ClubRequest];
            NSLog(@"不是最后一页");
            }
        }
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FindModel *model = _ClubArr[indexPath.row];
    NSString *clubId = model.clubID;
    [[StorageMgr singletonStorageMgr] addKey:@"clubId" andValue:clubId];
    
   ClubDetailViewController  *controller = [Utilities getStoryboardInstance:@"Home" byIdentity:@"Detail"];
    [self.navigationController pushViewController:controller animated:YES];
   // [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - request
-(void)dataInitialize{
    // [self hotRequest];
    [self TypeRequest];
}
//请求健身类型ID
- (void)TypeRequest{
    
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡"};
    [RequestAPI requestURL:@"/clubController/getNearInfos" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
      // NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *features = responseObject[@"result"][@"features"];
            NSArray *featureForm = features[@"featureForm"];
            for(NSDictionary *dict in featureForm){
                FindModel *model = [[FindModel alloc]initWithType:dict];
                [_TypeArr addObject:model];
                //    NSLog(@"数组里的是：%@",model.fName);
              }
               [_KindArr removeAllObjects];
             _KindArr  = [[NSMutableArray alloc]initWithObjects:@"全部分类", nil];
               for(int i = 0; i < 4;i++){
                FindModel *model = _TypeArr[i];
                [_KindArr addObject:model.fName];
            }
            
            //[_tableView reloadData];
            [self ClubRequest];
            
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
//默认按距离请求数据
- (void)ClubRequest{
      _membraneView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
    // NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            
            if(pageNum == 1){
                [_ClubArr removeAllObjects];
            }
            for(NSDictionary *dict in array){
                FindModel *model = [[FindModel alloc]initWithClub:dict];
                [_ClubArr addObject:model];
                
              }
            
            [_collectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
    
}
//请求n千米范围内的会所
- (void)KMClubRequest{
    _membraneView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"distance":_distance};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
      //  NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            
            if(pageNum == 1){
                [_ClubArr removeAllObjects];
            }

            for(NSDictionary *dict in array){
                FindModel *model = [[FindModel alloc]initWithClub:dict];
                
                [_ClubArr addObject:model];
               // NSLog(@"数组里的是%@",model);
                
             }
            NSLog(@"按%@米请求",_distance);
            [_collectionView reloadData];
            
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
//按种类请求会所
- (void)KindClubRequest{
    _membraneView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"featureId":_kindId};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //  NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            if(pageNum == 1){
                [_ClubArr removeAllObjects];
            }

            for(NSDictionary *dict in array){
                FindModel *model = [[FindModel alloc]initWithClub:dict];
                
                [_ClubArr addObject:model];
                
            }
            [_collectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}

//按人气请求会所
- (void)TypeClubRequest{
    _membraneView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@1};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //  NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            [_ClubArr removeAllObjects];
            for(NSDictionary *dict in array){
                FindModel *model = [[FindModel alloc]initWithClub:dict];
                
                [_ClubArr addObject:model];
                
            }
            [_collectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}


#pragma mark - Action
- (IBAction)CityAction:(UIButton *)sender forEvent:(UIEvent *)event {
     flag = 1;
    self.HeightConstraint.constant = _CityArr.count *40 ;
    _membraneView.hidden = NO;
    [_tableView reloadData];
}

- (IBAction)KindAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 2;
     self.HeightConstraint.constant = _KindArr.count *40 ;
    _membraneView.hidden = NO;
    [_tableView reloadData];
}

- (IBAction)DistanceAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 3;
    self.HeightConstraint.constant = _DistanceArr.count *40;
    _membraneView.hidden = NO;
     [_tableView reloadData];
}
@end

//
//- (void)hotRequest{
//
//    _avi = [Utilities getCoverOnView:self.view];
//    //NSDictionary *para =  @{@"1":@1};
//    [RequestAPI requestURL:@"/city/hotAndUpgradedList" withParameters:nil andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
//        NSLog(@"responseObject:%@", responseObject);
//        [_avi stopAnimating];
//
//        if([responseObject[@"resultFlag"] integerValue] == 8001){
//            NSDictionary *result = responseObject[@"result"];
//            FindModel * model  = [[FindModel alloc]initWithArr:result];
//            _hotarr = model.hotArr;
//            _upgradedArr = model.upgradedArr;
//            // NSLog(@"网址：%@",_AdImgarr[1]);
//
//            [self clubRequest];
//
//        }else{
//            //业务逻辑失败的情况下
//            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
//            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
//        }
//
//    } failure:^(NSInteger statusCode, NSError *error) {
//        [_avi stopAnimating];
//        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
//    }];
//
//}



//- (void)clubRequest{
//
//    _avi = [Utilities getCoverOnView:self.view];
//    for(int i = 0; i < _hotarr.count;i++){
//    NSDictionary *para =  @{@"clubKeyId":_hotarr[i],};
//    [RequestAPI requestURL:@"/clubController/getClubDetails" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
//        NSLog(@"responseObject:%@", responseObject);
//        [_avi stopAnimating];
//
//        if([responseObject[@"resultFlag"] integerValue] == 8001){
//            NSDictionary *result = responseObject[@"result"];
//            FindModel * model  = [[FindModel alloc]initWithArr:result];
//            _hotarr = model.hotArr;
//            _upgradedArr = model.upgradedArr;
//            // NSLog(@"网址：%@",_AdImgarr[1]);
//
//            [_collectionView reloadData];
//
//        }else{
//            //业务逻辑失败的情况下
//            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
//            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
//        }
//
//    } failure:^(NSInteger statusCode, NSError *error) {
//        [_avi stopAnimating];
//        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
//    }];
//
//}
//}


//- (void)hotClubRequest{
//    
//    _avi = [Utilities getCoverOnView:self.view];
//    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@"1",@"perPage":@"6"};
//    [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
//        NSLog(@"responseObject:%@", responseObject);
//        [_avi stopAnimating];
//        if([responseObject[@"resultFlag"] integerValue] == 8001){
//            [_avi stopAnimating];
//            NSArray *result = responseObject[@"result"][@"models"];
//            for(NSDictionary *dict in result){
//                FindModel *model = [[FindModel alloc]initWithClub:dict];
//                [_hotClubArr  addObject: model];
//                NSLog(@"数组里的是：%@",model.clubName);
//            }
//            [_collectionView reloadData];
//        }else{
//            //业务逻辑失败的情况下
//            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
//            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
//        }
//        
//    } failure:^(NSInteger statusCode, NSError *error) {
//        [_avi stopAnimating];
//        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
//    }];
//    
//}
