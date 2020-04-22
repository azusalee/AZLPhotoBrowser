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

- (void)addPhotoModel:(AZLPhotoBrowserModel *)photoModel{
    [self.modelArray addObject:photoModel];
}

- (NSArray<AZLPhotoBrowserModel *> *)photoModelArray{
    return self.modelArray;
}

@end
