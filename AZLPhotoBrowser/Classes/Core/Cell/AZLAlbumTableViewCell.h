//
//  AZLAlbumTableViewCell.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZLAlbumTableViewCell : UITableViewCell

/// 图片
@property (nonatomic, strong) UIImageView *lastImageView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 分割线
@property (nonatomic, strong) UIView *sepLineView;

@end

NS_ASSUME_NONNULL_END
