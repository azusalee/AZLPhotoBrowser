//
//  AZLAlbumViewController.h
//  AZLExtend
//
//  Created by lizihong on 2020/4/20.
//

#import <UIKit/UIKit.h>
#import "AZLPhotoBrowserModel.h"
#import "AZLAlbumResult.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AZLAlbumCompleteBlock)(NSArray<AZLAlbumResult*> *results);

/// 相册页
@interface AZLAlbumViewController : UIViewController

/// 每一行顯示列數(默認4)
@property (nonatomic, assign) NSInteger colCount;
/// 總共可以挑選圖片數量最大值(默認9)
@property (nonatomic, assign) NSInteger maxCount;
/// 回調
@property (nonatomic, copy) AZLAlbumCompleteBlock completeBlock;

/// 簡易方法
+ (void)showAlbum:(AZLAlbumCompleteBlock)completeBlock;

@end

NS_ASSUME_NONNULL_END
