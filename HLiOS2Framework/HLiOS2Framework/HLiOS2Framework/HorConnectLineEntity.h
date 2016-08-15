//
//  HorConnectLineEntity.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-8.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"

@interface HorConnectLineEntity : HLContainerEntity

@property (nonatomic, retain) NSMutableArray *answerArray;

@property (nonatomic, retain) NSMutableArray *sourceArray;

@property (nonatomic, retain) NSMutableArray *idArray;

@property float lineGap, rowGap;
//added by Adward 13-11-22
@property int lineWidth;
@property (nonatomic , retain) NSString *lineColor;
@property float lineAlpha;

@end
