//
//  AZLAlbumResult.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZLAlbumResult : NSObject

/// 圖片寬(按dp算)
@property (nonatomic, assign) CGFloat width;
/// 圖片高(按dp算)
@property (nonatomic, assign) CGFloat height;
/// 是否動圖
@property (nonatomic, assign) BOOL isAnimate;
/// 圖片數據
@property (nonatomic, strong, nullable) NSData *imageData;

@end

NS_ASSUME_NONNULL_END
