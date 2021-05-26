//
//  LoginViewController.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/6.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "AccessToken.h"
NS_ASSUME_NONNULL_BEGIN
@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

- (void)LoginViewControllerPop;

@end


@interface LoginViewController : UIViewController<WKUIDelegate,WKNavigationDelegate>

@property(weak,nonatomic)id<LoginViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
