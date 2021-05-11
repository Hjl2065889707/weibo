//
//  PostWBViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/10.
//

#import "PostWBViewController.h"

@interface PostWBViewController ()
@property(strong,nonatomic)UITextView *textView;

@end

@implementation PostWBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"send.png"] style:UIBarButtonItemStyleDone target:self action:@selector(postButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = postButton;

    
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(20, 150, 300, 300);
    _textView.font = [UIFont systemFontOfSize:25];
    _textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_textView];
    
}

- (void)postButtonPressed
{
    NSLog(@"post");
    
}



@end
