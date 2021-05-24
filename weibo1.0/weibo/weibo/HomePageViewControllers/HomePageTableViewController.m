//
//  HomePageTableViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/2.
//

#import "HomePageTableViewController.h"

@interface HomePageTableViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,TheWBCellDelegate,LoginViewControllerDelegate,PostWBViewControllerDelegate,UIGestureRecognizerDelegate,SearchHistoryTableViewDelegate>
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)NSArray *searchResultDataArray;
@property(strong,nonatomic)NSMutableArray *browseHistoryArray;
@property (nonatomic,strong)UISearchController *searchController;
@property (nonatomic,strong)UserInformation *userInformation;
@property (nonatomic,strong)SearchHistoryTableView *searchHistoryTableView;
@property(strong,nonatomic)AccessToken *accessToken;
@property(strong,nonatomic)WBCellFrame *wbCellFrame;
@end

@implementation HomePageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //cell的点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewClick:)];
    tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];

    //下拉刷新
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(reloadWBData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;

    //上拉加载
    UIRefreshControl *loadMoreRefreshControl = [[UIRefreshControl alloc] init];
    loadMoreRefreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"上拉加载"];
    [loadMoreRefreshControl addTarget:self action:@selector(loadMoreWB) forControlEvents:UIControlEventValueChanged];
 //   self.tableView.tableFooterView = loadMoreRefreshControl;
    
    //searchbar
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];//初始化
    self.searchController.searchResultsUpdater = self;//设置代理对象
    self.searchController.searchBar.delegate = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;//搜索时背景模糊
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                   self.searchController.searchBar.frame.origin.y,
                   self.searchController.searchBar.frame.size.width, 44.0);//设置frame
    self.tableView.tableHeaderView = self.searchController.searchBar;
    

    
    //UIBarButtonItem
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post.png"] style:UIBarButtonItemStyleDone target:self action:@selector(postWB)];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload.png"] style:UIBarButtonItemStyleDone target:self action:@selector(loadMoreWB)];
    self.navigationItem.leftBarButtonItem = reloadButton;
    self.navigationItem.rightBarButtonItem = postButton;

    //定时刷新
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:500];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
                });
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initAndCheckAccessToken];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return _searchResultDataArray.count;
    }
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
    //根据搜索栏是否激活设置theWBData
    if (self.searchController.active == NO) {
        cell.theWBData = _dataArray[indexPath.row];
    }else{
        cell.theWBData = _searchResultDataArray[indexPath.row];
    }
    //设置cell的代理
    cell.delegate = self;
    //设置wbCellFrame
    _wbCellFrame = [[WBCellFrame alloc] init];
    _wbCellFrame.wbData = cell.theWBData;//该行可以初始化wbCellFrame的所有属性
    cell.wbCellFrame = _wbCellFrame;
    //创建cell的子view的
    [cell loadSubviews];

     return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _wbCellFrame.attitudeTextViewFrame.origin.y+40;//设置cell的高度
}

//通过判断最后一个cell是否将要display来加载更多数据（上拉加载）
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row = %lu,count = %lu",indexPath.row,_dataArray.count);
    //如果要展示最后一个cell，则加载更多数据
    if (indexPath.row == (_dataArray.count-1)) {
        TheWbData *tempData = _dataArray.lastObject;
        NSLog(@"WBid = %lu",tempData.wbId.longValue);
        //请求数据
        NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
        NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@&max_id=%lu&count=20",self.accessToken.access_token,tempData.wbId.longValue];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSLog(@"%@",url.query);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //将获取到的数据转成字典
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //出错直接返回
            if ([tempDic valueForKey:@"error"]) {
                NSLog(@"error!!!");
                return;
            }
        
            //获取dic中要用到的信息
            NSMutableArray *statuesArray =[NSMutableArray arrayWithArray:[tempDic valueForKey:@"statuses"] ];
            [statuesArray removeObject:statuesArray.firstObject];
            //将传回的数据转换为theWBData对象并存入数组
            for(NSDictionary *dic in statuesArray)
            {
                TheWbData *theWBData = [[TheWbData alloc] init];
                [theWBData initWithWebDictionary:dic];
                [self.dataArray addObject:theWBData];
            }//同步回到主线程
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
        //执行任务
        [dataTask resume];
    }
    
    
}

#pragma mark - 点击事件
- (void)tableViewClick:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"click!");

    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:point];
    //获取当前用户信息，用于获取文件目录
    UserInformation *userInformation = [[UserInformation alloc] init];
    //从文件中获取数据
    self.browseHistoryArray = [[NSMutableArray alloc] initWithContentsOfFile:userInformation.browseHistoryFilePath];
    //文件为空则创建数组
    if (self.browseHistoryArray == nil) {
            self.browseHistoryArray = [[NSMutableArray alloc] init];
    }
    //删除重复的微博(根据用户名和微博发布时间判断)
    TheWbData *wbData = self.dataArray[indexpath.row];
    for (int i = 0;i<self.browseHistoryArray.count;i++) {
        NSDictionary *dic = self.browseHistoryArray[i];
        if ([wbData.creatTime isEqualToString:[dic valueForKey:@"created_at"]] && [wbData.name isEqualToString:[dic valueForKey:@"name"]]) {
            [self.browseHistoryArray removeObjectAtIndex:i];
        }
    }
    //历史记录不超过50条
    if (self.browseHistoryArray.count > 50) {
        [self.browseHistoryArray removeObjectAtIndex:0];
    }
    //添加当前微博的数据到数组中
    [self.browseHistoryArray addObject:[TheWbData initDicitonaryWithTheWbData:wbData]];
    //写入数据
    NSArray *array = [[NSArray alloc] initWithArray:self.browseHistoryArray];
    [array writeToFile:userInformation.browseHistoryFilePath atomically:NO];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.searchController.active) {
        return NO;
    }
    return YES;
}

#pragma mark - postWbButtonMethod
- (void)postWB
{
    PostWBViewController *postWBViewController = [[PostWBViewController alloc] init];
    postWBViewController.delegate = self;
    [self.navigationController pushViewController:postWBViewController animated:YES];
 //   [WeiboSDK shareToWeibo:@""];
}

#pragma mark - DataMethod


- (void)reloadWBData
{
    //请求数据
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@&count=30",self.accessToken.access_token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        self.dataArray = [NSMutableArray array];
        //加载自己发的微博
        UserInformation *userInformation = [[UserInformation alloc] init];
        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:userInformation.postedWBFilePath];
        
        for(NSDictionary *dic1 in array.reverseObjectEnumerator)//逆向枚举
        {
            TheWbData *theWBData = [[TheWbData alloc] init];
            [theWBData initWithFilePathDictionary:dic1];
            [self.dataArray addObject:theWBData];
        }
        //将获取到的数据转成字典
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //获取dic中要用到的信息
        NSArray *statuesArray = [tempDic valueForKey:@"statuses"];

        //将传回的数据转换为theWBData对象并存入数组
        for(NSDictionary *dic in statuesArray)
        {
            TheWbData *theWBData = [[TheWbData alloc] init];
            [theWBData initWithWebDictionary:dic];
            [self.dataArray addObject:theWBData];
        }

       
        //同步回到主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if ([self.tableView.refreshControl isRefreshing]) {
                        [self.tableView.refreshControl endRefreshing];
                    }
                });
    }];
    //执行任务
    [dataTask resume];
}

#pragma mark -CheckAccess_token
- (void)initAndCheckAccessToken
{
    //从文件中获取access_token
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *accessTokenFilePath = [NSString stringWithFormat:@"%@/accessToken.plist",docPath];
    NSString *accessTokenString = [NSString stringWithContentsOfFile:accessTokenFilePath encoding:NSUTF8StringEncoding error:nil];
    _accessToken = [[AccessToken  alloc] init];
    _accessToken.access_token = accessTokenString;
    //文件为空则跳转到登陆界面
    if (_accessToken.access_token == nil) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.delegate = self;
        [self.navigationController pushViewController:loginViewController animated:YES];
        return;
    }
    //判断该access_token是否有效
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/get_token_info?access_token=%@",_accessToken.access_token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];//设置请求的方法为POST方法
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //如果过期则跳转到登陆界面
        if ([dic valueForKey:@"expire_in"] < 0 || [dic valueForKey:@"error"] != nil) {
            NSLog(@"该access_token已过期！");
            //同步回到主线程
            dispatch_sync(dispatch_get_main_queue(), ^{
                LoginViewController *loginViewController = [[LoginViewController alloc] init];
                loginViewController.delegate = self;
                [self.navigationController pushViewController:loginViewController animated:YES];
            });
        }else{
            //如果没有过期
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //未过期则创建UserInformation单例
                    [self initUserInformation];
                });
              }
        
    }];

    [dataTask resume];
}
#pragma mark - initUserInformation
- (void)initUserInformation
{
    if (_userInformation == nil) {
        //根据access_token获得当前用户id，并创建UserInformation单例
        _userInformation = [[UserInformation alloc] init];
        NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
        NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/account/get_uid.json?access_token=%@",self.accessToken.access_token];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.userInformation.userId = [dic valueForKey:@"uid"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self reloadWBData];
            });
            
        }];
        [dataTask resume];

    }

    
    
}

#pragma mark - UISearchBarDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search");
    
    [_searchHistoryTableView addWithHistoryString:self.searchController.searchBar.text];
    _searchHistoryTableView.hidden = YES;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@ || %K CONTAINS %@", @"name",_searchController.searchBar.text, @"text",_searchController.searchBar.text];
    _searchResultDataArray = [_dataArray filteredArrayUsingPredicate:predicate];
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.tableView.scrollEnabled = NO;
    BOOL didShowSearchHistoryView = NO;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[SearchHistoryTableView class]]) {
            didShowSearchHistoryView = YES;
        }
    }
    if (didShowSearchHistoryView == NO) {
        _searchHistoryTableView = [[SearchHistoryTableView alloc] initWithFrame:CGRectMake(0, 54, self.view.bounds.size.width, self.view.bounds.size.height)];
        _searchHistoryTableView.searchHistoryTableViewDelegate = self;
        [_searchHistoryTableView loadSearchHistory];
        [self.view addSubview:_searchHistoryTableView];
    }
    _searchHistoryTableView.hidden = NO;

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _searchHistoryTableView.hidden = YES;
    self.searchController.active = NO;
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
}

- (void)poenLinkText:(NSURL *)url
{
    WebViewController *webViewController = [[WebViewController alloc] init];
    webViewController.url = url;
    [self.navigationController pushViewController:webViewController animated:YES];
}


- (void)reloadTabelViewData {
    [self reloadWBData];
}

- (void)loadMoreWB
{
        TheWbData *tempData = _dataArray.lastObject;
        NSLog(@"WBid = %lu",tempData.wbId.longValue);
        //请求数据
        NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
        NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@&max_id=%lu&count=20",self.accessToken.access_token,tempData.wbId.longValue];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSLog(@"%@",url.query);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //将获取到的数据转成字典
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //获取dic中要用到的信息
            NSMutableArray *statuesArray =[NSMutableArray arrayWithArray:[tempDic valueForKey:@"statuses"] ];
            [statuesArray removeObject:statuesArray.firstObject];
            //将传回的数据转换为theWBData对象并存入数组
            for(NSDictionary *dic in statuesArray)
            {
                TheWbData *theWBData = [[TheWbData alloc] init];
                [theWBData initWithWebDictionary:dic];
                [self.dataArray addObject:theWBData];
            }//同步回到主线程
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
        //执行任务
        [dataTask resume];
}

#pragma mark - SearchHistoryTableViewDelegate
-(void)replaceSearchBarTextWithString:(NSString *)str
{
    self.searchController.searchBar.text = str;

}
@end
