//
//  AZLEditRecord.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZLEditRecord : NSObject

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIColor *color;
// 画的时候的画布大小
@property (nonatomic, assign) CGRect bounds;

@end

NS_ASSUME_NONNULL_END
