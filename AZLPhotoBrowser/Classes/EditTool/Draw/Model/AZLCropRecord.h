//
//  AZLCropRecord.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZLCropRecord : NSObject

/// 裁剪前的原大小
@property (nonatomic, assign) CGRect imageBounds;
/// 上一次的裁剪圖片大小
@property (nonatomic, assign) CGRect lastCropRect;
/// 裁剪後的圖片大小
@property (nonatomic, assign) CGRect imageCropRect;

@end

NS_ASSUME_NONNULL_END
