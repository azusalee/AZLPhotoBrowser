//
//  ALPhotoBrowserModel.h
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@interface AZLPhotoBrowserModel : NSObject

/// 寬
@property (nonatomic, assign) double width;
/// 高
@property (nonatomic, assign) double height;

/// 小圖Image
@property (nonatomic, strong) UIImage *placeholdImage;
/// 大圖網絡url
@property (nonatomic, strong) NSString *originUrlString;

/// 圖片數據
@property (nonatomic, strong) NSData *imageData;
/// 是否動圖
@property (nonatomic, assign) BOOL isAnimate;
/// asset對象
@property (nonatomic, strong) PHAsset *asset;
/// uiimage對象
@property (nonatomic, strong) UIImage *image;

/// 过度动画的初始位置(屏幕所在的绝对位置)
@property (nonatomic, assign) CGRect fromRect;

// 以下屬性，編輯模式下有用
/// 是否原圖
@property (nonatomic, assign) BOOL isOrigin;

/// 獲取圖片
- (void)requestImage:(void (^)(UIImage *_Nullable image))resultHandler;


@end

NS_ASSUME_NONNULL_END
