//
//  AppDelegate.h
//  weibo
//
//  Created by 黄俊龙 on 2021/4/30.
//

#import <UIKit/UIKit.h>
#import "TabBarController.h"
#import "WeiboSDK.h"
#import "WBHttpRequest.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong,nonatomic)UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;


@end

