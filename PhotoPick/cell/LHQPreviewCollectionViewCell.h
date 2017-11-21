//
//  LHQPreviewCollectionViewCell.h
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/21.
//  Copyright © 2017年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHQPreviewCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView        *artScrollView;
@property(nonatomic,strong) UIImageView         *previewImage;


@end
