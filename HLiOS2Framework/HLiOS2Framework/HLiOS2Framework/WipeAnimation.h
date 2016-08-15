//
//  WipeAnimation.h
//  MoueeReleaseVertical
//
//  Created by user on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animation.h"

@interface WipeAnimation : Animation
{
    NSString *aspect;
    Boolean isWipeOut;
}

@property (nonatomic , retain) NSString *aspect;
@property Boolean isWipeOut;
@property (nonatomic , retain) NSDate *lastPlayDate;
@end
