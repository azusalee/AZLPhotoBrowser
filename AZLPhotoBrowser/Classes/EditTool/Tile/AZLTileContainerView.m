//
//  AZLTileContainerView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/5/15.
//

#import "AZLTileContainerView.h"
#import "AZLTileTextView.h"
#import <AZLExtend/AZLExtend.h>

@interface AZLTileContainerView()<UIGestureRecognizerDelegate, AZLTileViewDelegate>

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
        }else{
            [subView addTranslate:CGPointMake(cropRecord.imageCropRect.origin.x*scale, cropRecord.imageCropRect.origin.y*scale)];
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
        }else{
            [subView addTranslate:CGPointMake(-cropRecord.imageCropRect.origin.x*scale, -cropRecord.imageCropRect.origin.y*scale)];
        }
    }
}

- (void)addTextTile{
    CGRect rectInWindow = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGFloat offsetX = 0.5;
    if (rectInWindow.size.width > [UIScreen mainScreen].bounds.size.width) {
        offsetX = (-rectInWindow.origin.x+[UIScreen mainScreen].bounds.size.width*0.5)/rectInWindow.size.width;
    }
    
    CGFloat offsetY = 0.5;
    if (rectInWindow.size.height > [UIScreen mainScreen].bounds.size.height) {
        offsetY = (-rectInWindow.origin.y+[UIScreen mainScreen].bounds.size.height*0.5)/rectInWindow.size.height;
    }
    
    CGFloat x = _originBounds.size.width*offsetX-50;
    CGFloat y = _originBounds.size.height*offsetY-15;
    if (x < 0) {
        x = 0;
    }
    if (y < 0) {
        y = 0;
    }
    AZLTileTextView *textTile = [[AZLTileTextView alloc] initWithFrame:CGRectMake(x, y, 100, 30)];
    
    textTile.textView.textColor = self.tileColor;
    [self addSubview:textTile];
    [textTile.textView becomeFirstResponder];
    textTile.delegate = self;
}

/// 开始编辑
- (void)tileViewDidBeginEditing:(AZLTileView*)tileView{
    [self.delegate tileContainerViewDidBeginEditing:self];
}
/// 结束编辑
- (void)tileViewDidEndEditing:(AZLTileView*)tileView{
    [self.delegate tileContainerViewDidEndEditing:self];
}

@end
