//
//  AZLPathProviderBase.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import "AZLPathProviderBase.h"

@implementation AZLPathProviderBase

- (instancetype)init{
    if (self = [super init]) {
        _lineWidth = 1;
    }
    return self;
}

- (void)touchBeganWithPoint:(CGPoint)point{
}

- (void)touchMoveWithPoint:(CGPoint)point{
}

- (void)touchEndWithPoint:(CGPoint)point{
}

@end
