//
//  CaseComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-10.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "CaseComponent.h"

@implementation CaseComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)runCase:(HLPageController *)pageController
{
    
}

- (void)dealloc
{
    [self.caseEntity release];
    [super dealloc];
}

@end
