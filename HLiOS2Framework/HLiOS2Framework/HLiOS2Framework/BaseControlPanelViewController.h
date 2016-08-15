//
//  BaseControlPanelViewController.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/24/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLPopUpViewController.h"
#import "ClearView.h"
@class HLBookController;
@interface BaseControlPanelViewController : HLPopUpViewController<ClearViewDelegate>
{}
@property (nonatomic,assign) HLBookController *bookController;
@property float sx;
@property float sy;
@property float sx1;
@property float sy1;
@property UIInterfaceOrientation orientation;
-(void) setup:(CGRect )rect;
-(void) refreshPanel:(int)index count:(int)count enableNav:(Boolean)enableNav;
-(void) enable;
-(void) disable;
-(void) popDown;
-(void) dismissPopup;
@end
