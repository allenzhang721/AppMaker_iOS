//
//  ViewCrop.h
//  MoueeReleaseVertical
//
//  Created by user on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface HLViewCrop : NSObject
{}

+(UIImage *) crop:(UIView *) view :(CGRect) rect;
@end
