//
//  AZLViewController.m
//  AZLPhotoBrowser
//
//  Created by azusalee on 03/26/2020.
//  Copyright (c) 2020 azusalee. All rights reserved.
//

#import "AZLViewController.h"
#import <AZLPhotoBrowser/AZLPhotoBrowser.h>
#import <SDWebImage/SDWebImage.h>
#import <AZLExtend/AZLExtend.h>
#import <Photos/Photos.h>
#import <AZLPhotoBrowser/AZLAlbumViewController.h>

@interface AZLViewController ()

@property (nonnull, strong) NSMutableArray<UIImageView*> *imageViews;
@property (nonnull, strong) NSMutableArray<AZLPhotoBrowserModel*> *models;

@end

@implementation AZLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageWidth = screenWidth/3;
    self.imageViews = [[NSMutableArray alloc] init];
    NSArray *datas = @[
    @{@"url":@"https://b-ssl.duitang.com/uploads/item/201706/17/20170617202755_vasTA.thumb.700_0.jpeg", @"w":@(639), @"h":@(640)},
    @{@"url":@"https://a0.att.hudong.com/27/10/01300000324235124757108108752.jpg", @"w":@(800), @"h":@(600)},
    @{@"url":@"https://a3.att.hudong.com/13/41/01300000201800122190411861466.jpg", @"w":@(512), @"h":@(384)},
    ];
    NSMutableArray *models = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    for (NSDictionary *dict in datas) {
        AZLPhotoBrowserModel *model = [[AZLPhotoBrowserModel alloc] init];
        model.originUrlString = dict[@"url"];
        model.width = [dict[@"w"] doubleValue];
        model.height = [dict[@"h"] doubleValue];
        [models addObject:model];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageWidth, imageWidth*model.height/model.width)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = index;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidTap:)]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrlString]];
        [self.imageViews addObject:imageView];
        [self.view addSubview:imageView];
        
        model.fromRect = [self.view convertRect:imageView.frame toView:[UIApplication sharedApplication].keyWindow];
        x += imageView.width;
        if (x >= screenWidth) {
            x = 0;
            y += imageWidth+10;
        }
        ++index;
    }
    self.models = models;
    
    //[self setup];
}

- (void)imageDidTap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.models[gesture.view.tag] setPlaceholdImage:[self.imageViews[gesture.view.tag] image]];
        AZLPhotoBrowserViewController *controller = [[AZLPhotoBrowserViewController alloc] init];
        [controller showWithPhotoModels:self.models index:gesture.view.tag];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)albumDidTap:(id)sender {
    [AZLAlbumViewController showAlbum:^(NSArray<AZLPhotoBrowserModel *> * _Nonnull selectModels) {
        
    }];
}


@end
