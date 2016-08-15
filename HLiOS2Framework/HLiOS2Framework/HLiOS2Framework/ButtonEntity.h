//
//  ButtonEntity.h
//  Core
//
//  Created by Pi Yi on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBaseEntity.h"

@interface ButtonEntity : HLBaseEntity
{
    NSString *btnImg;
    NSString *btnHighlightImg;
    float x;
    float y;
    float width;
    float height;
    Boolean isVisible;
}

@property (nonatomic , retain) NSString *btnImg;
@property (nonatomic , retain) NSString *btnHighlightImg;
@property float x;
@property float y;
@property float width;
@property float height;
@property Boolean isVisible;
@property Boolean isUserDef;
@end
