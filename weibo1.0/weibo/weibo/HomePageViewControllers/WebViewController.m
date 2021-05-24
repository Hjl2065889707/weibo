//
//  WebViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/13.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>


@interface WebViewController ()


@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webview = [[WKWebView alloc] init];
    webview.frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:webview];
    [webview loadRequest:[NSURLRequest requestWithURL:_url]];
}


@end
