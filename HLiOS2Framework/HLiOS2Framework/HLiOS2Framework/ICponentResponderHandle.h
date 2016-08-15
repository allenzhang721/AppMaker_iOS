//
//  ICponentResponderHandle.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-11-5.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageComponent.h"
#import "HLImage.h"
#import "HLScrollView.h"
#import "HLContainer.h"

@interface ICponentResponderHandle : UIResponder
{
    
}

@property (nonatomic, assign) Component *com;
//@property (nonatomic, assign) ImageComponent *imgCom;
@property (nonatomic, assign) UIView    *responderView;
@property (nonatomic, assign) Boolean   isEnableMoveable;
@property (nonatomic, assign) Boolean   isStroyTelling;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)runLinkageContainerWidth:(float)wchange Height :(float)hchange;
- (void)runLinkageContainerXY:(float)lx :(float)ly;

@end
