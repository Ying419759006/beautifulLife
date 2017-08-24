//
//  PhotoTool.h
//  testApp
//
//  Created by YanqiaoW on 17/7/25.
//  Copyright © 2017年 ewbao. All rights reserved.
//  相册工具类

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


@interface PhotoTool : NSObject

+ (PhotoTool *)sharePhoneTool;

//相册权限
- (BOOL)isAuthorization;

//C语言函数保存
//1 把图片保存到系统相册中，结束后调用 image:didFinishSavingWithError:contextInfo:方法（回调方法）
//2 回调方法的格式有要求，可以进入头文件查看
- (void)useCsave:(UIImage *)image;

/**同步方式保存图片到系统的相机胶卷中---返回的是当前保存成功后相册图片对象集合*/
-(PHFetchResult<PHAsset *> *)syncSaveImageWithPhotos:(UIImage *)image;

/**拥有与 APP 同名的自定义相册--如果没有则创建*/
-(PHAssetCollection *)getAssetCollectionWithAppNameAndCreateIfNo;

/**将图片保存到自定义相册中*/
-(void)saveImageToCustomAblum:(UIImage *)image;

@end
