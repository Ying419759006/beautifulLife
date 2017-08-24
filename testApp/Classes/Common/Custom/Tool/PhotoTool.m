//
//  PhotoTool.m
//  testApp
//
//  Created by YanqiaoW on 17/7/25.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#import "PhotoTool.h"

@implementation PhotoTool

+ (PhotoTool *)sharePhoneTool
{
    static PhotoTool *_photoTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _photoTool = [[PhotoTool alloc] init];
    });
    return _photoTool;
}

//相册权限
- (BOOL)isAuthorization
{
    
    /*
     PHAuthorizationStatusNotDetermined ,---用户之前还未决定
     PHAuthorizationStatusRestricted, ---系统问题，用户没有权限决定--比如家长控制器模式
     PHAuthorizationStatusDenied,---用户之前拒绝过
     PHAuthorizationStatusAuthorized --用户允许
     */
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        // 这里便是无访问权限
        return NO;
    }
    return YES;
}

//C语言函数保存
//1 把图片保存到系统相册中，结束后调用 image:didFinishSavingWithError:contextInfo:方法（回调方法）
//2 回调方法的格式有要求，可以进入头文件查看
- (void)useCsave:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

//实现回调方法
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        NSLog(@"保存图片失败");
        return;
    }
    NSLog(@"保存图片成功");
}

/**同步方式保存图片到系统的相机胶卷中---返回的是当前保存成功后相册图片对象集合*/
-(PHFetchResult<PHAsset *> *)syncSaveImageWithPhotos:(UIImage *)image
{
    //--1 创建 ID 这个参数可以获取到图片保存后的 asset对象
    __block NSString *createdAssetID = nil;
    
    //--2 保存图片
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //----block 执行的时候还没有保存成功--获取占位图片的 id，通过 id 获取图片---同步
        createdAssetID = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    //--3 如果失败，则返回空
    if (error) {
        return nil;
    }
    
    //--4 成功后，返回对象
    //获取保存到系统相册成功后的 asset 对象集合，并返回
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetID] options:nil];
    return assets;
    
}

/**拥有与 APP 同名的自定义相册--如果没有则创建*/
-(PHAssetCollection *)getAssetCollectionWithAppNameAndCreateIfNo
{
    //1 获取以 APP 的名称
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    //2 获取与 APP 同名的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        //遍历
        if ([collection.localizedTitle isEqualToString:title]) {
            //找到了同名的自定义相册--返回
            return collection;
        }
    }
    
    //说明没有找到，需要创建
    NSError *error = nil;
    __block NSString *createID = nil; //用来获取创建好的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //发起了创建新相册的请求，并拿到ID，当前并没有创建成功，待创建成功后，通过 ID 来获取创建好的自定义相册
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        createID = request.placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"创建失败"];
        return nil;
    }else{
        [SVProgressHUD showSuccessWithStatus:@"创建成功"];
        //通过 ID 获取创建完成的相册 -- 是一个数组
        return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createID] options:nil].firstObject;
    }
    
}

/**将图片保存到自定义相册中*/
-(void)saveImageToCustomAblum:(UIImage *)image
{
    //1 将图片保存到系统的【相机胶卷】中---调用刚才的方法
    PHFetchResult<PHAsset *> *assets = [self syncSaveImageWithPhotos:image];
    if (assets == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        return;
    }
    
    //2 拥有自定义相册（与 APP 同名，如果没有则创建）--调用刚才的方法
    PHAssetCollection *assetCollection = [self getAssetCollectionWithAppNameAndCreateIfNo];
    if (assetCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"相册创建失败"];
        return;
    }
    
    
    //3 将刚才保存到相机胶卷的图片添加到自定义相册中 --- 保存带自定义相册--属于增的操作，需要在PHPhotoLibrary的block中进行
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //--告诉系统，要操作哪个相册
        PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        //--添加图片到自定义相册--追加--就不能成为封面了
        //--[collectionChangeRequest addAssets:assets];
        //--插入图片到自定义相册--插入--可以成为封面
        [collectionChangeRequest insertAssets:assets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        return;
    }
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
}


@end
