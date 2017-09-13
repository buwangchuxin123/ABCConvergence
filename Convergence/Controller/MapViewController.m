//
//  MapViewController.m
//  Convergence
//
//  Created by admin001 on 2017/9/13.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
@interface MapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>{

    NSInteger count;
}
@property(strong, nonatomic)CLLocationManager *locationManager;
@property(strong, nonatomic)MKMapView *mapView;
@property(strong, nonatomic)UILabel *longitudeLabel;//经度
@property(strong, nonatomic)UILabel *latitudeLabel;//纬度
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    count = 0;
    //初始化位置管理器对象作为定位功能的基础
    _locationManager = [[CLLocationManager alloc]init];
    //签署协议
    _locationManager.delegate = self;
    //表示每移动多少距离可以被识别
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //把地球分割的精度（分割成边长为多少的小方块）
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //判断用户有没有决定过要不要使用定位功能（如果没有就执行if语句里面的操作）
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //判断设备是否为iOS8.0以上系统
#ifdef __IPHONE_8_0
        //表示询问用户是否要使用定位功能（但是如果info.plist文件内没有设置好询问的语句内容，则不会出现弹窗）（requestWhenInUseAuthorization：表示当APP运行过程中使用定位；requestAlwaysAuthorization：表示只要装着这个APP就使用定位功能）
        [_locationManager requestWhenInUseAuthorization];
#endif
    }
    //开始持续获取用户设备坐标（开关打开）
    [_locationManager startUpdatingLocation];
    //创建一个地图视图，将他设置为与根视图同一位置
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    //签署协议
    _mapView.delegate = self;
    //表示地图可以缩放
    _mapView.zoomEnabled = YES;
    //表示地图可以移动
    _mapView.scrollEnabled = YES;
    //设置地图类型
    _mapView.mapType = MKMapTypeStandard;
    //表示显示用户位置
    _mapView.showsUserLocation = YES;
    //将地图视图放在根视图
    [self.view addSubview:_mapView];
    //初始化一个长按手势，设置手势被识别是要执行的方法
    UILongPressGestureRecognizer *longPress= [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction)];
    //将手势添加到地图视图上
    [_mapView addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
