//
//  HBImagePickerController.h
//  HBImagePickerControl
//
//  Created by HXJG-Applemini on 15/11/17.
//  Copyright © 2015年 HXJG-Applemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// 返回数据的类型
typedef NS_ENUM(NSInteger, HBImageType) {
    HBImageTypeAsset,                // 获得ALAsset对象
    HBImageTypeThumbnail,            // 获得剪切后的正方形缩略图
    HBImageTypeAspectRatioThumbnail, // 获得原比例的图片
    HBImageTypeFullScreeen,          // 获得全屏的图片
    HBImageTypeFullResolutionImage,  // 获得高清图
    HBImageTypeFileURL               // 获得文件的URL
};

@class HBImagePickerController;

@protocol HBImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(HBImagePickerController *)imagePicker didFinishedSelected:(NSArray *)images;

@optional
- (void)imagePickerControllerDidCancel:(HBImagePickerController *)imagePicker;

@end

@interface HBImagePickerController : UINavigationController

@property (nonatomic,assign) NSInteger maximumNumberOfSelection;// 最大选择数量
@property (nonatomic,assign) NSInteger numberOfSelected;// 之前已选择的图片数量 默认为0
@property (nonatomic,assign) BOOL isShowCamera; // 是否显示拍照
@property (nonatomic,assign) HBImageType imageType; // 返回数据类型，默认为返回ALAsset对象

@property (nonatomic,assign) BOOL isShowBtmPrompt;// 是否显示选择图片的底部提示，仅在超出一张时有效
@property (nonatomic,assign) id<HBImagePickerControllerDelegate,UINavigationControllerDelegate>delegate;
@property (nonatomic,strong) ALAssetsFilter *assetsFilter;

@end



