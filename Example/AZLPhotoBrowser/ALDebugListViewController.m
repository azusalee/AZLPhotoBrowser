//
//  ALDebugListViewController.m
//  tasker
//
//  Created by yangming on 2019/8/13.
//  Copyright © 2019 BT. All rights reserved.
//

#import "ALDebugListViewController.h"
#import "JumpVCModel.h"

@interface ALDebugListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ALDebugListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self setupData];
}


//設置數據
- (void)setupData{
    self.dataArray = [[NSMutableArray alloc] init];
    
    {
        JumpVCModel *model = [[JumpVCModel alloc] init];
        model.title = @"图片浏览";
        model.vcName = @"AZLDemoBrowserViewController";
        [self.dataArray addObject:model];
    }
    
    {
        JumpVCModel *model = [[JumpVCModel alloc] init];
        model.title = @"图片编辑";
        model.vcName = @"AZLDemoEditViewController";
        [self.dataArray addObject:model];
    }
    
    {
        JumpVCModel *model = [[JumpVCModel alloc] init];
        model.title = @"相册挑选";
        model.vcName = @"AZLDemoAlbumViewController";
        [self.dataArray addObject:model];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    JumpVCModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    JumpVCModel *model = self.dataArray[indexPath.row];
    if (model.viewController) {
        [self.navigationController pushViewController:model.viewController animated:YES];
    }else{
        id viewController = [[NSClassFromString(model.vcName) alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}



@end
