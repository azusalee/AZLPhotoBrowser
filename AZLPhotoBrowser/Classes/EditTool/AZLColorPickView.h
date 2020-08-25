//
//  AZLColorPickView.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AZLColorPickViewBlock)(UIColor *color);

@interface AZLColorPickView : UIView

/// 颜色选择回调
@property (nonatomic, copy) AZLColorPickViewBlock block;

/// 設置選擇的位置
- (void)setSelectViewPosition:(CGFloat)pointX;
/// 獲取選擇的位置
- (CGFloat)getSelectViewPosition;
/// 獲取當前顏色
- (UIColor*)getCurrentSelectColor;

@end

NS_ASSUME_NONNULL_END
