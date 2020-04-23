//
//  AZLEditDrawView.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import <UIKit/UIKit.h>
#import "AZLPathProviderBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface AZLEditDrawView : UIView

// 路径提供器（可以看作画笔）
@property (nonatomic, strong) AZLPathProviderBase *pathProvider;

@property (nonatomic, strong) UIColor *pathColor;

@end

NS_ASSUME_NONNULL_END
