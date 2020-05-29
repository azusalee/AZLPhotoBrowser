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

@property (nonatomic, strong) UIButton *deleteButton;


@property (nonatomic, assign) BOOL isPan;
@property (nonatomic, assign) BOOL isPinch;
@property (nonatomic, assign) BOOL isRotate;

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
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformScale(transform, 1/self.lastScale, 1/self.lastScale);
//    transform = CGAffineTransformRotate(transform, -self.lastRoateAngle);
    CGPoint newTran = tran;
    self.lastOrigin = CGPointMake(self.lastOrigin.x+newTran.x, self.lastOrigin.y+newTran.y);
    [self updateTransform];
}

- (void)updateTransform{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, self.lastOrigin.x, self.lastOrigin.y);
    transform = CGAffineTransformScale(transform, self.lastScale, self.lastScale);
    transform = CGAffineTransformRotate(transform, self.lastRoateAngle);
    
    self.transform = transform;
}

- (void)showDeleteButton{
    if (self.deleteButton == nil) {
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        [self.deleteButton setTitle:@"拖到此处删除" forState:UIControlStateNormal];
        self.deleteButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-69);
        [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.deleteButton.layer.borderWidth = 1;
        self.deleteButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [[UIApplication sharedApplication].keyWindow addSubview:self.deleteButton];
    }
}

- (void)hideDeleteButton{
    [self.deleteButton removeFromSuperview];
    self.deleteButton = nil;
}

- (void)checkEditEnd{
    if (self.isPan == NO && self.isPinch == NO && self.isRotate == NO) {
        [self.delegate tileViewDidEndEditing:self];
    }
}

- (void)viewDidPan:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        self.isPan = YES;
        self.startOrigin = self.lastOrigin;
        [self showDeleteButton];
        [self.delegate tileViewDidBeginEditing:self];
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint tran = [gesture translationInView:self];
        //NSLog(@"%0.2f, %0.2f", tran.x, tran.y);
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformScale(transform, self.lastScale, self.lastScale);
        transform = CGAffineTransformRotate(transform, self.lastRoateAngle);
        tran = CGPointApplyAffineTransform(tran, transform);
        self.lastOrigin = CGPointMake(self.startOrigin.x+tran.x, self.startOrigin.y+tran.y);
        [self updateTransform];
        CGPoint point = [gesture locationInView:self.deleteButton];
        if (CGRectContainsPoint(self.deleteButton.bounds, point)) {
            self.deleteButton.backgroundColor = [UIColor redColor];
        }else{
            self.deleteButton.backgroundColor = [UIColor clearColor];
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        CGPoint point = [gesture locationInView:self.deleteButton];
        if (CGRectContainsPoint(self.deleteButton.bounds, point)) {
            [self hideDeleteButton];
            [self removeFromSuperview];
        }else{
            [self hideDeleteButton];
        }
        self.isPan = NO;
        [self checkEditEnd];
    }
}

- (void)viewDidPinch:(UIPinchGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        self.isPinch = YES;
        self.startScale = self.lastScale;
        [self.delegate tileViewDidBeginEditing:self];
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        self.lastScale = self.startScale*gesture.scale;
        [self updateTransform];
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        self.isPinch = NO;
        [self checkEditEnd];
    }
}

- (void)viewDidRotate:(UIRotationGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        self.isRotate = YES;
        self.startRoateAngle = self.lastRoateAngle;
        [self.delegate tileViewDidBeginEditing:self];
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        self.lastRoateAngle = self.startRoateAngle+gesture.rotation;
        [self updateTransform];
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        self.isRotate = NO;
        [self checkEditEnd];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (otherGestureRecognizer == self.panGes || otherGestureRecognizer == self.pinchGes || otherGestureRecognizer == self.rotateGes) {
        return YES;
    }
    return NO;
}

@end
