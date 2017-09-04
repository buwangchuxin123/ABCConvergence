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
@interface FindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *kindBtn;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
@property (strong,nonatomic)UIActivityIndicatorView *avi;
@property (strong,nonatomic)NSArray *hotarr;
@property (strong,nonatomic)NSArray *upgradedArr;
@property (strong,nonatomic)NSMutableArray *hotClubArr;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hotClubArr = [NSMutableArray new];
    // Do any additional setup after loading the view.
    //禁止被选中
    _collectionView.allowsSelection = NO;
    [self naviConfig];
    [self dataInitialize];
}

- (void)viewWillAppear:(BOOL)animated{
    // [self dataInitialize];
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

#pragma mark - request
-(void)dataInitialize{
   // [self hotRequest];
    [self hotClubRequest];
}
- (void)hotClubRequest{
    
    _avi = [Utilities getCoverOnView:self.view];
     NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@"1",@"perPage":@"6"};
    [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
           NSArray *result = responseObject[@"result"][@"models"];
            for(NSDictionary *dict in result){
                FindModel *model = [[FindModel alloc]initWithClub:dict];
                [_hotClubArr  addObject: model];
                NSLog(@"数组里的是：%@",model.clubName);
              }
            [_collectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}


#pragma mark - collectionView
//每组有多少个items
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _hotClubArr.count;
}
//每个items长什么样
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FindCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    FindModel *model = _hotClubArr[indexPath.item];
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
//    //选中时cell的背景视图
//    UIView *sbv = [UIView new];
//    sbv.backgroundColor = [UIColor redColor];
//    cell.selectedBackgroundView = sbv;
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
