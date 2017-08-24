//
//  HBImagePickerCameraCell.m
//  HBImagePickerControl
//
//  Created by HXJG-Applemini on 15/11/17.
//  Copyright © 2015年 HXJG-Applemini. All rights reserved.
//

#import "HBImagePickerCameraCell.h"
#import "Masonry.h"

#define IMAGE_HEIGHT 45
@implementation HBImagePickerCameraCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    [self initCameraImageView];
//    [self initTextLabel];
}

- (void)initCameraImageView{
    _cameraImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hb_msg_reply_photo_default1"]];// bjxc_pz
    _cameraImage.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleAspectFit;

    [self addSubview:_cameraImage];
    [_cameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.centerX.mas_equalTo(self.contentView);
//        make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(20);
//        make.width.height.offset(IMAGE_HEIGHT);
//        make.edges.mas_equalTo(self.contentView);
        make.centerX.centerY.mas_equalTo(self.contentView);
         make.width.height.mas_equalTo(self.contentView);
//        make.width.height.offset(30);
        make.width.height.mas_equalTo(self.contentView);
    }];
}

//- (void)initTextLabel{
//    _textLabel = [[UILabel alloc]init];
//    _textLabel.backgroundColor = [UIColor clearColor];
//    _textLabel.textColor = [UIColor whiteColor];
//    _textLabel.text = @"拍照";
//    [self.contentView addSubview:_textLabel];
//    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.contentView);
//        make.top.mas_equalTo(_cameraImage.mas_bottom);
//    }];
//}

@end
