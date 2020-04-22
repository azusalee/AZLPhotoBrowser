//
//  AZLPhotoBrowserTheme.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import "AZLPhotoBrowserTheme.h"

@implementation AZLPhotoBrowserTheme

- (instancetype)init{
    if (self = [super init]) {
        _barBackgroundColor = [UIColor blackColor];
        _barTintColor = [UIColor whiteColor];
        
        _enableBackgroundColor = [UIColor greenColor];
        _enableTextColor = [UIColor whiteColor];
        _disableBackgroundColor = [UIColor lightGrayColor];
        _disableTextColor = [UIColor whiteColor];
        
        _sepLineColor = [UIColor lightGrayColor];
        
        _backgroundColor = [UIColor darkGrayColor];
        _textColor = [UIColor whiteColor];
    }
    return self;
}

@end
