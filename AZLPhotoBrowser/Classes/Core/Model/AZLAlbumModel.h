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
@property (nonatomic, readonly) NSArray<AZLPhotoBrowserModel*> *photoModelArray;

- (void)addPhotoModel:(AZLPhotoBrowserModel*)photoModel;

@end

NS_ASSUME_NONNULL_END
