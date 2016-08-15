//
//  FlowCoverNav.m
//  Core
//
//  Created by user on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HLFlowCoverNavigationView.h"
#import "HLNavView.h"
#import "HLFlipBaseController.h"
#import "SnapshotEntity.h"

@implementation HLFlowCoverNavigationView

@synthesize flowCoverView;
@synthesize backGround;
@synthesize btnClose;
@synthesize navLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

-(void) popup
{
    if (self.isPoped == NO)
    {
        self.hidden = NO;
        self.flowCoverView.offset = self.flipView.currentPageIndex;
        [self.flowCoverView draw];
        [self refreshPageNumber:self.flipView.currentPageIndex];
        [UIView beginAnimations:@"Move" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        CGRect rect = self.frame;
        self.frame = CGRectMake(rect.origin.x, rect.origin.y - rect.size.height, rect.size.width, rect.size.height);
        [UIView commitAnimations];
        self.isPoped = YES;
    }
    else
    {
        
    }
}

-(void) popdown
{
    if (self.isPoped == YES) 
    {
        [UIView beginAnimations:@"Move" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        CGRect rect = self.frame;
        self.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, rect.size.height);
        [UIView commitAnimations];
        self.isPoped = NO;
    }
    else
    {
        
    }
    
}

-(void) hide
{
    if (self.isPoped == YES) 
    {
        CGRect rect = self.frame;
        self.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, rect.size.height);
        self.isPoped = NO;

    }
}

-(void) refresh
{
    [self.flowCoverView clearCache];
    [self.flowCoverView draw];
}

-(void) load
{
    self.userInteractionEnabled = YES;
    self.backGround     = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tbp.png"]] autorelease];
    self.btnClose       = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navLabel       = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
    [self.navLabel release];
    self.navLabel.minimumFontSize = 10.0;
    self.navLabel.textAlignment = UITextAlignmentCenter;
    self.navLabel.textColor     = [UIColor whiteColor];
    self.navLabel.backgroundColor = [UIColor clearColor];
    UIImage *bc         = [UIImage imageNamed:@"navbtn.png"];
    UIImage *bc_hg      = [UIImage imageNamed:@"navbtn_hg.png"];
    [self.btnClose setImage:bc forState:UIControlStateNormal];
    [self.btnClose setImage:bc_hg forState:UIControlStateHighlighted];
    self.btnClose.userInteractionEnabled = YES;
    [self.btnClose addTarget:self action:@selector(closeSnapshot) forControlEvents:UIControlEventTouchUpInside];
    self.isPoped    = NO;
    if (self.snapshots == nil)
    {
        self.snapshots = [[NSMutableArray alloc] initWithCapacity:10];
        [self.snapshots release];
    }
    
    if (self.isVertical == YES) 
    {
        [self changeToVertical];
    }
    else
    {
        [self changeToHorizontal];
    }
    self.flowCoverView.delegate = self;
}

-(void) changeToVertical
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
//        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect screenBounds = [self.flipView getPageRect];      //Mr.chen , 1.23
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            if (screenBounds.size.width > screenBounds.size.height)
            {
                screenBounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
            }
        }
        if (self.flowCoverView == nil)
        {
            self.flowCoverView  = [[[FlowCoverView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, 200)] autorelease];
        }
        
        //原来192 * 72
        //现在76  * 30
        
        self.btnClose.frame = CGRectMake(screenBounds.size.width/2 - 50/2, 55 - 9, 50, 19);
        self.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, 200);
        self.flowCoverView.frame = CGRectMake(0, 50, screenBounds.size.width, 155);
        self.backGround.frame    = CGRectMake(0, 65, screenBounds.size.width, 150);
        self.navLabel.frame = CGRectMake(self.frame.size.width/2 - self.navLabel.frame.size.width/2, self.frame.size.height - self.navLabel.frame.size.height, self.navLabel.frame.size.width, self.navLabel.frame.size.height);
        [self addSubview:self.backGround];
        [self addSubview:self.flowCoverView];
        [self addSubview:self.btnClose];
        [self addSubview:self.navLabel];
        [self.flowCoverView draw];
    }
    else 
    {
        if (self.flowCoverView == nil)
        {
            self.flowCoverView  = [[[FlowCoverView alloc] initWithFrame:CGRectMake(0, 0, 768, 358)] autorelease];
        }
        self.btnClose.frame = CGRectMake(768/2 - 101/2, 45 - 13, 101, 38);
        self.frame = CGRectMake(0, 1024, 768, 358);
        self.flowCoverView.frame = CGRectMake(0, 40, 768, 323);
        self.backGround.frame    = CGRectMake(0, 65, 768, 293);
        self.navLabel.frame = CGRectMake(self.frame.size.width/2 - self.navLabel.frame.size.width/2, self.frame.size.height - self.navLabel.frame.size.height-10, self.navLabel.frame.size.width, self.navLabel.frame.size.height);
        [self addSubview:self.backGround];
        [self addSubview:self.flowCoverView];
        [self addSubview:self.btnClose];
        [self addSubview:self.navLabel];
        [self.flowCoverView draw];
    }
    
}

-(void) changeToHorizontal
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        //        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect screenBounds = [self.flipView getPageRect];      //Mr.chen , 1.23
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            if (screenBounds.size.width < screenBounds.size.height)
            {
                screenBounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
            }
        }
        if (self.flowCoverView == nil) 
        {
            self.flowCoverView  = [[[FlowCoverView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, 230)] autorelease];
        }
        self.btnClose.frame = CGRectMake(screenBounds.size.width/2 - 50/2, 57 - 11, 50, 19);
        self.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, 230);
        self.flowCoverView.frame = CGRectMake(0, 60, screenBounds.size.width, 170);
        self.backGround.frame    = CGRectMake(0, 65, screenBounds.size.width, 170);
        self.navLabel.frame = CGRectMake(self.frame.size.width/2 - self.navLabel.frame.size.width/2, self.frame.size.height - self.navLabel.frame.size.height, self.navLabel.frame.size.width, self.navLabel.frame.size.height);
        [self addSubview:self.backGround];
        [self addSubview:self.flowCoverView];
        [self addSubview:self.btnClose];
        [self addSubview:self.navLabel];
        [self.flowCoverView draw];
    }
    else 
    {
        if (self.flowCoverView == nil) 
        {
            self.flowCoverView  = [[[FlowCoverView alloc] initWithFrame:CGRectMake(0, 0, 1024, 358)] autorelease];
        }
        self.btnClose.frame = CGRectMake(1024/2 - 101/2, 35 - 13, 101, 38);
        self.frame = CGRectMake(0, 768, 1024, 358);
        self.flowCoverView.frame = CGRectMake(0, 40, 1024, 323);
        self.backGround.frame    = CGRectMake(0, 55, 1024, 303);
        self.navLabel.frame = CGRectMake(self.frame.size.width/2 - self.navLabel.frame.size.width/2, self.frame.size.height - self.navLabel.frame.size.height-10, self.navLabel.frame.size.width, self.navLabel.frame.size.height);
        [self addSubview:self.backGround];
        [self addSubview:self.flowCoverView];
        [self addSubview:self.btnClose];
        [self addSubview:self.navLabel];
        [self.flowCoverView draw];
    }

}

-(void) closeSnapshot
{
    if (self.isPoped == YES)
    {
        if (self.flipView != nil)
        {
            [self.flipView onNav];
        }
    }
}

- (int)flowCoverNumberImages:(FlowCoverView *)view
{
    return [self.snapshots count];
}

- (UIImage *)flowCover:(FlowCoverView *)view cover:(int)image
{
    NSString *snapresource = [self.snapshots objectAtIndex: image];
    NSString *path = [self.rootpath stringByAppendingPathComponent:snapresource];
    return   [UIImage imageWithContentsOfFile:path];
}

- (void)flowCover:(FlowCoverView *)view didSelect:(int)image
{
    if (self.isPoped)
    {
        [self popdown];
        [self.flipView gotoPage:image animate:YES];
    }
}

- (void)refreshPageNumber:(int) index;
{
    NSString *navText = [NSString stringWithFormat:@"%d / %d",index+1,[self.snapshots count]];
    if (self.snapTitles && index < [self.snapTitles count]) 
    {
        NSString *title = [self.snapTitles objectAtIndex:index];
        NSString *str = title;
        if (str && str.length > 0 && ![str isEqualToString:@"null"])
        {
            navText = [NSString stringWithFormat:@"%@ %d / %d", str, index+1,[self.snapshots count]];
        }
    }

//    if (self.bookEntity.isVerticalMode == YES) 
//    {
//        self.navLabel.frame = CGRectMake(self.view.frame.size.height/2 - self.navLabel.frame.size.width/2, self.navLabel.frame.origin.y, self.navLabel.frame.size.width, self.navLabel.frame.size.height);
//    }
//    else
//    {
//        self.navLabel.frame = CGRectMake(self.view.frame.size.width/2 - self.navLabel.frame.size.width/2, self.navLabel.frame.origin.y, self.navLabel.frame.size.width, self.navLabel.frame.size.height);
//    }

    [self.navLabel setText:navText];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    [self.backGround release];
    [self.navLabel release];
    [self.btnClose release];
    [self.flowCoverView release];
    
    [super dealloc];
}

@end
