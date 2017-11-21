//
//  LHQPreviewCollectionViewCell.m
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/21.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "LHQPreviewCollectionViewCell.h"


@implementation LHQPreviewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.artScrollView = [[UIScrollView alloc] init];
        self.artScrollView.frame = CGRectMake(0, 0, SelfView_W, SelfView_H);
        self.artScrollView.minimumZoomScale = 0.5;
        self.artScrollView.maximumZoomScale = 3.0;
        self.artScrollView.showsVerticalScrollIndicator = NO;
        self.artScrollView.showsHorizontalScrollIndicator = NO;
        
        self.artScrollView.delegate = self;
        [self.contentView addSubview:self.artScrollView];
        

        self.previewImage = [[UIImageView alloc]initWithFrame:self.bounds];
        self.previewImage.userInteractionEnabled = YES;
        self.previewImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.previewImage];
     
        
    }
    return self;
}

//这个方法的返回值决定了要缩放的内容(只能是UISCrollView的子控件)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.previewImage;
}
//控制缩放是在中心
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.previewImage.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       
                                       scrollView.contentSize.height * 0.5 + offsetY);
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

@end
