//
//  AZLDemoAlbumViewController.m
//  AZLPhotoBrowser_Example
//
//  Created by lizihong on 2020/12/10.
//  Copyright © 2020 azusalee. All rights reserved.
//

#import "AZLDemoAlbumViewController.h"

#import <AZLPhotoBrowser/AZLPhotoBrowser.h>


@interface AZLDemoAlbumViewController ()

@end

@implementation AZLDemoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)albumDidTap:(id)sender {
    // 打开相册挑选
    [AZLAlbumViewController showAlbum:^(NSArray<AZLAlbumResult *> * _Nonnull results) {
        NSLog(@"選擇了%ld張圖", results.count);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
