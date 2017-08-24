//
//  CenterController.m
//  testApp
//
//  Created by YanqiaoW on 17/7/24.
//  Copyright © 2017年 ewbao. All rights reserved.
//

#import "CenterController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface CenterController ()<MAMapViewDelegate>

@property (nonatomic,weak) MAMapView *mapView;

@end

@implementation CenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
}

-(void)addSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title  = @"小吃货";
    
    ///初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    mapView.showsUserLocation = NO;
    //    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    ///把地图添加至view
    [self.view addSubview:mapView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    self.mapView = mapView;
    
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    //精度圈是否显示：
    
    r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    //是否显示蓝点方向指向：
    
    r.showsHeadingIndicator = YES;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
    //调整精度圈填充颜色：
    
    r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
    //调整精度圈边线颜色：
    
    r.strokeColor = [UIColor blueColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
    //调整精度圈边线宽度：
    
    r.lineWidth = 2;///精度圈 边线宽度，默认0
    //精度圈是否显示律动效果：
    
    //    r.enablePulseAnnimation = NO;///内部蓝色圆点是否使用律动效果, 默认YES
    //    //调整定位蓝点的背景颜色：
    //
    //    r.locationDotBgColor = [UIColor greenColor];///定位点背景色，不设置默认白色
    //    //调整定位蓝点的颜色：
    //
    //    r.locationDotFillColor = [UIColor grayColor];///定位点蓝色圆点颜色，不设置默认蓝色
    //    //调整定位蓝点的图标：
    
    r.image = [UIImage imageNamed:@"jian"]; ///定位图标, 与蓝色原点互斥
    //执行：
    
    [mapView updateUserLocationRepresentation:r];
    
    //自定义大头针
    [self sustomPointAnnotation];
    
    //自定义范围圆
    [self customCircle];
    
}

- (void)clickBtn
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"hbAlipaySchemes://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"hbAlipaySchemes://"]];
    }
}

//自定义大头针
- (void)sustomPointAnnotation{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [self.mapView addAnnotation:pointAnnotation];
    
}

//实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式。 如下所示：
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)customCircle
{
    //构造圆
    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.952136, 116.50095) radius:5000];
    
    //在地图上添加圆
    [_mapView addOverlay: circle];
    
}

//继续在ViewController.m文件中，实现<MAMapViewDelegate>协议中的mapView:rendererForOverlay:回调函数，设置圆的样式。示例代码如下：
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth    = 5.f;
        circleRenderer.strokeColor  = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        circleRenderer.fillColor    = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
        return circleRenderer;
    }
    return nil;
}

@end
