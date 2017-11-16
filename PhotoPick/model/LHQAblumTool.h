//
//  LHQAblumTool.h
//  PhotoPick
//
//  Created by Hq.Lin on 2017/11/16.
//  Copyright © 2017年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LHQAblumList : NSObject

@property(nonatomic,strong) NSString  *title;//相册名字
@property(nonatomic,assign) NSInteger count;//该相册内的照片数量
@property(nonatomic,strong) PHAsset   *headImageAsset;//相册的第一张缩略图
@property(nonatomic,strong) PHAssetCollection  *assetCollecttion;//相册集，获取到该相册集下所有照片

@end

@interface LHQAblumTool : NSObject

+(instancetype)shareAblumTool;

//获取用户所有相册列表
-(NSArray<LHQAblumList *> *)getPhotoAblumList;

//获取相册内所有图片资源 。是否按图片创建时间排列
-(NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;

//获取指定相册内的所有图片
-(NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;

//获取每个Asset对应的图片
-(void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion;


@end

/*
 PHAsset:代表照片库中的一个资源实体。可以理解为一张照片，在打印的时候可以清楚的看见里面包含了照片的时间，标题等信息
 PHFetchOptions:获取资源时的参数，可以传nil，即使用默认值
 PHFetchResult:表示结果集，可以使相册集合，可以使照片实体集合
 PHAssetCollection:表示一个相册或者一个时刻，或者是系统提供的智能相册（最近删除、视频列表，收藏等等）
 PHCollectionList:和PHAssatCollection差不多
 PSHImageManager:用于处理资源的加载，加载图片的过程带有缓存处理，可以通过传入一个PHImageRequestOptions 控制资源的输出尺寸等规格
 */

