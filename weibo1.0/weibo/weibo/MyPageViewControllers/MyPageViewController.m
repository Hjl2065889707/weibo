//
//  MyPageViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/4/30.
//

#import "MyPageViewController.h"
#import "MyCollectionsTableViewController.h"
#import "AccessToken.h"
#import "BrowseHistoryTableViewController.h"
#import "UserInformation.h"


@interface MyPageViewController ()
@property(strong,nonatomic)NSString *accessToken;

@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AccessToken *accessToken = [[AccessToken alloc] init];
    self.accessToken = accessToken.access_token;
    
    UserInformation *userInformation = [[UserInformation alloc] init];
    //展示头像和昵称
    NSData *headImageData = [NSData dataWithContentsOfURL:userInformation.headImageURL];
    UIImage *headImage = [UIImage imageWithData:headImageData];
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:headImage];
    headImageView.frame = CGRectMake(10, 110, 80, 80);
    [self.view addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(110, 110, 250, 60);
    nameLabel.text = userInformation.name;
    nameLabel.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:nameLabel];
    
    
    //我的收藏按钮
    UIButton *myCollectsButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [myCollectsButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    [myCollectsButton setImage:[UIImage imageNamed:@"myCollections"] forState:UIControlStateNormal];
    myCollectsButton.frame = CGRectMake(160,250,100, 100);
//    myCollectsButton.backgroundColor = [UIColor redColor];
    [myCollectsButton addTarget:self action:@selector(collectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myCollectsButton];
    //历史记录按钮
    UIButton *browseHistoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [browseHistoryButton setImage:[UIImage imageNamed:@"browseHistory"] forState:UIControlStateNormal];
    browseHistoryButton.frame = CGRectMake(20,250, 100, 100);
    [browseHistoryButton addTarget:self action:@selector(browseHistoryButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:browseHistoryButton];
    //登出按钮
    UIButton *outButton = [UIButton systemButtonWithImage:[UIImage imageNamed:@"out"] target:self action:@selector(outButtonPressed)];
    outButton.frame = CGRectMake(310, 250, 100, 100);
    [self.view addSubview:outButton];
    //测试用按钮
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setTitle:NSLocalizedString(@"test", nil) forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(aButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    aButton.frame = CGRectMake(20, 500, 280, 40);
  //  [self.view addSubview:aButton];
    
}

- (void)collectButtonPressed
{
    [self.navigationController pushViewController:[[MyCollectionsTableViewController alloc] init] animated:YES];
    
}

- (void)browseHistoryButtonPressed
{
    [self.navigationController pushViewController:[[BrowseHistoryTableViewController alloc] init] animated:YES];
    
}
- (void)outButtonPressed
{
    //登出
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/revokeoauth2?access_token=%@",self.accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data) {
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dic);
    }];
    [dataTask resume];
}

- (void)aButtonPressed
{
    //获取当前登陆用户的uid
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@",self.accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data) {
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",[dic valueForKey:@"uid"]);
    }];
    [dataTask resume];
}

@end
