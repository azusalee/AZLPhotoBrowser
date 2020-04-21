//
//  AZLAlbumViewController.h
//  AZLExtend
//
//  Created by lizihong on 2020/4/20.
//

#import <UIKit/UIKit.h>
#import "AZLAlbumAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AZLAlbumCompleteBlock)(NSArray<AZLAlbumAssetModel*> *selectModels);

@interface AZLAlbumViewController : UIViewController

@property (nonatomic, assign) NSInteger colCount;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, copy) AZLAlbumCompleteBlock completeBlock;

+ (void)showAlbum:(AZLAlbumCompleteBlock)completeBlock;

@end

NS_ASSUME_NONNULL_END
