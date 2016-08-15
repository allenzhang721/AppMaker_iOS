//
//  MoveAnimationReverse.h
//  PaintApp
//
//  Created by user on 11-10-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface MoveAnimationReverse : NSObject
{
    UIView   *view;
    Boolean  isRevser;
    GLfloat  scaleW;
}
@property (nonatomic,assign) UIView *view;
@property Boolean isRevser;
@property GLfloat scaleW;
-(void) play;
-(void) stop;


@end
