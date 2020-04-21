//
//  AZLAlbumTableViewCell.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZLAlbumTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *lastImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *sepLineView;

@end

NS_ASSUME_NONNULL_END
