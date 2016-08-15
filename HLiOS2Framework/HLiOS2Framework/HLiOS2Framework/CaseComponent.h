//
//  CaseComponent.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-10.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "CaseEntity.h"
#import "HLPageController.h"
#import "HLContainer.h"

@interface CaseComponent : Component

@property (nonatomic, retain) CaseEntity *caseEntity;

- (void)runCase:(HLPageController *)pageController;

@end
