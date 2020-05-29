//
//  ALPhotoBroserCollectionViewCell.h
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZLPhotoBrowserView.h"

NS_ASSUME_NONNULL_BEGIN

@class AZLPhotoBrowserCollectionViewCell;
@protocol AZLPhotoBrowserCollectionViewCellDelegate <NSObject>

/// 单击事件回调
- (void)azlPhotoBrowserCollectionViewCellDidTap:(AZLPhotoBrowserCollectionViewCell *)cell;
/// 长按时间回调
- (void)azlPhotoBrowserCollectionViewCellDidLongPress:(AZLPhotoBrowserCollectionViewCell *)cell;

@end

@interface AZLPhotoBrowserCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>

/// 浏览view
@property (nonatomic, strong) AZLPhotoBrowserView *browserView;
/// 代理
@property (nonatomic, weak) id<AZLPhotoBrowserCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
