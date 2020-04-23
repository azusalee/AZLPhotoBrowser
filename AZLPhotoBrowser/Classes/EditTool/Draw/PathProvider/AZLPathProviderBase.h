//
//  AZLPathProviderBase.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class AZLPathProviderBase;
@protocol AZLPathProviderDelegate <NSObject>

//path改變的時候回調(临时的path)
- (void)pathProvider:(AZLPathProviderBase*)provider didChangePath:(UIBezierPath *)path;

//画完一条path时回调(抬手时回调)
- (void)pathProvider:(AZLPathProviderBase*)provider didEndPath:(UIBezierPath *)path;

@end

@interface AZLPathProviderBase : NSObject

@property (nonatomic, weak) id<AZLPathProviderDelegate> delegate;

@property (nonatomic, assign) CGFloat lineWidth;

//觸摸事件發生時，調用下面對應的方法
- (void)touchBeganWithPoint:(CGPoint)point;
- (void)touchMoveWithPoint:(CGPoint)point;
- (void)touchEndWithPoint:(CGPoint)point;


@end

NS_ASSUME_NONNULL_END
