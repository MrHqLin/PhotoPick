//
//  LHQCollectionViewCell.h
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/16.
//  Copyright © 2017年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectPhotosBlock)(UIButton *btn);

@interface LHQCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) UIImageView *photoImage;
@property(nonatomic,strong) UIButton    *selectBtn;
@property(nonatomic,strong) selectPhotosBlock selectBlock;

@end
