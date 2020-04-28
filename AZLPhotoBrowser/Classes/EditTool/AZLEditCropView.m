//
//  AZLEditCropView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/27.
//

#import "AZLEditCropView.h"

typedef NS_ENUM(NSUInteger, AZLEditCropViewPanType) {
    AZLEditCropViewPanTypeNone,
    AZLEditCropViewPanTypeLeftTop,
    AZLEditCropViewPanTypeRightTop,
    AZLEditCropViewPanTypeRightBottom,
    AZLEditCropViewPanTypeLeftBottom
};

@interface AZLEditCropView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *lineH1;
@property (nonatomic, strong) UIView *lineH2;

@property (nonatomic, strong) UIView *lineV1;
@property (nonatomic, strong) UIView *lineV2;

@property (nonatomic, assign) AZLEditCropViewPanType paningType;

@end

@implementation AZLEditCropView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat squareWidth = self.bounds.size.width/3;
    CGFloat squareHeight = self.bounds.size.height/3;
    
    self.lineH1 = [[UIView alloc] initWithFrame:CGRectMake(0, squareHeight, width, 1)];
    self.lineH1.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.lineH1];
    self.lineH2 = [[UIView alloc] initWithFrame:CGRectMake(0, squareHeight*2, width, 1)];
    self.lineH2.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.lineH2];
    
    self.lineV1 = [[UIView alloc] initWithFrame:CGRectMake(squareWidth, 0, 1, height)];
    self.lineV1.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.lineV1];
    self.lineV2 = [[UIView alloc] initWithFrame:CGRectMake(squareWidth*2, 0, 1, height)];
    self.lineV2.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.lineV2];
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat squareWidth = self.bounds.size.width/3;
    CGFloat squareHeight = self.bounds.size.height/3;
    
    self.lineH1.frame = CGRectMake(0, squareHeight, width, 1);
    self.lineH2.frame = CGRectMake(0, squareHeight*2, width, 1);
    self.lineV1.frame = CGRectMake(squareWidth, 0, 1, height);
    self.lineV2.frame = CGRectMake(squareWidth*2, 0, 1, height);
}

- (void)viewDidPan:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
    
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
    
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
    
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.paningType == AZLEditCropViewPanTypeNone) {
        return YES;
    }else{
        return NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
