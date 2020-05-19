//
//  ALPhotoBrowserModel.h
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset, AZLEditRecord, AZLCropRecord;
@interface AZLPhotoBrowserModel : NSObject

/// 圖片寬(按dp算)，如果不設置，可能顯示上有問題
@property (nonatomic, assign) CGFloat width;
/// 圖片高(按dp算)，如果不設置，可能顯示上有問題
@property (nonatomic, assign) CGFloat height;
/// 过度动画的初始位置(屏幕所在的绝对位置)，不設置會沒有過度動畫
@property (nonatomic, assign) CGRect fromRect;

/// 是否動圖(如果為YES，那麼圖片會當做是gif來處理)
@property (nonatomic, assign) BOOL isAnimate;

/// 小圖Image(佔位圖)
@property (nonatomic, strong, nullable) UIImage *placeholdImage;
/// 大圖網絡url
@property (nonatomic, strong, nullable) NSString *originUrlString;

/// asset對象
@property (nonatomic, strong, nullable) PHAsset *asset;
/// 圖片數據
@property (nonatomic, strong, nullable) NSData *imageData;
/// UIImage對象
@property (nonatomic, strong, nullable) UIImage *image;

/// 是否原圖
@property (nonatomic, assign) BOOL isOrigin;

/// 编辑记录
@property (nonatomic, strong, nullable) NSArray<AZLEditRecord*> *editRecords;
/// 馬賽克編輯記錄
@property (nonatomic, strong, nullable) NSArray<AZLEditRecord*> *mosaicRecords;
/// 裁剪記錄
@property (nonatomic, strong, nullable) NSArray<AZLCropRecord*> *cropRecords;
/// 贴字记录
@property (nonatomic, strong, nullable) UIView *editTileView;
/// 编辑过的图片
@property (nonatomic, strong, nullable) UIImage *editImage;
/// 编辑过的图片的縮率圖
@property (nonatomic, strong, nullable) UIImage *smallEditImage;

// 如果imageData和image沒有值，會根據設置的asset來獲得圖片，並設置imageData和image的值
// 注意佔用內存問題，因為image是解壓後的圖片，佔用的空間可能會很大，可以通過手動設置image為nil來釋放緩存
/// 獲取圖片
- (void)requestImage:(void (^)(UIImage *_Nullable image))resultHandler;
/// 獲取圖片數據
- (void)requestImageData:(void (^)(NSData *_Nullable imageData))resultHandler;


@end

NS_ASSUME_NONNULL_END
