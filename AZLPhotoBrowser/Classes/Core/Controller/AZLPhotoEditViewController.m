//
//  AZLPhotoEditViewController.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import "AZLPhotoEditViewController.h"
#ifdef AZLSDExtend
#import "AZLPhotoBrowser+SDExtend.h"
#endif
#import <AZLExtend/AZLExtend.h>
#import "AZLPhotoBrowserView.h"
#import "AZLPhotoBrowserManager.h"
#import "AZLEditDrawView.h"
#import "AZLPathProviderPencil.h"
#import "AZLPathProviderPen.h"
#import "AZLScratchView.h"
#import "AZLEditCropView.h"
#import "AZLCropRecord.h"
#import "AZLPhotoEditBottomView.h"
#import "AZLTileTextView.h"
#import "AZLTileContainerView.h"

@interface AZLPhotoEditViewController () <AZLEditDrawViewDelegate, AZLPhotoEditBottomViewDelegate, AZLTileContainerViewDelegate>

@property (nonatomic, strong) AZLPhotoBrowserView *browserView;

@property (nonatomic, strong) UIView *editTopView;
@property (nonatomic, strong) AZLPhotoEditBottomView *editBottomView;
@property (nonatomic, assign) BOOL isShowingEditUI;

/// 修改圖層view
@property (nonatomic, strong) AZLEditDrawView *drawView;
/// 馬賽克圖層view
@property (nonatomic, strong) AZLScratchView *mosaicView;
/// 馬賽克圖片
@property (nonatomic, strong) UIImageView *mosaicImageView;
/// 裁剪圖層view
@property (nonatomic, strong) AZLEditCropView *cropView;
/// 貼圖圖層view
@property (nonatomic, strong) AZLTileContainerView *tileView;
/// 當前已做過的裁剪記錄
@property (nonatomic, strong) NSMutableArray<AZLCropRecord*> *cropRecordArray;
/// 可以重做的裁剪記錄
@property (nonatomic, strong) NSMutableArray<AZLCropRecord*> *canRedoCropRecordArray;

@property (nonatomic, strong) UIImage *mosaicImage;

@end

@implementation AZLPhotoEditViewController

- (AZLScratchView *)mosaicView{
    if (_mosaicView == nil) {
        _mosaicView = [[AZLScratchView alloc] initWithFrame:self.browserView.imageView.bounds];
        _mosaicView.drawView.delegate = self;
        [_mosaicView.drawView addEditRecords:self.photoModel.mosaicRecords];
        _mosaicView.backgroundColor = [UIColor clearColor];
        _mosaicView.userInteractionEnabled = NO;
        _mosaicView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_mosaicView.bounds];
        self.mosaicImage = [self.photoModel.image azl_imageFromMosaicLevel:16];
        imageView.image = self.mosaicImage;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mosaicImageView = imageView;
        [_mosaicView addSubview:imageView];
        
        [self.browserView.imageView insertSubview:_mosaicView atIndex:0];
    }
    return _mosaicView;
}

- (AZLEditCropView *)cropView{
    if (_cropView == nil) {
        CGFloat width = self.view.bounds.size.width-100;
        _cropView = [[AZLEditCropView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _cropView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        
        [self.view insertSubview:_cropView aboveSubview:self.browserView];
    }
    return _cropView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.cropRecordArray = [[NSMutableArray alloc] init];
    self.canRedoCropRecordArray = [[NSMutableArray alloc] init];
    
    [self setupBrowserUI];
    [self setupEditUI];
    [self setupDrawUI];
}

- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    self.editBottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-80-self.view.safeAreaInsets.bottom, [UIScreen mainScreen].bounds.size.width, 80+self.view.safeAreaInsets.bottom);
}

- (void)setupBrowserUI{
    self.browserView = [[AZLPhotoBrowserView alloc] initWithFrame:self.view.bounds];
    self.browserView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    __weak AZLPhotoEditViewController *weakSelf = self;
    [self.browserView setSingleTapBlock:^{
        if (weakSelf.isShowingEditUI) {
            [weakSelf hideEditUI];
        }else{
            [weakSelf showEditUI];
        }
    }];
    
    AZLPhotoBrowserModel *model = self.photoModel;
    [self.browserView setImageWidth:model.width height:model.height];
    
    if (model.image != nil) {
        self.browserView.imageView.image = model.image;
    }else if (model.imageData != nil || model.asset != nil) {
        self.browserView.imageView.image = model.placeholdImage;
        [model requestImage:^(UIImage * _Nullable image) {
            weakSelf.browserView.imageView.image = image;
        }];
    }else{
        #ifdef AZLSDExtend
        [self.browserView.imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrlString] placeholderImage:model.placeholdImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            weakSelf.photoModel.image = image;
        }];
        #endif
    }
    
    [self.view addSubview:self.browserView];
}

- (void)setupEditUI{
    //頭部
    CGFloat navBarHeight = 44;
    self.editTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, navBarHeight+[UIApplication sharedApplication].statusBarFrame.size.height)];
    self.editTopView.backgroundColor = [UIColor clearColor];
    {
        // 添加漸變層
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.editTopView.bounds;
        gradientLayer.colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor, (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor]; //设置渐变颜色
        //gradientLayer.locations = @[@0.0, @1]; //颜色的起点位置，递增，并且数量跟颜色数量相等
        gradientLayer.startPoint = CGPointMake(0, 0); // 
        gradientLayer.endPoint = CGPointMake(0, 1); // 
        [self.editTopView.layer addSublayer:gradientLayer];
    }
    
    [self.view addSubview:self.editTopView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(5, self.editTopView.bounds.size.height-navBarHeight+2, 40, 40);
//    cancelButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    cancelButton.layer.cornerRadius = 20;
    cancelButton.tintColor = [UIColor whiteColor];
    [cancelButton setImage:[AZLPhotoBrowserManager sharedInstance].theme.backImage forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editTopView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(leftBarItemDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    //底部
    self.editBottomView = [[AZLPhotoEditBottomView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-80, [UIScreen mainScreen].bounds.size.width, 80)];
    self.editBottomView.delegate = self;
    [self.view addSubview:self.editBottomView];
    
    self.isShowingEditUI = YES;
}

- (void)showEditUI{
    self.editTopView.hidden = NO;
    self.editBottomView.hidden = NO;
    self.isShowingEditUI = YES;
}

- (void)hideEditUI{
    self.editTopView.hidden = YES;
    self.editBottomView.hidden = YES;
    self.isShowingEditUI = NO;
}

- (void)setupDrawUI{
    // 路徑圖層
    self.drawView = [[AZLEditDrawView alloc] initWithFrame:self.browserView.imageView.bounds];
    self.drawView.userInteractionEnabled = NO;
    self.drawView.delegate = self;
    self.drawView.pathColor = [UIColor whiteColor];
    self.drawView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.browserView.imageView addSubview:self.drawView];
    [self.drawView addEditRecords:self.photoModel.editRecords];
    
    // 有馬賽克記錄
    if (self.photoModel.mosaicRecords) {
        [self mosaicView];
    }
    // 有裁剪記錄
    if (self.photoModel.cropRecords.count > 0) {
        [self.cropRecordArray addObjectsFromArray:self.photoModel.cropRecords];
        AZLCropRecord *cropRecord = [self.photoModel.cropRecords lastObject];
        self.mosaicImageView.image = [self.mosaicImage azl_imageClipFromRect:cropRecord.imageCropRect];
        UIImage *cropImage = [self.photoModel.image azl_imageClipFromRect:cropRecord.imageCropRect];
        [self.browserView setImageWidth:cropImage.size.width height:cropImage.size.height];
        self.browserView.imageView.image = cropImage;
    }
    
    //貼圖圖層
    if (self.photoModel.editTileView != nil) {
        self.tileView = (AZLTileContainerView*)self.photoModel.editTileView;
//        self.tileView.transform = CGAffineTransformIdentity;
//        self.tileView.frame = self.browserView.imageView.bounds;
//        self.tileView.originBounds = self.browserView.imageView.bounds;
    }else{
        self.tileView = [[AZLTileContainerView alloc] initWithFrame:self.browserView.imageView.bounds];
    }
    self.tileView.delegate = self;
    
    //self.tileView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tileView.userInteractionEnabled = NO;
    [self.browserView.imageView addSubview:self.tileView];
    [self.tileView updateScaleWithBounds:self.browserView.imageView.bounds];
}

- (void)leftBarItemDidTap:(id)sender {
    [self generateEditImage];
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.block) {
        self.block(self.photoModel);
    }
}

- (void)undoEdit {
    if (self.editBottomView.editType == AZLEditTypeCrop) {
        if (self.cropRecordArray.count > 0) {
            NSInteger index = self.cropRecordArray.count-1;
            AZLCropRecord *cropRecord = self.cropRecordArray[index];
            [self.cropRecordArray removeObjectAtIndex:index];
            [self.canRedoCropRecordArray addObject:cropRecord];
            
            [self applyCropRecord:cropRecord isRedo:NO];
        }
    }else if (self.editBottomView.editType == AZLEditTypeMosaic) {
        [self.mosaicView.drawView removeLastRecord];
    }else{
        [self.drawView removeLastRecord];
    }
}

- (void)redoEdit {
    if (self.editBottomView.editType == AZLEditTypeCrop) {
        if (self.canRedoCropRecordArray.count > 0) {
            NSInteger index = self.canRedoCropRecordArray.count-1;
            AZLCropRecord *cropRecord = self.canRedoCropRecordArray[index];
            [self.canRedoCropRecordArray removeObjectAtIndex:index];
            [self.cropRecordArray addObject:cropRecord];
            
            [self applyCropRecord:cropRecord isRedo:YES];
        }
    }else if (self.editBottomView.editType == AZLEditTypeMosaic) {
        [self.mosaicView.drawView redoLastRecord];
    }else{
        [self.drawView redoLastRecord];
    }
}

- (void)doneDidTap {
    CGFloat scale = self.browserView.imageView.image.size.width/self.browserView.imageView.bounds.size.width;
    CGRect cropRect = [self.cropView convertRect:self.cropView.bounds toView:self.browserView.imageView];
    CGRect imageCropRect = CGRectMake(cropRect.origin.x*scale, cropRect.origin.y*scale, cropRect.size.width*scale, cropRect.size.height*scale);
    // 生成裁剪記錄
    AZLCropRecord *cropRecord = [[AZLCropRecord alloc] init];
    cropRecord.imageBounds = CGRectMake(0, 0, self.photoModel.image.size.width, self.photoModel.image.size.height);
    if (self.cropRecordArray.count > 0) {
        AZLCropRecord *lastRecord = [self.cropRecordArray lastObject];
        imageCropRect.origin.x += lastRecord.imageCropRect.origin.x;
        imageCropRect.origin.y += lastRecord.imageCropRect.origin.y;
        cropRecord.lastCropRect = lastRecord.imageCropRect;
    }
    cropRecord.imageCropRect = imageCropRect;
    [self.cropRecordArray addObject:cropRecord];
    [self.canRedoCropRecordArray removeAllObjects];
    
    [self applyCropRecord:cropRecord isRedo:YES];
}

- (void)applyCropRecord:(AZLCropRecord*)cropRecord isRedo:(BOOL)isRedo{
    self.editBottomView.redoEnable = self.canRedoCropRecordArray.count>0;
    self.editBottomView.undoEnable = self.cropRecordArray.count>0;
    CGRect cropRect = CGRectZero;
    if (isRedo) {
        [self.drawView redoCropRecord:cropRecord];
        [self.mosaicView.drawView redoCropRecord:cropRecord];
        [self.tileView redoCropRecord:cropRecord];
        cropRect = cropRecord.imageCropRect;
    }else{
        [self.drawView undoCropRecord:cropRecord];
        [self.mosaicView.drawView undoCropRecord:cropRecord];
        [self.tileView undoCropRecord:cropRecord];
        if (cropRecord.lastCropRect.size.width > 0) {
            cropRect = cropRecord.lastCropRect;
        }
    }
    
    if (cropRect.size.width > 0) {
        self.mosaicImageView.image = [self.mosaicImage azl_imageClipFromRect:cropRect];
        UIImage *cropImage = [self.photoModel.image azl_imageClipFromRect:cropRect];
        [self.browserView setImageWidth:cropImage.size.width height:cropImage.size.height];
        self.browserView.imageView.image = cropImage;
    }else{
        // 原圖顯示
        self.mosaicImageView.image = self.mosaicImage;
        [self.browserView setImageWidth:self.photoModel.width height:self.photoModel.height];
        self.browserView.imageView.image = self.photoModel.image;
    }
    
    self.cropView.frame = self.browserView.imageView.frame;
    [self.drawView setNeedsDisplay];
    [self.mosaicView.drawView setNeedsDisplay];
}

- (void)setEditType:(AZLEditType)editType{
    self.browserView.scrollView.scrollEnabled = NO;
    self.drawView.userInteractionEnabled = NO;
    self.mosaicView.userInteractionEnabled = NO;
    self.tileView.userInteractionEnabled = NO;
    self.cropView.hidden = YES;
    switch (editType) {
        case AZLEditTypeNone:
            self.browserView.scrollView.scrollEnabled = YES;
            
            break;
        case AZLEditTypePath:
            self.drawView.userInteractionEnabled = YES;
            self.editBottomView.redoEnable = [self.drawView getRedoRecords].count>0;
            self.editBottomView.undoEnable = [self.drawView getEditRecords].count>0;
            break;
        case AZLEditTypeMosaic:
            self.mosaicView.userInteractionEnabled = YES;
            self.editBottomView.redoEnable = [self.mosaicView.drawView getRedoRecords].count>0;
            self.editBottomView.undoEnable = [self.mosaicView.drawView getEditRecords].count>0;
            break;
        case AZLEditTypeCrop:
            self.browserView.scrollView.scrollEnabled = YES;
            self.cropView.hidden = NO;
            self.editBottomView.redoEnable = self.canRedoCropRecordArray.count>0;
            self.editBottomView.undoEnable = self.cropRecordArray.count>0;
            break;
        case AZLEditTypeTile:
            self.tileView.userInteractionEnabled = YES;
            self.browserView.scrollView.scrollEnabled = YES;
            break;
        default:
            break;
    }
}

- (void)generateEditImage{
    // 生成編輯後的圖片
    UIImage *oriImage = self.browserView.imageView.image;
    NSArray *editRecords = [self.drawView getEditRecords];
    NSArray *mosaicRecords = [self.mosaicView.drawView getEditRecords];
    if (editRecords.count > 0 || mosaicRecords.count > 0 || self.cropRecordArray.count > 0 || self.tileView.subviews.count > 0) {
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGRect renderRect = CGRectMake(0, 0, oriImage.size.width, oriImage.size.height);
        if (oriImage.scale != scale) {
            renderRect.size.width = renderRect.size.width*(oriImage.scale/scale);
            renderRect.size.height = renderRect.size.height*(oriImage.scale/scale);
        }
        self.browserView.imageView.frame = renderRect;
        
        UIGraphicsBeginImageContextWithOptions(renderRect.size, false, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.browserView.imageView.layer renderInContext:context];
        
        UIImage *editImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
//        UIImage *mosicImage = nil;
//        if (mosaicRecords.count > 0) {
//            self.mosaicView.frame = renderRect;
//            mosicImage = [UIImage azl_imageFromView:self.mosaicView];
//        }
        
//        UIGraphicsBeginImageContextWithOptions(renderRect.size, false, scale);
//        [oriImage drawInRect:renderRect];
//        
//        if (mosicImage) {
//            [mosicImage drawInRect:renderRect];
//        }
//        
//        for (AZLEditRecord *editRecord in editRecords) {
//            [editRecord renderWithBounds:renderRect];
//        }
//        
//        UIImage* editImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        self.photoModel.editImage = editImage;
        if (editImage.size.width > 120) {
            self.photoModel.smallEditImage = [editImage azl_imageFromWidth:100];
        }else{
            self.photoModel.smallEditImage = self.photoModel.editImage;
        }
        
        self.photoModel.editRecords = editRecords;
        self.photoModel.mosaicRecords = mosaicRecords;
        self.photoModel.cropRecords = self.cropRecordArray.copy;
        self.photoModel.editTileView = self.tileView;
    }else{
        self.photoModel.editImage = nil;
        self.photoModel.smallEditImage = nil;
        self.photoModel.editRecords = nil;
        self.photoModel.mosaicRecords = nil;
        self.photoModel.cropRecords = nil;
        self.photoModel.editTileView = nil;
    }
}

- (void)editDrawViewDidChangePath:(AZLEditDrawView *)drawView{
    NSInteger editCount = [drawView getEditRecords].count;
    NSInteger redoCount = [drawView getRedoRecords].count;
    
    self.editBottomView.redoEnable = redoCount>0;
    self.editBottomView.undoEnable = editCount>0;
    [self showEditUI];
}

- (void)editDrawViewEditingPath:(AZLEditDrawView *)drawView{
    [self hideEditUI];
}

// editBottomViewDelegate
- (void)editBottomViewUndoDidTap:(AZLPhotoEditBottomView*)editBottomView{
    [self undoEdit];
}
- (void)editBottomViewRedoDidTap:(AZLPhotoEditBottomView*)editBottomView{
    [self redoEdit];
}

- (void)editBottomView:(AZLPhotoEditBottomView*)editBottomView colorDidChange:(UIColor*)color{
    self.drawView.pathColor = color;
    self.tileView.tileColor = color;
}

- (void)editBottomView:(AZLPhotoEditBottomView*)editBottomView editTypeDidChange:(AZLEditType)editType{
    [self setEditType:editType];
}

- (void)editBottomView:(AZLPhotoEditBottomView*)editBottomView pathTypeDidChange:(AZLEditPathType)pathType{
    if (pathType == AZLEditPathTypePencil) {
        [self.drawView setPathProvider:[[AZLPathProviderPencil alloc] init]];
    }else if (pathType == AZLEditPathTypePen) {
        [self.drawView setPathProvider:[[AZLPathProviderPen alloc] init]];
    }
}

- (void)editBottomViewDoneDidTap:(AZLPhotoEditBottomView*)editBottomView{
    [self doneDidTap];
}

- (void)editBottomViewAddDidTap:(AZLPhotoEditBottomView *)editBottomView{
    [self.tileView addTextTile];
}

/// 开始编辑
- (void)tileContainerViewDidBeginEditing:(AZLTileContainerView*)tileContainerView{
    [self hideEditUI];
}
/// 结束编辑
- (void)tileContainerViewDidEndEditing:(AZLTileContainerView*)tileContainerView{
    [self showEditUI];
}

@end
