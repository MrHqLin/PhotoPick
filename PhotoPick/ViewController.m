//
//  ViewController.m
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/16.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "ViewController.h"
#import "LHQAblumTool.h"
#import "LHQCollectionViewCell.h"
#import "PhotoViewController.h"
#import "PhotoListViewController.h"


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray   *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"momoda";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArr = [[NSMutableArray alloc]init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.itemSize = CGSizeMake(80, 80);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[LHQCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCell"];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    if (self.dataArr.count == indexPath.row) {
        cell.photoImage.image = [UIImage imageNamed:@"add_os"];
        cell.selectBtn.hidden = YES;
    }
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count == indexPath.row) {
        PhotoListViewController *photoVc = [[PhotoListViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:photoVc];
        
        //使用异步任务并行队列实现 模态推送和push同步
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self presentViewController:nav animated:YES completion:nil];
        }) ;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PhotoViewController *vc = [[PhotoViewController alloc]init];
            [photoVc.navigationController pushViewController:vc animated:YES];
        }) ;
    }
}



@end
