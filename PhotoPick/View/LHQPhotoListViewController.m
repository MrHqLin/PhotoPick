//
//  PhotoListViewController.m
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/17.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "LHQPhotoListViewController.h"
#import "LHQPhotoViewController.h"
#import "LHQAblumTool.h"
#import "LHQPhotoTableViewCell.h"


@interface LHQPhotoListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView         *photoListView;
@property(nonatomic,strong) NSArray             *photoListArray;

@end

@implementation LHQPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"photoList";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.photoListArray = [[NSArray alloc]init];
    self.photoListArray = [[LHQAblumTool shareAblumTool] getPhotoAblumList];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [self.view addSubview: self.photoListView];

}


#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *photoListCell = @"photoListCell";
    LHQPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photoListCell];
    if (!cell) {
        cell = [[LHQPhotoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoListCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LHQAblumList *listInfo = self.photoListArray[indexPath.row];
    [[LHQAblumTool shareAblumTool] requestImageForAsset:listInfo.headImageAsset size:cell.imageView.frame.size resizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *image) {
        cell.photoImage.image = image;
        cell.titleLabel.text = listInfo.title;
    }];
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHQPhotoViewController *photoVc = [[LHQPhotoViewController alloc]init];
    LHQAblumList *listInfo = self.photoListArray[indexPath.row];
    photoVc.photoAssetCollection = listInfo.assetCollecttion;
    [self.navigationController pushViewController:photoVc animated:YES];
}

#pragma mark -- cancel
-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- lazy
- (UITableView *)photoListView
{
    if (!_photoListView) {
        _photoListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SelfView_W, SelfView_H-64) style:UITableViewStylePlain];
        _photoListView.rowHeight = 70;
        _photoListView.delegate = self;
        _photoListView.dataSource = self;
    }
    return _photoListView;
}

@end
