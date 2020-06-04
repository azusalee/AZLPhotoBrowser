//
//  AZLPhotoBroserViewController.m
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import "AZLPhotoBrowserViewController.h"
#import "AZLPhotoBrowserCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import <AZLExtend/AZLExtend.h>
#import <Photos/Photos.h>
#import "AZLPhotoBrowserManager.h"

/// 自定义过场动画
@interface AZLPhotoBrowserTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresent;

@end

@implementation AZLPhotoBrowserTransition

- (NSTimeInterval)duration{
    return 0.275;
}
// 出现动画
- (void)presentTransitionWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    AZLPhotoBrowserViewController *controller = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    AZLPhotoBrowserModel *model = [controller getCurrentPhotoModel];
    CGRect rect = model.fromRect;
    if (rect.size.width != 0 && rect.size.height != 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = model.placeholdImage;
        controller.view.alpha = 0;
        controller.photoCollectionView.hidden = YES;
        CGRect toRect = imageView.bounds;
        
        toRect.size.width = [UIScreen mainScreen].bounds.size.width;
        toRect.size.height = [UIScreen mainScreen].bounds.size.width*model.height/model.width;
        if (toRect.size.height > [UIScreen mainScreen].bounds.size.height) {
            toRect.size.height = [UIScreen mainScreen].bounds.size.height;
            toRect.size.width = [UIScreen mainScreen].bounds.size.height*model.width/model.height;
        }
        
        toRect.origin = CGPointMake(([UIScreen mainScreen].bounds.size.width-toRect.size.width)/2, ([UIScreen mainScreen].bounds.size.height-toRect.size.height)/2);
        //[controller.view addSubview:imageView];
        [transitionContext.containerView addSubview:controller.view];
        [transitionContext.containerView addSubview:imageView];
        [UIView animateWithDuration:[self duration] animations:^{
            imageView.frame = toRect;
            controller.view.alpha = 1;
        } completion:^(BOOL finished) {
            controller.photoCollectionView.hidden = NO;
            [imageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }else{
        controller.view.alpha = 0;
        [UIView animateWithDuration:[self duration] animations:^{
            controller.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        [transitionContext.containerView addSubview:controller.view];
    }
}
// 消失动画
- (void)dismissTransitionWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    AZLPhotoBrowserViewController *controller = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    AZLPhotoBrowserModel *model = [controller getCurrentPhotoModel];
    CGRect rect = model.fromRect;
    if (rect.size.width != 0 && rect.size.height != 0) {
        AZLPhotoBrowserCollectionViewCell *cell = (AZLPhotoBrowserCollectionViewCell*)[controller.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:controller.showingIndex inSection:0]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[cell.browserView.imageView convertRect:cell.browserView.imageView.bounds toView:[UIApplication sharedApplication].keyWindow]];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = cell.browserView.imageView.image;
        controller.photoCollectionView.hidden = YES;
        CGRect toRect = rect;
        
        controller.view.alpha = 1;
        [transitionContext.containerView addSubview:controller.view];
        [transitionContext.containerView addSubview:imageView];
        [UIView animateWithDuration:[self duration] animations:^{
            controller.view.alpha = 0;
            imageView.frame = toRect;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }else{
        controller.view.alpha = 1;
        [UIView animateWithDuration:[self duration] animations:^{
            controller.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        [transitionContext.containerView addSubview:controller.view];
    }
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
{
    return [self duration];
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (self.isPresent) {
        [self presentTransitionWithContext:transitionContext];
    }else{
        [self dismissTransitionWithContext:transitionContext];
    }
}

@end


@interface AZLPhotoBrowserViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate, AZLPhotoBrowserCollectionViewCellDelegate>

@property (nonatomic, strong) NSMutableArray<AZLPhotoBrowserModel*> *dataArray;

@end

@implementation AZLPhotoBrowserViewController

+ (void)showWithImages:(NSArray<UIImage*>*)imageArray index:(NSInteger)index{
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    for (UIImage *image in imageArray) {
        AZLPhotoBrowserModel *model = [[AZLPhotoBrowserModel alloc] init];
        model.width = image.size.width;
        model.height = image.size.height;
        model.image = image;
        [photoArray addObject:model];
    }
    [self showWithPhotoModels:photoArray.copy index:index];
}

+ (void)showWithPhotoModels:(NSArray<AZLPhotoBrowserModel*>*)photoArray index:(NSInteger)index{
    AZLPhotoBrowserViewController *controller = [[AZLPhotoBrowserViewController alloc] init];
    controller.showingIndex = index;
    [controller addPhotoModels:photoArray];
    [controller azl_presentSelf];
}

- (instancetype)init{
    if (self = [super init]) {
        _dataArray = [[NSMutableArray alloc] init];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.transitioningDelegate = self;
    }
    return self;
}

- (AZLPhotoBrowserModel *)getCurrentPhotoModel{
    return self.dataArray[self.showingIndex];
}

- (void)addPhotoModels:(NSArray<AZLPhotoBrowserModel*> *)photoArray{
    [self.dataArray addObjectsFromArray:photoArray];
    [self.photoCollectionView reloadData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    
    self.photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.photoCollectionView.contentInset = UIEdgeInsetsZero;
    self.photoCollectionView.backgroundColor = [UIColor clearColor];
    self.photoCollectionView.showsVerticalScrollIndicator = NO;
    self.photoCollectionView.showsHorizontalScrollIndicator = NO;
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.pagingEnabled = YES;
    self.photoCollectionView.frame = [UIScreen mainScreen].bounds;
    [self.photoCollectionView registerClass:[AZLPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"AZLPhotoBrowserCollectionViewCell"];
    [self.view addSubview:self.photoCollectionView];
    [self.photoCollectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*self.showingIndex, 0)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)showingIndexDidChange{
    
}

- (void)setShowingIndex:(NSInteger)showingIndex{
    _showingIndex = showingIndex;
    [self.photoCollectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*_showingIndex, 0)];
}

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger showingIndex = (scrollView.contentOffset.x/self.view.bounds.size.width)+0.5;
    if (self.showingIndex != showingIndex) {
        _showingIndex = showingIndex;
        [self showingIndexDidChange];
        [self.delegate photoBrowserViewControllerShowingIndexDidChange:self];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AZLPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AZLPhotoBrowserCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    AZLPhotoBrowserModel *model = self.dataArray[indexPath.row];
    [cell.browserView setImageWidth:model.width height:model.height];
    
    if (model.editImage != nil) {
        cell.browserView.imageView.image = model.editImage;
    }else if (model.image != nil) {
        cell.browserView.imageView.image = nil;
        cell.browserView.imageView.image = model.image;
    }else if (model.imageData != nil || model.asset != nil) {
        cell.browserView.imageView.image = model.placeholdImage;
        __weak AZLPhotoBrowserCollectionViewCell *weakCell = cell;
        [model requestImage:^(UIImage * _Nullable image) {
            weakCell.browserView.imageView.image = image;
        }];
    }else{
        [cell.browserView.imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrlString] placeholderImage:model.placeholdImage];
    }
    
    return cell;
}

- (void)azlPhotoBrowserCollectionViewCellDidTap:(AZLPhotoBrowserCollectionViewCell *)cell{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)azlPhotoBrowserCollectionViewCellDidLongPress:(AZLPhotoBrowserCollectionViewCell *)cell{
    NSIndexPath *indexPath = [self.photoCollectionView indexPathForCell:cell];
    AZLPhotoBrowserModel *model = self.dataArray[indexPath.row];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:[AZLPhotoBrowserManager sharedInstance].theme.cancelString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:[AZLPhotoBrowserManager sharedInstance].theme.photoSaveImageString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (model.originUrlString.length > 0) {
            [self saveImageWithUrl:model.originUrlString];
        }else{
            [self requestSaveImageWithImageData:
            UIImagePNGRepresentation(cell.browserView.imageView.image)];
        }
    }]];
    [alertVC azl_presentSelf];
}

- (void)requestSaveImageWithImageData:(NSData*)data{
    // 請求權限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImageWithImageData:data];
                
            }else{
                UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:[AZLPhotoBrowserManager sharedInstance].theme.photoAuthAlertTitleString message:[AZLPhotoBrowserManager sharedInstance].theme.photoAuthAlertContentString preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:[AZLPhotoBrowserManager sharedInstance].theme.photoAuthOpenString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:[AZLPhotoBrowserManager sharedInstance].theme.cancelString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                }];
                
                [alertViewController addAction:action1];
                [alertViewController addAction:action2];
                
                [alertViewController azl_presentSelf];
            }
        });
    }];
}

- (void)saveImageWithImageData:(NSData*)data{
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
        
        
        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
        
        
        // 2.4 创建一个占位对象
        //        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
        //        
        //        // 2.5 将占位对象添加到相册请求中
        //        [collectionRequest addAssets:@[placeholder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // 3. 判断是否出错, 如果报错, 声明保存不成功
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *alertContent = @"";
            if (error) {
                alertContent = [AZLPhotoBrowserManager sharedInstance].theme.photoSaveImageFailString;
            } else {
                alertContent = [AZLPhotoBrowserManager sharedInstance].theme.photoSaveImageSuccessString;
            }
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:alertContent message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:[AZLPhotoBrowserManager sharedInstance].theme.confirmString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            }];
            
            [alertViewController addAction:action1];
            [alertViewController azl_presentSelf];
        });
    }];
}

- (void)saveImageWithUrl:(NSString*)imageUrl{
    NSData *data = [[SDImageCache sharedImageCache] diskImageDataForKey:imageUrl];
    [self requestSaveImageWithImageData:data];
}

#pragma mark - UIViewControllerTransitioningDelegate過場
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController: (UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    AZLPhotoBrowserTransition *transition = [[AZLPhotoBrowserTransition alloc] init];
    transition.isPresent = YES;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController: (UIViewController *)dismissed{
    AZLPhotoBrowserTransition *transition = [[AZLPhotoBrowserTransition alloc] init];
    transition.isPresent = NO;
    return transition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal: (id<UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

@end
