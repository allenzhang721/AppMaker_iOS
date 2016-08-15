//
//  MoveAnimationReverse.m
//  PaintApp
//
//  Created by user on 11-10-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoveAnimationReverse.h"

@implementation MoveAnimationReverse
@synthesize view;
@synthesize isRevser;
@synthesize scaleW;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
		self.isRevser = YES;
        scaleW = 1;
    }
    return self;
}
-(void) play
{
    if (self.view != nil) 
	{
        [self.view.layer removeAllAnimations];
		CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.x"];
        if (self.isRevser == YES)
        {
            move.fromValue = [NSNumber numberWithFloat:self.view.layer.position.x];
            move.toValue   = [NSNumber numberWithFloat:(self.view.layer.position.x + 20 * scaleW)];
        }
        else
        {
            move.fromValue = [NSNumber numberWithFloat:self.view.layer.position.x+20 * scaleW];
            move.toValue   = [NSNumber numberWithFloat:(self.view.layer.position.x)];
        }
		move.duration  = 0.5f;
		CAAnimationGroup *group = [CAAnimationGroup animation]; 
		[group setDuration:0.5f]; 
        [group setFillMode:kCAFillModeForwards];
        group.removedOnCompletion =NO;
		[group setAnimations: [NSArray arrayWithObjects:move,nil]];
        group.repeatCount =1;
		[self.view.layer addAnimation:group forKey:@"moveFromBottomFadeIn"];
	}
}
-(void) stop
{
}
@end
