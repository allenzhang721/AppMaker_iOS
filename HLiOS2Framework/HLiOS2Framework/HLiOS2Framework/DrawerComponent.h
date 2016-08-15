//
//  DrawerComponent.h
//  Core
//
//  Created by sun yongle on 25/07/12.
//  Copyright (c) 2012年 PEM. All rights reserved.
//

#import "Component.h"
#import "DrawerEntity.h"

@interface DrawerComponent : Component

//-(id) initWithEntity : (DrawerEntity *)entity path : (NSString *)path;
-(void)showMenu : (Boolean) show;

-(BOOL)pointInside : (CGPoint) point;

@end
