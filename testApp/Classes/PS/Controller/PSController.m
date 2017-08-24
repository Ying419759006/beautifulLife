//
//  DeviceController.m
//  testApp
//
//  Created by YanqiaoW on 17/6/5.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#import "PSController.h"
#import "PSView.h"
#import "PhotoTool.h"


@interface PSController ()<PSViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) UIImageView *imageV; //要被PS的图片

@property (nonatomic, assign)CGPoint startP;    //切图时开始点

@property (nonatomic, assign)CGPoint moveStartP;    //移动图时开始点

@property (nonatomic,assign) CGPoint curP;

//@property (nonatomic,weak) PSView *PSImageView;  //PS块

@property (nonatomic, weak) UIView *coverView;  //裁剪区域

@property (nonatomic,strong) NSMutableArray *psViewArray; //ps块数组

@property (nonatomic,weak) UIButton *removeButton; //撤销按钮

@property (nonatomic,weak) UIButton *addButton;

@end

@implementation PSController

- (NSMutableArray *)psViewArray
{
    if (!_psViewArray) {
        _psViewArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _psViewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    [self addSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(50, 120, 60, 60);
    [addButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [addButton addTarget: self action: @selector(addImage:) forControlEvents: UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:addButton];
    self.addButton = addButton;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.addButton removeFromSuperview];
}

- (void)setNavItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setImage:[UIImage imageNamed:@"撤销"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"撤销选中"] forState:UIControlStateSelected];
    leftButton.selected = YES;
    [leftButton addTarget: self action: @selector(removePSView:) forControlEvents: UIControlEventTouchUpInside];
    self.removeButton = leftButton;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 25, 25);
    [saveButton setImage:[UIImage imageNamed:@"保存"] forState:UIControlStateNormal];
    [saveButton addTarget: self action: @selector(save) forControlEvents: UIControlEventTouchUpInside];
   
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addSubViews
{
    //设置需要PS的图片
    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.frame = self.view.bounds;
    backImage.userInteractionEnabled = YES;
    backImage.image = [UIImage imageNamed:@"美女桌面"];
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [backImage addGestureRecognizer:pan];

    [self.view addSubview:backImage];
    self.imageV = backImage;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"靓图";
}

- (void)addImage:(UIButton *)button
{
    [self addImage];
}

- (void)save
{
    //获取当前的授权状态
    BOOL isAuthorization = [[PhotoTool sharePhoneTool] isAuthorization];
    
    //存入相册
    if (isAuthorization) {
        [[PhotoTool sharePhoneTool] saveImageToCustomAblum:[self getNewImage]];
    }
    
}

#pragma mark --撤销
-(void)removePSView:(UIButton *)removeButton
{
    //移除截取的ps块
    [[self.psViewArray lastObject] removeFromSuperview];
    
    [self.psViewArray removeLastObject];
    
    removeButton.selected = self.psViewArray.count <= 0 ? YES: NO;
}

//截图时半透明背景
-(UIView *)coverView {
    
    if (_coverView == nil) {
        //创建UIView
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.7;
        _coverView = coverView;
        [self.view addSubview:coverView];
    }
    return _coverView;
    
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    
    //获取当前手指所在的点
    CGPoint curP = [pan locationInView:self.imageV];
    self.curP = curP;
    
    //判断手势的状态
    if(pan.state == UIGestureRecognizerStateBegan) {
        //记录当前手指的开始点
        self.startP = curP;
        
    } else if(pan.state == UIGestureRecognizerStateChanged) {
        
        //rect
        CGFloat w = curP.x - self.startP.x;
        CGFloat h = curP.y - self.startP.y;
        CGRect rect = CGRectMake(self.startP.x, self.startP.y, w, h);
        
        self.coverView.frame = rect;
        
        
    }else if(pan.state == UIGestureRecognizerStateEnded) {
        
        //模糊方案
        //UIImage *newImage = [self imageWithImageSimple:self.imageV.image scaledToSize:self.coverView.frame.size];
        
        
        //生成一张图片(高清)
        UIGraphicsBeginImageContextWithOptions(self.imageV.size, NO, 0.0);
        
        //设置裁剪区域
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.coverView.frame];
        [path addClip];
        
        //2.把UIImageV当中的内容渲染到上下文当中
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.imageV.layer renderInContext:ctx];

        //从上下文当中获取图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //关闭上下文
        UIGraphicsEndImageContext();
        
        
        //PS需要的新view
        PSView *newImageView = [[PSView alloc] initWithFrame:self.coverView.frame];
        
        //给PSView添加子控件, 隐藏白色边框
        UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:self.imageV.bounds];
        contentImageView.image = newImage;
        contentImageView.left = - self.coverView.left;
        contentImageView.top = - self.coverView.top;
        
        [newImageView addSubview:contentImageView];
        newImageView.delegate = self;
        newImageView.backgroundColor = [UIColor yellowColor];
        newImageView.userInteractionEnabled = YES;
        [self.imageV addSubview:newImageView];
        
        //添加到ps块数组
        [self.psViewArray addObject:newImageView];
        
        self.removeButton.selected = self.psViewArray.count > 0 ? NO : YES;
        
        //移除灰色透明板
        [self.coverView removeFromSuperview];

    }
}

//记录ps块原始位置
static CGPoint oldOrigin;
#pragma mark --PSViewDelegate
- (void)panPSView:(PSView *)psView pan:(UIPanGestureRecognizer *)pan
{
    
    //获取当前手指所在的点
    CGPoint curP = [pan locationInView:self.imageV];
    
    //判断手势的状态
    if(pan.state == UIGestureRecognizerStateBegan) {
        
        //记录当前手指的开始点
        self.moveStartP = curP;
        
        oldOrigin = psView.frame.origin;
        
        
    } else if(pan.state == UIGestureRecognizerStateChanged) {
        
        //rect
        CGFloat w = curP.x - self.moveStartP.x;
        CGFloat h = curP.y - self.moveStartP.y;
        NSLog(@"移动距离:%f,%f",w,h);
        psView.left = oldOrigin.x + w;
        psView.top = oldOrigin.y + h;
        
    }

}

//截屏
-(UIImage *)getNewImage
{
    //生成图片
    //1.开启一个位图上下文
    //高清 (iOS 7之后)
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    //模糊
//    UIGraphicsBeginImageContext(self.view.bounds.size);
    //2.把View的内容绘制到上下文当中
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    //UIView内容想要绘制到上下文当中, 必须使用渲染的方式
    [self.view.layer renderInContext:ctx];
    //3.从上下文当中生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

#pragma mark - 相机相册相关功能
- (void)addImage
{
    NSLog(@"选择相机还是相册");
    
    __block UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择照片来源" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    
    /**
     *  style参数：
     UIAlertActionStyleDefault,
     UIAlertActionStyleCancel,
     UIAlertActionStyleDestructive（默认按钮文本是红色的）
     *
     */
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"点击了相机");
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            
            [self presentPickerController:sourceType];
            
        } else {
            
            NSLog(@"当前设备不支持拍照");
            
        }
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"点击了相册");
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentPickerController:sourceType];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"点击了取消");
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}

- (void)presentPickerController:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    self.imagePickerController = imagePickerController;
    imagePickerController.delegate = self;  // 设置委托
    imagePickerController.sourceType = sourceType;
//    imagePickerController.allowsEditing = YES;
    imagePickerController.allowsEditing = NO;

    [self presentViewController:imagePickerController animated:YES completion:^{
//        [self dismissViewControllerAnimated:imagePickerController completion:nil];
    }];
}

//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:picker completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    self.imageV.image = image;
//    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    
    /* 以下是保存文件到沙盒路径下 */
    /* 把图片转成NSData类型的数据来保存文件 */
//    NSData *data;
//    
//    /* 判断图片是不是png格式的文件 */
//    if (UIImagePNGRepresentation(image))
//    {
//        /* 返回为png图像 */
//        data = UIImagePNGRepresentation(image);
//    }
//    else
//    {
//        /* 返回为JPEG图像 */
//        data = UIImageJPEGRepresentation(image, 1.0);
//    }
//    [[Tool sharedTool] setIconImageData:data];  //每次更换完头像本地储存
    
}



//模糊方案
//- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
//
//{
//
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//
//    return newImage;
//    
//}

@end
