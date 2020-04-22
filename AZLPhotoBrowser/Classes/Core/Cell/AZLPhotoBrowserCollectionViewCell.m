//
//  AZLPhotoBroserCollectionViewCell.m
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import "AZLPhotoBrowserCollectionViewCell.h"
#import <AZLExtend/AZLExtend.h>
#import "UIViewController+AZLTopController.h"
#import <SDWebImage/SDImageCache.h>
#import <Photos/Photos.h>

@interface AZLPhotoBrowserCollectionViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat imageAspect;

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat minWidth;
@property (nonatomic, assign) CGFloat minHeight;


@property (nonatomic, assign) CGFloat maxScale;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGRect startRect;

@end

@implementation AZLPhotoBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    __weak AZLPhotoBrowserCollectionViewCell *weakSelf = self;
    self.browserView = [[AZLPhotoBrowserView alloc] initWithFrame:self.contentView.bounds];
    self.browserView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.browserView setSingleTapBlock:^{
        [weakSelf.delegate azlPhotoBrowserCollectionViewCellDidTap:weakSelf];
    }];
    [self.browserView setLongPressBlock:^{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"保存到相冊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf saveImage];
        }]];
        [alertVC azl_presentSelf];
    }];
    [self.contentView addSubview:self.browserView];
}


- (void)saveImage{
    if (self.originUrl == nil) {
        return;
    }
    // 1. 获取相片库对象
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    // 2. 调用changeBlock
    [library performChanges:^{
        
//        // 2.1 创建一个相册变动请求
//        PHAssetCollectionChangeRequest *collectionRequest;
//        
//        // 2.2 取出指定名称的相册
//        PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:collectionName];
//        
//        // 2.3 判断相册是否存在
//        if (assetCollection) { // 如果存在就使用当前的相册创建相册请求
//            collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//        } else { // 如果不存在, 就创建一个新的相册请求
//            collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
//        }
        
        // 2.4 根据传入的相片, 创建相片变动请求
        
        NSData *data = [[SDImageCache sharedImageCache] diskImageDataForKey:self.originUrl];
        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
        
        
        // 2.4 创建一个占位对象
//        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
//        
//        // 2.5 将占位对象添加到相册请求中
//        [collectionRequest addAssets:@[placeholder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        // 3. 判断是否出错, 如果报错, 声明保存不成功
//        if (error) {
//            [SVProgressHUD showErrorWithStatus:@"保存失败"];
//        } else {
//            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//        }
    }];
}


@end
