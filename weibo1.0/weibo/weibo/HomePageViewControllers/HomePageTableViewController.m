//
//  HomePageTableViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/2.
//

#import "HomePageTableViewController.h"

@interface HomePageTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)WBCellFrame *wbCellFrame;
@end

@implementation HomePageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post.png"] style:UIBarButtonItemStyleDone target:self action:@selector(postWB)];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload.png"] style:UIBarButtonItemStyleDone target:self action:@selector(reloadTableViewData)];
    self.navigationItem.leftBarButtonItem = reloadButton;
    self.navigationItem.rightBarButtonItem = postButton;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadWBData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];//从复用回收池中取cell
    if(!cell){//如果取不到就让cell=新建cell
        cell = [[WBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    //移除cell里面的imageView
    for(UIView *uv in cell.contentView.subviews){
            [uv removeFromSuperview];
    }
    //设置cell被选中时不变灰
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置theWBData
    cell.theWBData = self.dataArray[indexPath.row];
    //设置wbCellFrame
    _wbCellFrame = [[WBCellFrame alloc] init];
    _wbCellFrame.wbData = self.dataArray[indexPath.row];//该行可以初始化wbCellFrame的所有属性
    cell.wbCellFrame = _wbCellFrame;
    //创建cell的子view的
    [cell initSubviews];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _wbCellFrame.attitudeTextViewFrame.origin.y+40;//设置cell的高度
}

#pragma mark - postWBMethod
- (void)postWB
{
    //跳转到postWB界面
    PostWBViewController *postViewController = [[PostWBViewController alloc] init];
    [self.navigationController pushViewController:postViewController animated:YES];
}

#pragma mark - DataMethod

- (void)reloadTableViewData
{
    NSLog(@"reload");
    [self reloadWBData];
    [self.tableView reloadData];
}

- (void)reloadWBData
{
    [self initAndCheckAccessToken];
    AccessToken *token = [[AccessToken alloc] init];
    NSLog(@"%@",token.access_token);
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@",token.access_token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray *statuesArray = [dic valueForKey:@"statuses"];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in statuesArray)
        {
            TheWbData *theWBData = [[TheWbData alloc] init];
            [theWBData initWithDictionary:dic];
            [dataArray addObject:theWBData];
        }//将传回的数据转换为theWBData对象并存入数组

        NSLog(@"%lu",dataArray.count);
        self.dataArray = dataArray;
        dispatch_sync(dispatch_get_main_queue(), ^{
            //同步回到主线程
            [self.tableView reloadData];
                });

    }];

    [dataTask resume];
}

#pragma mark -CheckAccess_token
- (void)initAndCheckAccessToken
{
    //获取access_token
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/accessToken.plist",docPath];
    NSString *accessTokenString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    AccessToken *accessToken = [[AccessToken  alloc] init];
    accessToken.access_token = accessTokenString;
    if (accessToken.access_token == nil) {
        [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/get_token_info?access_token=%@",accessToken.access_token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];//设置请求的方法为POST方法
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dic);
        if ([dic valueForKey:@"expire_in"] < 0 || [dic valueForKey:@"error"] != nil) {
            NSLog(@"该access_token已过期！");
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //同步回到主线程
                [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:NO];
                    });

        }
    }];

    [dataTask resume];
}



@end
