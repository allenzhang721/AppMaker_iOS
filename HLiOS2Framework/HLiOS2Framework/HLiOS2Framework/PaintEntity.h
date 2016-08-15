//
//  PaintEntity.h
//  Core
//
//  Created by user on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLContainerEntity.h"

@interface PaintEntity : HLContainerEntity
{
    NSString *img;
    
}

@property (nonatomic , retain) NSString *img;
//added by Adward 13-12-06
@property int lineWidth;
@end
