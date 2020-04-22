//
//  AZLPhotoEditViewController.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import "AZLPhotoEditViewController.h"
#import "AZLPhotoBrowserView.h"
#import <SDWebImage/SDWebImage.h>
#import "AZLPhotoBrowserManager.h"

@interface AZLPhotoEditViewController ()

@property (nonatomic, strong) AZLPhotoBrowserView *browserView;

@property (nonatomic, strong) UIView *editTopView;
@property (nonatomic, strong) UIView *editBottomView;
@property (nonatomic, assign) BOOL isShowingEditUI;

@end

@implementation AZLPhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.browserView = [[AZLPhotoBrowserView alloc] initWithFrame:self.view.bounds];
    self.browserView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    __weak AZLPhotoEditViewController *weakSelf = self;
    [self.browserView setSingleTapBlock:^{
        if (weakSelf.isShowingEditUI) {
            [weakSelf hideEditUI];
        }else{
            [weakSelf showEditUI];
        }
    }];
    
    AZLPhotoBrowserModel *model = self.photoModel;
    [self.browserView setImageWidth:model.width height:model.height];
    
    if (model.image != nil) {
        self.browserView.imageView.image = model.image;
    }else if (model.imageData != nil || model.asset != nil) {
        self.browserView.imageView.image = model.placeholdImage;
        [model requestImage:^(UIImage * _Nullable image) {
            weakSelf.browserView.imageView.image = image;
        }];
    }else{
        [self.browserView.imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrlString] placeholderImage:model.placeholdImage];
    }
    
    [self.view addSubview:self.browserView];
    
    [self setupEditUI];
}


- (void)setupEditUI{
    //頭部
    CGFloat navBarHeight = 44;
    self.editTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, navBarHeight+[UIApplication sharedApplication].statusBarFrame.size.height)];
    self.editTopView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.editTopView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(5, self.editTopView.bounds.size.height-navBarHeight, 44, navBarHeight);
    cancelButton.tintColor = [UIColor whiteColor];
    [cancelButton setImage:[AZLPhotoBrowserManager sharedInstance].theme.backImage forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editTopView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(leftBarItemDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    //底部
    self.editBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64, [UIScreen mainScreen].bounds.size.width, 64)];
    self.editBottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.editBottomView];
    
}

- (void)showEditUI{
    self.editTopView.hidden = NO;
    self.editBottomView.hidden = NO;
    self.isShowingEditUI = YES;
}

- (void)hideEditUI{
    self.editTopView.hidden = YES;
    self.editBottomView.hidden = YES;
    self.isShowingEditUI = NO;
}

- (void)leftBarItemDidTap:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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
