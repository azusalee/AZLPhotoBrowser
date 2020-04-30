//
//  AZLEditRecord.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import "AZLEditRecord.h"

@implementation AZLEditRecord

//- (void)clipWithFrame:(CGRect)frame{
//    [self.path applyTransform:CGAffineTransformMakeTranslation(-frame.origin.x, -frame.origin.y)];
//    self.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
//}

- (void)undoCropRecord:(AZLCropRecord*)cropRecord{
    [self applyBounds:cropRecord.imageCropRect];
    [self.path applyTransform:CGAffineTransformMakeTranslation(cropRecord.imageCropRect.origin.x, cropRecord.imageCropRect.origin.y)];
    self.bounds = cropRecord.imageBounds;
    if (cropRecord.lastCropRect.size.width > 0) {
        [self.path applyTransform:CGAffineTransformMakeTranslation(-cropRecord.lastCropRect.origin.x, -cropRecord.lastCropRect.origin.y)];
        self.bounds = CGRectMake(0, 0, cropRecord.lastCropRect.size.width, cropRecord.lastCropRect.size.height);
    }
}

- (void)redoCropRecord:(AZLCropRecord*)cropRecord{
    if (cropRecord.lastCropRect.size.width > 0) {
        [self applyBounds:cropRecord.lastCropRect];
        [self.path applyTransform:CGAffineTransformMakeTranslation(cropRecord.lastCropRect.origin.x, cropRecord.lastCropRect.origin.y)];
        self.bounds = cropRecord.imageBounds;
    }
    [self applyBounds:cropRecord.imageBounds];
    [self.path applyTransform:CGAffineTransformMakeTranslation(-cropRecord.imageCropRect.origin.x, -cropRecord.imageCropRect.origin.y)];
    self.bounds = CGRectMake(0, 0, cropRecord.imageCropRect.size.width, cropRecord.imageCropRect.size.height);
}

- (void)applyBounds:(CGRect)renderBounds{
    if (self.bounds.size.width != renderBounds.size.width) {
        CGFloat scale = renderBounds.size.width/self.bounds.size.width;
        [self.path applyTransform:CGAffineTransformMakeScale(scale, scale)];
        self.path.lineWidth = self.path.lineWidth*scale;
        self.bounds = renderBounds;
    }
}

- (void)renderWithBounds:(CGRect)renderBounds{
    [self applyBounds:renderBounds];
    [self.color set];
    [self.path fill];
    [self.path stroke];
}

@end
