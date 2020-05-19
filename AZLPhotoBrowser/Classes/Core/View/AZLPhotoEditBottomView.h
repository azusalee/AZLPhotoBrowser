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

- (void)editBottomViewUndoDidTap:(AZLPhotoEditBottomView*)editBottomView;
- (void)editBottomViewRedoDidTap:(AZLPhotoEditBottomView*)editBottomView;

- (void)editBottomView:(AZLPhotoEditBottomView*)editBottomView colorDidChange:(UIColor*)color;

- (void)editBottomView:(AZLPhotoEditBottomView*)editBottomView editTypeDidChange:(AZLEditType)editType;

- (void)editBottomView:(AZLPhotoEditBottomView*)editBottomView pathTypeDidChange:(AZLEditPathType)pathType;

- (void)editBottomViewDoneDidTap:(AZLPhotoEditBottomView*)editBottomView;
- (void)editBottomViewAddDidTap:(AZLPhotoEditBottomView*)editBottomView;

@end

@interface AZLPhotoEditBottomView : UIView

@property (nonatomic, weak) id<AZLPhotoEditBottomViewDelegate> delegate;

@property (nonatomic, readonly) AZLEditType editType;
@property (nonatomic, readonly) AZLEditPathType editPathType;

@property (nonatomic, assign) BOOL undoEnable;
@property (nonatomic, assign) BOOL redoEnable;

@end

NS_ASSUME_NONNULL_END
