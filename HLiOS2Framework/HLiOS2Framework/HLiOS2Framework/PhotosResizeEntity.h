//
//  PhotosResizeEntity.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-30.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"

@interface PhotosResizeEntity : HLContainerEntity

@property BOOL isShowControllerPoint;

@property (nonatomic, retain) NSMutableArray *imageSourceArray;

@property (nonatomic, retain) NSMutableArray *imgOriSizeArr;

@property (nonatomic, retain) NSMutableArray *showImgRectArr;

@property (nonatomic, retain) NSMutableArray *titleArr;

@property (nonatomic, retain) NSMutableArray *decArr;

@property (nonatomic, retain) NSMutableArray *zoomArr;

@property (nonatomic, retain) NSMutableArray *audioSourceArr;

@end
