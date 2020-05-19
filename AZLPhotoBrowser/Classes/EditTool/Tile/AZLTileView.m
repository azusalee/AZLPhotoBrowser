//
//  AZLTileView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/5/15.
//

#import "AZLTileView.h"

@interface AZLTileView()

@property (nonatomic, assign) CGRect startRect;
@property (nonatomic, assign) CGAffineTransform startTransform;

@property (nonatomic, assign) CGFloat startScale;
@property (nonatomic, assign) CGFloat lastScale;

@end

@implementation AZLTileView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _startScale = 1;
        _lastScale = 1;
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
        [self addGestureRecognizer:panGes];
        //self.layer.anchorPoint = CGPointMake(0.5, 0.5);
        UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPinch:)];
        [self addGestureRecognizer:pinchGes];
        
    }
    return self;
}


- (void)viewDidPan:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        self.startRect = self.frame;
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint tran = [gesture translationInView:self];
        CGRect targetRect = self.startRect;
        targetRect.origin.x += tran.x*self.lastScale;
        targetRect.origin.y += tran.y*self.lastScale;
        self.frame = targetRect;
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
        self.startRect = self.frame;
        self.startScale = self.lastScale;
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
//        CGPoint tran = [gesture translationInView:self];
//        CGRect targetRect = self.startRect;
//        targetRect.origin.x += tran.x;
//        targetRect.origin.y += tran.y;
//        self.frame = targetRect;
        self.lastScale = self.startScale*gesture.scale;
        self.transform = CGAffineTransformMakeScale(self.lastScale, self.lastScale);
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        //        CGPoint point = self.selectView.center;
        //        UIColor *color = [self azl_colorAtPoint:point];
        //        if (self.block) {
        //            self.block(color);
        //        }
        
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
