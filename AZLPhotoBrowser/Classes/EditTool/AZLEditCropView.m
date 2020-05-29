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
    AZLEditCropViewPanTypeLeftBottom,
    AZLEditCropViewPanTypeEdge
};

@interface AZLEditCropView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *lineH1;
@property (nonatomic, strong) UIView *lineH2;

@property (nonatomic, strong) UIView *lineV1;
@property (nonatomic, strong) UIView *lineV2;

@property (nonatomic, assign) AZLEditCropViewPanType paningType;
@property (nonatomic, assign) CGRect transStartFrame;

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
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
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
        CGPoint point = [gesture locationInView:[self superview]];
        CGFloat left = self.frame.origin.x;
        CGFloat right = self.frame.origin.x+self.frame.size.width;
        CGFloat top = self.frame.origin.y;
        CGFloat bottom = self.frame.origin.y+self.frame.size.height;
        if (self.paningType == AZLEditCropViewPanTypeLeftTop) {
            self.frame = CGRectMake(point.x, point.y, right-point.x, bottom-point.y);
        }else if (self.paningType == AZLEditCropViewPanTypeRightTop) {
            self.frame = CGRectMake(left, point.y, point.x-left, bottom-point.y);
        }else if (self.paningType == AZLEditCropViewPanTypeRightBottom) {
            self.frame = CGRectMake(left, top, point.x-left, point.y-top);
        }else if (self.paningType == AZLEditCropViewPanTypeLeftBottom) {
            self.frame = CGRectMake(point.x, top, right-point.x, point.y-top);
        }else if (self.paningType == AZLEditCropViewPanTypeEdge) {
            CGPoint trans = [gesture translationInView:self];
            self.frame = CGRectMake(self.transStartFrame.origin.x+trans.x, self.transStartFrame.origin.y+trans.y, self.transStartFrame.size.width, self.transStartFrame.size.height);
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        self.paningType = AZLEditCropViewPanTypeNone;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self];
    if (point.x < 50 && point.y < 50) {
        self.paningType = AZLEditCropViewPanTypeLeftTop;
    }else if (point.x > self.bounds.size.width-50 && point.y < 50) {
        self.paningType = AZLEditCropViewPanTypeRightTop;
    }else if (point.x > self.bounds.size.width-50 && point.y > self.bounds.size.height-50) {
        self.paningType = AZLEditCropViewPanTypeRightBottom;
    }else if (point.x < 50 && point.y > self.bounds.size.height-50) {
        self.paningType = AZLEditCropViewPanTypeLeftBottom;
    }
//    else if (point.x < 50 || point.x > self.bounds.size.width-50 || point.y < 50 || point.y > self.bounds.size.height-50) {
//        self.paningType = AZLEditCropViewPanTypeEdge;
//        self.transStartFrame = self.frame;
//    }
    else{
        self.paningType = AZLEditCropViewPanTypeEdge;
        self.transStartFrame = self.frame;
    }
//    else{
//        self.paningType = AZLEditCropViewPanTypeNone;
//        return NO;
//    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (self.isHidden == YES || self.userInteractionEnabled == NO) {
//        return nil;
//    }
//    if (point.x < 50 || point.x > self.bounds.size.width-50 || point.y < 50 || point.y > self.bounds.size.height-50) {
//        return [super hitTest:point withEvent:event];
//    }
//    return nil;
//}


@end
