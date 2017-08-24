//
//  HBPhotosViewController.m
//  HBImagePickerControl
//
//  Created by HXJG-Applemini on 15/11/17.
//  Copyright © 2015年 HXJG-Applemini. All rights reserved.
//

#import "HBPhotosViewController.h"
#import "Masonry.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HBImagePickerPhotoCell.h"
#import "HBImagePickerCameraCell.h"
#import "HBImagePickerController.h"
#import <AVFoundation/AVFoundation.h>

#import "Tool.h"
//#import "HBPreViewController.h"
//#import "HBUtils.h"
//#import "HBCommon.h"
//#import <MobileCoreServices/MobileCoreServices.h>
//#import "UIImage+Helpers.h"

//#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//#define TOP_HEIGHT 20+44 // 导航栏和状态栏高度
#define BOTTOM_BG_VIEW_HEIGHT 60
#define MIN_SPACE 1.5
#define CELL_WIDTH (SCREEN_WIDTH - 4*MIN_SPACE)/3

#define HB_IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface HBPhotosViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collecttionV;
@property (nonatomic,strong) UIView *bottomBgV;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) NSMutableArray *allAssets; // 所有照片的数组
@property (nonatomic,strong) NSMutableArray *indexPaths;// 已选照片的数组
@property (nonatomic,assign) NSInteger numbersOfPhotos;// 已选择的数量
@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;


@end

@implementation HBPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
    
    [self initCollectionView];
    
    [self setupIndexPathArray];
    
    [self setupGroup];
}

- (void)setNavBar{
    
    self.title = @"相册";
    self.view.backgroundColor = [UIColor whiteColor];

    //右侧item
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 25);
    [btn setImage:[UIImage imageNamed:@"add_nextBtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSeperator.width = -12;
//    self.navigationItem.rightBarButtonItems = @[negativeSeperator,barBtn];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    //左侧item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}
- (void)rightBtnClick:(UIButton *)sender{
    [self commit];
    
}

- (void)commit{
    NSMutableArray *assets = [[NSMutableArray alloc]init];
    HBImagePickerController *vc = (HBImagePickerController *)self.navigationController;
    for (NSIndexPath *indexPath in _indexPaths) {
        
        ALAsset *asset = [self.allAssets objectAtIndex:[self isShowCamera]?(indexPath.item - 1):indexPath.item];
        if (asset == nil) {
            break;
        }
        id obiect = [self getDataWithAsset:asset andImageType:vc.imageType];
        if (!obiect) {
            break;
        }
        [assets addObject:obiect];
    }
    
    if (assets.count==0) {
        [Tool showWarningSVProgressHUDWithStatus:@"请选择照片" time:1.0];
        return;
    }
    
    if ([vc.delegate respondsToSelector:@selector(imagePickerController:didFinishedSelected:)]) {
        [vc.delegate imagePickerController:vc didFinishedSelected:assets];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)backBtnClicked:(UIButton*)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCollectionView
{
    int cols = 3;
    CGFloat itemWH = (SCREEN_WIDTH - MIN_SPACE * (cols + 1))/cols;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = MIN_SPACE;
    flowLayout.minimumLineSpacing = MIN_SPACE;
    flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    
    CGFloat X = 0;
    CGFloat Y = NavigationBarHeight;
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT - Y;
    
    CGRect frame = CGRectMake(X, Y, width, height);
//    CGRect frame;
//    if ([self getImagePickerController].maximumNumberOfSelection > 1 && [self getImagePickerController].isShowBtmPrompt) {
//        frame = CGRectMake(X, Y, width, height - BOTTOM_BG_VIEW_HEIGHT);
//    }else {
//        frame = CGRectMake(X, Y, width, height);
//    }
    
    _collecttionV = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    _collecttionV.delegate = self;
    _collecttionV.dataSource = self;
    _collecttionV.backgroundColor = [UIColor whiteColor];
    _collecttionV.allowsMultipleSelection = YES;
    _collecttionV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collecttionV];
    
    [_collecttionV registerClass:[HBImagePickerCameraCell class] forCellWithReuseIdentifier:@"HBImagePickerCameraCell"];
    [_collecttionV registerClass:[HBImagePickerPhotoCell class] forCellWithReuseIdentifier:@"HBImagePickerPhotoCell"];
}

#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.allAssets >0) {
        [self.allAssets sortUsingComparator:[self getSortComparatorByDate]];
    }
    
    //如果显示(照相机)图标
    if ([self isShowCamera]) {
        return self.allAssets.count + 1;
    }
    
    return self.allAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //照相机图片cell
    if ([self isShowCamera] && indexPath.section == 0&&indexPath.row == 0) {
        HBImagePickerCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HBImagePickerCameraCell" forIndexPath:indexPath];
        return cell;
    }
    
    //相册cell
    HBImagePickerPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HBImagePickerPhotoCell" forIndexPath:indexPath];
    ALAsset *asset = [self.allAssets objectAtIndex:[self isShowCamera]?(indexPath.row - 1):indexPath.row];
    
    // 是否被选中
    BOOL isSelected = [_indexPaths containsObject:indexPath];
    
    // 是否显示选中按钮 (最多选0张时, 看不见选中按钮)
//    BOOL isShowBtn = [self getImagePickerController].maximumNumberOfSelection == 0?NO:YES;
    
    [cell setData:asset isSelected:isSelected isShowBtn:YES canSelected:[self canAdd]];
    
    __weak typeof(self) weakSelf = self;
    [cell setSenderSelected:^(BOOL selected) {
        [weakSelf changeDataWithIndexPath:indexPath isSelected:selected];
    }];
    
    [cell setOverRanging:^{

        //超出设置最大选中数时提示框
        [Tool showWarningSVProgressHUDWithStatus:[NSString stringWithFormat:@"一次最多可选择%zd张图片",[weakSelf getImagePickerController].maximumNumberOfSelection] time:2.0];
        

    }];
    return cell;
}

#pragma mark - Collection View Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isShowCamera]) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            [self cameraChoose];
        }else {
            [self photoChooseWithIndexPath:indexPath];
        }
    }else {
        [self photoChooseWithIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isShowCamera]) {
        if (indexPath.section == 0&&indexPath.row == 0) {
            [self cameraChoose];
        }else {
            [self photoChooseWithIndexPath:indexPath];
        }
    }else {
        [self photoChooseWithIndexPath:indexPath];
    }
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CELL_WIDTH, CELL_WIDTH);
}

- (id)getDataWithAsset:(ALAsset *)asset andImageType:(HBImageType)imageType{
    switch (imageType) {
        case HBImageTypeAsset:{
            return asset;
        }
            break;
        case HBImageTypeThumbnail:{
            return [UIImage imageWithCGImage:asset.thumbnail];
        }
            break;
        case HBImageTypeAspectRatioThumbnail:{
            return [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
        }
            break;
        case HBImageTypeFullScreeen: {
            
            return [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
        }
            break;
        case HBImageTypeFullResolutionImage: {
            UIImage *image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullResolutionImage scale:1 orientation:(UIImageOrientation)[asset defaultRepresentation].orientation];
            //            image = [image fixOrientation];
            //            NSLog(@"%u",[UIImagePNGRepresentation(image) length]);
            //            UIImageOrientation imageOrientation = image.imageOrientation;
            return image;
        }
            break;
        case HBImageTypeFileURL: {
            return [asset valueForProperty:ALAssetPropertyAssetURL];
        }
            break;
        default:
            return asset;
            break;
    }
}

- (HBImagePickerController *)getImagePickerController{
    return (HBImagePickerController *)self.navigationController;
}

#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark set up data
- (void)setupIndexPathArray{
    if (!self.indexPaths) {
        self.indexPaths = [[NSMutableArray alloc]init];
    }else {
        [self.indexPaths removeAllObjects];
    }
}

// 获取照片分组
- (void)setupGroup{
    
    //不支持照相或无权限 返回
    if (![self valideChoosePhose]) {
        return;
    }
    
    //创建相册
    if (!self.assetsLibrary) {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    
    ALAssetsFilter *assetsFilter = [self getImagePickerController].assetsFilter;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock groupResultsBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            [group setAssetsFilter:assetsFilter];
            if (group.numberOfAssets > 0) {
                [self setupAssetsWithGroup:group];
            }
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error) {
        NSLog(@"获取照片失败 - %@",[error localizedDescription]);
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:groupResultsBlock
                                    failureBlock:failureblock];
    
}

// 根据分组获得图片
- (void)setupAssetsWithGroup:(ALAssetsGroup *)group{
    if (!self.allAssets) {
        self.allAssets = [[NSMutableArray alloc]init];
    }else {
        [self.allAssets removeAllObjects];
    }
    ALAssetsGroupEnumerationResultsBlock resultBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            //            UIImage *image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullResolutionImage];
            //            UIImageOrientation imageOrientation = image.imageOrientation;
            //            NSLog(@"imageOrientation : %d",imageOrientation);
            [self.allAssets addObject:asset];
        }else if (self.allAssets.count > 0) {
            [self.collecttionV reloadData];
        }
    };
    [group enumerateAssetsUsingBlock:resultBlock];
}

- (NSComparator)getSortComparatorByDate{
    return ^NSComparisonResult(id obj1, id obj2) {
        ALAsset *asset1 = obj1;
        ALAsset *asset2 = obj2;
        NSDate *date1 = [asset1 valueForProperty:ALAssetPropertyDate];
        NSDate *date2 = [asset2 valueForProperty:ALAssetPropertyDate];
        return [date2 compare:date1];
    };
}

- (BOOL)isShowCamera{
    return [self getImagePickerController].isShowCamera;
}

- (void)setBtnTitleWithSelectedIndexPaths:(NSArray *)indexPaths{
    NSString *title = [NSString stringWithFormat:@"发送    %lu/%ld",[self getImagePickerController].numberOfSelected + indexPaths.count,(long)[self getImagePickerController].maximumNumberOfSelection];
    [_sendBtn setTitle:title forState:UIControlStateNormal];
}

//打开相机
- (void) cameraChoose{
    
    NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    //  imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    if(HB_IS_IOS8){
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (BOOL)valideChoosePhose{
    if (![self doesCameraSupportTakingPhotos]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"此设备不支持照相" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
    {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"未获得授权使用相册" message:@"请在ios\"设置\"-\"隐私\"-\"照片\"中打开" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertV show];
        return NO;
    }
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted){
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在ios\"设置\"-\"隐私\"-\"相机\"中打开" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertV show];
        return NO;
    }
    return YES;
}

#pragma mark UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (![self valideChoosePhose]) {
        return;
    }
    if ([self getImagePickerController].maximumNumberOfSelection < 1) {
        return;
    }
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSDictionary *metaData = info[UIImagePickerControllerMediaMetadata];
    //    image = [image fixOrientation];
    //    image = [self scaleImageWithImage:image];
    
    [self.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:metaData completionBlock:^(NSURL *assetURL, NSError *error) {
        ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *asset) {
            if (asset) {
                // 只可以选择一张时
                if ([self getImagePickerController].maximumNumberOfSelection == 1) {
                    [self delegateMothedOnlyOneChooseWithALasset:asset];
                }else {
                    [_allAssets insertObject:asset atIndex:0];
                    [self.collecttionV reloadData];
                }
            }
            
        };
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error) {
            NSLog(@"获取照片失败 - %@",[error localizedDescription]);
        };
        if (assetURL) {
            [self.assetsLibrary assetForURL:assetURL
                                resultBlock:resultBlock
                               failureBlock:failureblock];
        }
    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
        
    }];
    return result;
}

//检查摄像头是否支持拍照
- (BOOL)doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:(NSString*)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)delegateMothedOnlyOneChooseWithALasset:(ALAsset *)asset{
    if ([[self getImagePickerController].delegate respondsToSelector:@selector(imagePickerController:didFinishedSelected:)]) {
        [[self getImagePickerController].delegate imagePickerController:[self getImagePickerController] didFinishedSelected:@[[self getDataWithAsset:asset andImageType:[self getImagePickerController].imageType]]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaleImageWithImage:(UIImage *)image{
    //判断长宽，是否有大于4096 若有，则缩放,效率不容乐观。。。
    //    CGSize size=image.size;
    //    if(image.size.width > IMAGE_MAX_SIZE_WIDTH || image.size.height >IMAGE_MAX_SIZE_WIDTH){
    //
    //        float max= MAX(image.size.width, image.size.height);
    //
    //        float scale = IMAGE_MAX_SIZE_WIDTH / max;
    //
    //        CGSize newSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    //
    //        image=[UIImage scaleImage:image toSize:newSize];
    //
    //
    //    }
    return image;
}

- (void)changeDataWithIndexPath:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected{
    if (isSelected) {
        if ([_indexPaths containsObject:indexPath]) {
            [_indexPaths removeObject:indexPath];
        }
        [_indexPaths addObject:indexPath];
    }else {
        [_indexPaths removeObject:indexPath];
    }
    [self postNotification];
    [self setBtnTitleWithSelectedIndexPaths:_indexPaths];
}

- (BOOL)canAdd{
    BOOL canAdd = YES;
    
    //如果已经选中个数>= (设置最大数 - 之前已经选中了的个数)  就不能继续添加图片了
    if (_indexPaths.count >= ([self getImagePickerController].maximumNumberOfSelection - [self getImagePickerController].numberOfSelected)) {
        canAdd = NO;
    }
    return canAdd;
}

- (void)postNotification{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"canAddImage" object:[NSNumber numberWithBool:[self canAdd]]];
    
}

//点击选择自定义的相册照片
- (void)photoChooseWithIndexPath:(NSIndexPath *)indexPath{
    
    if ([self getImagePickerController].maximumNumberOfSelection < 1) {
        return;
    }
    
    if ([self getImagePickerController].maximumNumberOfSelection == 1) {
        [self changeDataWithIndexPath:indexPath isSelected:YES];
//        [self commit]; ????
        return;
    }
    
    ALAsset *asset = [self.allAssets objectAtIndex:[self isShowCamera]?(indexPath.item -1):indexPath.item];
    //    if ([self getImagePickerController].maximumNumberOfSelection == 1) {
    //        [self delegateMothedOnlyOneChooseWithALasset:asset];
    //        return;
    //    }
    
    //跳转新控制器
    /*
    HBPreViewController *vc = [[HBPreViewController alloc]init];
    
    [self postNotification];
    HBImagePickerPhotoCell *cell = (HBImagePickerPhotoCell*)[_collecttionV cellForItemAtIndexPath:indexPath];
    vc.isSelected = cell.selectonBtn.selected;
    vc.canSelected = [self canAdd];
    __weak typeof(self) weakSelf = self;
    [vc setChoosePhoto:^(BOOL isChoosed) {
        [weakSelf changeDataWithIndexPath:indexPath isSelected:isChoosed];
        cell.selectonBtn.selected = isChoosed;
        cell.selectedView.hidden = !isChoosed;
    }];
    vc.isHiddenBottom = [self getImagePickerController].maximumNumberOfSelection == 1?YES:NO;
    [self pushNextVCByInstance:vc];
    // 单张预览
    vc.imageArrayType = HBImageArrayTypeImage;
    HBImageType imageType = [self getImagePickerController].imageType;
    UIImage *image;
    switch (imageType) {
        case HBImageTypeThumbnail:{
            image = [UIImage imageWithCGImage:asset.thumbnail];
            break;
        }
        case HBImageTypeFullResolutionImage:{
            image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
            break;
        }
        case HBImageTypeFullScreeen:{
            image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
            break;
        }
        default:
            image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
            break;
    }
    vc.imageArray = @[image];
    //    vc.imageArray = @[[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
    */
    
    
    // 连续预览
    //    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    //    for (ALAsset *asset in self.allAssets) {
    //        [mArray addObject:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
    //    }
    //    vc.imageArrayType = HBImageArrayTypeImage;
    //    vc.imageArray = mArray;
    //    vc.currectIndex = [self isShowCamera]?(indexPath.item -1):indexPath.item;
}

@end
