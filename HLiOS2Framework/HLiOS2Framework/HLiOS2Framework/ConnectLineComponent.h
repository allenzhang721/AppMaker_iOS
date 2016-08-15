//
//  ConnectLineComponent.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-9.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "ConnectLineEntity.h"
#import "DrawLineView.h"

@interface ConnectLineComponent : Component <DrawLineViewDelegate>
{
    
}

@property (nonatomic, retain) ConnectLineEntity *connectLineEntity;

@property (nonatomic, retain) NSString *imagePath;

@property (nonatomic, retain) CALayer *wiggleLayer;

@end
