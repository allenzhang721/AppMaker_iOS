//
//  SphereView.m
//  Core
//
//  Created by mac on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SphereView.h"

#define kAnimationSpeed 5.0
#define kImageSpacing 10.0
#define kPanelTotal 4

@implementation SphereView

@synthesize isLoop;
@synthesize isVertical;
@synthesize delegate;
@synthesize speed;
@synthesize isAllowZoom;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        isLoop = YES;
        isVertical = NO;
        imageSpacing =  10;
        self.speed        = 5;
    	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        scrollView.bounces = NO;
        scrollView.pagingEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator   = NO;
        [self addSubview:scrollView];
        scrview = scrollView;
        [scrollView release];
        
        
        // Animated Image
        UIImageView *animView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        animView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:animView];
        aniview = animView;
        [animView release];
    }
    return self;
}

- (void)timerUpdate
{
    if (!self.isClockWise)
    {
        imageIndex--;
    }
    else
    {
        imageIndex++;
    }
    [self updateAnimationView];
}

- (void)setPatharray:(NSMutableArray *)arr;
{
    if (arr && arr.count > 0) {
        [arr retain];
        patharr = arr;
        
        sequenceSize = patharr.count;
        if (self.isVertical)
        {
            if (imageSpacing < self.frame.size.height / sequenceSize) {
                imageSpacing = self.frame.size.height / sequenceSize;
                imageSpacing = ((imageSpacing / 5)+1) * 5;
            }
            scrview.contentSize = CGSizeMake(self.frame.size.width, kPanelTotal * imageSpacing * sequenceSize);
            scrview.contentOffset = CGPointMake(0, imageSpacing * sequenceSize);
            currentOffset = scrview.contentOffset.y;
        }
        else
        {
            if (imageSpacing < self.frame.size.width / sequenceSize) {
                imageSpacing = self.frame.size.width / sequenceSize;
                imageSpacing = ((imageSpacing / 5)+1) * 5;
            }
            scrview.contentSize = CGSizeMake(kPanelTotal * imageSpacing * sequenceSize , self.frame.size.height);
            scrview.contentOffset = CGPointMake(imageSpacing * sequenceSize , 0);
            currentOffset = scrview.contentOffset.x;
        }
        
        
        //setup image
        NSString *imageFileName;
        imageFileName = [patharr objectAtIndex:0];
        if (imageFileName && aniview) {
            aniview.image = [UIImage imageWithContentsOfFile:imageFileName];
        }
    }
    if (self.isAutoRotation)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    }
}

- (void)resetContentpos:(UIScrollView *)scrollView
{
    if (!scrollView) {
        return;
    }
    if (self.isVertical)
    {
        int panelIndex = scrollView.contentOffset.y/(imageSpacing * sequenceSize);
        
        // Move ScrollView content to make it continuos
        if (panelIndex == 0) {
            scrollView.contentOffset = CGPointMake(0,  currentOffset + imageSpacing * sequenceSize);
            currentOffset = scrollView.contentOffset.y;
          
//        } else if (panelIndex == 2){
//            scrollView.contentOffset = CGPointMake(0, currentOffset - imageSpacing * sequenceSize);
//            currentOffset = scrollView.contentOffset.y;
//        }
        } else if (panelIndex <= 3){
            scrollView.contentOffset = CGPointMake(0, currentOffset - imageSpacing * sequenceSize);
            currentOffset = scrollView.contentOffset.y;
        }
    }
    else
    {
        int panelIndex = scrollView.contentOffset.x/(imageSpacing * sequenceSize);
        
        // Move ScrollView content to make it continuos
        if (panelIndex == 0) {
            scrollView.contentOffset = CGPointMake(currentOffset + imageSpacing * sequenceSize, 0);
            currentOffset = scrollView.contentOffset.x;
          
//        } else if (panelIndex == 2){
//            scrollView.contentOffset = CGPointMake(currentOffset - imageSpacing * sequenceSize, 0);
//            currentOffset = scrollView.contentOffset.x;
//        }
        } else if (panelIndex <= 3){
            scrollView.contentOffset = CGPointMake(currentOffset - imageSpacing * sequenceSize, 0);
            currentOffset = scrollView.contentOffset.x;
        }
    }
}

- (void)updateAnimationView {
    
    if (self.isAutoRotation)//adward 2.14 isLoop
    {
        if (imageIndex < 0) imageIndex = sequenceSize-1;
        if (imageIndex >= sequenceSize) imageIndex = 0;
    }
    else
    {
        if (imageIndex < 0)
        {
            imageIndex = sequenceSize-1;
            return;
        }
        if (imageIndex >= sequenceSize)
        {
            imageIndex = 0;
            return;
        }
    }
    
    NSString *filepath = [patharr objectAtIndex:imageIndex];
    if (filepath) {
        aniview.image = [UIImage imageWithContentsOfFile:filepath];
        if ([self.delegate respondsToSelector:@selector(didShowPicIndex:)])
        {
            [self.delegate didShowPicIndex:imageIndex];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	// Increment imageindex based if the the scrollview scrolls more than a set distance
	
    if (self.isVertical)
    {
        if (scrollView.contentOffset.y < currentOffset - self.speed ) {
            //		imageIndex++;
            imageIndex--;
            currentOffset = scrollView.contentOffset.y;
            [self updateAnimationView];
        } else if (scrollView.contentOffset.y > currentOffset + self.speed) {
            //		imageIndex--;
            imageIndex++;
            currentOffset = scrollView.contentOffset.y;
            [self updateAnimationView];
        }
    }
    else
    {
        
        if (scrollView.contentOffset.x < currentOffset - self.speed ) {
            //		imageIndex++;
            imageIndex--;
            currentOffset = scrollView.contentOffset.x;
            [self updateAnimationView];
        } else if (scrollView.contentOffset.x > currentOffset + self.speed) {
            //		imageIndex--;
            imageIndex++;
            currentOffset = scrollView.contentOffset.x;
            [self updateAnimationView];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self resetContentpos:scrollView];
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self resetContentpos:scrollView];
    }
}

- (void)stopTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)dealloc
{
    if (patharr)
    {
        [patharr release];
    }
    [super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
