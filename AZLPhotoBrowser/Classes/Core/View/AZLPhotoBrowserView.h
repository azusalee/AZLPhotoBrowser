//
//  AZLPhotoBrowserView.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZLPhotoBrowserView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

/// 单击回调
@property (nonatomic, copy) void(^singleTapBlock)(void);
/// 长按回调
@property (nonatomic, copy) void(^longPressBlock)(void);

// 设置图片需要显示的宽高(会影响放大缩小的效果)
- (void)setImageWidth:(CGFloat)width height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
