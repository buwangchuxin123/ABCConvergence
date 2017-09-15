//
//  MapViewController.m
//  Convergence
//
//  Created by admin001 on 2017/9/13.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"
@interface MapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>{

    NSInteger count;
}
@property(strong, nonatomic)CLLocationManager *locationManager;
@property(strong, nonatomic)MKMapView *mapView;
@property(strong, nonatomic)NSString *longitude;//经度
@property(strong, nonatomic)NSString *latitude;//纬度
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
}
#pragma mark - MKMapViewDelegate
//当设备位置更新时调用(确定位置同时放大地图)
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //初始化MKCoordinateRegion这个视角对象
    MKCoordinateRegion region;
    //初始化MKCoordinateSpan这个缩放值对象
    MKCoordinateSpan span;
    //设置x和y方向上具体的视角缩放值
    span.longitudeDelta = 0.01;
    span.latitudeDelta = 0.01;
    //初始化CLLocationCoordinate2D这个坐标对象
    CLLocationCoordinate2D location;
    _latitude = [[StorageMgr singletonStorageMgr]objectForKey:@"weidu"];
    _longitude = [[StorageMgr singletonStorageMgr]objectForKey:@"jingdu"];
    location.latitude= [_latitude doubleValue];
    location.longitude = [_longitude doubleValue];
    //将设置好点缩放值和中心点打包放入region结构中
    region.span = span;
    region.center = location;
    //将打包好的视角结构作为参数运用到map view的设置视角的方法中去
    [mapView setRegion:region animated:YES];


}
////显示大头针时触发，返回大头针视图，通常自定义大头针可以通过此方法进行
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation{
////    _latitude = [[StorageMgr singletonStorageMgr]objectForKey:@"weidu"];
////    _longitude = [[StorageMgr singletonStorageMgr]objectForKey:@"jingdu"];
//    
//    CGPoint location = [annotation locationInView:_mapView];
//    CLLocationCoordinate2D mapCoordinate = [_mapView convertPoint:location toCoordinateFromView:_mapView];
//    [self pinAnnotationViaCoordinate:mapCoordinate];
//}
//根据坐标创建大头针并安插
-(void)pinAnnotationViaCoordinate:(CLLocationCoordinate2D)mapCoordinate{
    //设置弱引用的自身以供block使用来解开强引用循环（双下划线）
    __weak MapViewController *weakSelf = self;
    //设置大头针的标题与副标题
    
    [self setAnnotationWithDescriptionOnCoordinate:mapCoordinate completionHandler:^(NSDictionary *info) {
        //初始化一个大头针对象
        Annotation *annotation = [[Annotation alloc] init];
        //将方法参数中的坐标设置为大头针的坐标属性
        annotation.coordinate = mapCoordinate;
        if (info) {
            //设置大头针的标题与副标题属性
            annotation.title = info[@"City"];
            annotation.subtitle = info[@"Name"];
        }
        //将大头针插入地图视图
        [weakSelf.mapView addAnnotation:annotation];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//逆地理编码方法（这里是block的声明方式（创建block甲方的方式），看！看！看！！！）
- (void)setAnnotationWithDescriptionOnCoordinate:(CLLocationCoordinate2D)mapCoordinate completionHandler:(void (^)(NSDictionary *info))annotationCompletionHandler {
    //初始化一个地理编码对象
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    //将CLLocationCoordinate2D对象转换成CLLocation对象
    CLLocation *annoLoc = [[CLLocation alloc] initWithLatitude:mapCoordinate.latitude longitude:mapCoordinate.longitude];
    //执行逆地理编码方法
    [revGeo reverseGeocodeLocation:annoLoc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            //获取成功得到逆地理编码结果中的地址信息字典
            NSDictionary *info = [placemarks[0] addressDictionary];
            NSLog(@"info = %@", info);
            //在此处触发annotationCompletionHandler这个block发生，并把info作为参数传递给方法执行方（乙方）（由此可见，此block会在逆地理编码成功获得信息后触发）
            annotationCompletionHandler(info);
        } else {
           // [self checkError:error];
            annotationCompletionHandler(nil);
        }
    }];
}

///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

@end
