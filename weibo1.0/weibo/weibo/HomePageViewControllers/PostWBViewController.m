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
    
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(20, 150, 300, 300);
    _textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_textView];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
