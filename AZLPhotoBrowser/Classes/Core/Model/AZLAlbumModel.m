//
//  AZLAlbumModel.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/20.
//

#import "AZLAlbumModel.h"

@interface AZLAlbumModel()

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation AZLAlbumModel

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.modelArray = [[NSMutableArray alloc] init];
}

- (void)addAssetModel:(AZLAlbumAssetModel *)assetModel{
    [self.modelArray addObject:assetModel];
}

- (NSArray<AZLAlbumAssetModel *> *)assetModelArray{
    return self.modelArray;
}

@end
