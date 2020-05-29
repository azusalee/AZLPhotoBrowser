//
//  AZLEditRecord.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import <Foundation/Foundation.h>
#import "AZLCropRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface AZLEditRecord : NSObject

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIColor *color;
// 画的时候的画布大小
@property (nonatomic, assign) CGRect bounds;

- (void)undoCropRecord:(AZLCropRecord*)cropRecord;
- (void)redoCropRecord:(AZLCropRecord*)cropRecord;

/// 應用新的bounds
- (void)applyBounds:(CGRect)renderBounds;
- (void)renderWithBounds:(CGRect)renderBounds;

@end

NS_ASSUME_NONNULL_END
