//
//  ALPhotoBroserViewController.h
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZLPhotoBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN

@class AZLPhotoBrowserViewController;
@protocol AZLPhotoBrowserViewControllerDelegate <NSObject>

/// 显示的图片切换
- (void)photoBrowserViewControllerShowingIndexDidChange:(AZLPhotoBrowserViewController *)controller;

@end

/// 图片浏览页
@interface AZLPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, assign) NSInteger showingIndex;

@property (nonatomic, weak) id<AZLPhotoBrowserViewControllerDelegate> delegate;

/// 简易显示方法
+ (void)showWithImages:(NSArray<UIImage*>*)imageArray index:(NSInteger)index;
+ (void)showWithPhotoModels:(NSArray<AZLPhotoBrowserModel*>*)photoArray index:(NSInteger)index;
/// 添加图片模型数组
- (void)addPhotoModels:(NSArray<AZLPhotoBrowserModel*>*)photoArray;
/// 获取当前显示的model
- (AZLPhotoBrowserModel *)getCurrentPhotoModel;

@end

NS_ASSUME_NONNULL_END
