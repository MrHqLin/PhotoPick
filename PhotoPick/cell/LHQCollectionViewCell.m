//
//  LHQCollectionViewCell.m
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/16.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "LHQCollectionViewCell.h"

@implementation LHQCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photoImage = [[UIImageView alloc]init];
        self.photoImage.center = self.center;
        self.photoImage.bounds = CGRectMake(0, 0, 50, 50);
        [self.contentView addSubview:self.photoImage];
    }
    return self;
}

@end
