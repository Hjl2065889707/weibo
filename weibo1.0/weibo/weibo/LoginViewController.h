//
//  LoginViewController.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/6.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController<WeiboSDKDelegate,WKUIDelegate,WKNavigationDelegate>

@end

NS_ASSUME_NONNULL_END
