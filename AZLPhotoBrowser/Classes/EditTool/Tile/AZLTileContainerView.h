//
//  AZLTileContainerView.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/5/15.
//

#import <UIKit/UIKit.h>
#import "AZLCropRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface AZLTileContainerView : UIView

@property (nonatomic, assign) CGRect originBounds;

@property (nonatomic, strong) UIColor *tileColor;

- (void)undoCropRecord:(AZLCropRecord*)cropRecord;
- (void)redoCropRecord:(AZLCropRecord*)cropRecord;
- (void)updateScaleWithBounds:(CGRect)bounds;

@end

NS_ASSUME_NONNULL_END
