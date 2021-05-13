//
//  WebViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/13.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>


@interface WebViewController ()
@property(strong,nonatomic)NSURL *url;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    [webview loadRequest:[NSURLRequest requestWithURL:_url]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
