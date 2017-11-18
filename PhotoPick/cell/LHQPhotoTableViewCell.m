//
//  LHQPhotoTableViewCell.m
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/18.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "LHQPhotoTableViewCell.h"

@implementation LHQPhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.photoImage = [[UIImageView alloc]init];
        self.photoImage.clipsToBounds = YES;
        self.photoImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.photoImage];
        [self.photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(70);
        }];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.photoImage.mas_right).offset(10);
            make.top.mas_equalTo(self.photoImage.mas_top);
            make.bottom.mas_equalTo(self.photoImage.mas_bottom);
        }];
        
    }
    return self;
}

@end
