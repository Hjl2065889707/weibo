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
    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:webview];
    webview.UIDelegate = self;
    self.webView=webview;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2233344854&response_type=code&redirect_uri=https://api.weibo.com/oauth2/default.html"]]];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    
    UIButton *ssoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssoButton setTitle:NSLocalizedString(@"请求微博认证（SSO授权）", nil) forState:UIControlStateNormal];
    [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    ssoButton.frame = CGRectMake(20, 90, 280, 40);
    [self.view addSubview:ssoButton];
    
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [outButton setTitle:NSLocalizedString(@"out", nil) forState:UIControlStateNormal];
    [outButton addTarget:self action:@selector(outButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    outButton.frame = CGRectMake(20, 290, 280, 40);
    [self.view addSubview:outButton];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setTitle:NSLocalizedString(@"111", nil) forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(aButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    aButton.frame = CGRectMake(20, 390, 280, 40);
    [self.view addSubview:aButton];
}



#pragma mark SSO Authorization
- (void)ssoButtonPressed
{
    NSLog(@"pressed");
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = [kRedirectURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.scope = @"all";

    request.shouldShowWebViewForAuthIfCannotSSO = YES;

    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};

    [WeiboSDK sendRequest:request completion:nil];
}

- (void)outButtonPressed
{
    [WeiboSDK linkToProfile];
}

- (void)aButtonPressed
{
//    [WeiboSDK linkToProfile];
    
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2233344854&redirect_uri=https://api.weibo.com/oauth2/default.html"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    NSString *postString = @"client_id=2233344854&client_secret=08bb2e702d643ee1314bfec6d0c32bf3&grant_type=authorization_code";


    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dic);
    }];

    [dataTask resume];
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"%@",response);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"~~~~~~~~~~~~~~~");

    NSLog(@"%@",self.webView.URL.query);
    NSLog(@"~~~~~~~~~~~~~~~");
    
    
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token?client_id=2233344854&client_secret=08bb2e702d643ee1314bfec6d0c32bf3&grant_type=authorization_code&redirect_uri=https://api.weibo.com/oauth2/default.html&%@",self.webView.URL.query];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dic);
        self.token = [dic valueForKey:@"access_token"];
        NSLog(@"%@",self.token);
    }];

    [dataTask resume];
}

@end
