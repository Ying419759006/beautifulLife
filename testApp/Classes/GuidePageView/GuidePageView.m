//
//  GuidePageView.m
//  
//
//
//

#import "GuidePageView.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface GuidePageView ()<UIScrollViewDelegate>
{
    NSArray *_arrayOfImageNames;//图片名
    UIPageControl *_pageControl;//分页控制器
    UIScrollView *_scrollView;
}
@end

@implementation GuidePageView

-(id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray{
    if (self = [super initWithFrame:frame]) {
        _arrayOfImageNames = imageArray;
        //创建Scrollview
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH + 64)];
        //设置分页
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;//关闭弹簧效果
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        
        //设置contentsize
        _scrollView.contentSize = CGSizeMake(imageArray.count * SCREENW, SCREENH+64);
        for (int i = 0; i<imageArray.count; i++) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREENW, 0, SCREENW,SCREENH)];
            imageV.image = [UIImage imageNamed:imageArray[i]];
            imageV.contentMode = UIViewContentModeScaleAspectFit;
            imageV.userInteractionEnabled = YES;//imageView默认没有打开用户交互
            [_scrollView addSubview:imageV];
            
            if (i == imageArray.count-1) { //最后一页 添加跳转button
                //跳转按钮
                self.goInButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.goInButton.frame = CGRectMake((SCREENW-200)/2, SCREENH-100, 200, 40);
                
                [self.goInButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [self.goInButton setTitle:@"开启你的另一面" forState:UIControlStateNormal];
                [self.goInButton addTarget:self action:@selector(goInButtonClick) forControlEvents:UIControlEventTouchUpInside];
                self.goInButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                self.goInButton.titleLabel.textColor = [UIColor redColor];
                self.goInButton.layer.borderWidth = 1;
                self.goInButton.layer.borderColor = [UIColor yellowColor].CGColor;
                self.goInButton.layer.cornerRadius = 10;
                self.goInButton.layer.masksToBounds = YES;
//                [imageV addSubview:self.goInButton];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goInButtonClick)];
                [imageV addGestureRecognizer:tap];
            
            }
        }
        [self addSubview:_scrollView];
        //添加分页控制器
        [self addPageControl];
    }
    return self;
}
#pragma mark - 建立滚动视图和分页控制器的关联
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger numberOfPage = offSetX / _scrollView.frame.size.width;
    _pageControl.currentPage = numberOfPage;
    _pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
}
-(void)addPageControl{
    //1 获取分页控制器对象
    CGFloat pageControlX = 0;
    CGFloat pageControlW = self.frame.size.width;
    CGFloat pageControlH = 60;
    CGFloat pageControlY = self.frame.size.height-pageControlH;
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH)];
    
    //2 设置属性
    _pageControl.numberOfPages = _arrayOfImageNames.count;
    _pageControl.userInteractionEnabled = NO;//不让用户点击
    
    //3 添加到界面
//    [self addSubview:_pageControl];//不加
}

-(void)goInButtonClick{
    [UIView animateWithDuration:2.0 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformScale(self.transform, 2.0, 2.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
