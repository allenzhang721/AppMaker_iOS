//
//  PushView.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 8/31/16.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 pushView
 ┌─────────────────┐ 
 │ ┌───────┐       │ 10
 │ │ title │       │
 │ └───────┘       │ 0
 │ ┌─────────────┐ │
 │ │             │ │
 │ │   content   │ │
 │ │             │ │
 │ └─────────────┘ │
 │        ┌──────┐ │ 0
 │        │ date │ │
 │        └──────┘ │ 10
 └─────────────────┘
  20             20
 */

typedef void(^Handler)();
@interface PushCell : UIView

@property (nonatomic, copy) Handler closeHandler;
@property (nonatomic, copy) Handler tapHandler;

-(void) setConent:(NSString *)content title:(NSString *)title date:(NSString *)date;

@end
