//
//  AZLPhotoBrowserTheme.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZLPhotoBrowserTheme : NSObject

// 顏色
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

// 圖片
/// 返回圖片
@property (nonatomic, strong) UIImage *backImage;
/// 撤銷
@property (nonatomic, strong) UIImage *undoImage;
/// 重做
@property (nonatomic, strong) UIImage *redoImage;

// 自定義文字
// 完成
@property (nonatomic, strong) NSString *finishString;
// 確定
@property (nonatomic, strong) NSString *confirmString;
// 取消
@property (nonatomic, strong) NSString *cancelString;
// 全部
@property (nonatomic, strong) NSString *allString;
// 动图
@property (nonatomic, strong) NSString *animateString;
// 你最多只能选择%ld张照片
@property (nonatomic, strong) NSString *moreThanMaxAlertString;
// 我知道了
@property (nonatomic, strong) NSString *moreThanMaxAlertConfirmString;

// 访问相册
@property (nonatomic, strong) NSString *photoAuthAlertTitleString;
// 您还没有打开相册权限
@property (nonatomic, strong) NSString *photoAuthAlertContentString;
// 去打开
@property (nonatomic, strong) NSString *photoAuthOpenString;
// 保存到相冊
@property (nonatomic, strong) NSString *photoSaveImageString;

// 保存到相冊成功
@property (nonatomic, strong) NSString *photoSaveImageSuccessString;
// 保存到相冊失敗
@property (nonatomic, strong) NSString *photoSaveImageFailString;

// 編輯
@property (nonatomic, strong) NSString *editString;

@end

NS_ASSUME_NONNULL_END
