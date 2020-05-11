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

/// 自定义过场动画
@interface AZLPhotoBrowserTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresent;

@end

@implementation AZLPhotoBrowserTransition

- (NSTimeInterval)duration{
    return 0.275;
}

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
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
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

+ (void)showWithPhotoModels:(NSArray<AZLPhotoBrowserModel*> *)photoArray index:(NSInteger)index{
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

- (void)viewDidLoad {
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
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AZLPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AZLPhotoBrowserCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    AZLPhotoBrowserModel *model = self.dataArray[indexPath.row];
    cell.originUrl = model.originUrlString;
    //[cell.browserView.scrollView setZoomScale:1];
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

#pragma mark - UIViewControllerTransitioningDelegate過場
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    AZLPhotoBrowserTransition *transition = [[AZLPhotoBrowserTransition alloc] init];
    transition.isPresent = YES;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    AZLPhotoBrowserTransition *transition = [[AZLPhotoBrowserTransition alloc] init];
    transition.isPresent = NO;
    return transition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
