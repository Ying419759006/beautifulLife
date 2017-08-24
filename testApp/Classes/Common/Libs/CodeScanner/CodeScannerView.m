//
//  CodeScannerView.m
//  SmartDevice
//
//  Created by YanqiaoW on 16/12/14.
//  Copyright © 2016年 ewbao. All rights reserved.
//

#import "CodeScannerView.h"
#import "CodeScannerMatchView.h"
#import <AVFoundation/AVFoundation.h>

@interface CodeScannerView () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) CodeScannerMatchView *matchView;
@property (nonatomic, strong) NSDate *lastDetectionDate;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;

@end

@implementation CodeScannerView {
    NSTimer *_timer;
    BOOL _scanning;
    BOOL _wasScanning;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
        
        AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([videoCaptureDevice lockForConfiguration:&error]) {
            if (videoCaptureDevice.isAutoFocusRangeRestrictionSupported) {
                [videoCaptureDevice setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
            }
            if ([videoCaptureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [videoCaptureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            [videoCaptureDevice unlockForConfiguration];
        } else {
            NSLog(@"Could not configure video capture device: %@", error);
        }
        
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
        if(videoInput) {
            [self.captureSession addInput:videoInput];
        } else {
            NSLog(@"Could not create video input: %@", error);
        }
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:self.previewLayer];
        
        self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.captureSession addOutput:self.metadataOutput];
        [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode]];
        
        self.matchView = [[CodeScannerMatchView alloc] init];
        [self addSubview:self.matchView];
        self.quietPeriodAfterMatch = 2.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deactivate)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:[UIApplication sharedApplication]];
        
        // Register for notification that app did enter foreground
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(activate)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:[UIApplication sharedApplication]];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setMetadataObjectTypes:(NSArray *)metaDataObjectTypes {
    [self.metadataOutput setMetadataObjectTypes:metaDataObjectTypes];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewLayer.frame = self.bounds;
    
    //扫描范围限制在框内
    CGRect rect = self.bounds;
    CGFloat margin = 50;
    CGFloat matchViewWH = SCREEN_WIDTH - margin*2;
    rect.size = CGSizeMake(matchViewWH, matchViewWH);
    rect.origin.x = margin;
    rect.origin.y = 100;
    
    self.matchView.frame = rect;
    
    /*
     //Doesn't work for some reason: CGAffineTransform error
    CGRect rect = [self.previewLayer metadataOutputRectOfInterestForRect:self.previewLayer.bounds];
    self.metadataOutput.rectOfInterest = rect;
    */ 
}

- (void)start {
    if (!_scanning) {
        _scanning = YES;
        [self.matchView reset];
        [self.captureSession startRunning];
        
        if ([self.delegate respondsToSelector:@selector(scannerViewDidStartScanning:)]) {
            [self.delegate scannerViewDidStartScanning:self];
        }
    }
    
}

- (void)stop {
    if (_scanning) {
        _scanning = NO;
        [_timer invalidate];
        _timer = nil;
        //新增
        [self.matchView stop];
        [self.captureSession stopRunning];
        
        if ([self.delegate respondsToSelector:@selector(scannerViewDidStopScanning:)]) {
            [self.delegate scannerViewDidStopScanning:self];
        }
    }
}

- (void)deactivate {
    _wasScanning = _scanning;
    [self stop];
}

- (void)activate {
    if (_wasScanning) {
        [self start];
        _wasScanning = NO;
    }
}

- (CGPoint)pointFromArray:(NSArray *)points atIndex:(NSUInteger)index {
    NSDictionary *dict = [points objectAtIndex:index];
    CGPoint point;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dict, &point);    
    return [self.matchView convertPoint:point fromView:self];
}

- (BOOL)isInQuietPeriod {
    return self.lastDetectionDate != nil && (-[self.lastDetectionDate timeIntervalSinceNow]) <= self.quietPeriodAfterMatch;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([self isInQuietPeriod]) {
        return;
    }
    for(AVMetadataObject *metadataObject in metadataObjects)
    {
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
            BOOL foundMatch = readableObject.stringValue != nil;
            NSArray *corners = readableObject.corners;
            NSLog(@"corners ==== %@", corners);
            if (corners.count == 4 && foundMatch) {
                
                CGPoint topLeftPoint     = [self pointFromArray:corners atIndex:0];
                CGPoint bottomLeftPoint  = [self pointFromArray:corners atIndex:1];
                CGPoint bottomRightPoint = [self pointFromArray:corners atIndex:2];
                CGPoint topRightPoint    = [self pointFromArray:corners atIndex:3];
                
                if (CGRectContainsPoint(self.matchView.bounds, topLeftPoint) &&
                    CGRectContainsPoint(self.matchView.bounds, topRightPoint) &&
                    CGRectContainsPoint(self.matchView.bounds, bottomLeftPoint) &&
                    CGRectContainsPoint(self.matchView.bounds, bottomRightPoint))
                {
                    [self stop];
                    _timer = [NSTimer scheduledTimerWithTimeInterval:self.quietPeriodAfterMatch
                                                              target:self
                                                            selector:@selector(start)
                                                            userInfo:nil
                                                             repeats:NO];
                    self.lastDetectionDate = [NSDate date];
                    
                    [self.matchView setFoundMatchWithTopLeftPoint:topLeftPoint
                                                    topRightPoint:topRightPoint
                                                  bottomLeftPoint:bottomLeftPoint
                                                 bottomRightPoint:bottomRightPoint];
                    
                    [self.delegate scannerView:self didReadCode:readableObject.stringValue];
                }
            }
        }
    }
}

@end
