//
//  BehaviorDecoder.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMTBXML.h"
#import "HLBehaviorEntity.h"

@interface HLBehaviorDecoder : NSObject
{}
+(HLBehaviorEntity*) decode:(TBXMLElement *)behavior;
+(Boolean)    getBooleanType:(NSString *) value;

@end
