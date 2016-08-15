//
//  MultiJigImageView.m
//  MultiJig
//
//  Created by Senn, Matthew on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiJigImageView.h"
#import "UIImageCategory.h"


#define kPiecesWidth      105
#define kPiecesHeight     90

#pragma mark MultiJig Image View Class
@implementation MultiJigImageView

@synthesize isRightPuted;
@synthesize grid_x, grid_y;
@synthesize grid_size;
@synthesize containerView;
@synthesize mainView;
@synthesize scrollView;
@synthesize controller;


-(id)init
{
    self = [super init];
    if (self) 
    {
        self.isRightPuted = NO;
        self.userInteractionEnabled = YES;
        UIGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture)];
        gesture.delegate = (id <UIGestureRecognizerDelegate>)self;
        [self addGestureRecognizer:gesture];
        gesture.cancelsTouchesInView = NO;      //deliver touch events
        [gesture release];
    }
    return self;
}

#pragma mark utility

-(void)backtoContainer
{
    if (self.superview != self.containerView) {
        [self removeFromSuperview];
        self.center = originCenter;
        self.frame = CGRectMake(originCenter.x - kPiecesWidth/2, originCenter.y - kPiecesHeight/2, kPiecesWidth, kPiecesHeight);
        [self.containerView addSubview:self];
    }
}


#pragma mark -
#pragma mark Gestures and taps

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture
{
	return YES;
}

- (void)didGesture
{
    int a;
    a = 3;
}

#pragma mark -
#pragma mark touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isRightPuted) 
    {
        return;
    }
    UITouch *th = [touches anyObject];
    p1 = [th locationInView:self.mainView];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isRightPuted) 
    {
        return;
    }
    //back to scroll view
    [self backtoContainer];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //back to scroll view
   
    if (self.isRightPuted) 
    {
        return;
    }
    if (![controller isRightGrid:self]) {
        [self backtoContainer];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isRightPuted) 
    {
        return;
    }
    if (self.superview  == self.containerView)
    {
        //caculate pos on mainview
        originCenter = self.center;
        CGPoint center;
        center.x = self.center.x - self.scrollView.contentOffset.x + self.containerView.frame.origin.x;
        center.y = self.center.y + self.scrollView.frame.origin.y;
       // [self removeFromSuperview];
        self.center = center;
        [self.mainView addSubview:self];
        
        CGRect rect = self.frame;
        CGFloat x = rect.origin.x - (grid_size.width-rect.size.width) / 2;
        CGFloat y = rect.origin.y - (grid_size.height-rect.size.height) / 2;
        
        [UIView beginAnimations:@"Scale" context:nil];
        [UIView setAnimationDuration:0.30];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.frame = CGRectMake(x, y, grid_size.width, grid_size.height);
        [UIView commitAnimations];
        return;  
    }
    
    UITouch *th = [touches anyObject];
    p2 = [th locationInView:self.mainView];
    self.center = CGPointMake(self.center.x + p2.x - p1.x, self.center.y + p2.y-p1.y);
    p1 = p2;
}


@end
