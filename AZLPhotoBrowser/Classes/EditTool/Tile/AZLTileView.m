//
//  AZLTileView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/5/15.
//

#import "AZLTileView.h"

@interface AZLTileView() <UIGestureRecognizerDelegate>


@property (nonatomic, assign) CGAffineTransform startTransform;

@property (nonatomic, assign) CGPoint startOrigin;
@property (nonatomic, assign) CGPoint lastOrigin;

@property (nonatomic, assign) CGFloat startScale;
@property (nonatomic, assign) CGFloat lastScale;

@property (nonatomic, assign) CGFloat startRoateAngle;
@property (nonatomic, assign) CGFloat lastRoateAngle;


@property (nonatomic, strong) UIPanGestureRecognizer *panGes;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGes;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotateGes;

@end

@implementation AZLTileView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _originPoint = frame.origin;
        _startScale = 1;
        _lastScale = 1;
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
        [self addGestureRecognizer:panGes];
        panGes.delegate = self;
        _panGes = panGes;
        UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPinch:)];
        [self addGestureRecognizer:pinchGes];
        pinchGes.delegate = self;
        _pinchGes = pinchGes;
        UIRotationGestureRecognizer *rotateGes = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidRotate:)];
        [self addGestureRecognizer:rotateGes];
        rotateGes.delegate = self;
        _rotateGes = rotateGes;
    }
    return self;
}

- (void)addTranslate:(CGPoint)tran{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1/self.lastScale, 1/self.lastScale);
    transform = CGAffineTransformRotate(transform, -self.lastRoateAngle);
    CGPoint newTran = CGPointApplyAffineTransform(tran, transform);
    self.lastOrigin = CGPointMake(self.lastOrigin.x+newTran.x, self.lastOrigin.y+newTran.y);
    [self updateTransform];
}

- (void)updateTransform{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, self.lastScale, self.lastScale);
    transform = CGAffineTransformRotate(transform, self.lastRoateAngle);
    transform = CGAffineTransformTranslate(transform, self.lastOrigin.x, self.lastOrigin.y);
    self.transform = transform;
}


- (void)viewDidPan:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        self.startOrigin = self.lastOrigin;
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint tran = [gesture translationInView:self];
        //NSLog(@"%0.2f, %0.2f", tran.x, tran.y);
        self.lastOrigin = CGPointMake(self.startOrigin.x+tran.x, self.startOrigin.y+tran.y);
        [self updateTransform];
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        //        CGPoint point = self.selectView.center;
        //        UIColor *color = [self azl_colorAtPoint:point];
        //        if (self.block) {
        //            self.block(color);
        //        }
        
    }
}

- (void)viewDidPinch:(UIPinchGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        self.startScale = self.lastScale;
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        self.lastScale = self.startScale*gesture.scale;
        [self updateTransform];
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        //        CGPoint point = self.selectView.center;
        //        UIColor *color = [self azl_colorAtPoint:point];
        //        if (self.block) {
        //            self.block(color);
        //        }
        
    }
}

- (void)viewDidRotate:(UIRotationGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        self.startRoateAngle = self.lastRoateAngle;
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        self.lastRoateAngle = self.startRoateAngle+gesture.rotation;
        [self updateTransform];
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        //        CGPoint point = self.selectView.center;
        //        UIColor *color = [self azl_colorAtPoint:point];
        //        if (self.block) {
        //            self.block(color);
        //        }
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (otherGestureRecognizer == self.panGes || otherGestureRecognizer == self.pinchGes || otherGestureRecognizer == self.rotateGes) {
        return YES;
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
