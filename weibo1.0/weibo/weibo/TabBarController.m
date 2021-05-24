//
//  TabBarController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/4/30.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *homePageNavigationController = [[UINavigationController alloc] initWithRootViewController:[ [HomePageTableViewController alloc] init] ];
    homePageNavigationController.tabBarItem.title = @"主页";
    [homePageNavigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]} forState:UIControlStateSelected];
    homePageNavigationController.tabBarItem.image = [UIImage imageNamed:@"home.png"];
    homePageNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"home-fill.png"];
    [self addChildViewController:homePageNavigationController];
    
    UINavigationController *findPageNavigationController = [[UINavigationController alloc] initWithRootViewController:[ [FindPageTableViewController alloc] init] ];
    findPageNavigationController.tabBarItem.title = @"发现";
    [findPageNavigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]} forState:UIControlStateSelected];
    findPageNavigationController.tabBarItem.image = [UIImage imageNamed:@"find.png"];
    findPageNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"find-fill.png"];
    [self addChildViewController:findPageNavigationController];
    
    UINavigationController *messagePageNavigationController = [[UINavigationController alloc] initWithRootViewController:[ [MessagePageTableViewController alloc] init] ];
    messagePageNavigationController.tabBarItem.title = @"消息";
    [messagePageNavigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]} forState:UIControlStateSelected];
    messagePageNavigationController.tabBarItem.image = [UIImage imageNamed:@"message.png"];
    messagePageNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"message-fill.png"];
    [self addChildViewController:messagePageNavigationController];
    
    UINavigationController *myPageNavigationController = [[UINavigationController alloc] initWithRootViewController:[ [MyPageViewController alloc] init] ];
    myPageNavigationController.tabBarItem.title = @"我";
    [myPageNavigationController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]} forState:UIControlStateSelected];
    myPageNavigationController.tabBarItem.image = [UIImage imageNamed:@"my.png"];
    myPageNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"my-fill.png"];
    [self addChildViewController:myPageNavigationController];
    
}


@end
