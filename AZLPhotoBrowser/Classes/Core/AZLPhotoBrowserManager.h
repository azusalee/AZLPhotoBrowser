//
//  AZLPhotoBrowserManager.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import <Foundation/Foundation.h>
#import "AZLPhotoBrowserTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface AZLPhotoBrowserManager : NSObject

/// 單例
+ (instancetype)sharedInstance;

/// 主題配置(顏色等)
@property (nonatomic, strong) AZLPhotoBrowserTheme *theme;

@end

NS_ASSUME_NONNULL_END
