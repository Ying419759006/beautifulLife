//
//  FilterController.m
//  testApp
//
//  Created by YanqiaoW on 17/7/24.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#import "FilterController.h"

#import "HBImagePickerController.h"

@interface FilterController () <HBImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation FilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showImagePickerVC];
}

- (void)addSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"滤镜";
    
//    [self showImagePickerVC];
}

- (void)showImagePickerVC{
    HBImagePickerController *vc = [[HBImagePickerController alloc]init];
    vc.isShowCamera = YES;
    vc.maximumNumberOfSelection = 5;// 最大选择数量 //测试
    vc.delegate = self;
    //    vc.isShowBtmPrompt = YES;//测试
    
    vc.imageType=HBImageTypeFullResolutionImage;// 获得高清图
    //    vc.imageType = HBImageTypeAspectRatioThumbnail;
    /*
     HBImageTypeAsset,                // 获得ALAsset对象
     HBImageTypeThumbnail,            // 获得剪切后的正方形缩略图
     HBImageTypeAspectRatioThumbnail, // 获得原比例的图片
     HBImageTypeFullScreeen,          // 获得全屏的图片
     HBImageTypeFullResolutionImage,  // 获得高清图
     HBImageTypeFileURL               // 获得文件的URL
     */
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
