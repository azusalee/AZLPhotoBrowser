//
//  AZLTileContainerView.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/5/15.
//

#import <UIKit/UIKit.h>
#import "AZLCropRecord.h"

NS_ASSUME_NONNULL_BEGIN

@class AZLTileContainerView;
@protocol AZLTileContainerViewDelegate <NSObject>

/// 开始编辑
- (void)tileContainerViewDidBeginEditing:(AZLTileContainerView*)tileContainerView;
/// 结束编辑
- (void)tileContainerViewDidEndEditing:(AZLTileContainerView*)tileContainerView;

@end

@interface AZLTileContainerView : UIView

@property (nonatomic, weak) id<AZLTileContainerViewDelegate> delegate;

@property (nonatomic, assign) CGRect originBounds;

@property (nonatomic, strong) UIColor *tileColor;

- (void)undoCropRecord:(AZLCropRecord*)cropRecord;
- (void)redoCropRecord:(AZLCropRecord*)cropRecord;
- (void)updateScaleWithBounds:(CGRect)bounds;

- (void)addTextTile;

@end

NS_ASSUME_NONNULL_END
