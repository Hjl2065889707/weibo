//
//  LoginViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/6.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WBHttpRequest.h"
#import <WebKit/WebKit.h>

@interface LoginViewController ()
@property(weak,nonatomic)WKWebView *webView;
@property(strong,nonatomic)NSString *token;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *ssoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [ssoButton setTitle:NSLocalizedString(@"请求微博认证（SSO授权）", nil) forState:UIControlStateNormal];
//    [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    ssoButton.frame = CGRectMake(20, 90, 280, 40);
//    [self.view addSubview:ssoButton];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 340, 500,600)];
    [self.view addSubview:webview];
    webview.UIDelegate = self;
    self.webView=webview;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2233344854&response_type=code&redirect_uri=https://api.weibo.com/oauth2/default.html"]]];
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//页面消失的时候销毁观察者
    
}

//#pragma mark SSO Authorization
//- (void)ssoButtonPressed
//{
//    NSLog(@"pressed");
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = kRedirectURI;
//    request.scope = @"all";
//    request.shouldShowWebViewForAuthIfCannotSSO = YES;
//
//    [WeiboSDK sendRequest:request completion:nil];
//}

- (void)outButtonPressed
{
    //登出
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/revokeoauth2?access_token=%@",self.token];
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
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/account/get_uid.json?access_token=%@",self.token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dic);
    }];

    [dataTask resume];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

    if([self.webView.URL.query hasPrefix:@"code"]){//如果字符串前面包含“code”
        NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
        NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token?client_id=2233344854&client_secret=08bb2e702d643ee1314bfec6d0c32bf3&grant_type=authorization_code&redirect_uri=https://api.weibo.com/oauth2/default.html&%@",self.webView.URL.query];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.token = [dic valueForKey:@"access_token"];
            
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [NSString stringWithFormat:@"%@/accessToken.plist",docPath];
            //获取文件路径
            if ([self.token writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil]) {
                NSLog(@"写入成功！！！");
            }
            
            AccessToken *token = [[AccessToken alloc] init];
            token.access_token = self.token;
            NSLog(@"token = %@",self.token);
        }];
        [dataTask resume];
        
    }
}



@end
