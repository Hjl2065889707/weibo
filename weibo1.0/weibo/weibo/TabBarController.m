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
    HomePageTableViewController *homePageTableViewController = [ [HomePageTableViewController alloc] init];
    homePageTableViewController.tabBarItem.title = @"主页";
    homePageTableViewController.tabBarItem.image = [UIImage imageNamed:@"home.png"];
    homePageTableViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"home-fill.png"];
    [self addChildViewController:homePageTableViewController];
    
    FindPageTableViewController *findPageTableViewController = [[FindPageTableViewController alloc] init];
    findPageTableViewController.tabBarItem.title = @"发现";
    findPageTableViewController.tabBarItem.image = [UIImage imageNamed:@"find.png"];
    findPageTableViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"find-fill.png"];
    [self addChildViewController:findPageTableViewController];
    
    
    MessagePageTableViewController *messagePageTableViewController = [[MessagePageTableViewController alloc] init];
    messagePageTableViewController.tabBarItem.title = @"消息";
    messagePageTableViewController.tabBarItem.image = [UIImage imageNamed:@"message.png"];
    messagePageTableViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"message-fill.png"];
    [self addChildViewController:messagePageTableViewController];
    
    MyPageViewController *myPageViewController = [[MyPageViewController alloc] init];
    myPageViewController.tabBarItem.title = @"我";
    myPageViewController.tabBarItem.image = [UIImage imageNamed:@"my.png"];
    myPageViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"my-fill.png"];
    [self addChildViewController:myPageViewController];
}


@end
