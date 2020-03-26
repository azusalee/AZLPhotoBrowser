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
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scrollView.contentInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.imageView];
    [self.contentView addSubview:self.scrollView];
    
    UITapGestureRecognizer *doubleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGes.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTapGes];
    
    UITapGestureRecognizer *singleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [singleTapGes requireGestureRecognizerToFail:doubleTapGes];
    [self.contentView addGestureRecognizer:singleTapGes];
    
    self.scrollView.pinchGestureRecognizer.enabled = NO;
    self.imageView.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imagePinch:)];
    pinchGes.delegate = self;
    [self.imageView addGestureRecognizer:pinchGes];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.imageView addGestureRecognizer:longPressGes];
}

- (void)setImageWidth:(CGFloat)width height:(CGFloat)height{
    self.imageWidth = width;
    self.imageHeight = height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    if (width == 0 || height == 0) {
        self.imageView.frame = self.scrollView.bounds;
        self.maxScale = 2;
        self.maxWidth = screenWidth*2;
        self.maxHeight = screenHeight*2;
        self.minWidth = screenWidth;
        self.minHeight = screenHeight;
        return;
    }
    
    CGFloat imageAspect = width/height;
    self.imageHeight = imageAspect;
    CGFloat screenAspect = screenWidth/screenHeight;
    if (imageAspect > screenAspect) {
        CGFloat imageHeight = screenWidth/imageAspect;
        if (imageHeight < screenHeight/2) {
            self.maxScale = screenHeight/imageHeight;
            self.maxWidth = screenWidth*self.maxScale;
            self.maxHeight = screenHeight;
        }else{
            self.maxScale = 2;
            self.maxWidth = screenWidth*self.maxScale;
            self.maxHeight = imageHeight*self.maxScale;
        }
        self.minWidth = screenWidth;
        self.minHeight = imageHeight;
        self.imageView.frame = CGRectMake(0, (screenHeight-imageHeight)/2, screenWidth, imageHeight);
    }else{
        CGFloat imageWidth = screenHeight*imageAspect;
        if (imageWidth < screenWidth/2) {
            self.maxScale = screenWidth/imageWidth;
            self.maxWidth = screenWidth;
            self.maxHeight = screenHeight*self.maxScale;
        }else{
            self.maxScale = 2;
            self.maxWidth = imageWidth*self.maxScale;
            self.maxHeight = screenHeight*self.maxScale;
        }
        self.minWidth = imageWidth;
        self.minHeight = screenHeight;
        self.imageView.frame = CGRectMake((screenWidth-imageWidth)/2, 0, imageWidth, screenHeight);
    }
}

- (CGPoint)offsetWithPoint:(CGPoint)point imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight {
    CGPoint pointAspect = CGPointMake(point.x/self.imageView.bounds.size.width, point.y/self.imageView.bounds.size.height);
    CGPoint pointInScreen = [self.imageView convertPoint:point toView:self.contentView];
    CGPoint afterPoint = CGPointMake(imageWidth*pointAspect.x, imageHeight*pointAspect.y);
    CGPoint pointInScroll = CGPointMake(self.scrollView.contentOffset.x+pointInScreen.x, self.scrollView.contentOffset.y+pointInScreen.y);
    CGPoint offset = self.scrollView.contentOffset;
    CGPoint move = CGPointMake(afterPoint.x-pointInScroll.x, afterPoint.y-pointInScroll.y);
    offset.x += move.x;
    offset.y += move.y;
    if (imageWidth <= self.scrollView.bounds.size.width || offset.x < 0) {
        offset.x = 0;
    }else if (offset.x+self.scrollView.bounds.size.width > imageWidth) {
        offset.x = imageWidth-self.scrollView.bounds.size.width;
    }
    
    if (imageHeight <= self.scrollView.bounds.size.height || offset.y < 0) {
        offset.y = 0;
    }else if (offset.y+self.scrollView.bounds.size.height > imageHeight) {
        offset.y = imageHeight-self.scrollView.bounds.size.height;
    }
    return offset;
}

- (void)updateImageWithScale:(CGFloat)scale point:(CGPoint)point{
    CGFloat imageWidth = self.startRect.size.width*scale;
    CGFloat imageHeight = self.startRect.size.height*scale;

    CGFloat originX = 0;
    CGFloat originY = 0;
    
    CGFloat contentWidth = imageWidth;
    CGFloat contentHeight = imageHeight;
    if (contentWidth < self.scrollView.bounds.size.width) {
        contentWidth = self.scrollView.bounds.size.width;
        originX = (contentWidth-imageWidth)/2;
    }
    if (contentHeight < self.scrollView.bounds.size.height) {
        contentHeight = self.scrollView.bounds.size.height;
        originY = (contentHeight-imageHeight)/2;
    }
    
    CGPoint offset = [self offsetWithPoint:point imageWidth:imageWidth imageHeight:imageHeight];
    [self.scrollView setContentOffset:offset animated:NO];
    self.scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
    self.imageView.frame = CGRectMake(originX, originY, imageWidth, imageHeight);
}

- (void)updateMaxImageWithPoint:(CGPoint)point{
    CGFloat imageWidth = self.maxWidth;
    CGFloat imageHeight = self.maxHeight;
    CGPoint offset = [self offsetWithPoint:point imageWidth:imageWidth imageHeight:imageHeight];
    [UIView animateWithDuration:0.275 animations:^{
        self.scrollView.contentOffset = offset;
        self.scrollView.contentSize = CGSizeMake(imageWidth, imageHeight);
        self.imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    }];
}

- (void)updateMinImage{
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat imageWidth = self.minWidth;
    CGFloat imageHeight = self.minHeight;
    CGFloat contentWidth = imageWidth;
    CGFloat contentHeight = imageHeight;
    if (contentWidth < self.scrollView.bounds.size.width) {
        contentWidth = self.scrollView.bounds.size.width;
        originX = (contentWidth-imageWidth)/2;
    }
    if (contentHeight < self.scrollView.bounds.size.height) {
        contentHeight = self.scrollView.bounds.size.height;
        originY = (contentHeight-imageHeight)/2;
    }
    
    [UIView animateWithDuration:0.275 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView.contentSize = self.scrollView.bounds.size;
        self.imageView.frame = CGRectMake(originX, originY, imageWidth, imageHeight);
    }];
}

- (void)singleTap:(UITapGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.delegate azlPhotoBrowserCollectionViewCellDidTap:self];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.imageWidth == 0 || self.imageHeight == 0) {
            return;
        }
        CGPoint location = [recognizer locationInView:self.imageView];
        if (self.imageView.bounds.size.width > self.minWidth) {
            [self updateMinImage];
        }else{
            [self updateMaxImageWithPoint:location];
        }

    }
}

- (void)imagePinch:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.startRect = self.imageView.bounds;
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [recognizer locationInView:self.imageView];
        [self updateImageWithScale:recognizer.scale point:location];
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [recognizer locationInView:self.imageView];
        if (self.imageView.bounds.size.width > self.maxWidth) {
            [self updateMaxImageWithPoint:location];
        }else if (self.imageView.bounds.size.width < self.minWidth){
            [self updateMinImage];
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        if (self.imageView.image) {
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"保存到相冊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
//                NSData *data = [[SDImageCache sharedImageCache] diskImageDataForKey:self.originUrl];
//                PHPhotoLibrary *library = [[PHPhotoLibrary alloc] init];
//                [library ]
                [self saveImage];
            }]];
            [alertVC azl_presentSelf];
        }
    }
}

- (void)saveImage{
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return self.imageView;
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//
//    //if (scrollView.zoomScale <= 1) {
//        self.imageView.center = CGPointMake(self.scrollView.bounds.size.width/2, self.scrollView.bounds.size.height/2);
//    //}
//    //NSLog(@"%f,%f", scrollView.contentSize.width, scrollView.contentSize.height);
//}

@end
