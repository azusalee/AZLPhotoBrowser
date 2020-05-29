//
//  AZLPhotoEditBottomView.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AZLEditType) {
    AZLEditTypeNone = 0,
    AZLEditTypePath,
    AZLEditTypeMosaic,
    AZLEditTypeCrop,
    AZLEditTypeTile,
};

typedef NS_ENUM(NSUInteger, AZLEditPathType) {
    AZLEditPathTypePencil = 0,
    AZLEditPathTypePen,
};

@class AZLPhotoEditBottomView;
@protocol AZLPhotoEditBottomViewDelegate <NSObject>

/// 撤回点击
- (void)editBottomViewUndoDidTap:(AZLPhotoEditBottomView*)editBottomView;
/// 重做点击
- (void)editBottomViewRedoDidTap:(AZLPhotoEditBottomView*)editBottomView;

/// 颜色更改
- (void)editBottomView:(AZLPhotoEditBottomView*)editBottomView colorDidChange:(UIColor*)color;

/// 编辑类型改变
- (void)editBottomView:(AZLPhotoEditBottomView*)editBottomView editTypeDidChange:(AZLEditType)editType;

/// 更改画笔类型
- (void)editBottomView:(AZLPhotoEditBottomView*)editBottomView pathTypeDidChange:(AZLEditPathType)pathType;

/// 完成点击
- (void)editBottomViewDoneDidTap:(AZLPhotoEditBottomView*)editBottomView;
/// 添加点击
- (void)editBottomViewAddDidTap:(AZLPhotoEditBottomView*)editBottomView;

@end

@interface AZLPhotoEditBottomView : UIView

@property (nonatomic, weak) id<AZLPhotoEditBottomViewDelegate> delegate;
/// 编辑类型
@property (nonatomic, readonly) AZLEditType editType;
/// 画笔类型
@property (nonatomic, readonly) AZLEditPathType editPathType;

//@property (nonatomic, assign) BOOL undoEnable;
//@property (nonatomic, assign) BOOL redoEnable;
/// 设置撤回是否可以点击
- (void)setUndoEnable:(BOOL)undoEnable;
/// 设置重做是否可以点击
- (void)setRedoEnable:(BOOL)redoEnable;

@end

NS_ASSUME_NONNULL_END
