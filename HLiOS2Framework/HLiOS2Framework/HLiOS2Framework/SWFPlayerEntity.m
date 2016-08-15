////
////  SWFPlayerEntity.m
////  MoueeIOS2Core
////
////  Created by Pi Yi on 3/7/13.
////  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
////
//
//#import "SWFPlayerEntity.h"
//#import "Utility.h"
//
//@implementation SWFPlayerEntity
//@synthesize isStroyTelling;
//@synthesize isLoop;
//
//-(void) decodeData:(TBXMLElement *)data
//{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    TBXMLElement *allowUserZoom = [TBXML childElementNamed:@"IsLoop"  parentElement:data];
//    if (allowUserZoom != nil)
//    {
//        NSString *isAllowUserZoom = [TBXML textForElement:allowUserZoom];
//        self.isLoop = [isAllowUserZoom boolValue];
//    }
//    [pool release];
//}
//
//-(void) decode:(TBXMLElement *)container
//{
//    TBXMLElement *allowMove = [TBXML childElementNamed:@"IsStroyTelling"  parentElement:container];
//    self.isStroyTelling     = [Utility stringToBoolean:[TBXML textForElement:allowMove]];
//}
//@end
