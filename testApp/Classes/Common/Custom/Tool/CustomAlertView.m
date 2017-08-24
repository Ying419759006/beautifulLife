//
//  CustomAlertView.m
//  CustomAlertView
//


#import "CustomAlertView.h"
#import <objc/runtime.h>

#define MAINSCREENwidth   [UIScreen mainScreen].bounds.size.width
#define MAINSCREENheight  [UIScreen mainScreen].bounds.size.height
#define KEYWINDOW       [[UIApplication sharedApplication] keyWindow]
#define RGB(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define AlertViewJianGe 19.5

@interface CustomAlertView()

@property(nonatomic,strong)UIView *bGView;
@property (nonatomic,strong)UILabel *sexLab;//性别
@property (nonatomic,strong)UILabel *locationLab;//区域
@property (nonatomic,strong)UIButton *qRButton;
@property (nonatomic,strong)NSMutableArray *selectedBtnMArr;//选中的按钮数组
@property (nonatomic,strong)UIImageView *selfImage;

@end

@implementation CustomAlertView
{
    float alertViewHeight;
    float _sexLineVY;
}

-(UIView *)bGView{
    if (!_bGView) {
        _bGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENwidth, MAINSCREENheight)];
        _bGView.backgroundColor = [UIColor blackColor];
        _bGView.alpha = 0.2;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackground:)];
        [_bGView addGestureRecognizer:tap1];
    }
    return _bGView;
}
-(instancetype)initWithAlertViewFrame:(CGRect)frame viewcontroller:(UIViewController *)vc
{
    self=[super init];
    
    CGFloat AlertViewHeight = 350;
    _VC = vc;
    [KEYWINDOW addSubview:self.bGView];
    self.center = CGPointMake(MAINSCREENwidth/2, MAINSCREENheight/2);
    self.bounds = CGRectMake(0, frame.origin.y, MAINSCREENwidth, AlertViewHeight);
    [KEYWINDOW addSubview:self];
    
    _selfImage = [[UIImageView alloc] initWithFrame:CGRectMake(AlertViewJianGe, frame.origin.y, MAINSCREENwidth-2*AlertViewJianGe, AlertViewHeight)];
    _selfImage.backgroundColor = [UIColor whiteColor];
    alertViewHeight = AlertViewHeight;
    _selfImage.layer.cornerRadius = 5;
    _selfImage.layer.masksToBounds = YES;
    [self addSubview:_selfImage];
    
    _sexLab = [[UILabel alloc] init];
    _sexLab.frame = CGRectMake(_selfImage.frame.origin.x+10,_selfImage.frame.origin.y+10, 130, 40);
    _sexLab.font = [UIFont systemFontOfSize:14];
    _sexLab.adjustsFontSizeToFitWidth = YES;
    _sexLab.textColor = RGB(47, 46, 51, 1);
    _sexLab.text = @"性别";
    [self addSubview:_sexLab];
    
    _sexLineVY = 0;
    NSArray *sexArr = @[@"全部",@"男生",@"女生"];
    [self addAllSelectedBtn:sexArr withImg:_selfImage beginTag:100 beginY:_sexLab defaultSelectionIndex:2];
    
    NSArray *locationArr = @[@"附近",@"已关注"];
    _locationLab = [[UILabel alloc] init];
    _locationLab.frame = CGRectMake(_selfImage.frame.origin.x+10,_sexLineVY+30, 130, 40);
    _locationLab.font = [UIFont systemFontOfSize:14];
    _locationLab.adjustsFontSizeToFitWidth = YES;
    _locationLab.textColor = RGB(47, 46, 51, 1);
    _locationLab.text = @"区域";
    [self addSubview:_locationLab];
    [self addAllSelectedBtn:locationArr withImg:_selfImage beginTag:200 beginY:_locationLab defaultSelectionIndex:1];
    
    //确定按钮
    CGFloat btnHeight = 40;
    _qRButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _qRButton.frame = CGRectMake((self.frame.size.width-100)/2, _selfImage.frame.size.height-btnHeight-15, 100, btnHeight);
    _qRButton.backgroundColor = RGB(47, 46, 51, 1);
    [_qRButton setTitleColor:[UIColor whiteColor] forState:0];
    _qRButton.layer.cornerRadius = 3;
    _qRButton.layer.masksToBounds = YES;
    [_qRButton setTitle:@"确认" forState:UIControlStateNormal];
    _qRButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _qRButton.tag =1;
    [self addSubview:_qRButton];
    [_qRButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}


- (void)addAllSelectedBtn:(NSArray *)mArr withImg:(UIImageView *)image beginTag:(NSInteger)beginTag beginY:(UIView *)beginView defaultSelectionIndex:(NSInteger)index{

    for (int i=0; i<mArr.count/3+1; i++) {
        float btnW = 60;//(image.frame.size.width-4*10)/3;
        float btnH = 30;
        float gap = (image.frame.size.width-btnW*mArr.count)/(mArr.count+1);
        float btnY = beginView.frame.origin.y+beginView.frame.size.height+10 + i*(5+btnH)+5;
        for (int j=0; j<3; j++) {
            float btnX = j*(gap+btnW)+gap+image.frame.origin.x;
            if (i>=mArr.count/3&&j>=mArr.count%3) {
                break;
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:mArr[i*3+j] forState:UIControlStateNormal];
            btn.tag = beginTag+i*3+j;
            
            [btn setTitleColor:RGB(47, 46, 51, 1) forState:UIControlStateSelected];
            [btn setTitleColor:RGB(153, 153, 153, 1) forState:UIControlStateNormal];
            
            if (index == j&&i==0) {
                btn.selected = YES;
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = [UIColor orangeColor].CGColor;
                [self.selectedBtnMArr addObject:btn.titleLabel.text];
            }
            
            [btn addTarget:self action:@selector(changeButtonStatus:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            
            [self addSubview:btn];
        }
        _sexLineVY = beginView.frame.origin.y+beginView.frame.size.height+10+5+btnH+10;
    }
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(image.frame.origin.x, _sexLineVY, image.frame.size.width, 0.3f)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineV];
}

- (void)clickBackground:(UITapGestureRecognizer *)sender{
    [self hide:YES];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 更改Button状态
- (void)changeButtonStatus:(UIButton *)sender
{
    
    NSArray *viewsArray = [self subviews];
    for (int i=0; i<viewsArray.count; i++) {
        
        if ([viewsArray[i] isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)viewsArray[i];
            if (((btn.tag>=100&&btn.tag<200)&&(sender.tag>=100&&sender.tag<200))||(btn.tag>=200&&sender.tag>=200)) {
                if (btn.selected == YES&&btn!=sender) {
                    btn.selected = NO;
                    btn.layer.borderColor = [UIColor clearColor].CGColor;
                    if ([self.selectedBtnMArr containsObject:btn.titleLabel.text]) {
                        [self.selectedBtnMArr removeObject:btn.titleLabel.text];
                    }
                    continue;
                }
            }
        }
    }
    sender.selected = YES;
    sender.layer.borderWidth = 0.5;
    sender.layer.borderColor = [UIColor orangeColor].CGColor;
    
//    [self.selectedBtnMArr removeAllObjects];
    for (int i=0; i<viewsArray.count; i++) {
        
        if ([viewsArray[i] isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)viewsArray[i];
            if (((btn.tag>=100&&btn.tag<200)&&(sender.tag>=100&&sender.tag<200))||(btn.tag>=200&&sender.tag>=200)){
                if (btn.selected == YES) {
                    if (![self.selectedBtnMArr containsObject:btn.titleLabel.text]) {
                        [self.selectedBtnMArr addObject:btn.titleLabel.text];
                    }
                    
                }
            }
        }
    }
}
-(NSMutableArray *)selectedBtnMArr{
    if (!_selectedBtnMArr) {
        _selectedBtnMArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedBtnMArr;
}
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)buttonClick:(UIButton*)button
{
    
    if (button.tag == 1) {
        NSLog(@"反馈--选中了：%@",self.selectedBtnMArr);
        if (self.selectedBtnMArr.count>0) {
            if ([self.delegate respondsToSelector:@selector(screenSuccess:)]) {
                [self.delegate screenSuccess:self.selectedBtnMArr];
            }
            
            [self hide:YES];
        }
    }
}
- (void)show:(BOOL)animated
{
    /*
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak CustomAlertView *weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        }];
    }
     */
}

- (void)hide:(BOOL)animated
{
    [self endEditing:YES];
    if (self.bGView) {

        __weak CustomAlertView *weakSelf = self;
        [weakSelf.bGView removeFromSuperview];
        [weakSelf removeFromSuperview];
        weakSelf.bGView=nil;
    }
    
}



@end
