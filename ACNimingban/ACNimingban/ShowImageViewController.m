//
//  ShowImageViewController.m
//  ACNimingban
//
//  Created by lanou3g on 16/1/27.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "ShowImageViewController.h"
#import "UIColor+iOS7Colors.h"
#import "KParser.h"
#import "KGif.h"
#import "KGesture.h"
#define imgURL @"http://cdn.ovear.info:8998"


// 图片格式
enum imageType{
    typeImg,
    typeGif
};

@interface ShowImageViewController ()
// 原始宽高360x360
// 静态图view, 高height 宽width
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgW;
// 动态图view, 高height 宽width
@property (weak, nonatomic) IBOutlet UIWebView *gifView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gifH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gifW;
/** 用于暂时接收图片 */
@property(nonatomic,strong)UIImage *tempImage;
// 记录图片宽高格式
@property(nonatomic,assign)double tempH;
@property(nonatomic,assign)double tempW;
@property(nonatomic,assign)int tempType;
// 文件管理者
@property(nonatomic,strong)NSFileManager *manager;
@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图片查看";
    // 导航栏按钮图标
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down.png"] style:UIBarButtonItemStylePlain target:self action:@selector(downloadAction)];
    self.navigationItem.rightBarButtonItem = right;

    // 开启图片交互
    self.imgView.userInteractionEnabled = YES;
    
    // 加载图片
    [KParser imageShowWithURL:[imgURL stringByAppendingString:self.model.image] handler:^(UIImage *image) {
        self.tempImage = image;
        // 回到主线程处理
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showImg_Gif];
            [self.view reloadInputViews];
        });
    }];
}

#pragma mark - 导航栏样式变化以及Back
#pragma mark Back返回,导航栏还原
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    // 按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor iOS7darkBlueColor];
    // 标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    // nav背景色
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

#pragma mark 视图即将加载,导航栏样式变化
- (void)viewWillAppear:(BOOL)animated{
    // 按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // nav背景色
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}

#pragma mark - 图片处理
- (void)showImg_Gif{
    // 拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    // 图片宽高记录，格式
    _tempH = self.tempImage.size.height;
    _tempW = self.tempImage.size.width;
    _tempType = [[self.model.image uppercaseString] hasSuffix:@"GIF"]?typeGif:typeImg;
    // 添加手势
    if(_tempType==typeImg){
        self.gifH.constant = 0;
        self.imgView.image = self.tempImage;
        [self.imgView addGestureRecognizer:pan];
    }else{
        self.imgH.constant = 0;
        [KGif gifWithImageURL:[imgURL stringByAppendingString:self.model.image] webView:self.gifView setting:nil];
        [self.gifView addGestureRecognizer:pan];
    }
    // 图片显示宽高,注意WebView高+64
    NSLayoutConstraint *height = (_tempType == typeImg?self.imgH:self.gifH);
    NSLayoutConstraint *width  = (_tempType == typeImg?self.imgW:self.gifW);
    if(_tempW<360){
        width.constant = _tempW;
        height.constant = (_tempType==typeImg?_tempH:_tempH+64);
    }else{
        width.constant = 360;
        double h = (_tempH/_tempW)*360;
        height.constant = (_tempType==typeImg?h:h+64);
    }
}

#pragma mark 长图拖动手势添加
- (void)panAction:(UIPanGestureRecognizer*)pan{
    if((_tempType == typeImg?self.imgW.constant:self.gifW.constant) <= [UIScreen mainScreen].bounds.size.width){
        CGPoint center = pan.view.center;
        [KGesture gesturePanWithGesture:pan];
        pan.view.center = CGPointMake(center.x, pan.view.center.y);
    }else{
        [KGesture gesturePanWithGesture:pan];
        CGRect frame = pan.view.frame;
        if(frame.origin.x >= 0){
            frame.origin.x = 0;
            pan.view.frame = frame;
        }
        if(frame.origin.x <= ([UIScreen mainScreen].bounds.size.width - _tempW)){
            frame.origin.x = ([UIScreen mainScreen].bounds.size.width - _tempW);
            pan.view.frame = frame;
        }
    }
    
}

#pragma mark 图片缩放
BOOL isZoom = NO;
- (IBAction)zoomImage:(UIButton *)sender {
    // 动画模式
    [UIView beginAnimations:@"animation" context:nil];
    // 当图片实际宽大于360时放大,否则不处理,注意webView高+64
    if(_tempW > 360){
        NSLayoutConstraint *height = (_tempType == typeImg?self.imgH:self.gifH);
        NSLayoutConstraint *width  = (_tempType == typeImg?self.imgW:self.gifW);
        if(isZoom == NO){
            height.constant = (_tempType==typeImg?_tempH:_tempH+64);
            width.constant = _tempW;
            isZoom = YES;
            [sender setImage:[UIImage imageNamed:@"zoom0.png"] forState:UIControlStateNormal];
        }else{
            width.constant = 360;
            double h = (_tempH/_tempW)*360;
            height.constant = (_tempType==typeImg?h:h+64);
            isZoom = NO;
            [sender setImage:[UIImage imageNamed:@"zoom.png"] forState:UIControlStateNormal];
        }
    }
    [UIView commitAnimations];
}

// 暂时不实现
#pragma mark - 图片下载,保存至本地相册
- (void)downloadAction{
    // 初始化文件管理者
    self.manager = [[NSFileManager alloc] init];
    // Document 路径
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    // 设置data二进制文件类型
    NSData *data = [NSData data];
    // 判断图片格式: (.GIF), (.PNG), (.JPG|.JPEG)
    if(_tempType == typeGif){
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imgURL stringByAppendingString:self.model.image]]];
    }else{
        if([[self.model.image uppercaseString] hasSuffix:@"PNG"]){
            data = UIImagePNGRepresentation(self.tempImage);
        }else{
            data = UIImageJPEGRepresentation(self.tempImage, 1);
        }
    }
    // 存储路径
    NSArray *array = [self.model.image componentsSeparatedByString:@"/"];
    NSString *imgPath = [@"/" stringByAppendingString:(NSString*)[array lastObject]];
    [self.manager createFileAtPath:[filePath stringByAppendingString:imgPath] contents:data attributes:nil];
    // 打印路径
    NSLog(@"%@", [filePath stringByAppendingString:imgPath]);
}

#pragma mark - 页面即将消失, 图片消失(高度为零)
- (void)viewWillDisappear:(BOOL)animated{
    self.imgH.constant = 0;
    self.gifH.constant = 0;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
