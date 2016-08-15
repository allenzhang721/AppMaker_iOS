//
//  ButtonComponet.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-15.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "ButtonContainerEntity.h"
#import "ADButtonView.h"

@interface ButtonComponet : Component
{
    ADButtonView *adBtnView;
}
@property (nonatomic, retain) ButtonContainerEntity *entity;

@end
