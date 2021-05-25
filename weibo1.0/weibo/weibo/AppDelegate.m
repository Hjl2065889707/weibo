//
//  AppDelegate.m
//  weibo
//
//  Created by 黄俊龙 on 2021/4/30.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //打开调试模式(便于输出调试信息
//    [WeiboSDK enableDebugMode:YES];
    //注册 appkey(clientid)和 universalLink
//    [WeiboSDK registerApp:kAppKey universalLink:@"https://applink.com"];
    //创建主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    TabBarController *tabBarController = [[TabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
