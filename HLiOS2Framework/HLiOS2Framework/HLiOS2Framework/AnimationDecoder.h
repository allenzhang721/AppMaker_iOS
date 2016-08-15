//
//  AnimationDecoder.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animation.h"
#import "EMTBXML.h"

@interface AnimationDecoder : NSObject
{
    
}

+(Animation*) decode:(TBXMLElement *)animation;

+(void) setSX:(float) sx;
+(void) setSY:(float) sy;
+(float) getSX;
+(float) getSY;
@end
