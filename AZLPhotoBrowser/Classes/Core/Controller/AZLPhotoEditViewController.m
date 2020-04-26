//
//  AZLPhotoEditViewController.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import "AZLPhotoEditViewController.h"
#import "AZLPhotoBrowserView.h"
#import <SDWebImage/SDWebImage.h>
#import "AZLPhotoBrowserManager.h"
#import "AZLEditDrawView.h"
#import "AZLColorPickView.h"
#import <AZLExtend/AZLExtend.h>

#import "AZLPathProviderPencil.h"
#import "AZLPathProviderPen.h"
#import "AZLScratchView.h"

typedef NS_ENUM(NSUInteger, AZLEditType) {
    AZLEditTypeNone = 0,
    AZLEditTypePencil,
    AZLEditTypePen,
    AZLEditTypeMosaic,
};


@interface AZLPhotoEditViewController () <AZLEditDrawViewDelegate>

@property (nonatomic, strong) AZLPhotoBrowserView *browserView;

@property (nonatomic, strong) UIView *editTopView;
@property (nonatomic, strong) UIView *editBottomView;
@property (nonatomic, assign) BOOL isShowingEditUI;

/// 修改圖層view
@property (nonatomic, strong) AZLEditDrawView *drawView;
/// 取色器view
@property (nonatomic, strong) AZLColorPickView *colorPickView;
/// 馬賽克圖層view
@property (nonatomic, strong) AZLScratchView *mosaicView;

@property (nonatomic, strong) UIButton *undoButton;
@property (nonatomic, strong) UIButton *redoButton;

@property (nonatomic, strong) UIButton *pencilButton;
@property (nonatomic, strong) UIButton *penButton;
@property (nonatomic, strong) UIButton *mosaicButton;
@property (nonatomic, strong) UIView *editTypeIndicateView;

@property (nonatomic, assign) AZLEditType editType;

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
        imageView.image = [self.browserView.imageView.image azl_imageFromMosaicLevel:16];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_mosaicView addSubview:imageView];
        
        [self.browserView.imageView insertSubview:_mosaicView atIndex:0];
    }
    return _mosaicView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        [self.browserView.imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrlString] placeholderImage:model.placeholdImage];
    }
    
    [self.view addSubview:self.browserView];
    
    [self setupEditUI];
    [self setDrawUI];
}

- (void)setupEditUI{
    //頭部
    CGFloat navBarHeight = 44;
    self.editTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, navBarHeight+[UIApplication sharedApplication].statusBarFrame.size.height)];
    self.editTopView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.editTopView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(5, self.editTopView.bounds.size.height-navBarHeight, 44, navBarHeight);
    cancelButton.tintColor = [UIColor whiteColor];
    [cancelButton setImage:[AZLPhotoBrowserManager sharedInstance].theme.backImage forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editTopView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(leftBarItemDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    //底部
    self.editBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-80, [UIScreen mainScreen].bounds.size.width, 80)];
    self.editBottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.editBottomView];
    
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

- (void)setDrawUI{
    self.drawView = [[AZLEditDrawView alloc] initWithFrame:self.browserView.imageView.bounds];
    self.drawView.userInteractionEnabled = NO;
    self.drawView.delegate = self;
    self.drawView.pathColor = [UIColor whiteColor];
    self.drawView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.browserView.imageView addSubview:self.drawView];
    [self.drawView addEditRecords:self.photoModel.editRecords];
    
    if (self.photoModel.mosaicRecords) {
        [self mosaicView];
    }
    
    self.colorPickView = [[AZLColorPickView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    self.colorPickView.hidden = YES;
    __weak AZLPhotoEditViewController *weakSelf = self;
    [self.colorPickView setBlock:^(UIColor * _Nonnull color) {
        weakSelf.drawView.pathColor = color;
    }];
    [self.editBottomView addSubview:self.colorPickView];
    
    self.undoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.undoButton.hidden = YES;
    self.undoButton.enabled = (self.photoModel.editRecords.count>0);
    [self.undoButton setImage:[AZLPhotoBrowserManager sharedInstance].theme.undoImage forState:UIControlStateNormal];
    [self.undoButton setImage:[[AZLPhotoBrowserManager sharedInstance].theme.undoImage azl_imageWithGradientTintColor:[UIColor lightTextColor]] forState:UIControlStateDisabled];
    [self.undoButton setTintColor:[UIColor whiteColor]];
    self.undoButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-85, 30, 30, 30);
    [self.undoButton addTarget:self action:@selector(undoDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.editBottomView addSubview:self.undoButton];
    
    self.redoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.redoButton.enabled = NO;
    self.redoButton.hidden = YES;
    [self.redoButton setImage:[AZLPhotoBrowserManager sharedInstance].theme.redoImage forState:UIControlStateNormal];
    [self.redoButton setImage:[[AZLPhotoBrowserManager sharedInstance].theme.redoImage azl_imageWithGradientTintColor:[UIColor lightTextColor]] forState:UIControlStateDisabled];
    [self.redoButton setTintColor:[UIColor whiteColor]];
    self.redoButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-45, 30, 30, 30);
    [self.redoButton addTarget:self action:@selector(redoDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.editBottomView addSubview:self.redoButton];
    
    self.editTypeIndicateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.editTypeIndicateView.layer.borderWidth = 1;
    self.editTypeIndicateView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.editTypeIndicateView.hidden = YES;
    [self.editBottomView addSubview:self.editTypeIndicateView];
    
    self.pencilButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.pencilButton.frame = CGRectMake(15, 38, 30, 30);
    [self.pencilButton setTitle:@"鉛" forState:UIControlStateNormal];
    [self.pencilButton setTintColor:[UIColor whiteColor]];
    [self.pencilButton addTarget:self action:@selector(pencilDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.editBottomView addSubview:self.pencilButton];
    
    self.penButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.penButton.frame = CGRectMake(55, 38, 30, 30);
    [self.penButton setTitle:@"鋼" forState:UIControlStateNormal];
    [self.penButton setTintColor:[UIColor whiteColor]];
    [self.penButton addTarget:self action:@selector(penDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.editBottomView addSubview:self.penButton];
    
    self.mosaicButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.mosaicButton.frame = CGRectMake(95, 38, 30, 30);
    [self.mosaicButton setTitle:@"馬" forState:UIControlStateNormal];
    [self.mosaicButton setTintColor:[UIColor whiteColor]];
    [self.mosaicButton addTarget:self action:@selector(mosaicDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.editBottomView addSubview:self.mosaicButton];
}

- (void)leftBarItemDidTap:(id)sender {
    [self generateEditImage];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)undoDidTap:(UIButton*)button {
    if (self.editType == AZLEditTypeMosaic) {
        [self.mosaicView.drawView removeLastRecord];
    }else{
        [self.drawView removeLastRecord];
    }
}

- (void)redoDidTap:(UIButton*)button {
    if (self.editType == AZLEditTypeMosaic) {
        [self.mosaicView.drawView redoLastRecord];
    }else{
        [self.drawView redoLastRecord];
    }
}

- (void)setEditType:(AZLEditType)editType{
    _editType = editType;
    switch (editType) {
        case AZLEditTypeNone:
            self.browserView.scrollView.scrollEnabled = YES;
            self.drawView.userInteractionEnabled = NO;
            self.mosaicView.userInteractionEnabled = NO;
            self.editTypeIndicateView.hidden = YES;
            self.colorPickView.hidden = YES;
            self.redoButton.hidden = YES;
            self.undoButton.hidden = YES;
            break;
        case AZLEditTypePencil:
            self.browserView.scrollView.scrollEnabled = NO;
            self.drawView.userInteractionEnabled = YES;
            self.drawView.pathProvider = [[AZLPathProviderPencil alloc] init];
            self.editTypeIndicateView.center = self.pencilButton.center;
            self.editTypeIndicateView.hidden = NO;
            self.colorPickView.hidden = NO;
            self.mosaicView.userInteractionEnabled = NO;
            self.redoButton.hidden = NO;
            self.undoButton.hidden = NO;
            self.redoButton.enabled = [self.drawView getRedoRecords].count>0;
            self.undoButton.enabled = [self.drawView getEditRecords].count>0;
            break;
        case AZLEditTypePen:
            self.browserView.scrollView.scrollEnabled = NO;
            self.drawView.userInteractionEnabled = YES;
            self.drawView.pathProvider = [[AZLPathProviderPen alloc] init];
            self.editTypeIndicateView.center = self.penButton.center;
            self.editTypeIndicateView.hidden = NO;
            self.colorPickView.hidden = NO;
            self.mosaicView.userInteractionEnabled = NO;
            self.redoButton.hidden = NO;
            self.undoButton.hidden = NO;
            self.redoButton.enabled = [self.drawView getRedoRecords].count>0;
            self.undoButton.enabled = [self.drawView getEditRecords].count>0;
            break;
        case AZLEditTypeMosaic:
            self.browserView.scrollView.scrollEnabled = NO;
            self.editTypeIndicateView.hidden = NO;
            self.editTypeIndicateView.center = self.mosaicButton.center;
            self.colorPickView.hidden = YES;
            self.drawView.userInteractionEnabled = NO;
            self.mosaicView.userInteractionEnabled = YES;
            self.redoButton.hidden = NO;
            self.undoButton.hidden = NO;
            self.redoButton.enabled = [self.mosaicView.drawView getRedoRecords].count>0;
            self.undoButton.enabled = [self.mosaicView.drawView getEditRecords].count>0;
            break;
        default:
            break;
    }
}

- (void)pencilDidTap:(UIButton*)button {
    if (self.editType != AZLEditTypePencil) {
        self.editType = AZLEditTypePencil;
    }else{
        self.editType = AZLEditTypeNone;
    }
}

- (void)penDidTap:(UIButton*)button{
    if (self.editType != AZLEditTypePen) {
        self.editType = AZLEditTypePen;
    }else{
        self.editType = AZLEditTypeNone;
    }
}

- (void)mosaicDidTap:(UIButton*)button{
    if (self.editType != AZLEditTypeMosaic) {
        self.editType = AZLEditTypeMosaic;
    }else{
        self.editType = AZLEditTypeNone;
    }
}

- (void)generateEditImage{
    // 生成編輯後的圖片
    UIImage *oriImage = self.browserView.imageView.image;
    NSArray *editRecords = [self.drawView getEditRecords];
    NSArray *mosaicRecords = [self.mosaicView.drawView getEditRecords];
    if (editRecords.count > 0 || mosaicRecords.count > 0) {
        
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
    }else{
        self.photoModel.editImage = nil;
        self.photoModel.smallEditImage = nil;
        self.photoModel.editRecords = nil;
        self.photoModel.mosaicRecords = nil;
    }
}

- (void)editDrawViewDidChangePath:(AZLEditDrawView *)drawView{
    NSInteger editCount = [drawView getEditRecords].count;
    NSInteger redoCount = [drawView getRedoRecords].count;
    
    self.redoButton.enabled = redoCount>0;
    self.undoButton.enabled = editCount>0;
    [self showEditUI];
}

- (void)editDrawViewDidBeginEditing:(AZLEditDrawView *)drawView{
    [self hideEditUI];
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
