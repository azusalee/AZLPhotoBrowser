//
//  AZLPhotoBrowserEditViewController.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import "AZLPhotoBrowserViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AZLPhotoBrowserEditCompleteBlock)(NSArray<AZLPhotoBrowserModel*> *selectModels);

@interface AZLPhotoBrowserEditViewController : AZLPhotoBrowserViewController

@property (nonatomic, copy) AZLPhotoBrowserEditCompleteBlock completeBlock;

- (void)addSelectPhotoModels:(NSArray<AZLPhotoBrowserModel*> *)photoArray;

@end

NS_ASSUME_NONNULL_END
