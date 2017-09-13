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
