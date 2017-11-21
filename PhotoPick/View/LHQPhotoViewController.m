//
//  PhotoViewController.m
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/17.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "LHQPhotoViewController.h"
#import "LHQAblumTool.h"
#import "LHQCollectionViewCell.h"
#import "LHQPhotoListViewController.h"
#import "LHQPreviewViewController.h"


@interface LHQPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView                 *photosCollection;
@property(nonatomic,strong)NSArray                          *dataArray;
@property(nonatomic,strong)NSMutableArray                   *selectPhotosArray;
@property(nonatomic,strong)NSMutableArray                   *selectCellArray;
@property(nonatomic,strong)UIView                           *bottomView;
@property(nonatomic,strong)UIButton                         *completeBtn;
@property(nonatomic,strong)UIButton                         *showPhotoBtn;

@property(nonatomic,strong)MWPhotoBrowser                   *browser;
@property(nonatomic,strong)NSMutableArray                   *thumbs;
@property(nonatomic,strong)NSMutableArray                   *selections;

@end

static NSString *photoCell = @"photosCell_view";
@implementation LHQPhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"photos";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //数据源
    self.selectCellArray = [[NSMutableArray alloc]init];
    self.selectPhotosArray = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
    if (self.photoAssetCollection) {
        self.dataArray = [[LHQAblumTool shareAblumTool] getAssetsInAssetCollection:self.photoAssetCollection ascending:YES];
    }else{
        self.dataArray = [[LHQAblumTool shareAblumTool] getAllAssetInPhotoAblumWithAscending:YES];
    }
//    NSLog(@"data %@",self.dataArray);
    
    //控件
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(cleanSelect)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SelfView_W-50)/4, (SelfView_W-50)/4);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.photosCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-40) collectionViewLayout:layout];
    self.photosCollection.backgroundColor = [UIColor whiteColor];
    self.photosCollection.delegate = self;
    self.photosCollection.dataSource = self;
    self.photosCollection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.photosCollection];
    [self.photosCollection registerClass:[LHQCollectionViewCell class] forCellWithReuseIdentifier:photoCell];
    
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    [self.bottomView addSubview:self.showPhotoBtn];
    [self.showPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView.mas_left).offset(10);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
    }];
    [self.bottomView addSubview:self.completeBtn];
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
    }];
    
}



#pragma mark -- 清除所选
-(void)cleanSelect
{
    if (self.selectCellArray.count && self.selectPhotosArray.count) {
        for (NSInteger index = 0; index < self.selectCellArray.count; index ++) {
            LHQCollectionViewCell *cell = (LHQCollectionViewCell *)[self.photosCollection cellForItemAtIndexPath:self.selectCellArray[index]];
            cell.selectBtn.selected = NO;
        }
    }
    [self.completeBtn setTitle:@"完成(0)" forState:UIControlStateNormal];
    [self.selectPhotosArray removeAllObjects];
}
#pragma mark -- 完成
-(void)completeTap:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 展示
-(void)showPhotoTap:(UIButton *)sender
{
    
}
#pragma mark -- back
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCell forIndexPath:indexPath];
    PHAsset *asset = self.dataArray[indexPath.row];
    [[LHQAblumTool shareAblumTool] requestImageForAsset:asset
                                                   size:CGSizeMake((SelfView_W-50)/4, (SelfView_W-50)/4)
                                             resizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *image) {
        cell.photoImage.image = image;
    }];
    __weak typeof(self) weakSelf = self;
    //点击cell中的button 获取对应的cell
    cell.selectBlock = ^(UIButton *btn) {
        btn.selected = !btn.selected;
        LHQCollectionViewCell *cell = (LHQCollectionViewCell *)[[btn superview] superview];
        NSIndexPath *path = [weakSelf.photosCollection indexPathForCell:cell];
        PHAsset *asset = self.dataArray[path.row];
        if (btn.selected == YES) {
            [weakSelf shakeToShow:btn];
            [weakSelf.selectPhotosArray addObject:asset];
            [weakSelf.selectCellArray addObject:path];
        }else{
            [weakSelf.selectPhotosArray removeObject:asset];
            [weakSelf.selectCellArray removeObject:path];
        }
        [weakSelf.completeBtn setTitle:[NSString stringWithFormat:@"完成(%ld)",weakSelf.selectPhotosArray.count] forState:UIControlStateNormal];
        
    };
    
    
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHQPreviewViewController *previewVc = [[LHQPreviewViewController alloc]init];
    previewVc.photos = self.dataArray;
    previewVc.currentIndexPath = indexPath;
    [self.navigationController pushViewController:previewVc animated:YES];
}




#pragma mark 列表中按钮点击动画效果
-(void)shakeToShow:(UIButton *)button{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}

#pragma mark -- lazy
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    }
    return _bottomView;
}
- (UIButton *)completeBtn
{
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_completeBtn setTitle:@"完成(0)" forState:UIControlStateNormal];
        [_completeBtn addTarget:self action:@selector(completeTap:) forControlEvents:UIControlEventTouchUpInside];
        [_completeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _completeBtn;
}
- (UIButton *)showPhotoBtn
{
    if (!_showPhotoBtn) {
        _showPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _showPhotoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_showPhotoBtn addTarget:self action:@selector(showPhotoTap:) forControlEvents:UIControlEventTouchUpInside];
        [_showPhotoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_showPhotoBtn setTitle:@"预览" forState:UIControlStateNormal];
    }
    return _showPhotoBtn;
}

@end
