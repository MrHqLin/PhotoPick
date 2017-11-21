//
//  LHQPreviewViewController.m
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/20.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "LHQPreviewViewController.h"
#import "LHQAblumTool.h"
#import "LHQPreviewCollectionViewCell.h"

static NSString *_cellIdentifier = @"collectionViewCell";

@interface LHQPreviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *previewCollection;

//top
@property(nonatomic,strong) UIView            *topView;
@property(nonatomic,strong) UIButton          *backBtn;
@property(nonatomic,strong) UIButton          *selectBtn;

@end

@implementation LHQPreviewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"show";
    
    
    [self.view addSubview:self.previewCollection];
    [self setupTopView];
    [self setupToolbar];
    //滚动到指定区域
    [self.previewCollection scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark -- top
-(void)setupTopView
{
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView.mas_left).offset(15);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
    }];
    [self.topView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
    }];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)selectTap:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
#pragma mark -- bottom
-(void)setupToolbar
{
    
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHQPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    PHAsset *asset = self.photos[indexPath.row];
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    [[LHQAblumTool shareAblumTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
        
        UIImageView *textimage = [[UIImageView alloc] initWithImage:image];
        
        //移除上一个artimage
        [cell.previewImage removeFromSuperview];
        
        cell.previewImage = [[UIImageView alloc] init];
        cell.previewImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.previewImage.frame = [self setImage:textimage];
        cell.previewImage.image = image;
        [cell.artScrollView addSubview:cell.previewImage];
        
        //设置scroll的contentsize的frame
        cell.artScrollView.contentSize = cell.previewImage.frame.size;
    }];
   
    return cell;
}

//根据不同的比例设置尺寸
-(CGRect) setImage:(UIImageView *)imageView
{
    
    CGFloat imageX = imageView.frame.size.width;
    
    CGFloat imageY = imageView.frame.size.height;
    
    CGRect imgfram;
    
    CGFloat CGscale;
    
    BOOL flx =  (SelfView_W / SelfView_H) > (imageX / imageY);
    
    if(flx)
    {
        CGscale = SelfView_H / imageY;
        
        imageX = imageX * CGscale;
        
        imgfram = CGRectMake((SelfView_W - imageX) / 2, 0, imageX, SelfView_H);
        
        return imgfram;
    }
    else
    {
        CGscale = SelfView_H / imageX;
        
        imageY = imageY * CGscale;
        
        imgfram = CGRectMake(0, (SelfView_H - imageY) / 2, SelfView_W, imageY);
        
        return imgfram;
    }
    
}


#pragma mark -- lazy
 - (UICollectionView *)previewCollection
{
    if (!_previewCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(SelfView_W, SelfView_H);
         layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);//右边距10 过滤cell间隙
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _previewCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SelfView_W+10, SelfView_H) collectionViewLayout:layout];
        _previewCollection.showsHorizontalScrollIndicator = YES;
        _previewCollection.showsVerticalScrollIndicator = NO;
        _previewCollection.pagingEnabled = YES;
        _previewCollection.backgroundColor = [UIColor blackColor];
        _previewCollection.bounces = NO;
        _previewCollection.delegate = self;
        _previewCollection.dataSource = self;
        [_previewCollection registerClass:[LHQPreviewCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        
        [self.view addSubview:_previewCollection];
    }
    return _previewCollection;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SelfView_W, 60)];
        _topView.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:45.0/255.0 blue:60.0/255.0 alpha:1];
    }
    return _topView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn addTarget:self action:@selector(selectTap:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setImage:[UIImage imageNamed:@"photo_unselect_white"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"photo_select_white"] forState:UIControlStateSelected];
    }
    return _selectBtn;
}


#pragma mark -- common
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
