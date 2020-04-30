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

/// 图片浏览页
@interface AZLPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, assign) NSInteger showingIndex;

/// 简易显示方法
+ (void)showWithPhotoModels:(NSArray<AZLPhotoBrowserModel*> *)photoArray index:(NSInteger)index;
/// 添加图片模型数组
- (void)addPhotoModels:(NSArray<AZLPhotoBrowserModel*> *)photoArray;
/// 获取当前显示的model
- (AZLPhotoBrowserModel *)getCurrentPhotoModel;

@end

NS_ASSUME_NONNULL_END
