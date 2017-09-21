//
//  ActivityViewController.m
//  Convergence
//
//  Created by admin1 on 2017/9/6.
//  Copyright © 2017年 EDucation. All rights reserved.
//
#import "DetailViewController.h"
#import "ActivityViewController.h"
#import "ActivityModel.h"
#import "ActivityCell.h"
@interface ActivityViewController ()<UITableViewDataSource ,UITableViewDelegate> {
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL isLoding;
    BOOL firstVisit;
}

@property (weak, nonatomic) IBOutlet UITableView *activityTableView;
@property (strong,nonatomic) NSMutableArray *arr;
@property (strong,nonatomic) UIActivityIndicatorView *avi;
@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self uiLayout];
    
    [self dataInitialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    NSNotification *note = [NSNotification notificationWithName:@"opendoor" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    NSNotification *note = [NSNotification notificationWithName:@"ban" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
    
}

- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"活动列表";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(20, 124, 236);
    //self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}


- (void)uiLayout{
    //为表格视图创建footer(该方法可以去除表格视图底部多余的下划线)
    _activityTableView.tableFooterView = [UIView new];
    //创建下拉刷新器
    [self refreshConfiguration];
    
}


- (void)refreshConfiguration{
    //初始化一个下拉刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    //打下标
    refreshControl.tag = 10001;
    //设置标题
    NSString *title = @"大风车转悠悠";
    //创建属性字典
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : [UIColor grayColor], NSBackgroundColorAttributeName : [UIColor clearColor]};//NSBackgroundColorAttributeName设置@"大风车转悠悠"的背景颜色
    //将文字和属性字典包裹一个带属性的字符串
    NSAttributedString *attriTitle = [[NSAttributedString alloc] initWithString:title attributes:attrDict];
    refreshControl.attributedTitle = attriTitle;
    //设置下拉刷新指示器颜色(菊花颜色)
    refreshControl.tintColor = [UIColor blackColor];
    //设置背景色
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //定义用户触发下拉事件时执行的方法
      [refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加activityTableView中 (在tableView中，下拉刷新控件会自动放置在表格视图顶部后侧位置)
    [self.activityTableView addSubview:refreshControl];
}
/*
 - (void)refreData:(UIRefreshControl *)sender{
 //过2秒再执行end方法
 [self performSelector:@selector(end) withObject:nil afterDelay:2];
 }
 */

- (void)refreshPage{
    page = 1;
    [self networkRequest];
}

- (void)end{
    //在activityTableView中，根据下标10001获得其子视图:下拉刷新控件
    UIRefreshControl *refresh = (UIRefreshControl *)[self.activityTableView viewWithTag:10001];
    //结束刷新
    [refresh endRefreshing];
}

//这个方法处理网络请求未完成后所有不同类型的动画终止
- (void)endAnimation{
     isLoding = NO;
    [_avi stopAnimating];
    [self end];
}
//这个方法专门做数据的处理
- (void)dataInitialize{
    _avi = [Utilities getCoverOnView:self.view];
    [self networkRequest];
}
//执行网络请求
- (void)networkRequest{
    perPage = 10;
    if (!isLoding) {
        isLoding = YES;
        //在这里开启一个真实的网络请求
        //设置接口地址
        NSString *request = @"/event/list";
        //设置接口入参
        NSDictionary *prarmeter = @{@"page" : @(page), @"perPage" : @(perPage), @"city":@"无锡"};
        
        //开始请求
        [RequestAPI requestURL:request withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
            //成功以后要做的事情
         // NSLog(@"responseObject = %@",responseObject);
            [self endAnimation];//暂停
    
            if ([responseObject[@"resultFlag"] integerValue] == 8001) {
                //业务逻辑成功的情况下
                NSDictionary *result = responseObject[@"result"];
                NSArray *models = result[@"models"];
                NSDictionary *pagingInfo = result[@"pagingInfo"];
                totalPage = [pagingInfo[@"totalPage"] integerValue];
                
                if (page == 1) {
                    //清空数据
                    [_arr removeAllObjects];
                }
                
                for (NSDictionary *dict in models) {
                    //用ActivityModel类中定义的初始化方法initWhitDictionary: 将遍历得来的字典dict转换成为initWhitDictionary对象
                    ActivityModel *activityModel = [[ActivityModel alloc] initWithDictionary:dict];
                    //将上述实例化好的ActivityModel对象插入_arr数组中
                    [_arr addObject:activityModel];
                }
                //刷新表格（重载数据）
                [self.activityTableView reloadData];//reloadData重新加载activityTableView数据
                
            }else{
                //业务逻辑失败的情况下
                NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
                [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            }
        } failure:^(NSInteger statusCode, NSError *error) {
            
            //NSLog(@"statusCode = %ld",(long)statusCode);
            [self endAnimation];
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }];
    }
}



//设置表格视图一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"个数是：%lu",(unsigned long)_arr.count);
    return _arr.count;
    
}

//设置一个细胞将要出现的时候要做的事情
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是不是最后一行细胞将要出现
    if (indexPath.row == _arr.count - 1) {
        //判断还有没有下一页存在
        if (page < totalPage) {
            //在这里执行上拉翻页的数据操作
            page++;
            [self networkRequest];
        }
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据某个具体的名字找到该名字在页面上对应的细胞
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    //deque 队列
    
    //根据当前正在渲染的细胞的行号，从对应数组中拿到这一行所匹配的活动字典
    ActivityModel *activity = _arr[indexPath.row];
    
    //将http请求的字符串转换为nsurl
    NSURL *URL = [NSURL URLWithString:activity.imgUrl];
    //将URL给NSData（下载图片）NSData二进制的数据流
    //NSData *data = [NSData dataWithContentsOfURL:URL];
    //让图片加载
    //cell.activityImageView.image = [UIImage imageWithData:data];
    //将上3句合并
    //cell.activityImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:activity.imgUrl]]];
    //依靠SDWebImage来异步地下载一张远程路径中的图片并三级缓存在项目中，同时为下载的时间周期过程中设置一张临时占位图
    //不知道啥，加了可以请求到酒店图片
    NSString *userAgent = @"";
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                                 forHTTPHeaderField:@"Accept"];
    /////////////////////////
    

    [cell.activityImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"默认"]];
    
    
    cell.activityNameLabel.text = activity.name;
    cell.activityInfLabel.text = activity.content;
    cell.activityLikeLabel.text = [NSString stringWithFormat:@"顶:%ld",(long)activity.like];
    cell.activityUnlikeLabel.text = [NSString stringWithFormat:@"踩:%ld",(long)activity.unlike];
    //给每一行的收藏按钮打上下标，用来区分它是哪一行的按钮
    cell.favoBtn.tag = 100000 + indexPath.row;
        if (activity.isFavo) {
            cell.favoBtn.titleLabel.text = @"取消收藏";
        }else{
            cell.favoBtn.titleLabel.text = @"收藏";
        }
   // NSString *title = activity.isFavo ?@"取消收藏" :@"收藏";
  //  [cell.favoBtn setTitle:activity.isFavo ? @"取消收藏" : @"收藏" forState:UIControlStateNormal];
   // [cell.favoBtn setTitle:@"收藏" forState:UIControlStateNormal];
    /*
     //组
     //indexPath.section;
     //行indexPath.row;
     //判断当前正在渲染的细胞属于第几行
     if (indexPath.row == 0) {
     //第一行
     //修改图片内容
     cell.activityImageView.image = [UIImage imageNamed:@"png2"];
     //修改标签的名字
     cell.activityNameLabel.text = @"环太湖骑行";
     cell.activityInfLabel.text = @"从无锡滨湖区雪浪街道太湖出发，经过南京，苏州，嘉兴，上海再返回无锡";
     cell.activityLikeLabel.text = @"顶:80";
     cell.activityUnlikeLabel.text = @"踩:1";
     }else{
     //第二行
     //修改图片内容
     cell.activityImageView.image = [UIImage imageNamed:@"鄱阳湖"];
     //修改标签的名字
     cell.activityNameLabel.text = @"环鄱阳湖游街";
     cell.activityInfLabel.text = @"经过每一条街道，吃遍每一条街道的美食";
     cell.activityLikeLabel.text = @"顶:800万";
     cell.activityUnlikeLabel.text = @"踩:1";
     }*/
    
    return cell;
    
}


//设置每一组中每一行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取三要素（计算文字高度的三要素）
    //1.文字内容
    ActivityModel *activity = _arr[indexPath.row];
    NSString *activityContent = activity.content;
    //2.字体大小
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    UIFont *font = cell.activityInfLabel.font;
    //3.宽度尺寸
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
    CGSize size = CGSizeMake(width, 1000);
    //根据三元素计算尺寸
    CGFloat height = [activityContent boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size.height;
    //活动内容标签的原点y轴的位置+活动内容标签根据文字自适应大小后获得的高度+活动内容标签距离细胞底部的间距
    return cell.activityInfLabel.frame.origin.y + height + 10 + 5;//高度
}

//设置每一组中每一行被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断当前这个tableView是否为_activityTableView（这个条件判断常在一个页面中有多个tableView的时候）
    if ([tableView isEqual:_activityTableView]) {
        //取消选中
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        
    }
    
    
}
//收藏按钮的事件
- (IBAction)favoAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_arr !=nil && _arr.count != 0){
        //通过按钮的下标值去减100000拿到行号，再通过行号拿到对应的数据类型
        ActivityModel *activity = _arr[sender.tag - 100000];
        
        NSString *message = activity.isFavo ? @"是否取消收藏该活动" : @"是否收藏该活动";
        //创建弹出框，标题为@"提示"，内容为@"是否收藏该活动"
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        //创建取消按钮
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {/*代码块（black）*/
            
        }];
        //创建确定按钮
        UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (activity.isFavo) {
                activity.isFavo = NO;
            }else{
                activity.isFavo = YES;
            }
            
            [self.activityTableView reloadData];//reloadData重新加载activityTableView数据
        }];
        //将按钮添加到弹窗中，（添加按钮的顺序决定了按钮的排版:从左到右；从上到下，取消风格按钮会在左边）
        [alert addAction:actionA];
        [alert addAction:actionB];
        //将presentViewController的方法，以model的方式显示另一个页面（显示弹出框）
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

//当某一个页面跳转行为将要发生的时候
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"List2Detail"]) {
        //当列表页到详情页的这个跳转要发生的时候
        //1.获取要传递到下一页的数据
        NSIndexPath *indexPath = [_activityTableView indexPathForSelectedRow];
        ActivityModel *activity = _arr[indexPath.row];
        //2.获取下一页的实例
        DetailViewController *detailVC = segue.destinationViewController;
        //3.把数据给下一页预备好的接收容器
        detailVC.activity = activity;
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
