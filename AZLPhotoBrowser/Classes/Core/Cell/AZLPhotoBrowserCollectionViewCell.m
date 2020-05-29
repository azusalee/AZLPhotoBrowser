//
//  AZLPhotoBroserCollectionViewCell.m
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import "AZLPhotoBrowserCollectionViewCell.h"

@interface AZLPhotoBrowserCollectionViewCell()

@end

@implementation AZLPhotoBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    __weak AZLPhotoBrowserCollectionViewCell *weakSelf = self;
    self.browserView = [[AZLPhotoBrowserView alloc] initWithFrame:self.contentView.bounds];
    self.browserView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // 单击事件
    [self.browserView setSingleTapBlock:^{
        [weakSelf.delegate azlPhotoBrowserCollectionViewCellDidTap:weakSelf];
    }];
    // 长按事件
    [self.browserView setLongPressBlock:^{
        [weakSelf.delegate azlPhotoBrowserCollectionViewCellDidLongPress:weakSelf];
    }];
    [self.contentView addSubview:self.browserView];
}

@end
