//
//  AZLPathProviderPencil.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import "AZLPathProviderPencil.h"

@interface AZLPathProviderPencil()


@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation AZLPathProviderPencil

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (void)setup{
    self.lineWidth = 3;
}

- (void)touchBeganWithPoint:(CGPoint)point{
    self.path = [[UIBezierPath alloc] init];
    self.path.lineWidth = self.lineWidth;
    [self.path moveToPoint:point];
}

- (void)touchMoveWithPoint:(CGPoint)point{
    [self.path addLineToPoint:point];
    [self.path moveToPoint:point];
    
    [self.delegate pathProvider:self didChangePath:self.path];
}

- (void)touchEndWithPoint:(CGPoint)point{
    [self.delegate pathProvider:self didEndPath:self.path];
}

@end
