//
//  GridViewEntity.h
//  Core
//
//  Created by mac on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HLContainerEntity.h"

@interface GridViewEntity : HLContainerEntity


@property float cellWidth;
@property float cellHeight;
@property NSInteger shelfID;
@property NSInteger shelfType;
@property (nonatomic, retain) NSString *serverAdd;

@end
