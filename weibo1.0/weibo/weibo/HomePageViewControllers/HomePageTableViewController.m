//
//  HomePageTableViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/2.
//

#import "HomePageTableViewController.h"

@interface HomePageTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSMutableArray *dataArray;
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
    cell.theWBData = self.dataArray[indexPath.row];
    
    WBCellFrame *wbCellFrame = [[WBCellFrame alloc] init];
    wbCellFrame.wbData = self.dataArray[indexPath.row];//该行可以初始化wbCellFrame的所有属性
    cell.wbCellFrame = wbCellFrame;
    
    [cell initSubviews];
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;//设置cell的高度
}

#pragma mark - postWBMethod
- (void)postWB
{
    PostWBViewController *postViewController = [[PostWBViewController alloc] init];
    [self.navigationController pushViewController:postViewController animated:YES];
}

#pragma mark - DataMethod

- (void)reloadTableViewData
{
    NSLog(@"reload");
    [self.tableView reloadData];
}

- (void)reloadWBData
{
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

    }];

    [dataTask resume];
}


@end
