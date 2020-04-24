//
//  AZLPhotoBrowserTheme.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZLPhotoBrowserTheme : NSObject

/// 頭部底部bar背景色
@property (nonatomic, strong) UIColor *barBackgroundColor;
/// 頭部底部bar文字圖片色
@property (nonatomic, strong) UIColor *barTintColor;

/// 按鈕可用時的背景色
@property (nonatomic, strong) UIColor *enableBackgroundColor;
/// 按鈕可用時的文字色
@property (nonatomic, strong) UIColor *enableTextColor;
/// 按鈕不可用時的背景色
@property (nonatomic, strong) UIColor *disableBackgroundColor;
/// 按鈕不可用時的文字色
@property (nonatomic, strong) UIColor *disableTextColor;
/// 分割線顏色
@property (nonatomic, strong) UIColor *sepLineColor;

/// 主要controller的背景色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 主要文字色
@property (nonatomic, strong) UIColor *textColor;

/// 返回圖片
@property (nonatomic, strong) UIImage *backImage;
/// 撤銷
@property (nonatomic, strong) UIImage *undoImage;
/// 重做
@property (nonatomic, strong) UIImage *redoImage;

@end

NS_ASSUME_NONNULL_END
