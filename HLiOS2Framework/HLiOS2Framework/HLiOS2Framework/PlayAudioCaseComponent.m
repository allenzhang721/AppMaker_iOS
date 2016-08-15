//
//  PlayAudioCaseComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-10.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "PlayAudioCaseComponent.h"

@implementation PlayAudioCaseComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.caseEntity = (CaseEntity *)entity;
    }
    return self;
}

- (void)runCase:(HLPageController *)pageController
{
    [super runCase:pageController];
    for (int i = 0; i < self.caseEntity.containerIdArr.count; i++)
    {
        if ([[self.caseEntity.containerIdArr objectAtIndex:i] isEqualToString:container.entity.entityid])
        {
            [container play];
        }
        else
        {
            for (int j = 0; j < pageController.objects.count; j++)
            {
                HLContainer *caseContainer = (HLContainer *)[pageController.objects objectAtIndex:j];
                if ([[self.caseEntity.containerIdArr objectAtIndex:i] isEqualToString:caseContainer.entity.entityid])
                {
                    [caseContainer stop];
                }
            }
        }
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
