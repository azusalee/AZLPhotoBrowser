//
//  AZLEditDrawView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import "AZLEditDrawView.h"
#import "AZLPathProviderPencil.h"
#import "AZLEditRecord.h"

@interface AZLEditDrawView() <AZLPathProviderDelegate>

@property (nonatomic, strong) NSMutableArray<AZLEditRecord*> *editRecordArray;
@property (nonatomic, strong) AZLEditRecord *tmpEditRecord;

@end

@implementation AZLEditDrawView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.opaque = NO;
    self.multipleTouchEnabled = YES;
    self.editRecordArray = [[NSMutableArray alloc] init];
    self.pathProvider = [[AZLPathProviderPencil alloc] init];
    self.pathProvider.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.count != 1) {
        return;
    }
    self.tmpEditRecord = [[AZLEditRecord alloc] init];
    self.tmpEditRecord.color = self.pathColor;
    self.tmpEditRecord.bounds = self.bounds;
    //獲取觸點位置
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.pathProvider touchBeganWithPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.count != 1) {
        return;
    }
    //獲取觸點位置
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.pathProvider touchMoveWithPoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.count != 1) {
        return;
    }
    //獲取觸點位置
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.pathProvider touchEndWithPoint:point];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.tmpEditRecord) {
        [self.editRecordArray addObject:self.tmpEditRecord];
        self.tmpEditRecord = nil;
        [self setNeedsDisplay];
    }
}

//path改變的時候回調(临时的path)
- (void)pathProvider:(AZLPathProviderBase*)provider didChangePath:(UIBezierPath *)path{
    self.tmpEditRecord.path = path;
    [self setNeedsDisplay];
}

//画完一条path时回调(抬手时回调)
- (void)pathProvider:(AZLPathProviderBase*)provider didEndPath:(UIBezierPath *)path{
    self.tmpEditRecord.path = path;
    [self.editRecordArray addObject:self.tmpEditRecord];
    self.tmpEditRecord = nil;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGRect nowBounds = self.bounds;
    for (AZLEditRecord *editRecord in self.editRecordArray) {
        if (nowBounds.size.width != editRecord.bounds.size.width) {
            CGFloat scale = nowBounds.size.width/editRecord.bounds.size.width;
            [editRecord.path applyTransform:CGAffineTransformMakeScale(scale, scale)];
            editRecord.path.lineWidth = editRecord.path.lineWidth*scale;
            editRecord.bounds = nowBounds;
        }
        
        [editRecord.color set];
        [editRecord.path stroke];
    }
    
    if (self.tmpEditRecord) {
        [self.tmpEditRecord.color set];
        [self.tmpEditRecord.path stroke];
    }
    
}

@end
