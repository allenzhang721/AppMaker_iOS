//
//  Utility.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLUtility.h"

@implementation HLUtility
+(Boolean) stringToBoolean:(NSString *) value
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
