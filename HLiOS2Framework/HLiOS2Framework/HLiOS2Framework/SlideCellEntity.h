//
//  SlideCellEntity.h
//  Core
//
//  Created by sun yongle on 12/08/12.
//  Copyright (c) 2012年 PEM. All rights reserved.
//

#import "HLContainerEntity.h"

@interface SlideCellEntity : HLContainerEntity

@property (nonatomic, readonly) NSMutableArray *normalImages;
@property (nonatomic, readonly) NSMutableArray *selImages;
@property BOOL isVirtical;
@property float cellWidth;
@property float cellHeight;

@end
