//
//  AZLEditDrawView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import "AZLEditDrawView.h"
#import "AZLPathProviderPencil.h"


@interface AZLEditShapeLayer : CAShapeLayer

@property (nonatomic, strong) AZLEditRecord *record;
@property (nonatomic, assign) CGFloat lastTransScale;

- (void)applyBounds:(CGRect)bounds;

@end

@implementation AZLEditShapeLayer

- (instancetype)init{
    if (self = [super init]) {
        _lastTransScale = 1;
    }
    return self;
}

- (void)setRecord:(AZLEditRecord *)record{
    _record = record;
    //self.anchorPoint = CGPointMake(0, 0);
    self.bounds = record.bounds;
    self.lineWidth = record.path.lineWidth;
    self.strokeColor = record.color.CGColor;
    self.fillColor = record.color.CGColor;
}

- (void)applyBounds:(CGRect)bounds {
    if (self.frame.size.width == bounds.size.width) {
        return;
    }
    [self.record applyBounds:bounds];
    
    self.lineWidth = self.record.path.lineWidth;
    self.path = self.record.path.CGPath;
    self.frame = bounds;
}

@end

@interface AZLEditDrawView() <AZLPathProviderDelegate>

@property (nonatomic, strong) NSMutableArray<AZLEditRecord*> *editRecordArray;
@property (nonatomic, strong) NSMutableArray<AZLEditRecord*> *redoRecordArray;
@property (nonatomic, strong) AZLEditRecord *tmpEditRecord;

@property (nonatomic, strong) AZLEditShapeLayer *tmpShapeLayer;

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
    self.redoRecordArray = [[NSMutableArray alloc] init];
    self.pathProvider = [[AZLPathProviderPencil alloc] init];
}

- (void)setPathProvider:(AZLPathProviderBase *)pathProvider{
    _pathProvider = pathProvider;
    pathProvider.delegate = self;
}

- (void)addEditRecords:(NSArray<AZLEditRecord *> *)records{
    if (records.count == 0) {
        return;
    }
    [self.editRecordArray addObjectsFromArray:records];
    [self setNeedsDisplay];
}

- (void)removeLastRecord{
    if (self.editRecordArray.count > 0) {
        AZLEditRecord *lastRecord = [self.editRecordArray lastObject];
        [self.editRecordArray removeLastObject];
        [self.redoRecordArray addObject:lastRecord];
        
        [self setNeedsDisplay];
        [self.delegate editDrawViewDidChangePath:self];
    }
}

- (void)redoLastRecord{
    if (self.redoRecordArray.count > 0) {
        AZLEditRecord *redoRecord = [self.redoRecordArray lastObject];
        [self.redoRecordArray removeLastObject];
        [self.editRecordArray addObject:redoRecord];
        
        [self setNeedsDisplay];
        [self.delegate editDrawViewDidChangePath:self];
    }
}

- (void)pathDidFinish{
    [self.editRecordArray addObject:self.tmpEditRecord];
    [self.redoRecordArray removeAllObjects];
    [self.tmpShapeLayer removeFromSuperlayer];
    self.tmpShapeLayer = nil;
    self.tmpEditRecord = nil;
    [self setNeedsDisplay];
    [self.delegate editDrawViewDidChangePath:self];
}

- (void)undoCropRecord:(AZLCropRecord *)cropRecord{
    for (AZLEditRecord *record in self.editRecordArray) {
        [record undoCropRecord:cropRecord];
    }
}

- (void)redoCropRecord:(AZLCropRecord *)cropRecord{
    for (AZLEditRecord *record in self.editRecordArray) {
        [record redoCropRecord:cropRecord];
    }
}

- (NSArray<AZLEditRecord *> *)getEditRecords{
    return self.editRecordArray.copy;
}

- (NSArray<AZLEditRecord *> *)getRedoRecords{
    return self.redoRecordArray.copy;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.count != 1) {
        return;
    }
    self.tmpEditRecord = [[AZLEditRecord alloc] init];
    self.tmpEditRecord.color = self.pathColor;
    self.tmpEditRecord.bounds = self.bounds;
    self.tmpShapeLayer = [[AZLEditShapeLayer alloc] init];
    self.tmpShapeLayer.record = self.tmpEditRecord;
    self.tmpShapeLayer.frame = self.bounds;
    self.tmpShapeLayer.lineWidth = self.pathProvider.lineWidth;
    [self.layer addSublayer:self.tmpShapeLayer];
    //獲取觸點位置
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.pathProvider touchBeganWithPoint:point];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.count != 1) {
        return;
    }
    [self.delegate editDrawViewEditingPath:self];
    
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
    if (self.tmpEditRecord.path != nil) {
        [self pathDidFinish];
    }else{
        self.tmpEditRecord = nil;
        [self.tmpShapeLayer removeFromSuperlayer];
        self.tmpShapeLayer = nil;
    }
}

//path改變的時候回調(临时的path)
- (void)pathProvider:(AZLPathProviderBase*)provider didChangePath:(UIBezierPath *)path{
    self.tmpEditRecord.path = path;
    self.tmpShapeLayer.path = self.tmpEditRecord.path.CGPath;
    //[self setNeedsDisplay];
}

//画完一条path时回调(抬手时回调)
- (void)pathProvider:(AZLPathProviderBase*)provider didEndPath:(UIBezierPath *)path{
    self.tmpEditRecord.path = path;
    self.tmpShapeLayer.path = self.tmpEditRecord.path.CGPath;
    [self pathDidFinish];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGRect nowBounds = self.bounds;
    for (AZLEditRecord *editRecord in self.editRecordArray) {
        [editRecord renderWithBounds:nowBounds];
    }
    
}

@end
