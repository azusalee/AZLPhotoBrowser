//
//  ALPhotoBrowserModel.m
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import "AZLPhotoBrowserModel.h"
#import <Photos/Photos.h>
#ifdef AZLSDExtend
#import "AZLPhotoBrowser+SDExtend.h"
#endif

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
        if (imageData != nil) {
            weakSelf.imageData = imageData;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [weakSelf getImageByData];
                if (resultHandler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        resultHandler(weakSelf.image);
                    });
                }
            });
        }else{
            [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:UIScreen.mainScreen.bounds.size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result != nil) {
                    weakSelf.imageData = UIImageJPEGRepresentation(result, 1);
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [weakSelf getImageByData];
                        if (resultHandler) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                resultHandler(weakSelf.image);
                            });
                        }
                    });
                }
            }];
        }
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
        if (imageData != nil) {
            weakSelf.imageData = imageData;
            if (resultHandler) {
                resultHandler(weakSelf.imageData);
            };
        }else{
            [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:UIScreen.mainScreen.bounds.size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result != nil) {
                    weakSelf.imageData = UIImageJPEGRepresentation(result, 1);
                    if (resultHandler) {
                        resultHandler(weakSelf.imageData);
                    };
                }
            }];
        }
    }];
}

- (UIImage *)getImageByData{
    #ifdef AZLSDExtend
    if (self.isAnimate) {
        UIImage *image = [UIImage sd_imageWithGIFData:self.imageData];
        self.image = image;
    }else{
        UIImage *image = [[UIImage alloc] initWithData:self.imageData];
        // 先解壓，不然imageview設置的時候會有明顯的卡頓
        self.image = [UIImage sd_decodedImageWithImage:image];
    }
    #else
        UIImage *image = [[UIImage alloc] initWithData:self.imageData];
        self.image = [[UIImage alloc] initWithCGImage:[self CGImageCreateDecoded:image.CGImage] scale:image.scale orientation:image.imageOrientation];
    #endif
    
    
    return self.image;
}

#ifndef AZLSDExtend
- (CGImageRef)CGImageCreateDecoded:(CGImageRef)imageRef {
    if (!imageRef) {
        return NULL;
    }
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    BOOL hasAlpha = NO;
    if (alphaInfo == kCGImageAlphaPremultipliedLast ||
        alphaInfo == kCGImageAlphaPremultipliedFirst ||
        alphaInfo == kCGImageAlphaLast ||
        alphaInfo == kCGImageAlphaFirst) {
        hasAlpha = YES;
    }

    // BGRA8888 (premultiplied) or BGRX8888
    // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, bitmapInfo);
    if (!context) return NULL;

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    CFRelease(context);
    CGColorSpaceRelease(colorSpace);
    return newImage;
}
#endif

@end
