//
//  AZLPathProviderPen.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/24.
//

#import "AZLPathProviderBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface AZLPathProviderPen : AZLPathProviderBase

//設置lineWidth，並不會改變實際的linewidth值，而是改变lineWeight值
@property (nonatomic, assign) CGFloat lineWeight;

@end

NS_ASSUME_NONNULL_END
