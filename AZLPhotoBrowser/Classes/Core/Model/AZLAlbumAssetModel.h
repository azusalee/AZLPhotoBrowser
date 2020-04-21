//
//  AZLAlbumAssetModel.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@interface AZLAlbumAssetModel : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) NSData *imageData;

// 是否動圖
@property (nonatomic, assign) BOOL isAnimate;

- (void)requestImageData:(void (^)(NSData *_Nullable imageData))resultHandler;

@end

NS_ASSUME_NONNULL_END
