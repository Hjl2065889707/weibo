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
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post.png"] style:UIBarButtonItemStyleDone target:self action:@selector(postWB)];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload.png"] style:UIBarButtonItemStyleDone target:self action:@selector(reloadWB)];
    self.navigationItem.leftBarButtonItem = reloadButton;
    self.navigationItem.rightBarButtonItem = postButton;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];//从复用回收池中取cell
    if(!cell){//如果取不到就让cell=新建cell
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
    }
    TheWbData *theWBData = self.dataArray[indexPath.row];
    
    cell.textLabel.text = theWBData.name;
    cell.detailTextLabel.text = theWBData.text;
    NSData *headPictureData = [NSData dataWithContentsOfURL:[NSURL URLWithString:theWBData.profileImageURL]];
    cell.imageView.image = [UIImage imageWithData:headPictureData];  //设置头像
    
//    if(theWBData.pictureNumber != 0){
//        NSLog(@"存在图片");
//    }
    cell.textLabel.font = [UIFont systemFontOfSize:20];//设置textLable字体大小
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];//设置副标题字体大小
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;//设置cell的高度
}


- (void)postWB
{
    NSLog(@"post");
    [self.tableView reloadData];
}

- (void)reloadWB
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
