//
//  AZLDemoEditViewController.m
//  AZLPhotoBrowser_Example
//
//  Created by lizihong on 2020/12/10.
//  Copyright © 2020 azusalee. All rights reserved.
//

#import "AZLDemoEditViewController.h"

#import <AZLPhotoBrowser/AZLPhotoEditViewController.h>

@interface AZLDemoEditViewController ()

@property (nonatomic, strong) AZLPhotoBrowserModel *editModel;
@property (nonatomic, strong) UIImageView *editImageView;

@end

@implementation AZLDemoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageWidth = screenWidth/3;
    CGFloat x = 0;
    CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height;
    // 本地图片编辑
    {
        NSDictionary *dict = @{@"url":@"", @"w":@(600), @"h":@(901), @"imageName":@"image2"};
        
        AZLPhotoBrowserModel *model = [[AZLPhotoBrowserModel alloc] init];
        model.originUrlString = dict[@"url"];
        if (dict[@"imageName"]) {
            model.image = [UIImage imageNamed:dict[@"imageName"]];
        }
        model.width = [dict[@"w"] doubleValue];
        model.height = [dict[@"h"] doubleValue];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y+90, imageWidth, imageWidth*model.height/model.width)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 0;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editImageDidTap:)]];
        if (model.image) {
            imageView.image = model.image;
        }
        [self.view addSubview:imageView];
        
        model.fromRect = [self.view convertRect:imageView.frame toView:[UIApplication sharedApplication].keyWindow];
        
        self.editModel = model;
        self.editImageView = imageView;
    }
}


/// 点击编辑图片
- (void)editImageDidTap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        AZLPhotoEditViewController *controller = [[AZLPhotoEditViewController alloc] init];
        controller.photoModel = self.editModel;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:YES completion:nil];
        __weak typeof(self) weakself = self;
        [controller setBlock:^(AZLPhotoBrowserModel *photoModel) {
            if (photoModel.editImage) {
                weakself.editImageView.image = photoModel.editImage;
            }else{
                weakself.editImageView.image = photoModel.image;
            }
        }];
    }
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
