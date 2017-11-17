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
        self.photoImage = [[UIImageView alloc]initWithFrame:self.bounds];
        self.photoImage.clipsToBounds = YES;
        self.photoImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.photoImage];
//        [self.photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.mas_centerX);
//            make.centerY.mas_equalTo(self.mas_centerY);
//        }];
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectBtn setImage:[UIImage imageNamed:@"photo_unselect"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"photo_select"] forState:UIControlStateSelected];
        [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectBtn];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(3);
            make.right.mas_equalTo(self.mas_right).offset(-3);
        }];
    }
    return self;
}

-(void)selectClick:(UIButton *)sender
{
    _selectBlock(sender);
}

@end
