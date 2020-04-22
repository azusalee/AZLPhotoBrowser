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

@property (nonatomic, copy) void(^singleTapBlock)(void);
@property (nonatomic, copy) void(^longPressBlock)(void);

- (void)setImageWidth:(CGFloat)width height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
