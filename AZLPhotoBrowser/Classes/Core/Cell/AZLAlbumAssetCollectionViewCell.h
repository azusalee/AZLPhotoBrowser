//
//  AZLAlbumAssetCollectionViewCell.h
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AZLAlbumAssetCollectionViewCell;
@protocol AZLAlbumAssetCollectionViewCellDelegate <NSObject>

/// 选择按钮点击事件(取消选择和选择)
- (void)albumAssetCollectionViewCell:(AZLAlbumAssetCollectionViewCell*)cell didSelectAtIndex:(NSInteger)index;

@end

@interface AZLAlbumAssetCollectionViewCell : UICollectionViewCell

/// 图片
@property (nonatomic, strong) UIImageView *imageView;
/// 蒙版view
@property (nonatomic, strong) UIView *coverView;
/// 类型label
@property (nonatomic, strong) UILabel *extLabel;
/// 选择的按钮
@property (nonatomic, strong) UIButton *selectButton;
/// 所在的index
@property (nonatomic, assign) NSInteger index;
/// 代理
@property (nonatomic, weak) id<AZLAlbumAssetCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
