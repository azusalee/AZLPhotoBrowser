//
//  AZLPathProviderPen.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/24.
//

#import "AZLPathProviderPen.h"

/**
 獲取兩點間的中心點
 */
static inline CGPoint
AZLPointAveragePoints(CGPoint pointA, CGPoint pointB)
{
    CGPoint p;
    p.x = (pointA.x + pointB.x) * 0.5f;
    p.y = (pointA.y + pointB.y) * 0.5f;
    return p;
}

/**
 獲取點A到點B的矢量值
 */
static inline CGPoint
AZLPointDifferentialPointOfPoints(CGPoint pointA, CGPoint pointB)
{
    CGPoint p;
    p.x = pointB.x - pointA.x;
    p.y = pointB.y - pointA.y;
    return p;
}

/**
 計算矢量的標量長度
 */
static inline CGFloat
AZLPointHypotenuseOfPoint(CGPoint point)
{
    return (CGFloat)sqrt(point.x * point.x + point.y * point.y);
}

/**
 獲取兩點之間的距離
 */
static inline CGFloat
AZLPointDistanceBetweenPoints(CGPoint pointA, CGPoint pointB)
{
    return AZLPointHypotenuseOfPoint(AZLPointDifferentialPointOfPoints(pointA, pointB));
}

@interface AZLWeightPoint : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat weight;

+ (CGFloat)weightWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB;

@end

@interface UIBezierPath (AZLSignaturePath)

- (void)azl_addDotWithWeightedPoint:(AZLWeightPoint *)pointA;

- (void)azl_addLineWithPointA:(AZLWeightPoint*)pointA pointB:(AZLWeightPoint*)pointB;

- (void)azl_addQuadCurveWithWeightedPointA:(AZLWeightPoint *)pointA pointB:(AZLWeightPoint *)pointB pointC:(AZLWeightPoint *)pointC;

- (void)azl_addBezierCurveWithWeightedPointA:(AZLWeightPoint *)pointA pointB:(AZLWeightPoint *)pointB pointC:(AZLWeightPoint *)pointC pointD:(AZLWeightPoint *)pointD;

@end


/**
 A struct to represent a line between a start and end point
 */
typedef struct
{
    CGPoint startPoint;
    CGPoint endPoint;
} AZLLine;

/**
 A struct to represent a pair of UBLines
 */
typedef struct
{
    AZLLine firstLine;
    AZLLine secondLine;
} AZLLinePair;

@implementation UIBezierPath (AZLSignaturePath)

- (void)azl_addDotWithWeightedPoint:(AZLWeightPoint *)pointA
{
    [self moveToPoint:pointA.point];
    [self addArcWithCenter:pointA.point radius:pointA.weight startAngle:0 endAngle:(CGFloat)M_PI * 2.0 clockwise:YES];
}

- (void)azl_addLineWithPointA:(AZLWeightPoint *)pointA pointB:(AZLWeightPoint *)pointB{
    AZLLinePair linePair = [UIBezierPath _linesPerpendicularToLineWithWeightedPointA:pointA pointB:pointB];
    [self moveToPoint:linePair.firstLine.startPoint];
    [self addLineToPoint:linePair.secondLine.startPoint];
    [self addLineToPoint:linePair.secondLine.endPoint];
    [self addLineToPoint:linePair.firstLine.endPoint];
    [self closePath];
}

- (void)azl_addQuadCurveWithWeightedPointA:(AZLWeightPoint *)pointA pointB:(AZLWeightPoint *)pointB pointC:(AZLWeightPoint *)pointC
{
    AZLLinePair linePairAB = [self.class _linesPerpendicularToLineWithWeightedPointA:pointA pointB:pointB];
    AZLLinePair linePairBC = [self.class _linesPerpendicularToLineWithWeightedPointA:pointB pointB:pointC];
    AZLLine lineA = linePairAB.firstLine;
    AZLLine lineB = [self.class _averageLine:linePairAB.secondLine andLine:linePairBC.firstLine];
    AZLLine lineC = linePairBC.secondLine;
    
    [self moveToPoint:lineA.startPoint];
    [self addQuadCurveToPoint:lineC.startPoint controlPoint:lineB.startPoint];
    [self addLineToPoint:lineC.endPoint];
    [self addQuadCurveToPoint:lineA.endPoint controlPoint:lineB.endPoint];
    [self closePath];
}

- (void)azl_addBezierCurveWithWeightedPointA:(AZLWeightPoint *)pointA pointB:(AZLWeightPoint *)pointB pointC:(AZLWeightPoint *)pointC pointD:(AZLWeightPoint *)pointD
{
    AZLLinePair linePairAB = [self.class _linesPerpendicularToLineWithWeightedPointA:pointA pointB:pointB];
    AZLLinePair linePairBC = [self.class _linesPerpendicularToLineWithWeightedPointA:pointB pointB:pointC];
    AZLLinePair linePairCD = [self.class _linesPerpendicularToLineWithWeightedPointA:pointC pointB:pointD];
    
    AZLLine lineA = linePairAB.firstLine;
    AZLLine lineB = [self.class _averageLine:linePairAB.secondLine andLine:linePairBC.firstLine];
    AZLLine lineC = [self.class _averageLine:linePairBC.secondLine andLine:linePairCD.firstLine];
    AZLLine lineD = linePairCD.secondLine;
    
    [self moveToPoint:lineA.startPoint];
    [self addCurveToPoint:lineD.startPoint controlPoint1:lineB.startPoint controlPoint2:lineC.startPoint];
    [self addLineToPoint:lineD.endPoint];
    [self addCurveToPoint:lineA.endPoint controlPoint1:lineC.endPoint controlPoint2:lineB.endPoint];
    [self closePath];
}

#pragma mark - Private

+ (AZLLinePair)_linesPerpendicularToLineWithWeightedPointA:(AZLWeightPoint*)pointA pointB:(AZLWeightPoint*)pointB
{
    AZLLine line = (AZLLine){pointA.point, pointB.point};
    
    AZLLine linePerpendicularToPointA = [self.class _linePerpendicularToLine:line withMiddlePoint:pointA.point length:pointA.weight];
    AZLLine linePerpendicularToPointB = [self.class _linePerpendicularToLine:line withMiddlePoint:pointB.point length:pointB.weight];
    
    return (AZLLinePair){linePerpendicularToPointA, linePerpendicularToPointB};
}

+ (AZLLine)_linePerpendicularToLine:(AZLLine)line withMiddlePoint:(CGPoint)middlePoint length:(CGFloat)newLength
{
    // Calculate end point if line started at 0,0
    CGPoint relativeEndPoint = AZLPointDifferentialPointOfPoints(line.startPoint, line.endPoint);
    
    if (newLength == 0 || CGPointEqualToPoint(relativeEndPoint, CGPointZero)) {
        return (AZLLine){middlePoint, middlePoint};
    }
    
    // Modify line's length to be the length needed either side of the middle point
    CGFloat lengthEitherSideOfMiddlePoint = newLength / 2.0f;
    CGFloat originalLineLength = [self.class _lengthOfLine:line];
    CGFloat lengthModifier = lengthEitherSideOfMiddlePoint / originalLineLength;
    relativeEndPoint.x *= lengthModifier;
    relativeEndPoint.y *= lengthModifier;
    
    // Swap X/Y and invert one axis to get perpendicular line
    CGPoint perpendicularLineStartPoint = CGPointMake(relativeEndPoint.y, -relativeEndPoint.x);
    // Make other axis negative for perpendicular line in the opposite direction
    CGPoint perpendicularLineEndPoint = CGPointMake(-relativeEndPoint.y, relativeEndPoint.x);
    
    // Move perpendicular line to middle point
    perpendicularLineStartPoint.x += middlePoint.x;
    perpendicularLineStartPoint.y += middlePoint.y;
    
    perpendicularLineEndPoint.x += middlePoint.x;
    perpendicularLineEndPoint.y += middlePoint.y;
    
    return (AZLLine){perpendicularLineStartPoint, perpendicularLineEndPoint};
}

+ (AZLLine)_averageLine:(AZLLine)lineA andLine:(AZLLine)lineB
{
    return (AZLLine){AZLPointAveragePoints(lineA.startPoint, lineB.startPoint), AZLPointAveragePoints(lineA.endPoint, lineB.endPoint)};
}

+ (CGFloat)_lengthOfLine:(AZLLine)line
{
    return AZLPointDistanceBetweenPoints(line.startPoint, line.endPoint);
}

@end

@implementation AZLWeightPoint
+ (CGFloat)weightWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB{
    CGFloat length = AZLPointDistanceBetweenPoints(pointA, pointB);
    
    /**
     The is the maximum length that will vary weight. Anything higher will return the same weight.
     */
    static const CGFloat maxLengthRange = 50.0f;
    
    /*
     These are based on having a minimum line thickness of 2.0 and maximum of 7, linearly over line lengths 0-maxLengthRange. They fit into a typical linear equation: y = mx + c
     
     Note: Only the points of the two parallel bezier curves will be at least as thick as the constant. The bezier curves themselves could still be drawn with sharp angles, meaning there is no true 'minimum thickness' of the signature.
     */
    static const CGFloat gradient = 0.1f;
    static const CGFloat constant = 2.0f;
    
    CGFloat inversedLength = maxLengthRange - length;
    inversedLength = MAX(0, inversedLength);
    
    return (inversedLength * gradient) + constant;
}

@end

@interface AZLPathProviderPen ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIBezierPath *tmpPath;

@property (nonatomic, strong) AZLWeightPoint *point0;
@property (nonatomic, strong) AZLWeightPoint *point1;
@property (nonatomic, strong) AZLWeightPoint *point2;
@property (nonatomic, strong) AZLWeightPoint *point3;

@property (nonatomic, assign) NSInteger nextPointIndex;
@property (nonatomic, assign) CGFloat lineWeight;

@end

@implementation AZLPathProviderPen

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (void)setup{
    [self setLineWidth:3];
}

- (void)setLineWidth:(CGFloat)lineWidth{
    [super setLineWidth:1];
    self.lineWeight = lineWidth;
}

- (void)touchBeganWithPoint:(CGPoint)point{
    self.path = [[UIBezierPath alloc] init];
    self.tmpPath = [[UIBezierPath alloc] init];
    AZLWeightPoint *weightPoint = [[AZLWeightPoint alloc] init];
    weightPoint.point = point;
    weightPoint.weight = self.lineWeight;
    self.point0 = weightPoint;
    [self.tmpPath removeAllPoints];
    [self.tmpPath appendPath:self.path];
    [self.tmpPath azl_addDotWithWeightedPoint:self.point0];
    self.nextPointIndex = 1;
    
    if (self.delegate) {
        [self.delegate pathProvider:self didChangePath:self.tmpPath];
    }
}

- (void)touchMoveWithPoint:(CGPoint)point{
    
    AZLWeightPoint *previousPoint;
    if (self.nextPointIndex == 1) {
        previousPoint = self.point0;
    }else if (self.nextPointIndex == 2){
        previousPoint = self.point1;
    }else if (self.nextPointIndex == 3){
        previousPoint = self.point2;
    }else if (self.nextPointIndex == 4){
        previousPoint = self.point3;
    }
    
    //兩點間距離過少的時候不作處理
    if (AZLPointDistanceBetweenPoints(point, previousPoint.point) < 2) {
        return;
    }
    
    //分開4中情況，1，2，3，4個點的時候分別處理
    //只有四個點的時候為完整的，添加到path；其他的情況都為臨時線，添加到tmpPath
    if (self.nextPointIndex == 1){
        AZLWeightPoint *weightPoint = [[AZLWeightPoint alloc] init];
        weightPoint.point = point;
        weightPoint.weight = [AZLWeightPoint weightWithPointA:self.point0.point pointB:point];
        self.point1 = weightPoint;
        
        [self.tmpPath removeAllPoints];
        [self.tmpPath appendPath:self.path];
        [self.tmpPath azl_addLineWithPointA:self.point0 pointB:self.point1];
        
        self.nextPointIndex = 2;
    }else if (self.nextPointIndex == 2){
        AZLWeightPoint *weightPoint = [[AZLWeightPoint alloc] init];
        weightPoint.point = point;
        weightPoint.weight = [AZLWeightPoint weightWithPointA:self.point1.point pointB:point];
        self.point2 = weightPoint;
        
        [self.tmpPath removeAllPoints];
        [self.tmpPath appendPath:self.path];
        [self.tmpPath azl_addQuadCurveWithWeightedPointA:self.point0 pointB:self.point1 pointC:self.point2];
        
        self.nextPointIndex = 3;
        
    }else if (self.nextPointIndex == 3) {
        AZLWeightPoint *weightPoint = [[AZLWeightPoint alloc] init];
        weightPoint.point = point;
        weightPoint.weight = [AZLWeightPoint weightWithPointA:self.point2.point pointB:point];
        self.point3 = weightPoint;
        
        [self.tmpPath removeAllPoints];
        [self.tmpPath appendPath:self.path];
        [self.tmpPath azl_addBezierCurveWithWeightedPointA:self.point0 pointB:self.point1 pointC:self.point2 pointD:self.point3];
        
        self.nextPointIndex = 4;
    }else if (self.nextPointIndex == 4){
        //第四個點的時候，為完整的線，添加到path，然後重新計算pointIndex
        CGPoint point3 = AZLPointAveragePoints(self.point2.point, point);
        AZLWeightPoint *weightPoint = [[AZLWeightPoint alloc] init];
        weightPoint.point = point3;
        weightPoint.weight = [AZLWeightPoint weightWithPointA:self.point2.point pointB:point3];
        self.point3 = weightPoint;
        
        [self.path azl_addBezierCurveWithWeightedPointA:self.point0 pointB:self.point1 pointC:self.point2 pointD:self.point3];
        
        {
            self.point0 = self.point3;
            AZLWeightPoint *weightPoint = [[AZLWeightPoint alloc] init];
            weightPoint.point = point;
            weightPoint.weight = [AZLWeightPoint weightWithPointA:previousPoint.point pointB:point];
            self.point1 = weightPoint;
            self.nextPointIndex = 2;
            
            [self.tmpPath removeAllPoints];
            [self.tmpPath appendPath:self.path];
            [self.tmpPath azl_addLineWithPointA:self.point0 pointB:self.point1];
        }
    }
    
    [self.delegate pathProvider:self didChangePath:self.tmpPath];
}

- (void)touchEndWithPoint:(CGPoint)point{
    //鬆手的時候為完成這次畫線，把tmpPath的線路賦值到path里
    [self.path removeAllPoints];
    [self.path appendPath:self.tmpPath];
    self.nextPointIndex = 0;
    [self.delegate pathProvider:self didEndPath:self.path];
}

@end
