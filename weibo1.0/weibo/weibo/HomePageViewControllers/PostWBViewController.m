//
//  PostWBViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/17.
//

#import "PostWBViewController.h"
#import "UserInformation.h"
#import "TheWbData.h"
#import <Photos/Photos.h>

@interface PostWBViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic)UITextView *textView;
@property(strong,nonatomic)TheWbData *theWBData;
@property(strong,nonatomic)UIImagePickerController *imagePicker;
@property(strong,nonatomic)NSMutableArray *postedWBArray;

@end

@implementation PostWBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStyleDone target:self action:@selector(postWB)];
    self.navigationItem.rightBarButtonItem = postButton;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    _textView.font = [UIFont systemFontOfSize:22];
    _textView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_textView];
    
    UIButton *selectPictureButton = [UIButton systemButtonWithImage:[UIImage imageNamed:@"home.png"] target:self action:@selector(selectPictureButtonPressed)];
    selectPictureButton.frame = CGRectMake(100, 450, 50, 50);
    [self.view addSubview:selectPictureButton];
    

    
}






#pragma mark - postButtonMethod

- (void)postWB
{
    NSLog(@"post!");

    UserInformation *userInformation = [[UserInformation alloc] init];

    
    _postedWBArray = [NSMutableArray arrayWithContentsOfFile:userInformation.postedWBFilePath];
    if (_postedWBArray == nil) {
        _postedWBArray = [NSMutableArray array];
    }
    
    //获取当前时间
    NSDate *date = [NSDate date];
    //设置日期格式
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy MM dd HH:mm:ss"];
    //变为数字
    NSString* dateStr = [formatter1 stringFromDate:date];
    
    _theWBData = [[TheWbData alloc] init];
    _theWBData.name =  [NSString stringWithFormat:@"%@",userInformation.userId];
    _theWBData.profileImageURL = @"https://www.baidu.com/img/flexible/logo/pc/result@2.png";
    _theWBData.creatTime = dateStr;
    _theWBData.location = @"广州";
    _theWBData.text = _textView.text;
    _theWBData.pictureNumber = @0;
    _theWBData.pictureURLs = [NSArray array];
    _theWBData.attitudesCount = @666;
    _theWBData.commentsCount = @666;
    _theWBData.repostsCount = @666;
    _theWBData.userId = @123456 ;
    _theWBData.originalPictureURL = @"nil";
    _theWBData.middlePictureURL = @"nil";
    
    [_postedWBArray addObject:[TheWbData initDicitonaryWithTheWbData:_theWBData ]];
    NSArray *tempArray = [NSArray arrayWithArray:_postedWBArray];
   NSLog(@"%d",[tempArray writeToFile:userInformation.postedWBFilePath atomically:NO]) ;
    
}

#pragma mark - SelectPictureButtonMethod
- (void)selectPictureButtonPressed
{
    NSLog(@"select");
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = NO;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePicker animated:YES completion:NULL];
    

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    
    [_imagePicker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(10, 500, 50, 50);
    [self.view addSubview: imageView];

}

@end
