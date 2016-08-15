//
//  PageDecoder.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageEntity.h"

@interface PageDecoder : NSObject
+(void) close;
+(void) load:(PageEntity *)entity path:(NSString *)path;
+(PageEntity *) decode:(NSString *)pageid path:(NSString *)path;

+(void) setSX:(float) sx;
+(void) setSY:(float) sy;
+(void) setSX1:(float) sx;
+(void) setSY1:(float) sy;
+(float) getSX;
+(float) getSY;
+(void) setHorVerMode:(bool) value;
+(void) setAndroidType:(bool) value;
+(void) setBookWidth:(float) value;
+(void) setBookHeight:(float) value;
@end
