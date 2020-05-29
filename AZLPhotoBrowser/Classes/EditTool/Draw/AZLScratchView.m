//
//  AZLScratchView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/26.
//

#import "AZLScratchView.h"

@interface AZLScratchView()

@end

@implementation AZLScratchView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    self.multipleTouchEnabled = YES;
    self.drawView = [[AZLEditDrawView alloc] initWithFrame:self.bounds];
    self.drawView.pathProvider.lineWidth = 16;
    self.drawView.userInteractionEnabled = NO;
    self.drawView.backgroundColor = [UIColor clearColor];
    self.drawView.pathColor = [UIColor whiteColor];
    self.drawView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.maskView = self.drawView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.drawView touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.drawView touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.drawView touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.drawView touchesCancelled:touches withEvent:event];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = CGRectNull;
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
        //此处为获取新的bounds
            newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
            self.drawView.frame = newFrame;
        }
    }
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"frame"];
}

@end
