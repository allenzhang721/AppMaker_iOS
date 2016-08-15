//
//  ImageEntity.h
//  MoueeiPad
//
//  Created by FloatBits on 7/18/11.
//  Copyright 2011 FloatBits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLContainerEntity.h"

@interface ImageEntity : HLContainerEntity
{
    Boolean isZoomByUser;
    Boolean isStroyTelling;
}
@property Boolean isZoomInner;
@property Boolean isZoomByUser;
@property Boolean isStroyTelling;
@property Boolean isMoveScale;
@property (nonatomic,retain) NSString *type;
@property float scale;

@end
