//
//  AZLPhotoBrowserEditViewController.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import "AZLPhotoBrowserViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AZLPhotoBrowserEditCompleteBlock)(NSArray<AZLPhotoBrowserModel*> *selectModels);

/// 图片浏览选择编辑页
@interface AZLPhotoBrowserEditViewController : AZLPhotoBrowserViewController

/// 完成回调
@property (nonatomic, copy) AZLPhotoBrowserEditCompleteBlock completeBlock;

/// 添加选择图片图片
- (void)addSelectPhotoModels:(NSArray<AZLPhotoBrowserModel*> *)photoArray;

@end

NS_ASSUME_NONNULL_END
