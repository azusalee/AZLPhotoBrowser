//
//  AZLViewController.m
//  AZLPhotoBrowser
//
//  Created by azusalee on 03/26/2020.
//  Copyright (c) 2020 azusalee. All rights reserved.
//

#import "AZLViewController.h"
#import <SDWebImage/SDWebImage.h>

#import <AZLPhotoBrowser/AZLPhotoBrowser.h>
#import <AZLExtend/AZLExtend.h>
#import <Photos/Photos.h>
#import <AZLPhotoBrowser/AZLAlbumViewController.h>
#import <AZLPhotoBrowser/AZLPhotoEditViewController.h>

@interface AZLViewController ()

@property (nonatomic, strong) NSMutableArray<UIImageView*> *imageViews;
@property (nonatomic, strong) NSMutableArray<AZLPhotoBrowserModel*> *models;

@property (nonatomic, strong) AZLPhotoBrowserModel *editModel;
@property (nonatomic, strong) UIImageView *editImageView;

@end

@implementation AZLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIImage *image = [UIImage imageNamed:@"undo"];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    NSString *imageString = [imageData base64EncodedStringWithOptions:0];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageWidth = screenWidth/3;
    self.imageViews = [[NSMutableArray alloc] init];
    NSArray *datas = @[
    @{@"url":@"https://b-ssl.duitang.com/uploads/item/201706/17/20170617202755_vasTA.thumb.700_0.jpeg", @"w":@(639), @"h":@(640)},
    @{@"url":@"https://a0.att.hudong.com/27/10/01300000324235124757108108752.jpg", @"w":@(800), @"h":@(600)},
    @{@"url":@"https://a3.att.hudong.com/13/41/01300000201800122190411861466.jpg", @"w":@(512), @"h":@(384)},
    @{@"url":@"http://img5.imgtn.bdimg.com/it/u=2444540448,3036722547&fm=26&gp=0.jpg", @"w":@(704), @"h":@(1000), @"imageName":@"image1"},
    @{@"url":@"http://hbimg.b0.upaiyun.com/357d23d074c2954d568d1a6f86a5be09d190a45116e95-0jh9Pg_fw658", @"w":@(658), @"h":@(494)}
    ];
    NSMutableArray *models = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    CGFloat x = 0;
    CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height;
    for (NSDictionary *dict in datas) {
        AZLPhotoBrowserModel *model = [[AZLPhotoBrowserModel alloc] init];
        model.originUrlString = dict[@"url"];
        if (dict[@"imageName"]) {
            model.image = [UIImage imageNamed:dict[@"imageName"]];
        }
        model.width = [dict[@"w"] doubleValue];
        model.height = [dict[@"h"] doubleValue];
        [models addObject:model];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageWidth, imageWidth*model.height/model.width)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = index;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidTap:)]];
        if (model.image) {
            imageView.image = model.image;
        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrlString]];
        }
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
        imageView.tag = index;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editImageDidTap:)]];
        if (model.image) {
            imageView.image = model.image;
        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrlString]];
        }
        [self.view addSubview:imageView];
        
        model.fromRect = [self.view convertRect:imageView.frame toView:[UIApplication sharedApplication].keyWindow];
        
        self.editModel = model;
        self.editImageView = imageView;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)imageDidTap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.models[gesture.view.tag] setPlaceholdImage:[self.imageViews[gesture.view.tag] image]];
        [AZLPhotoBrowserViewController showWithPhotoModels:self.models index:gesture.view.tag];
    }
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)albumDidTap:(id)sender {
    [AZLAlbumViewController showAlbum:^(NSArray<AZLAlbumResult *> * _Nonnull results) {
        NSLog(@"選擇了%ld張圖", results.count);
    }];
}


@end
