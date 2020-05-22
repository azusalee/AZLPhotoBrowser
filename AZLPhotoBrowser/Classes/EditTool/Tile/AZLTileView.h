//
//  AZLTileView.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/5/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZLTileView : UIView

@property (nonatomic, assign, readonly) CGPoint originPoint;

@property (nonatomic, assign, readonly) CGPoint startOrigin;
@property (nonatomic, assign, readonly) CGPoint lastOrigin;

@property (nonatomic, assign, readonly) CGFloat startScale;
@property (nonatomic, assign, readonly) CGFloat lastScale;

@property (nonatomic, assign, readonly) CGFloat startRoateAngle;
@property (nonatomic, assign, readonly) CGFloat lastRoateAngle;

- (void)addTranslate:(CGPoint)tran;
- (void)updateTransform;

@end

NS_ASSUME_NONNULL_END
