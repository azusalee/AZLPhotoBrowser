//
//  AZLEditDrawView.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import <UIKit/UIKit.h>
#import "AZLPathProviderBase.h"
#import "AZLEditRecord.h"

NS_ASSUME_NONNULL_BEGIN

@class AZLEditDrawView;
@protocol AZLEditDrawViewDelegate <NSObject>

- (void)editDrawViewDidChangePath:(AZLEditDrawView*)drawView;

- (void)editDrawViewDidBeginEditing:(AZLEditDrawView*)drawView;

@end

@interface AZLEditDrawView : UIView

// 路径提供器（可以看作画笔）
@property (nonatomic, strong) AZLPathProviderBase *pathProvider;

@property (nonatomic, strong) UIColor *pathColor;

@property (nonatomic, assign) id<AZLEditDrawViewDelegate> delegate;

/// 添加編輯記錄
- (void)addEditRecords:(NSArray<AZLEditRecord*>*)records;

/// 撤銷最後一次修改
- (void)removeLastRecord;
/// 重做最後一次撤銷的編輯
- (void)redoLastRecord;

/// 獲取編輯記錄
- (NSArray<AZLEditRecord*>*)getEditRecords;
/// 獲取可重做的編輯記錄
- (NSArray<AZLEditRecord*>*)getRedoRecords;

@end

NS_ASSUME_NONNULL_END
