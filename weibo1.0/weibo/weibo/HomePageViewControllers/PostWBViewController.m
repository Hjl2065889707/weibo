//
//  PostWBViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/17.
//

#import "PostWBViewController.h"
#import "UserInformation.h"
#import "TheWbData.h"
#import <PhotosUI/PhotosUI.h>

@interface PostWBViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property(strong,nonatomic)UITextView *textView;
@property(strong,nonatomic)UILabel *placeHolder;
@property(strong,nonatomic)TheWbData *theWBData;
@property(strong,nonatomic)UIImagePickerController *imagePicker;
@property(strong,nonatomic)NSMutableArray *postedWBArray;
@property(strong,nonatomic)UIImageView  *imageView;


@end

@implementation PostWBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _theWBData = [[TheWbData alloc] init];
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
    [self.view addSubview:_placeHolder];
    
    //textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 250)];
    _textView.font = [UIFont systemFontOfSize:22];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    //自动弹出键盘
    [_textView becomeFirstResponder];
    //选择图片
    UIButton *selectPictureButton = [UIButton systemButtonWithImage:[UIImage imageNamed:@"picture.png"] target:self action:@selector(selectPictureButtonPressed)];
    selectPictureButton.frame = CGRectMake(10, 500, 50, 50);
    [self.view addSubview:selectPictureButton];
    
    //图片预览
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(10, 350, 150, 150);
        [self.view addSubview: _imageView];
    
}






#pragma mark - postButtonMethod

- (void)postWB
{
    NSLog(@"post!");

    UserInformation *userInformation = [[UserInformation alloc] init];
    //初始化_postedWBArray
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
    
    _theWBData.name =  [NSString stringWithFormat:@"%@",userInformation.userId];
    _theWBData.profileImageURL = @"https://www.baidu.com/img/flexible/logo/pc/result@2.png";
    _theWBData.creatTime = dateStr;
    _theWBData.location = @"广州";
    _theWBData.text = _textView.text;
    if (_theWBData.pictureNumber.intValue != 1 ) {
        _theWBData.pictureNumber = @0;
    }
    
    _theWBData.pictureURLs = [NSArray array];
    _theWBData.attitudesCount = @666;
    _theWBData.commentsCount = @666;
    _theWBData.repostsCount = @666;
    _theWBData.userId = @123456 ;
    if (_theWBData.originalPictureURL == nil) {
        _theWBData.originalPictureURL = @"nil";
    }
    if (_theWBData.middlePictureURL == nil) {
        _theWBData.middlePictureURL = @"nil";
    }
    _theWBData.wbId = @0;
    
    [_postedWBArray addObject:[TheWbData initDicitonaryWithTheWbData:_theWBData] ];
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

#pragma mark - SelectPictureButtonMethod
- (void)selectPictureButtonPressed
{
    //选择图片的按钮
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    if ([ [info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        NSURL *imageURL = [info objectForKey:UIImagePickerControllerImageURL];
        NSString *URLString = [NSString stringWithFormat:@"%@",imageURL];
        _theWBData.originalPictureURL = URLString;
        _theWBData.middlePictureURL = URLString;
        NSLog(@"URL = %@",URLString);
        _theWBData.pictureNumber = @1;
        _theWBData.pictureData = [NSData dataWithContentsOfURL:imageURL];
        _imageView.image = [UIImage imageWithData:_theWBData.pictureData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
