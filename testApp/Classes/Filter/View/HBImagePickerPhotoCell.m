//
//  HBImagePickerPhotoCell.m
//  HBImagePickerControl
//
//  Created by HXJG-Applemini on 15/11/17.
//  Copyright © 2015年 HXJG-Applemini. All rights reserved.
//

#import "HBImagePickerPhotoCell.h"
#import "Masonry.h"

@implementation HBImagePickerPhotoCell
{
    BOOL _canSelected;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        self.backgroundColor = [UIColor blackColor];
        _canSelected = YES;
        [self initViews];
        [self addNotification];
    }
    return self;
}

- (void)initViews{
    [self initPhotoView];
    [self initSelectedView];
    [self initSelectionBtn];
}

- (void)initPhotoView{
    _photoView = [[UIImageView alloc]init];
    _photoView.contentMode = UIViewContentModeScaleAspectFill;
    _photoView.clipsToBounds = YES;
    [self.contentView addSubview:_photoView];
    
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)initSelectedView{
    _selectedView = [[UIView alloc]init];
    _selectedView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.contentView addSubview:_selectedView];
    [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
//    _selectedView.userInteractionEnabled = YES;
    _selectedView.hidden = YES;
}

- (void)initSelectionBtn
{
    _selectonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectonBtn setImage:[UIImage imageNamed:@"bjxc_wxz"] forState:UIControlStateNormal];
    [_selectonBtn setImage:[UIImage imageNamed:@"hb_my_xiangce_s"] forState:UIControlStateSelected];
    [_selectonBtn addTarget:self action:@selector(selectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectonBtn];
    [_selectonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.contentView);
        make.width.height.offset(35);
    }];
    
//    // 扩大点击范围
//    UIControl *control = [[UIControl alloc]init];
//    [control addTarget:self action:@selector(selectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:control];
//    [control mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.mas_equalTo(self.contentView);
//        make.width.height.offset(35);
//    }];
//    _selectedControl = control;
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canAddImage:) name:@"canAddImage" object:nil];
}

- (void)canAddImage:(NSNotification *)noti{
    NSNumber *boolValue = noti.object;
    _canSelected = boolValue.boolValue;
}

- (void)selectionBtnAction:(UIButton *)sender
{
    if (!_canSelected && !_selectonBtn.selected) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，别选了，这几张足够展示您的魅力了！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"就是这么自信，不选了", nil];
//        [alert show];
        if (self.overRanging) {
            self.overRanging();
        }
        return;
    }
    _selectonBtn.selected = !_selectonBtn.selected;
    //取消选中时去掉蒙版选中时加上蒙版，根据需求隐藏
    _selectedView.hidden = !_selectonBtn.selected;
    if (_senderSelected) {
        self.senderSelected(_selectonBtn.selected);
    }
}

- (void)setData:(ALAsset *)asset isSelected:(BOOL)isSelected isShowBtn:(BOOL)isShowBtn canSelected:(BOOL)canSelected{
//    self.photoView.image = [UIImage imageWithCGImage:asset.thumbnail]; //之前使用asset.thumbnail非常模糊
    
    NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithCGImage:asset.aspectRatioThumbnail], 0.1);
    UIImage * newImage = [UIImage imageWithData:imgData];
    self.photoView.image = newImage;
    
    _canSelected = canSelected;
//    if (isShowBtn) {
//        _selectonBtn.hidden = NO;
//        _selectonBtn.selected = isSelected;
//        _selectedView.hidden = !isSelected;
//    }else {
//        _selectonBtn.hidden = YES;
//        _selectedView.hidden = YES;
//    }
    _selectonBtn.selected = isSelected;
    _selectonBtn.hidden = !isShowBtn;
    //取消选中时去掉蒙版选中时加上蒙版，根据需求隐藏
//    _selectedView.hidden = !isShowBtn;
//    _selectedControl.hidden = !isShowBtn;
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
