//
//  AZLPhotoBrowserEditViewController.m
//  AZLPhotoBrowser
//
//  Created by lizihong on 2020/4/22.
//

#import "AZLPhotoBrowserEditViewController.h"
#import "AZLPhotoBrowserCollectionViewCell.h"
#import "AZLPhotoBrowserManager.h"
#import "AZLPhotoEditViewController.h"

@interface AZLPhotoBrowserEditViewController ()

@property (nonatomic, strong) UIView *editTopView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIView *editBottomView;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, assign) BOOL isShowingEditUI;
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation AZLPhotoBrowserEditViewController

- (instancetype)init{
    if (self = [super init]) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupEditUI];
    [self updateCurrentPhotoUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showEditUI];
    [self.photoCollectionView reloadData];
}

- (void)addSelectPhotoModels:(NSArray<AZLPhotoBrowserModel*> *)photoArray{
    [self.selectArray addObjectsFromArray:photoArray];
}

- (void)setupEditUI{
    //頭部
    CGFloat navBarHeight = 44;
    self.editTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, navBarHeight+[UIApplication sharedApplication].statusBarFrame.size.height)];
    self.editTopView.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.barBackgroundColor;
    
    [self.view addSubview:self.editTopView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(5, self.editTopView.bounds.size.height-navBarHeight, 44, navBarHeight);
    cancelButton.tintColor = [AZLPhotoBrowserManager sharedInstance].theme.barTintColor;
    [cancelButton setImage:[AZLPhotoBrowserManager sharedInstance].theme.backImage forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:[AZLPhotoBrowserManager sharedInstance].theme.barTintColor forState:UIControlStateNormal];
    [self.editTopView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(leftBarItemDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.editTopView.bounds.size.width-39, self.editTopView.bounds.size.height-navBarHeight+10, 24, 24)];
    self.selectButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.selectButton setTitleColor:[AZLPhotoBrowserManager sharedInstance].theme.enableTextColor forState:UIControlStateNormal];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.selectButton.layer.cornerRadius = 12;
    [self.selectButton addTarget:self action:@selector(selectButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.editTopView addSubview:self.selectButton];
    
    
    //底部
    self.editBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64, [UIScreen mainScreen].bounds.size.width, 64)];
    self.editBottomView.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.barBackgroundColor;
    [self.view addSubview:self.editBottomView];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.editButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.editButton setTitle:@"編輯" forState:UIControlStateNormal];
    [self.editButton sizeToFit];
    self.editButton.frame = CGRectMake(15, 12, self.editButton.bounds.size.width, 40);
    
    [self.editButton setTitleColor:[AZLPhotoBrowserManager sharedInstance].theme.barTintColor forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.editBottomView addSubview:self.editButton];
    
    [self hideEditUI];
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
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.completeBlock) {
        self.completeBlock(self.selectArray.copy);
    }
}

- (void)selectButtonDidTap:(id)sender {
    AZLPhotoBrowserModel *model = [self getCurrentPhotoModel];
    if ([self.selectArray containsObject:model]) {
        [self.selectArray removeObject:model];
    }else{
        [self.selectArray addObject:model];
    }
    [self updateCurrentPhotoUI];
}

- (void)editDidTap:(id)sender {
    AZLPhotoBrowserModel *model = [self getCurrentPhotoModel];
    
    AZLPhotoEditViewController *controller = [[AZLPhotoEditViewController alloc] init];
    controller.photoModel = model;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:NO completion:nil];
}

- (void)updateCurrentPhotoUI{
    AZLPhotoBrowserModel *model = [self getCurrentPhotoModel];
    if (model.isAnimate) {
        // 動圖不讓編輯(暫時先這樣)
        self.editButton.hidden = YES;
    }else{
        self.editButton.hidden = NO;
    }
    if ([self.selectArray containsObject:model]) {
        NSUInteger selectIndex = [self.selectArray indexOfObject:model]+1;
        self.selectButton.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.enableBackgroundColor;
        [self.selectButton setTitle:[NSString stringWithFormat:@"%ld", selectIndex] forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = nil;
        self.selectButton.layer.borderWidth = 0;
    }else{
        self.selectButton.backgroundColor = [UIColor clearColor];
        [self.selectButton setTitle:@"" forState:UIControlStateNormal];
        self.selectButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.selectButton.layer.borderWidth = 1;
    }
}

- (void)showingIndexDidChange{
    [self updateCurrentPhotoUI];
}

- (void)azlPhotoBrowserCollectionViewCellDidTap:(AZLPhotoBrowserCollectionViewCell *)cell{
    if (self.isShowingEditUI) {
        [self hideEditUI];
    }else{
        [self showEditUI];
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
