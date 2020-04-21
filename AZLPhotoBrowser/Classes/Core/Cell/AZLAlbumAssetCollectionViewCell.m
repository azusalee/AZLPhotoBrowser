//
//  AZLAlbumAssetCollectionViewCell.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/20.
//

#import "AZLAlbumAssetCollectionViewCell.h"

@implementation AZLAlbumAssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    
    self.extLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, 40, 20)];
    self.extLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.extLabel.textAlignment = NSTextAlignmentCenter;
    self.extLabel.textColor = [UIColor whiteColor];
    self.extLabel.font = [UIFont systemFontOfSize:12];
    self.extLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:self.extLabel];
    
    self.selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-30, 10, 20, 20)];
    self.selectButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.selectButton.layer.cornerRadius = 10;
    [self.selectButton addTarget:self action:@selector(selectButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectButton];
}

- (void)selectButtonDidTap:(UIButton*)button {
    [self.delegate albumAssetCollectionViewCell:self didSelectAtIndex:self.index];
}

@end
