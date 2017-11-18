//
//  PhotoListViewController.m
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/17.
//  Copyright © 2017年 lin. All rights reserved.
//

#import "LHQPhotoListViewController.h"
#import "LHQPhotoViewController.h"

@interface LHQPhotoListViewController ()

@end

@implementation LHQPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"photoList";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];

}


#pragma mark -- cancel
-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
