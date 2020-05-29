//
//  AZLColorPickView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import "AZLColorPickView.h"
#import <AZLExtend/AZLExtend.h>

@interface AZLColorPickView()

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation AZLColorPickView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    self.gradientLayer = gradientLayer;
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor, (id)[UIColor redColor].CGColor, (id)[UIColor yellowColor].CGColor, (id)[UIColor greenColor].CGColor, (id)[UIColor cyanColor].CGColor, (id)[UIColor blueColor].CGColor, (id)[UIColor purpleColor].CGColor, (id)[UIColor blackColor].CGColor]; //设置渐变颜色
    // gradientLayer.locations = @[@0.0, @0.2, @0.5]; //颜色的起点位置，递增，并且数量跟颜色数量相等
    gradientLayer.startPoint = CGPointMake(0, 0); // 
    gradientLayer.endPoint = CGPointMake(1, 0); // 
    [self.layer addSublayer:gradientLayer]; //将图层添加到视图的图层上
    
    self.selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    self.selectView.centerX = 0;
    self.selectView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.selectView.layer.borderWidth = 3;
    self.selectView.layer.cornerRadius = self.height/2;
    [self addSubview:self.selectView];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

- (void)viewDidTap:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [gesture locationInView:self];
        UIColor *color = [[UIImage azl_imageFromView:self] azl_colorFromPoint:point];
        self.selectView.centerX = point.x;
        if (self.block) {
            self.block(color);
        }
    }
}

- (void)viewDidPan:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesture locationInView:self];
        self.selectView.centerX = point.x;
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed) {
        CGPoint point = self.selectView.center;
        UIColor *color = [self azl_colorAtPoint:point];
        if (self.block) {
            self.block(color);
        }
    }
}

@end
