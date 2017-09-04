//
//  SigninViewController.m
//  Convergence
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "SigninViewController.h"
#import "UserModel.h"
@interface SigninViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
- (IBAction)signAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) UIActivityIndicatorView *avi;


@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self uiLayout];
    // Do any additional setup after loading the view.
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
//这个方法专门做导航条的控制
- (void)naviConfig{
    
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}
- (void)uiLayout{
    if(![[Utilities getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]){
        if([Utilities getUserDefaults:@"Username"] != nil){
            //将它显示在用户名输入框中
            _userTextField.text = [Utilities getUserDefaults:@"Username"];
        }
    }
}
- (IBAction)signAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if(_userTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    if(_pwdTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的密码" andTitle:nil onView:self];
        return;
    }
    if(_pwdTextField.text.length < 6 || _pwdTextField.text.length > 18){
        [Utilities popUpAlertViewWithMsg:@"您的密码必须在6~18之间" andTitle:nil onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字(invertedSet:反向设置，Digits：数字)
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if(_userTextField.text.length < 11 || [_userTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
        return;
    }
    //无输入异常的情况下，开始正式执行登录接口
    [self request];
    
}
#pragma mark - 网络请求
//登录注册相关
- (void)request{
    NSString *str = [Utilities uniqueVendor];
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *prarmeter = @{@"deviceType" : @7001, @"deviceId" : str};
    //开始请求
    [RequestAPI requestURL:@"/login/getKey" withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情
        //NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
            NSString *exponent = result[@"exponent"];
            NSString *modulus = result[@"modulus"];
            //对内容进行MD5加密
            NSString *md5Str = [_pwdTextField.text getMD5_32BitString];
            //用模数与指数对MD5加密过后的密码进行加密
            NSString *rsaStr = [NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
            //加密完成执行接口
            [self signWithEncryptPwd:rsaStr];
        }else{
            [_avi stopAnimating];
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //失败以后要做的事情
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

- (void)signWithEncryptPwd:(NSString *)encryptPwd {
    NSString *str = [Utilities uniqueVendor];
    [RequestAPI requestURL:@"/login" withParameters:@{@"userName" : _userTextField.text, @"password" : encryptPwd, @"deviceType" : @7001, @"deviceId" : str} andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
       //     UserModel *usermodel =[[UserModel alloc]initWhitDictionary:result];
            //将登录获取到的用户信息打包存储到单例化全局变量中
         //   [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:usermodel];
            //单独将用户的ID也存储进单例化全局变量来作为用户是否已经登录的判断依据，同时也方便其它所有页面更快捷地使用ID这个参数
         //   [[StorageMgr singletonStorageMgr]addKey:@"MemberId" andValue:usermodel.memberId];
            //让根视图结束编辑状态达到收起键盘的目的
            [self.view endEditing:YES];
            //情空密码输入框里的内容
            _pwdTextField.text = @"";
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:_userTextField.text];
            //用model的方式返回上一页
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
#pragma mark - 收起键盘
//按键盘上的Return键收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//按键盘以外的任意部位收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}

@end
