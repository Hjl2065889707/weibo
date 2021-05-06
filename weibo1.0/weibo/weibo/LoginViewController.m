//
//  LoginViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/6.
//

#import "LoginViewController.h"
#import "WeiboSDK.h"
#import "WBHttpRequest.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *ssoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssoButton setTitle:NSLocalizedString(@"请求微博认证（SSO授权）", nil) forState:UIControlStateNormal];
    [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    ssoButton.frame = CGRectMake(20, 90, 280, 40);
    [self.view addSubview:ssoButton];
    
}

#pragma mark SSO Authorization
- (void)ssoButtonPressed
{
    NSLog(@"pressed");
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://www.sina.com";
    request.scope = @"all";
    //下面两句测试打开ituns网页
    request.shouldShowWebViewForAuthIfCannotSSO = YES;
//    request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request completion:nil];
}




@end
