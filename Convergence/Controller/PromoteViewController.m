//
//  PromoteViewController.m
//  Convergence
//
//  Created by admin001 on 2017/9/8.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "PromoteViewController.h"
#import <CoreImage/CoreImage.h>
#import "UserModel.h"
@interface PromoteViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic)NSString *QR;
@end

@implementation PromoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self netRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
    self.navigationItem.title = @"我的推广";
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 124, 236);
   // self.navigationController.na
    self.navigationController.navigationBar.titleTextAttributes =@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
}
-(void)netRequest{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"] forKey:@"memberId"];
//    NSString *ID = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"];
//    NSDictionary *para = @{@"memberId":ID};
    [RequestAPI requestURL:@"/mySelfController/getInvitationCode" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
        //    NSDictionary *result = responseObject[@"result"];
         //   _QR = result[@"result"];
          _QR =  responseObject[@"result"];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情
        NSLog(@"statusCode = %ld",(long)statusCode);
        
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];

    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//创建一个二维码滤镜实例（CIFilter）
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //滤镜恢复默认设置
    [filter setDefaults];
    //给滤镜添加数据
    NSString *string = [NSString stringWithFormat:@"http://dwz.cn/%@",_QR];
    //将字符串转成二进制数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //通过KVC设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 6.获取滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 7.将CIImage转成UIImage
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    
    //显示二维码
    _imageView.image = image;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    //CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    CGFloat scale = MIN(10, 20);
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
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
