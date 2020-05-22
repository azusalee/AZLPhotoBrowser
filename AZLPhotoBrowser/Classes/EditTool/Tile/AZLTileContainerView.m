//
//  AZLTileContainerView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/5/15.
//

#import "AZLTileContainerView.h"
#import "AZLTileView.h"

@interface AZLTileContainerView()<UIGestureRecognizerDelegate>

@end

@implementation AZLTileContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _originBounds = self.bounds;
        _tileColor = [UIColor whiteColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
        self.layer.anchorPoint = CGPointMake(0, 0);
        self.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidTap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self endEditing:YES];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self.superview removeObserver:self forKeyPath:@"frame"];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    [self.superview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = CGRectNull;
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
            //此处为获取新的bounds
            newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
            [self updateScaleWithBounds:newFrame];
        }
    }
}

- (void)updateScaleWithBounds:(CGRect)bounds {
    CGFloat scaleW = bounds.size.width/self.originBounds.size.width;
    //CGFloat scaleH = newFrame.size.height/self.originBounds.size.height;
    self.transform = CGAffineTransformMakeScale(scaleW, scaleW);
}

- (void)undoCropRecord:(AZLCropRecord*)cropRecord{
    self.transform = CGAffineTransformIdentity;
    CGFloat scale = self.bounds.size.width/cropRecord.imageCropRect.size.width;
    if (cropRecord.lastCropRect.size.width <= 0) {
        self.frame = CGRectMake(0, 0, cropRecord.imageBounds.size.width*scale, cropRecord.imageBounds.size.height*scale);
    }else{
        self.frame = CGRectMake(0, 0, cropRecord.lastCropRect.size.width*scale, cropRecord.lastCropRect.size.height*scale);
    }
    self.originBounds = self.frame;
    for (AZLTileView *subView in self.subviews) {
        if (cropRecord.lastCropRect.size.width > 0) {
            [subView addTranslate:CGPointMake((cropRecord.imageCropRect.origin.x-cropRecord.lastCropRect.origin.x)*scale, (cropRecord.imageCropRect.origin.y-cropRecord.lastCropRect.origin.y)*scale)];
//            subView.frame = CGRectMake((cropRecord.imageCropRect.origin.x-cropRecord.lastCropRect.origin.x)*scale+subView.frame.origin.x, (cropRecord.imageCropRect.origin.y-cropRecord.lastCropRect.origin.y)*scale+subView.frame.origin.y, subView.frame.size.width, subView.frame.size.height);
        }else{
            [subView addTranslate:CGPointMake(cropRecord.imageCropRect.origin.x*scale, cropRecord.imageCropRect.origin.y*scale)];
//            subView.frame = CGRectMake(cropRecord.imageCropRect.origin.x*scale+subView.frame.origin.x, cropRecord.imageCropRect.origin.y*scale+subView.frame.origin.y, subView.frame.size.width, subView.frame.size.height);
        }
    }
}

- (void)redoCropRecord:(AZLCropRecord*)cropRecord{
    
    self.transform = CGAffineTransformIdentity;
    CGFloat scale = 1;
    if (cropRecord.lastCropRect.size.width <= 0) {
        scale = self.bounds.size.width/cropRecord.imageBounds.size.width;
    }else{
        scale = self.bounds.size.width/cropRecord.lastCropRect.size.width;
    }
    self.frame = CGRectMake(0, 0, cropRecord.imageCropRect.size.width*scale, cropRecord.imageCropRect.size.height*scale);
    self.originBounds = self.frame;
    for (AZLTileView *subView in self.subviews) {
        if (cropRecord.lastCropRect.size.width > 0) {
            [subView addTranslate:CGPointMake((-cropRecord.imageCropRect.origin.x+cropRecord.lastCropRect.origin.x)*scale, (-cropRecord.imageCropRect.origin.y+cropRecord.lastCropRect.origin.y)*scale)];
//            subView.frame = CGRectMake((-cropRecord.imageCropRect.origin.x+cropRecord.lastCropRect.origin.x)*scale+subView.frame.origin.x, (-cropRecord.imageCropRect.origin.y+cropRecord.lastCropRect.origin.y)*scale+subView.frame.origin.y, subView.frame.size.width, subView.frame.size.height);
        }else{
            [subView addTranslate:CGPointMake(-cropRecord.imageCropRect.origin.x*scale, -cropRecord.imageCropRect.origin.y*scale)];
//            subView.frame = CGRectMake(-cropRecord.imageCropRect.origin.x*scale+subView.frame.origin.x, -cropRecord.imageCropRect.origin.y*scale+subView.frame.origin.y, subView.frame.size.width, subView.frame.size.height);
        }
    }
}

- (void)dealloc{
    //[self.superview removeObserver:self forKeyPath:@"bounds"];
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    //CGFloat scale = self.superview.bounds.size.width/self.originBounds.size.width;
//    //self.transform = CGAffineTransformMakeScale(scale, scale);
////    for (UIView *subView in self.subviews) {
////        if ([subView isKindOfClass:[AZLTileView class]]) {
////            AZLTileView *tileView = (AZLTileView*)subView;
////            if (tileView.superOriginBounds.size.width > 0) {
////                CGFloat scale = self.bounds.size.width/tileView.superOriginBounds.size.width;
////                [tileView updateFrameWithScale:scale];
////            }
////        }
////    }
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}


@end
