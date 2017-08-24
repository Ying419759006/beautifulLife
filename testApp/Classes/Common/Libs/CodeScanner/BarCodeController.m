//
//  BarCodeViewController.m
//  EasyCharge
//
//  Created by yager on 15/3/12.
//  Copyright (c) 2015年 ___yager.com___. All rights reserved.
//

#import "BarCodeController.h"

#import "CodeScannerView.h"
#import "SoundHelper.h"

@interface BarCodeController ()<CodeScannerViewDelegate>

@property (nonatomic, strong) CodeScannerView *codeScannerView;
@property (nonatomic, strong) UILabel *codeLabel;

@end

@implementation BarCodeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"扫码充电";
    
    CGFloat labelHeight = 60.0f;
    CGSize viewSize = self.view.bounds.size;
    self.codeScannerView = [[CodeScannerView alloc] initWithFrame:CGRectMake(0, 64, viewSize.width, viewSize.height - labelHeight)];
    self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.codeScannerView.frame.size.height, viewSize.width - 10, labelHeight)];
    
    self.codeLabel.backgroundColor = [UIColor clearColor];
    self.codeLabel.textColor = [UIColor whiteColor];
    self.codeLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.codeLabel.numberOfLines = 2;
    self.codeLabel.textAlignment = NSTextAlignmentCenter;
    self.codeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.codeScannerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.codeScannerView.delegate = self;
    [self.view addSubview:self.codeScannerView];
    [self.view addSubview:self.codeLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.codeScannerView stop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.codeScannerView start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

#pragma mark - CodeScannerViewDelegate

- (void)scannerView:(CodeScannerView *)scannerView didReadCode:(NSString *)code {
    NSLog(@"Scanned code: %@", code);
    
    self.codeLabel.text = [NSString stringWithFormat:@"扫描信息: %@", code];
    
    [self performSelector:@selector(beep) withObject:nil afterDelay:0.1];
}

- (void)scannerViewDidStartScanning:(CodeScannerView *)scannerView {
    self.codeLabel.text = @"正在扫描...";
}

- (void)scannerViewDidStopScanning:(CodeScannerView *)scannerView {
    
}

#pragma mark - Private

- (void)beep {
    [SoundHelper playSoundFromFile:@"BEEP.mp3" fromBundle:[NSBundle mainBundle] asAlert:YES];
}

@end
