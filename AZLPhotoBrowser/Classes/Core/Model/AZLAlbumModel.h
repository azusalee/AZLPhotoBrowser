//
//  AZLAlbumModel.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/20.
//

#import <Foundation/Foundation.h>
#import "AZLPhotoBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AZLAlbumModel : NSObject

/// 標題
@property (nonatomic, strong) NSString *title;
/// 图片模型数组
@property (nonatomic, readonly) NSArray<AZLPhotoBrowserModel*> *photoModelArray;

/// 增加图片模型
- (void)addPhotoModel:(AZLPhotoBrowserModel*)photoModel;

@end

NS_ASSUME_NONNULL_END
