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

@interface PostWBViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property(strong,nonatomic)UITextView *textView;
@property(strong,nonatomic)UILabel *placeHolder;
@property(strong,nonatomic)TheWbData *theWBData;
@property(strong,nonatomic)UIImagePickerController *imagePicker;
@property(strong,nonatomic)NSMutableArray *postedWBArray;

@end

@implementation PostWBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //postButton
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(postWB)];
    postButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = postButton;
    //模拟placeHolder
    _placeHolder = [[UILabel alloc] init];
    _placeHolder.text = @"分享新鲜事...";
    _placeHolder.textColor = [UIColor grayColor];
    _placeHolder.frame = CGRectMake(7, 105, 200, 35);
    _placeHolder.font = [UIFont systemFontOfSize:22];
//    _placeHolder.backgroundColor = [UIColor redColor];
    [self.view addSubview:_placeHolder];
    
    //textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    _textView.font = [UIFont systemFontOfSize:22];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    //自动弹出键盘
    [_textView becomeFirstResponder];
    
    
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
    //变为str
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
    _theWBData.wbId = @0;
    
    [_postedWBArray addObject:[TheWbData initDicitonaryWithTheWbData:_theWBData ]];
    NSArray *tempArray = [NSArray arrayWithArray:_postedWBArray];
    NSString *alertStr = @"";
    if ([tempArray writeToFile:userInformation.postedWBFilePath atomically:NO]) {
        alertStr = @"发送成功!";
    }else{
        alertStr = @"发送失败!";
    }
    //提示是否发送成功
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    //暂停1秒来显示alertController
    [NSThread sleepForTimeInterval:1];
    [self dismissViewControllerAnimated:YES completion:^{
        //自动回到homePage页面，并刷新数据
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate performSelector:@selector(reloadTabelViewData)];
    }];

    
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

#pragma mark - textViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (_textView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        _placeHolder.hidden = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
        _placeHolder.hidden = NO;

    }
}



@end
