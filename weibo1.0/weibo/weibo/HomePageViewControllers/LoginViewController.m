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
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [self loadWebView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;

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



#pragma mark -监听WebView的url改变:获取access_token
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if ([self.webView.URL.query hasPrefix:@"error"]) {
        //说明用户点击了取消，但是这样是8行的，要重写加载webView
        [self loadWebView];
    }
    
    if([self.webView.URL.query hasPrefix:@"code"]){//如果字符串前面包含“code”
        NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
        NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token?client_id=2233344854&client_secret=08bb2e702d643ee1314bfec6d0c32bf3&grant_type=authorization_code&redirect_uri=https://api.weibo.com/oauth2/default.html&%@",self.webView.URL.query];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];//设置请求的方法为POST方法
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.token = [dic valueForKey:@"access_token"];
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [NSString stringWithFormat:@"%@/accessToken.plist",docPath];
            //获取文件路径
            if ([self.token writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil]) {
                NSLog(@"写入成功！！！");
            }//保存accessToken到本地

            AccessToken *token = [[AccessToken alloc] init];
            token.access_token = self.token;
            NSLog(@"token = %@",self.token);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //同步回到主线程
                [self.navigationController popToRootViewControllerAnimated:YES];
                    });
        }];//创建一个dataTask
        
        [dataTask resume];//执行任务
    }
}

- (void)loadWebView
{
    WKWebView *webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    webview.UIDelegate = self;
    self.webView=webview;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2233344854&response_type=code&redirect_uri=https://api.weibo.com/oauth2/default.html"]]];
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
}

@end
