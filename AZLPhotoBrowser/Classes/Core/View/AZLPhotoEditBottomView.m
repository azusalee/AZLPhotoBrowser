//
//  AZLPhotoEditBottomView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/5/13.
//

#import "AZLPhotoEditBottomView.h"
#import "AZLColorPickView.h"
#import "AZLPhotoBrowserManager.h"
#import <AZLExtend/AZLExtend.h>

@interface AZLPhotoEditBottomView()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

/// 取色器view
@property (nonatomic, strong) AZLColorPickView *colorPickView;
@property (nonatomic, strong) UIView *editTypeIndicateView;
@property (nonatomic, strong) UIView *editSubTypeIndicateView;

@property (nonatomic, strong) UIButton *pathButton;
@property (nonatomic, strong) UIButton *pencilButton;
@property (nonatomic, strong) UIButton *penButton;
@property (nonatomic, strong) UIButton *mosaicButton;
@property (nonatomic, strong) UIButton *cropButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *tileButton;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIButton *undoButton;
@property (nonatomic, strong) UIButton *redoButton;

@property (nonatomic, assign) AZLEditType editType;
@property (nonatomic, assign) AZLEditPathType editPathType;

@end

@implementation AZLPhotoEditBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

- (void)setup{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor, (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor]; //设置渐变颜色
    //gradientLayer.locations = @[@0.0, @1]; //颜色的起点位置，递增，并且数量跟颜色数量相等
    gradientLayer.startPoint = CGPointMake(0, 0); // 
    gradientLayer.endPoint = CGPointMake(0, 1); // 
    [self.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;

    self.colorPickView = [[AZLColorPickView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
    self.colorPickView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.colorPickView.hidden = YES;
    __weak AZLPhotoEditBottomView *weakSelf = self;
    [self.colorPickView setBlock:^(UIColor * _Nonnull color) {
        //weakSelf.drawView.pathColor = color;
        [weakSelf.delegate editBottomView:weakSelf colorDidChange:color];
    }];
    [self addSubview:self.colorPickView];
    
    self.undoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.undoButton.hidden = YES;
    [self.undoButton setImage:[AZLPhotoBrowserManager sharedInstance].theme.undoImage forState:UIControlStateNormal];
    [self.undoButton setImage:[[AZLPhotoBrowserManager sharedInstance].theme.undoImage azl_imageWithGradientTintColor:[UIColor lightTextColor]] forState:UIControlStateDisabled];
    [self.undoButton setTintColor:[UIColor whiteColor]];
    self.undoButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-85, 30, 30, 30);
    [self.undoButton addTarget:self action:@selector(undoDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.undoButton];
    
    self.redoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.redoButton.enabled = NO;
    self.redoButton.hidden = YES;
    [self.redoButton setImage:[AZLPhotoBrowserManager sharedInstance].theme.redoImage forState:UIControlStateNormal];
    [self.redoButton setImage:[[AZLPhotoBrowserManager sharedInstance].theme.redoImage azl_imageWithGradientTintColor:[UIColor lightTextColor]] forState:UIControlStateDisabled];
    [self.redoButton setTintColor:[UIColor whiteColor]];
    self.redoButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-45, 30, 30, 30);
    [self.redoButton addTarget:self action:@selector(redoDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.redoButton];
    
    self.editTypeIndicateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.editTypeIndicateView.layer.borderWidth = 1;
    self.editTypeIndicateView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.editTypeIndicateView.hidden = YES;
    [self addSubview:self.editTypeIndicateView];
    
    self.editSubTypeIndicateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.editSubTypeIndicateView.layer.borderWidth = 1;
    self.editSubTypeIndicateView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.editSubTypeIndicateView.hidden = YES;
    [self addSubview:self.editSubTypeIndicateView];
    
    self.pathButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.pathButton.frame = CGRectMake(15, 38, 30, 30);
    [self.pathButton setTitle:@"笔" forState:UIControlStateNormal];
    [self.pathButton setTintColor:[UIColor whiteColor]];
    [self.pathButton addTarget:self action:@selector(pathDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pathButton];
    
    self.pencilButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.pencilButton.frame = CGRectMake(15, -34, 30, 30);
    [self.pencilButton setTitle:@"铅" forState:UIControlStateNormal];
    [self.pencilButton setTintColor:[UIColor whiteColor]];
    [self.pencilButton addTarget:self action:@selector(pencilDidTap:) forControlEvents:UIControlEventTouchUpInside];
    self.pencilButton.hidden = YES;
    [self addSubview:self.pencilButton];
    
    self.penButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.penButton.frame = CGRectMake(55, -34, 30, 30);
    [self.penButton setTitle:@"钢" forState:UIControlStateNormal];
    [self.penButton setTintColor:[UIColor whiteColor]];
    [self.penButton addTarget:self action:@selector(penDidTap:) forControlEvents:UIControlEventTouchUpInside];
    self.penButton.hidden = YES;
    [self addSubview:self.penButton];
    
    self.mosaicButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.mosaicButton.frame = CGRectMake(55, 38, 30, 30);
    [self.mosaicButton setTitle:@"马" forState:UIControlStateNormal];
    [self.mosaicButton setTintColor:[UIColor whiteColor]];
    [self.mosaicButton addTarget:self action:@selector(mosaicDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.mosaicButton];
    
    self.cropButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cropButton.frame = CGRectMake(95, 38, 30, 30);
    [self.cropButton setTitle:@"裁" forState:UIControlStateNormal];
    [self.cropButton setTintColor:[UIColor whiteColor]];
    [self.cropButton addTarget:self action:@selector(cropDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cropButton];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.doneButton.hidden = YES;
    self.doneButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-30, -34, 60, 40);
    [self.doneButton setTitle:@"裁剪" forState:UIControlStateNormal];
    [self.doneButton setTintColor:[UIColor whiteColor]];
    self.doneButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.doneButton.layer.borderWidth = 1;
    self.doneButton.layer.cornerRadius = 8;
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.doneButton addTarget:self action:@selector(doneDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.doneButton];
    
    self.tileButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.tileButton.frame = CGRectMake(135, 38, 30, 30);
    [self.tileButton setTitle:@"贴" forState:UIControlStateNormal];
    [self.tileButton setTintColor:[UIColor whiteColor]];
    [self.tileButton addTarget:self action:@selector(tileDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.tileButton];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.addButton.hidden = YES;
    self.addButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-30, -44, 60, 40);
    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.addButton setTintColor:[UIColor whiteColor]];
    self.addButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.addButton.layer.borderWidth = 1;
    self.addButton.layer.cornerRadius = 8;
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.addButton addTarget:self action:@selector(addDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
    
}

- (void)setUndoEnable:(BOOL)undoEnable{
    self.undoButton.enabled = undoEnable;
}

//- (BOOL)undoEnable{
//    return self.undoButton.enabled;
//}

- (void)setRedoEnable:(BOOL)redoEnable{
    self.redoButton.enabled = redoEnable;
}

//- (BOOL)redoEnable{
//    return self.redoButton.enabled;
//}

- (void)setEditType:(AZLEditType)editType{
    _editType = editType;
    self.editTypeIndicateView.hidden = YES;
    self.editSubTypeIndicateView.hidden = YES;
    self.colorPickView.hidden = YES;
    self.redoButton.hidden = YES;
    self.undoButton.hidden = YES;
    self.pencilButton.hidden = YES;
    self.penButton.hidden = YES;
    self.doneButton.hidden = YES;
    self.addButton.hidden = YES;
    
    switch (editType) {
        case AZLEditTypeNone:
            
            break;
        case AZLEditTypePath:
            self.colorPickView.hidden = NO;
            self.editTypeIndicateView.center = self.pathButton.center;
            self.editTypeIndicateView.hidden = NO;
            self.editSubTypeIndicateView.hidden = NO;
            self.editPathType = self.editPathType;
            self.pencilButton.hidden = NO;
            self.penButton.hidden = NO;
            self.redoButton.hidden = NO;
            self.undoButton.hidden = NO;
            break;
        case AZLEditTypeMosaic:
            self.editTypeIndicateView.hidden = NO;
            self.editTypeIndicateView.center = self.mosaicButton.center;
            self.redoButton.hidden = NO;
            self.undoButton.hidden = NO;
            break;
        case AZLEditTypeCrop:
            self.editTypeIndicateView.hidden = NO;
            self.editTypeIndicateView.center = self.cropButton.center;
            self.redoButton.hidden = NO;
            self.undoButton.hidden = NO;
            self.doneButton.hidden = NO;
            break;
        case AZLEditTypeTile:
            self.editTypeIndicateView.hidden = NO;
            self.editTypeIndicateView.center = self.tileButton.center;
            self.colorPickView.hidden = NO;
            self.addButton.hidden = NO;
            
            break;
    }
}

- (void)setEditPathType:(AZLEditPathType)editPathType{
    _editPathType = editPathType;
    switch (editPathType) {
        case AZLEditPathTypePencil:
            self.editSubTypeIndicateView.center = self.pencilButton.center;
            break;
        case AZLEditPathTypePen:
            self.editSubTypeIndicateView.center = self.penButton.center;
            break;
            
    }
}

- (void)undoDidTap:(UIButton*)button {
   [self.delegate editBottomViewUndoDidTap:self];
}

- (void)redoDidTap:(UIButton*)button {
    [self.delegate editBottomViewRedoDidTap:self];
}

- (void)pencilDidTap:(UIButton*)button {
    self.editPathType = AZLEditPathTypePencil;
    [self.delegate editBottomView:self pathTypeDidChange:self.editPathType];
}

- (void)penDidTap:(UIButton*)button{
    self.editPathType = AZLEditPathTypePen;
    [self.delegate editBottomView:self pathTypeDidChange:self.editPathType];
}

- (void)doneDidTap:(UIButton*)button{
    [self.delegate editBottomViewDoneDidTap:self];
}

- (void)pathDidTap:(UIButton*)button {
    if (self.editType != AZLEditTypePath) {
        self.editType = AZLEditTypePath;
    }else{
        self.editType = AZLEditTypeNone;
    }
    [self.delegate editBottomView:self editTypeDidChange:self.editType];
}

- (void)mosaicDidTap:(UIButton*)button{
    if (self.editType != AZLEditTypeMosaic) {
        self.editType = AZLEditTypeMosaic;
    }else{
        self.editType = AZLEditTypeNone;
    }
    [self.delegate editBottomView:self editTypeDidChange:self.editType];
}

- (void)cropDidTap:(UIButton*)button{
    if (self.editType != AZLEditTypeCrop) {
        self.editType = AZLEditTypeCrop;
    }else{
        self.editType = AZLEditTypeNone;
    }
    [self.delegate editBottomView:self editTypeDidChange:self.editType];
}

- (void)tileDidTap:(UIButton*)button{
    if (self.editType != AZLEditTypeTile) {
        self.editType = AZLEditTypeTile;
    }else{
        self.editType = AZLEditTypeNone;
    }
    [self.delegate editBottomView:self editTypeDidChange:self.editType];
}

- (void)addDidTap:(UIButton*)button{
    [self.delegate editBottomViewAddDidTap:self];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    // 重写hitTest，使范围外的button可以相应
    if (self.isHidden == YES || self.userInteractionEnabled == NO) {
        return nil;
    }
    if (self.editType == AZLEditTypePath) {
        if (CGRectContainsPoint(self.pencilButton.frame, point)) {
            return self.pencilButton;
        }
        if (CGRectContainsPoint(self.penButton.frame, point)) {
            return self.penButton;
        }
    }else if (self.editType == AZLEditTypeCrop) {
        if (CGRectContainsPoint(self.doneButton.frame, point)) {
            return self.doneButton;
        }
    }else if (self.editType == AZLEditTypeTile) {
        if (CGRectContainsPoint(self.addButton.frame, point)) {
            return self.addButton;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end
