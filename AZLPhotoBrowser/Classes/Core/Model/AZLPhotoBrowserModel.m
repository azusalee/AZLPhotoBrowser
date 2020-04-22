//
//  ALPhotoBrowserModel.m
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import "AZLPhotoBrowserModel.h"
#import <Photos/Photos.h>
#import <SDWebImage/SDWebImage.h>

@implementation AZLPhotoBrowserModel

- (void)requestImage:(void (^)(UIImage *_Nullable image))resultHandler{
    if (self.image) {
        if (resultHandler) {
            resultHandler(self.image);
        }
        return;
    }
    if (self.imageData) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self getImageByData];
            if (resultHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultHandler(self.image);
                });
            }
        });
        return;
    }
    
    __weak AZLPhotoBrowserModel *weakSelf = self;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        weakSelf.imageData = imageData;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf getImageByData];
            if (resultHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultHandler(weakSelf.image);
                });
            }
        });
    }];
}

- (void)requestImageData:(void (^)(NSData *_Nullable imageData))resultHandler{
    if (self.imageData) {
        if (resultHandler) {
            resultHandler(self.imageData);
        };
    }
    
    __weak AZLPhotoBrowserModel *weakSelf = self;
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

- (UIImage *)getImageByData{
    if (self.isAnimate) {
        UIImage *image = [UIImage sd_imageWithGIFData:self.imageData];
        self.image = image;
    }else{
        UIImage *image = [[UIImage alloc] initWithData:self.imageData];
        // 先解壓，不然imageview設置的時候會有明顯的卡頓
        self.image = [UIImage sd_decodedImageWithImage:image];
    }
    return self.image;
}

@end
