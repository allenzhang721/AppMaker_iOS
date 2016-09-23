//
//  HLGobalBookID.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 23/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLGobalBookID.h"

@implementation HLGobalBookID

+ (HLGobalBookID *)share {
    
    static HLGobalBookID * record = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        record = [[HLGobalBookID alloc] init];
        record.bookID = @"";
    });
    
    return record;
}

@end
