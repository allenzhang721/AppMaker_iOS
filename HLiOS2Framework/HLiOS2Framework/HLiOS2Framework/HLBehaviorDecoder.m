//
//  BehaviorDecoder.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HLBehaviorDecoder.h"

@implementation HLBehaviorDecoder

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(HLBehaviorEntity*) decode:(TBXMLElement *)behavior
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    HLBehaviorEntity *behaviorEntity  = [[HLBehaviorEntity alloc] init];
    behaviorEntity.eventName	    = [EMTBXML textForElement:[EMTBXML childElementNamed:@"EventName" parentElement:behavior]];
    behaviorEntity.functionObjectID = [EMTBXML textForElement:[EMTBXML childElementNamed:@"FunctionObjectID" parentElement:behavior]];
    behaviorEntity.functionName     = [EMTBXML textForElement:[EMTBXML childElementNamed:@"FunctionName" parentElement:behavior]];
    NSString *isRepeat    = [EMTBXML textForElement:[EMTBXML childElementNamed:@"IsRepeat" parentElement:behavior]];
    behaviorEntity.isRepeat = [HLBehaviorDecoder getBooleanType:isRepeat];
    if (([behaviorEntity.functionName compare:@"FUNCTION_GOTO_PAGE"] == NSOrderedSame) || ([behaviorEntity.functionName compare:@"FUNCTION_PAGE_CHANGE"] == NSOrderedSame)||([behaviorEntity.functionName compare:@"FUNCTION_GOTO_URL"] == NSOrderedSame))
    {
        behaviorEntity.value = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Value" parentElement:behavior]];
    }
    if (([behaviorEntity.eventName compare: @"BEHAVIOR_ON_ENTER_SPOT"] == NSOrderedSame) ||([behaviorEntity.eventName compare: @"BEHAVIOR_ON_OUT_SPOT"] == NSOrderedSame))
    {
        behaviorEntity.value = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Value" parentElement:behavior]];
    }
    if ([EMTBXML childElementNamed:@"Value" parentElement:behavior] != nil) 
    {
         behaviorEntity.value = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Value" parentElement:behavior]];
    }
    if ([EMTBXML childElementNamed:@"EventValue" parentElement:behavior] != nil)
    {
        behaviorEntity.behaviorValue = [EMTBXML textForElement:[EMTBXML childElementNamed:@"EventValue" parentElement:behavior]];
    }
    [pool release];
    return behaviorEntity;
}

+(Boolean) getBooleanType:(NSString *) value
{
    if ( [value compare:@"false"] == NSOrderedSame)
    {
        return NO;
    }
    else 
    {
        return YES;
    }	 
}

@end
