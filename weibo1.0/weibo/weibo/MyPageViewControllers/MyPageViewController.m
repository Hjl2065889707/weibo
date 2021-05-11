//
//  MyPageViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/4/30.
//

#import "MyPageViewController.h"
#import "MyCollectionsTableViewController.h"


@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *myCollectsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [myCollectsButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    myCollectsButton.frame = CGRectMake(100,100,50, 50);
    [myCollectsButton addTarget:self action:@selector(collectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myCollectsButton];
    
}

- (void)collectButtonPressed
{
    NSLog(@"pressed");
    
}

@end
