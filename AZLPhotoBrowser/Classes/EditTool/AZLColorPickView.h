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

@property (nonatomic, copy) AZLColorPickViewBlock block;

@end

NS_ASSUME_NONNULL_END
