//
//  PostWBViewController.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/17.
//

#import <UIKit/UIKit.h>

@protocol PostWBViewControllerDelegate <NSObject>

- (void)PostWBViewControllerPop;

@end
NS_ASSUME_NONNULL_BEGIN

@interface PostWBViewController : UIViewController

@property(weak,nonatomic)id<PostWBViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
