//
//  AZLPhotoEditViewController.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import <UIKit/UIKit.h>
#import "AZLPhotoBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AZLPhotoEditCompleteBlock)(AZLPhotoBrowserModel *photoModel);

@interface AZLPhotoEditViewController : UIViewController

/// 需要处理的对象（注意：内部逻辑会直接处理传入的该对象）
@property (nonatomic, strong) AZLPhotoBrowserModel *photoModel;

@property (nonatomic, copy) AZLPhotoEditCompleteBlock block;

@end

NS_ASSUME_NONNULL_END
