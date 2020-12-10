//
//  AZLDemoBrowserViewController.m
//  AZLPhotoBrowser_Example
//
//  Created by lizihong on 2020/12/10.
//  Copyright © 2020 azusalee. All rights reserved.
//

#import "AZLDemoBrowserViewController.h"
#import <SDWebImage/SDWebImage.h>

#import <AZLPhotoBrowser/AZLPhotoBrowser.h>
#import <AZLExtend/AZLExtend.h>

@interface AZLDemoBrowserViewController ()

@property (nonatomic, strong) NSMutableArray<UIImageView*> *imageViews;
@property (nonatomic, strong) NSMutableArray<AZLPhotoBrowserModel*> *models;

@end

@implementation AZLDemoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 网络图片浏览
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageWidth = screenWidth/3;
    self.imageViews = [[NSMutableArray alloc] init];
    NSArray *datas = @[
    @{@"url":@"https://b-ssl.duitang.com/uploads/item/201706/17/20170617202755_vasTA.thumb.700_0.jpeg", @"w":@(639), @"h":@(640)},
    @{@"url":@"https://a3.att.hudong.com/13/41/01300000201800122190411861466.jpg", @"w":@(512), @"h":@(384)},
    @{@"url":@"http://img5.imgtn.bdimg.com/it/u=2444540448,3036722547&fm=26&gp=0.jpg", @"w":@(704), @"h":@(1000), @"imageName":@"image1"},
    @{@"url":@"http://hbimg.b0.upaiyun.com/357d23d074c2954d568d1a6f86a5be09d190a45116e95-0jh9Pg_fw658", @"w":@(658), @"h":@(494)}
    ];
    NSMutableArray *models = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    CGFloat x = 0;
    CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height+60;
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
}

/// 点击浏览图片
- (void)imageDidTap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.models[gesture.view.tag] setPlaceholdImage:[self.imageViews[gesture.view.tag] image]];
        [AZLPhotoBrowserViewController showWithPhotoModels:self.models index:gesture.view.tag];
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
