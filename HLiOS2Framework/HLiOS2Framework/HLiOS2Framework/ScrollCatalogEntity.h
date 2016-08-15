//
//  ScrollCatalogEntity.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-29.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"

@interface ScrollCatalogEntity : HLContainerEntity

@property (nonatomic, retain)NSMutableArray *leftArray;
@property (nonatomic, retain)NSMutableArray *centerArray;
@property (nonatomic, retain)NSMutableArray *rightArray;
@property (nonatomic, retain)NSMutableArray *leftIndexArray;
@property (nonatomic, retain)NSMutableArray *centerIndexArray;
@property (nonatomic, retain)NSMutableArray *rightIndexArray;


@end
