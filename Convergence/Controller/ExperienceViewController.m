//
//  ExperienceViewController.m
//  Convergence
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "ExperienceViewController.h"
#import "EModel.h"
#import "ePurchaseTableViewController.h"
@interface ExperienceViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UILabel *eName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *originPrice;

@property (weak, nonatomic) IBOutlet UILabel *clubName;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UILabel *sellNumber;
@property (weak, nonatomic) IBOutlet UILabel *useDate;
@property (weak, nonatomic) IBOutlet UILabel *useTime;
@property (weak, nonatomic) IBOutlet UITextView *useRule;
@property (weak, nonatomic) IBOutlet UITextView *userInfo;
- (IBAction)PayAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)addressAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong,nonatomic)UIActivityIndicatorView *avi;
@property (strong,nonatomic)EModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;


@end

@implementation ExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationItem.title = @"体验券信息";
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


-(void)request{
    _avi = [Utilities getCoverOnView:self.view];
    
    NSString *eId =  [[[StorageMgr singletonStorageMgr]objectForKey:@"eId"] isKindOfClass:[NSNull class]]?@"-1" : [[StorageMgr singletonStorageMgr]objectForKey:@"eId"] ;
    NSDictionary *para = @{@"experienceId":eId};
    [RequestAPI requestURL:@"/clubController/experienceDetail" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"]integerValue] == 8001){
           // NSLog(@"responseObject:%@",responseObject);
            NSDictionary *result = responseObject[@"result"];
            _model = [[EModel alloc]initWithexperience:result];
            [self uiLayout];
            [self introduceViewHeight];
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:@"提示" onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [Utilities popUpAlertViewWithMsg:@"请保持网络通畅" andTitle:@"提示" onView:self];
    }];

}

-(void)uiLayout{
    NSURL * url = [NSURL URLWithString:_model.eLogo];
    [_Image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认"]];
     _eName.text = _model.eName;
//    NSDictionary *Dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   [UIFont systemFontOfSize:15.0],
//                                   [UIColor redColor],nil];
//    NSMutableAttributedString *yuan = [[NSMutableAttributedString alloc]initWithString:@"元" attributes:Dict];
//    NSLog(@"东东：%@",yuan);
    _price.text = _model.currentPrice;
     _originPrice.text = [NSString stringWithFormat:@"原价:%@元",_model.orginPrice];;
     _clubName.text = _model.clubName;
     _addressBtn.titleLabel.text = _model.eAddress;
     _sellNumber.text = [NSString stringWithFormat:@"已售:%@",_model.saleCount];
     _useDate.text = [NSString stringWithFormat:@"%@-%@",_model.beginDate,_model.endDate];
     _useTime.text = _model.userTime;
     _useRule.text = _model.rules;
     _userInfo.text = _model.ePromot;
}
-(void)introduceViewHeight{
    CGSize maxSize = CGSizeMake(UI_SCREEN_W - 30, 1000);
    //拿的已经显示在textView上的高度
    CGSize contentSize = [_useRule.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_useRule.font} context:nil].size;
    //将文字内容的尺寸给textView高度约束
   // _introduceHeight.constant = contentSize.height + 36;
     //NSLog(@"内容高度是：%f",contentSize.height);
    _viewHeight.constant =contentSize.height + 36 + 175;
    
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

- (IBAction)PayAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        ePurchaseTableViewController *purchase = [Utilities getStoryboardInstance:@"Home" byIdentity:@"Purchase"];
        purchase.Model = _model;
        [self.navigationController pushViewController:purchase animated:YES];
    }else{
        //获取要跳转过去的那个页面
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Login" byIdentity:@"LoginNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }
    
}

- (IBAction)addressAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
