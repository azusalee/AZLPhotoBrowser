//
//  AZLPhotoBrowserManager.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import "AZLPhotoBrowserManager.h"

@implementation AZLPhotoBrowserManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id Instance;
    dispatch_once(&onceToken, ^{
        Instance = [[self alloc] init];
    });
    return Instance;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.theme = [[AZLPhotoBrowserTheme alloc] init];
}

@end
