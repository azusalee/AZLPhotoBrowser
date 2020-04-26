//
//  AZLScratchView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/26.
//

#import "AZLScratchView.h"
#import "AZLPathProviderPen.h"

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
    self.multipleTouchEnabled = YES;
    self.drawView = [[AZLEditDrawView alloc] initWithFrame:self.bounds];
    self.drawView.pathProvider.lineWidth = 16;
    self.drawView.userInteractionEnabled = NO;
    self.drawView.backgroundColor = [UIColor clearColor];
    self.drawView.pathColor = [UIColor whiteColor];
    self.drawView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.maskView = self.drawView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.drawView.frame = self.bounds;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
