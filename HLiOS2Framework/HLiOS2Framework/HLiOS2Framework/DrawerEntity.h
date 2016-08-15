//
//  DrawerEntity.h
//  Core
//
//  Created by sun yongle on 25/07/12.
//  Copyright (c) 2012年 PEM. All rights reserved.
//

#import "HLContainerEntity.h"

@interface DrawerEntity : HLContainerEntity

@property NSInteger segCount;
@property (nonatomic, retain) NSString *btnPic;
@property (nonatomic, retain) NSString *btnSelPic;
@property (nonatomic, retain) NSMutableArray *segBtnPics;
@property (nonatomic, retain) NSMutableArray *segBtnSelPics;


@end
