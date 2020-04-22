//
//  AZLAlbumViewController.m
//  AZLExtend
//
//  Created by lizihong on 2020/4/20.
//

#import "AZLAlbumViewController.h"
#import <Photos/Photos.h>
#import "AZLAlbumModel.h"
#import "AZLAlbumAssetCollectionViewCell.h"
#import "AZLAlbumTableViewCell.h"
#import <AZLExtend/AZLExtend.h>
#import "AZLPhotoBrowserEditViewController.h"
#import "AZLPhotoBrowserManager.h"

@interface AZLAlbumViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, AZLAlbumAssetCollectionViewCellDelegate>

@property (nonatomic, strong) NSMutableArray<AZLAlbumModel*> *albumArray;
@property (nonatomic, strong) NSMutableArray<AZLPhotoBrowserModel*> *selectPhotoArray;
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, assign) NSInteger selectAlbumIndex;

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, strong) UIView *customNavView;

@property (nonatomic, strong) UITableView *albumTableView;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *bottomDoneButton;

@end

@implementation AZLAlbumViewController

+ (void)showAlbum:(AZLAlbumCompleteBlock)completeBlock {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                
                AZLAlbumViewController *albumController = [[AZLAlbumViewController alloc] init];
                albumController.completeBlock = completeBlock;
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:albumController];
                navVC.navigationBarHidden = YES;
                navVC.modalPresentationStyle = UIModalPresentationFullScreen;
                navVC.navigationBar.tintColor = [UIColor blackColor];
                [navVC azl_presentSelf];
                
            }else{
                UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"访问相册" message:@"您还没有打开相册权限" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                }];
                
                [alertViewController addAction:action1];
                [alertViewController addAction:action2];
                
                [alertViewController azl_presentSelf];
            }
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.colCount == 0) {
        self.colCount = 4;
    }
    if (self.maxCount == 0) {
        self.maxCount = 9;
    }
    [self setup];
    [self setupUI];
    [self setupNavView];
    [self setupBottomView];
}

- (void)setup{
    self.selectPhotoArray = [[NSMutableArray alloc] init];
    self.albumArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *assetDict = [[NSMutableDictionary alloc] init];
    //PHFetchOptions *option = nil;
    // 全部圖
    AZLAlbumModel *allAlbumModel = [[AZLAlbumModel alloc] init];
    allAlbumModel.title = @"全部";
    PHFetchResult<PHAssetCollection *> *allResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    for (PHAssetCollection *collection in allResult) {
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        for (PHAsset *asset in assets) {
            if (asset.mediaType == PHAssetMediaTypeImage) {
                // 只處理圖片類型
                AZLPhotoBrowserModel *photoModel = [[AZLPhotoBrowserModel alloc] init];
                photoModel.asset = asset;
                photoModel.width = asset.pixelWidth/[UIScreen mainScreen].scale;
                photoModel.height = asset.pixelHeight/[UIScreen mainScreen].scale;
                [allAlbumModel addPhotoModel:photoModel];
                assetDict[asset.localIdentifier] = photoModel;
            }
        }
    }
    [self.albumArray addObject:allAlbumModel];
    
    if (@available(iOS 11, *)) {
        AZLAlbumModel *animateAlbumModel = [[AZLAlbumModel alloc] init];
        animateAlbumModel.title = @"動圖";
        // 動圖
        PHFetchResult<PHAssetCollection *> *animateResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumAnimated options:nil];
        for (PHAssetCollection *collection in animateResult) {
            PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            for (PHAsset *asset in assets) {
                if (assetDict[asset.localIdentifier] != nil) {
                    AZLPhotoBrowserModel *photoModel = assetDict[asset.localIdentifier];
                    photoModel.isAnimate = YES;
                    [animateAlbumModel addPhotoModel:photoModel];
                }
            }
        }
        [self.albumArray addObject:animateAlbumModel];
    } else {
        // Fallback on earlier versions
    }
}

- (void)setupNavView{
    CGFloat navBarHeight = 44;
    self.customNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, navBarHeight+[UIApplication sharedApplication].statusBarFrame.size.height)];
    self.customNavView.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.barBackgroundColor;
    
    [self.view addSubview:self.customNavView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.tintColor = [AZLPhotoBrowserManager sharedInstance].theme.barTintColor;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelButton sizeToFit];
    cancelButton.frame = CGRectMake(15, self.customNavView.bounds.size.height-44, cancelButton.width, 44);
    
    [cancelButton setTitleColor:[AZLPhotoBrowserManager sharedInstance].theme.barTintColor forState:UIControlStateNormal];
    [self.customNavView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(leftBarItemDidTap:) forControlEvents:UIControlEventTouchUpInside];
//    self.title = @"相冊";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemDidTap:)];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(80, cancelButton.frame.origin.y, [UIScreen mainScreen].bounds.size.width-160, 44)];
    [self.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewDidTap:)]];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:self.titleView.bounds];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [AZLPhotoBrowserManager sharedInstance].theme.barTintColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.titleView addSubview:self.titleLabel];
    
    [self.customNavView addSubview:self.titleView];
    [self updateTitle];
}

- (void)setupBottomView{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64, [UIScreen mainScreen].bounds.size.width, 64)];
    self.bottomView.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.barBackgroundColor;
    [self.view addSubview:self.bottomView];
    
    self.bottomDoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.bottomDoneButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-95, 12, 80, 40);
    [self.bottomDoneButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.bottomDoneButton setTitleColor:[AZLPhotoBrowserManager sharedInstance].theme.enableTextColor forState:UIControlStateNormal];
    self.bottomDoneButton.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.enableBackgroundColor;
    [self.bottomDoneButton addTarget:self action:@selector(doneDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.bottomDoneButton];
    [self updateDoneButton];
}

- (void)setupUI{
    self.view.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.backgroundColor;
    CGFloat bottomViewHeight = 64;
    CGFloat navViewHeight = 44+[UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width-self.colCount+1)/self.colCount;
    self.cellWidth = cellWidth;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
    self.photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, navViewHeight, self.view.bounds.size.width, self.view.bounds.size.height-navViewHeight-bottomViewHeight) collectionViewLayout:layout];
    self.photoCollectionView.contentInset = UIEdgeInsetsZero;
    self.photoCollectionView.backgroundColor = [UIColor clearColor];
    self.photoCollectionView.showsVerticalScrollIndicator = NO;
    self.photoCollectionView.showsHorizontalScrollIndicator = NO;
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.photoCollectionView registerClass:[AZLAlbumAssetCollectionViewCell class] forCellWithReuseIdentifier:@"AZLAlbumAssetCollectionViewCell"];
    [self.view addSubview:self.photoCollectionView];
    
    
    self.albumTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navViewHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-navViewHeight-bottomViewHeight) style:UITableViewStylePlain];
    self.albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.albumTableView.delegate = self;
    self.albumTableView.dataSource = self;
    self.albumTableView.hidden = YES;
    self.albumTableView.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.backgroundColor;
    [self.albumTableView registerClass:[AZLAlbumTableViewCell class] forCellReuseIdentifier:@"AZLAlbumTableViewCell"];
    [self.view addSubview:self.albumTableView];
    
}

- (void)leftBarItemDidTap:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneDidTap:(id)sender{
    if (self.completeBlock) {
        NSInteger selectCount = self.selectPhotoArray.count;
        __block NSInteger processCount = 0;
        NSArray *selectArray = self.selectPhotoArray.copy;
        __weak AZLAlbumViewController *weakSelf = self;
        for (AZLPhotoBrowserModel *selectModel in selectArray) {
            [selectModel requestImageData:^(NSData * _Nullable imageData) {
                processCount += 1;
                if (selectCount == processCount) {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    [weakSelf doneWithSelectArray:selectArray];
                }
            }];
        } 
    }
}

- (void)doneWithSelectArray:(NSArray<AZLPhotoBrowserModel*>*)selectArray {
    if (self.completeBlock) {
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        for (AZLPhotoBrowserModel *photoModel in selectArray) {
            AZLAlbumResult *result = [[AZLAlbumResult alloc] init];
            result.width = photoModel.width;
            result.height = photoModel.height;
            result.isAnimate = photoModel.isAnimate;
            result.imageData = photoModel.imageData;
            [resultArray addObject:result];
        }
        self.completeBlock(resultArray);
    }
}

- (void)titleViewDidTap:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.albumTableView.isHidden == YES) {
            [self showAlbumTableView];
        }else{
            [self hideAlbumTableView];
        }
    }
}

- (void)showAlbumTableView{
    self.albumTableView.bottom = self.customNavView.bottom;
    self.albumTableView.hidden = NO;
    [UIView animateWithDuration:0.275 animations:^{
        self.albumTableView.top = self.customNavView.bottom;
    }];
}

- (void)hideAlbumTableView{
    [UIView animateWithDuration:0.275 animations:^{
        self.albumTableView.bottom = self.customNavView.bottom;
    } completion:^(BOOL finished) {
        self.albumTableView.hidden = YES;
    }];
}

- (void)updateTitle{
    AZLAlbumModel *albumModel = self.albumArray[self.selectAlbumIndex];
    self.titleLabel.text = albumModel.title;
}

- (void)updateDoneButton{
    if (self.selectPhotoArray.count > 0) {
        [self.bottomDoneButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.bottomDoneButton setTitleColor:[AZLPhotoBrowserManager sharedInstance].theme.enableTextColor forState:UIControlStateNormal];
        self.bottomDoneButton.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.enableBackgroundColor;
        self.bottomDoneButton.enabled = YES;
    }else{
        [self.bottomDoneButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.bottomDoneButton setTitleColor:[AZLPhotoBrowserManager sharedInstance].theme.disableTextColor forState:UIControlStateNormal];
        self.bottomDoneButton.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.disableBackgroundColor;
        self.bottomDoneButton.enabled = NO;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    AZLAlbumModel *albumModel = self.albumArray[self.selectAlbumIndex];
    return albumModel.photoModelArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AZLAlbumAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AZLAlbumAssetCollectionViewCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.delegate = self;
    AZLAlbumModel *albumModel = self.albumArray[self.selectAlbumIndex];
    AZLPhotoBrowserModel *photoModel = albumModel.photoModelArray[indexPath.row];
    if (photoModel.isAnimate) {
        cell.extLabel.text = @"GIF";
        cell.extLabel.hidden = NO;
    }else{
        cell.extLabel.hidden = YES;
    }
    if ([self.selectPhotoArray containsObject:photoModel]) {
        NSUInteger selectIndex = [self.selectPhotoArray indexOfObject:photoModel]+1;
        cell.selectButton.backgroundColor = [AZLPhotoBrowserManager sharedInstance].theme.enableBackgroundColor;
        [cell.selectButton setTitle:[NSString stringWithFormat:@"%ld", selectIndex] forState:UIControlStateNormal];
        cell.selectButton.layer.borderColor = nil;
        cell.selectButton.layer.borderWidth = 0;
    }else{
        cell.selectButton.backgroundColor = [UIColor clearColor];
        [cell.selectButton setTitle:@"" forState:UIControlStateNormal];
        cell.selectButton.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.selectButton.layer.borderWidth = 1;
    }
    
    __weak AZLAlbumAssetCollectionViewCell *weakCell = cell;
    [[PHImageManager defaultManager] requestImageForAsset:photoModel.asset targetSize:CGSizeMake(self.cellWidth, self.cellWidth) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakCell.imageView.image = result;
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    AZLAlbumModel *albumModel = self.albumArray[self.selectAlbumIndex];
    AZLPhotoBrowserModel *photoModel = albumModel.photoModelArray[indexPath.row];
    if (self.selectPhotoArray.count == self.maxCount && [self.selectPhotoArray containsObject:photoModel] == false) {
        // 選擇到達最大數量且所點圖片不是選擇的圖，不處理
        return;
    }
    
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    NSMutableArray *selectPhotoArray = [[NSMutableArray alloc] init];
    [photoArray addObjectsFromArray:self.selectPhotoArray];
    [selectPhotoArray addObjectsFromArray:self.selectPhotoArray];
    NSInteger showIndex = 0;
    if ([self.selectPhotoArray containsObject:photoModel] == false) {
        [photoArray addObject:photoModel];
        showIndex = photoArray.count-1;
    }else{
        showIndex = [self.selectPhotoArray indexOfObject:photoModel];
    }
    AZLPhotoBrowserEditViewController *controller = [[AZLPhotoBrowserEditViewController alloc] init];
    [controller addPhotoModels:photoArray];
    [controller addSelectPhotoModels:selectPhotoArray];
    controller.showingIndex = showIndex;
    __weak AZLAlbumViewController *weakSelf = self;
    [controller setCompleteBlock:^(NSArray<AZLPhotoBrowserModel *> * _Nonnull selectModels) {
        [weakSelf.selectPhotoArray removeAllObjects];
        for (AZLPhotoBrowserModel *selectPhotoModel in selectModels) {
            [weakSelf.selectPhotoArray addObject:selectPhotoModel];
        }
        [weakSelf.photoCollectionView reloadData];
        [weakSelf updateDoneButton];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AZLAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AZLAlbumTableViewCell"];
    AZLAlbumModel *albumModel = self.albumArray[indexPath.row];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ (%ld)", albumModel.title, albumModel.photoModelArray.count];
    if (albumModel.photoModelArray.count > 0) {
        AZLPhotoBrowserModel *photoModel = [albumModel.photoModelArray lastObject];
        __weak AZLAlbumTableViewCell *weakCell = cell;
        [[PHImageManager defaultManager] requestImageForAsset:photoModel.asset targetSize:CGSizeMake(64, 64) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakCell.lastImageView.image = result;
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectAlbumIndex = indexPath.row;
    [self hideAlbumTableView];
    [self updateTitle];
    [self.photoCollectionView reloadData];
}

- (void)albumAssetCollectionViewCell:(AZLAlbumAssetCollectionViewCell *)cell didSelectAtIndex:(NSInteger)index{
    AZLAlbumModel *albumModel = self.albumArray[self.selectAlbumIndex];
    AZLPhotoBrowserModel *photoModel = albumModel.photoModelArray[index];
    if ([self.selectPhotoArray containsObject:photoModel]) {
        [self.selectPhotoArray removeObject:photoModel];
        cell.selectButton.backgroundColor = [UIColor clearColor];
        [cell.selectButton setTitle:@"" forState:UIControlStateNormal];
        cell.selectButton.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.selectButton.layer.borderWidth = 1;
    }else{
        if (self.selectPhotoArray.count == self.maxCount) {
            // 大於最大選擇數
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"你最多只能選擇%ld張照片", self.maxCount] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            }];
            [alertViewController addAction:action2];
            
            [self presentViewController:alertViewController animated:YES completion:nil];
            return;
        }
        [self.selectPhotoArray addObject:photoModel];
        
        NSUInteger selectIndex = self.selectPhotoArray.count;
        cell.selectButton.backgroundColor = [UIColor greenColor];
        [cell.selectButton setTitle:[NSString stringWithFormat:@"%ld", selectIndex] forState:UIControlStateNormal];
        cell.selectButton.layer.borderColor = nil;
        cell.selectButton.layer.borderWidth = 0;
    }
    [self updateDoneButton];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    AZLAlbumModel *album = self.albumArray[0];
    for (AZLPhotoBrowserModel *photoModel in album.photoModelArray) {
        photoModel.image = nil;
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
