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

- (void)albumAssetCollectionViewCell:(AZLAlbumAssetCollectionViewCell*)cell didSelectAtIndex:(NSInteger)index;

@end

@interface AZLAlbumAssetCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *extLabel;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<AZLAlbumAssetCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
