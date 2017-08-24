//
//  HBImagePickerController.m
//  HBImagePickerControl
//
//  Created by HXJG-Applemini on 15/11/17.
//  Copyright © 2015年 HXJG-Applemini. All rights reserved.
//

#import "HBImagePickerController.h"
#import "HBPhotosViewController.h"

@interface HBImagePickerController ()

@end

@implementation HBImagePickerController
@dynamic delegate;

- (instancetype)init
{
    HBPhotosViewController *photosVC = [[HBPhotosViewController alloc]init];
    self = [super initWithRootViewController:photosVC];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        _assetsFilter = [ALAssetsFilter allPhotos];
        if ([self respondsToSelector:@selector(setPreferredContentSize:)]) { //自行设置自己在popover中显示的尺寸
            
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
