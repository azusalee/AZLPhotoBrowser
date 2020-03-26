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


@interface AZLPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, assign) NSInteger showingIndex;

- (void)showWithPhotoModels:(NSArray<AZLPhotoBrowserModel*> *)photoArray index:(NSInteger)index;

- (AZLPhotoBrowserModel *)getCurrentPhotoModel;

@end

NS_ASSUME_NONNULL_END
