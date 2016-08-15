//
//  BehaviorDecoder.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "BehaviorEntity.h"

@interface BehaviorDecoder : NSObject
{}
+(BehaviorEntity*) decode:(TBXMLElement *)behavior;
+(Boolean)    getBooleanType:(NSString *) value;

@end
