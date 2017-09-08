//
//  ExperienceViewController.m
//  Convergence
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 EDucation. All rights reserved.
//

#import "ExperienceViewController.h"
#import "EModel.h"
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

@end

@implementation ExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)request{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para = @{@"experienceId":@89};
    [RequestAPI requestURL:@"/clubController/experienceDetail" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            NSLog(@"responseObject:%@",responseObject);
            NSDictionary *result = responseObject[@"result"];
            _model = [[EModel alloc]initWithexperience:result];
            [self uiLayout];
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
     _price.text = _model.currentPrice;
     _originPrice.text = _model.orginPrice;
     _clubName.text = _model.clubName;
    _addressBtn.titleLabel.text = _model.eAddress;
    _sellNumber.text = [NSString stringWithFormat:@"已售：%@",_model.saleCount];
    _useDate.text = [NSString stringWithFormat:@"%@-%@",_model.beginDate,_model.endDate];
    _useTime.text = _model.userTime;
    _useRule.text = _model.rules;
    _userInfo.text = _model.ePromot;
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
}

- (IBAction)addressAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
