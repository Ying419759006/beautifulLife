//
//  CodeScannerView.h
//  SmartDevice
//
//  Created by YanqiaoW on 16/12/14.
//  Copyright © 2016年 ewbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CodeScannerView;

@protocol CodeScannerViewDelegate < NSObject >

- (void)scannerView:(CodeScannerView *)scannerView didReadCode:(NSString*)code;

@optional
- (void)scannerViewDidStartScanning:(CodeScannerView *)scannerView;
- (void)scannerViewDidStopScanning:(CodeScannerView *)scannerView;

@end


@interface CodeScannerView : UIView

@property (nonatomic, weak) id <CodeScannerViewDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval quietPeriodAfterMatch;

- (void)setMetadataObjectTypes:(NSArray *)metaDataObjectTypes;
- (void)start;
- (void)stop;

@end
