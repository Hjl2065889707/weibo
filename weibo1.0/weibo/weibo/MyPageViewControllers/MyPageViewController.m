//
//  MyPageViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/4/30.
//

#import "MyPageViewController.h"
#import "MyCollectionsTableViewController.h"
#import "AccessToken.h"


@interface MyPageViewController ()
@property(strong,nonatomic)NSString *accessToken;

@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AccessToken *accessToken = [[AccessToken alloc] init];
    self.accessToken = accessToken.access_token;
    //我的收藏按钮
    UIButton *myCollectsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [myCollectsButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    myCollectsButton.frame = CGRectMake(100,100,200, 50);
    [myCollectsButton addTarget:self action:@selector(collectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myCollectsButton];
    
    
    
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [outButton setTitle:NSLocalizedString(@"out", nil) forState:UIControlStateNormal];
    [outButton addTarget:self action:@selector(outButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    outButton.frame = CGRectMake(20, 190, 280, 40);
    [self.view addSubview:outButton];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setTitle:NSLocalizedString(@"111", nil) forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(aButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    aButton.frame = CGRectMake(20, 290, 280, 40);
    [self.view addSubview:aButton];
    
}

- (void)collectButtonPressed
{
    NSLog(@"pressed");
    
}

- (void)outButtonPressed
{
    //登出
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/revokeoauth2?access_token=%@",self.accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dic);
    }];

    [dataTask resume];
}

- (void)aButtonPressed
{
    //获取当前登陆用户的uid
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/account/get_uid.json?access_token=%@",self.accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dic);
    }];

    [dataTask resume];
    
}

@end