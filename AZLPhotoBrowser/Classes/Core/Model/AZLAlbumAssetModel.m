//
//  AZLAlbumAssetModel.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/20.
//

#import "AZLAlbumAssetModel.h"
#import <Photos/Photos.h>

@interface AZLAlbumAssetModel()

@end

@implementation AZLAlbumAssetModel

- (void)requestImageData:(void (^)(NSData *_Nullable imageData))resultHandler{
    if (self.imageData) {
        if (resultHandler) {
            resultHandler(self.imageData);
        };
    }
    
    __weak AZLAlbumAssetModel *weakSelf = self;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        weakSelf.imageData = imageData;
        if (resultHandler) {
            resultHandler(weakSelf.imageData);
        };
    }];
}

@end
