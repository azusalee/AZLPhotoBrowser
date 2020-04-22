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

- (void)azlPhotoBrowserCollectionViewCellDidTap:(AZLPhotoBrowserCollectionViewCell*)cell;

@end

@interface AZLPhotoBrowserCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) AZLPhotoBrowserView *browserView;
@property (nonatomic, strong) NSString *originUrl;
@property (nonatomic, weak) id<AZLPhotoBrowserCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
