//
//  CustomScaleAnimation.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animation.h"

@interface CustomScaleAnimation : Animation
{
    NSString *type;
	NSString *aspect;
    float widthScale;;
    float heightScale;
}

@property (nonatomic , retain) NSString *type;
@property (nonatomic , retain) NSString *aspect;
@property float widthScale;
@property float heightScale;
@property CGPoint centernPoint;
@end
