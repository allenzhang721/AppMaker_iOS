//
//  BehaviorDecoder.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BehaviorDecoder.h"

@implementation BehaviorDecoder

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(BehaviorEntity*) decode:(TBXMLElement *)behavior
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BehaviorEntity *behaviorEntity  = [[BehaviorEntity alloc] init];
    behaviorEntity.eventName	    = [TBXML textForElement:[TBXML childElementNamed:@"EventName" parentElement:behavior]];
    behaviorEntity.functionObjectID = [TBXML textForElement:[TBXML childElementNamed:@"FunctionObjectID" parentElement:behavior]];
    behaviorEntity.functionName     = [TBXML textForElement:[TBXML childElementNamed:@"FunctionName" parentElement:behavior]];
    NSString *isRepeat    = [TBXML textForElement:[TBXML childElementNamed:@"IsRepeat" parentElement:behavior]];
    behaviorEntity.isRepeat = [BehaviorDecoder getBooleanType:isRepeat];
    if (([behaviorEntity.functionName compare:@"FUNCTION_GOTO_PAGE"] == NSOrderedSame) || ([behaviorEntity.functionName compare:@"FUNCTION_PAGE_CHANGE"] == NSOrderedSame)||([behaviorEntity.functionName compare:@"FUNCTION_GOTO_URL"] == NSOrderedSame))
    {
        behaviorEntity.value = [TBXML textForElement:[TBXML childElementNamed:@"Value" parentElement:behavior]];
    }
    if (([behaviorEntity.eventName compare: @"BEHAVIOR_ON_ENTER_SPOT"] == NSOrderedSame) ||([behaviorEntity.eventName compare: @"BEHAVIOR_ON_OUT_SPOT"] == NSOrderedSame))
    {
        behaviorEntity.value = [TBXML textForElement:[TBXML childElementNamed:@"Value" parentElement:behavior]];
    }
    if ([TBXML childElementNamed:@"Value" parentElement:behavior] != nil) 
    {
         behaviorEntity.value = [TBXML textForElement:[TBXML childElementNamed:@"Value" parentElement:behavior]];
    }
    if ([TBXML childElementNamed:@"EventValue" parentElement:behavior] != nil)
    {
        behaviorEntity.behaviorValue = [TBXML textForElement:[TBXML childElementNamed:@"EventValue" parentElement:behavior]];
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
