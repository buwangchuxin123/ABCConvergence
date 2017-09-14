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
#pragma mark - CLLocationManagerDelegate
//当设备位置变化时执行以下方法，如果位置不变也会每秒执行一次（必须当开关打开时才会执行）（只有当distanceFilter属性为0时，该方法才会每秒调用）
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    BOOL shouldUpdate = NO;
    if (++ count == 1) {
        shouldUpdate  = YES;
    }else{
        if(newLocation.coordinate.longitude != oldLocation.coordinate.longitude || newLocation.coordinate.latitude != oldLocation.coordinate.latitude){
            shouldUpdate = YES;
        }
    }
    if (shouldUpdate) {
        NSLog(@"CLLocation:%f",newLocation.coordinate.longitude);
        NSLog(@"CLlocation:%f",newLocation.coordinate.latitude);
        _longitudeLabel.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
        _latitudeLabel.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    }
    //停止获取用户坐标（关闭开关）
    //[manager stopUpdatingLocation];
    //过5秒钟后停止获取用户坐标（关闭开关）
    [manager performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:5.f];
}
//当设备获取坐标失败是调用一下方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error) {
        [self checkError:error];
    }
}

#pragma mark - MKMapViewDelegate
//当设备位置更新时调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"MKUserLocation经度：%f", userLocation.coordinate.longitude);
    NSLog(@"MKUserLocation纬度：%f", userLocation.coordinate.latitude);
    
    //初始化MKCoordinateRegion这个视角对象
    MKCoordinateRegion region;
    //初始化MKCoordinateSpan这个缩放值对象
    MKCoordinateSpan span;
    //设置x和y方向上具体的视角缩放值
    span.longitudeDelta = 0.01;
    span.latitudeDelta = 0.01;
    //初始化CLLocationCoordinate2D这个坐标对象
    CLLocationCoordinate2D location;
    //设置具体经纬度作为视角中心点
    location.longitude = userLocation.coordinate.longitude;
    location.latitude = userLocation.coordinate.latitude;
    //将设置好点缩放值和中心点打包放入region结构中
    region.span = span;
    region.center = location;
    //将打包好的视角结构作为参数运用到map view的设置视角的方法中去
    [mapView setRegion:region animated:YES];
}
//当地图加载失败时调用
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    if (error) {
        [self checkError:error];
    }
}
#pragma mark - Private

//错误判断与处理
- (void)checkError:(NSError *)error {
    switch (error.code) {
        case kCLErrorNetwork: {
            NSLog(@"没网");
        }
            break;
        case kCLErrorDenied: {
            NSLog(@"没开定位");
        }
            break;
        case kCLErrorLocationUnknown: {
            NSLog(@"荒山野岭，定位不到");
        }
            break;
        default: {
            NSLog(@"其他");
        }
            break;
    }
}
-(void)longPressAction:(UILongPressGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按");
        //获得手势（长按手势）在指定视图坐标系中的位置（locationInView是获得单个手指位置的方法）

    }
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
