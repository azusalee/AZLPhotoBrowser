//
//  AZLEditDrawView.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/23.
//

#import "AZLEditDrawView.h"
#import "AZLPathProviderPencil.h"


@interface AZLEditDrawView() <AZLPathProviderDelegate>

@property (nonatomic, strong) NSMutableArray<AZLEditRecord*> *editRecordArray;
@property (nonatomic, strong) NSMutableArray<AZLEditRecord*> *redoRecordArray;
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
    self.tmpEditRecord = nil;
    [self setNeedsDisplay];
    [self.delegate editDrawViewDidChangePath:self];
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
    //獲取觸點位置
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.pathProvider touchBeganWithPoint:point];
    [self.delegate editDrawViewDidBeginEditing:self];
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
        [self pathDidFinish];
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
    [self pathDidFinish];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGRect nowBounds = self.bounds;
    for (AZLEditRecord *editRecord in self.editRecordArray) {
        [editRecord renderWithBounds:nowBounds];
    }
    
    if (self.tmpEditRecord) {
        [self.tmpEditRecord renderWithBounds:nowBounds];
    }
    
}

@end
