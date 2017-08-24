//
//  HBImagePickerPhotoCell.h
//  HBImagePickerControl
//
//  Created by HXJG-Applemini on 15/11/17.
//  Copyright © 2015年 HXJG-Applemini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^SenderSeleted)(BOOL isSelected);
@interface HBImagePickerPhotoCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *photoView;
@property (nonatomic,strong) UIButton *selectonBtn;
//@property (nonatomic,strong) UIControl *selectedControl;  //扩大按钮点击范围的
@property (nonatomic,strong) UIView *selectedView;
@property (nonatomic,copy) SenderSeleted senderSelected;

@property (nonatomic,copy) void (^overRanging)();

- (void)setData:(ALAsset *)asset isSelected:(BOOL)isSelected isShowBtn:(BOOL)isShowBtn canSelected:(BOOL)canSelected;

@end
