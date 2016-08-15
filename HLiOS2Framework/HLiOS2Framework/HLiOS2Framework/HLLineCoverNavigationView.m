//
//  LineCoverNav.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/24/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLLineCoverNavigationView.h"
#import "HLFlipBaseController.h"
#import "HLLineCoverCell.h"

@implementation HLLineCoverNavigationView

@synthesize tableViewCover;
@synthesize bgImg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) load
{
    self.tableViewCover = [[[UITableView alloc] init] autorelease];
    self.tableViewCover.dataSource = self;
    self.tableViewCover.delegate   = self;
    self.tableViewCover.transform = CGAffineTransformMakeRotation(M_PI / 2 *3);
    self.tableViewCover.backgroundColor = [UIColor clearColor];
    self.tableViewCover.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableViewCover.showsHorizontalScrollIndicator = NO;
    self.tableViewCover.showsVerticalScrollIndicator   = NO;
    self.tableViewCover.clipsToBounds                  = YES;
    self.isTableViewInit                               = NO;
    self.userInteractionEnabled = YES;
    self.bgImg = [[[UIImageView alloc] init] autorelease];
    [self.bgImg   setImage:[UIImage imageNamed:@"lc_bg.png"]];
    [self addSubview:self.bgImg];
    self.btnClose = [[[UIButton alloc] init] autorelease];
    UIImage *cn   = [UIImage imageNamed:@"pop_btn_n.png"];
    [self.btnClose setImage:cn forState:UIControlStateNormal];
    self.btnClose.frame = CGRectMake(0, 0, cn.size.width, cn.size.height);
    [self addSubview:self.btnClose];
    self.backgroundColor = [UIColor clearColor];
    [self.btnClose addTarget:self action:@selector(popdown) forControlEvents:UIControlEventTouchUpInside];
    self.isPoped    = NO;
    [self addSubview:self.tableViewCover];
    if (self.snapshots == nil)
    {
        self.snapshots = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    }
    
    if (self.isVertical == YES)
    {
        [self changeToVertical];
    }
    else
    {
        [self changeToHorizontal];
    }
}

-(void) changeToHorizontal
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            if (screenBounds.size.width < screenBounds.size.height)
            {
                screenBounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
            }
        }
        self.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, 220);
        self.bgImg.frame = CGRectMake(0, self.frame.size.height - 191, self.frame.size.width, 191);
        self.btnClose.frame = CGRectMake(self.frame.size.width/2 - self.btnClose.frame.size.width/2, 10, self.btnClose.frame.size.width, self.btnClose.frame.size.height);
        if (self.isTableViewInit == NO)
        {
            self.tableViewCover.frame = CGRectMake(0, self.frame.size.height - 191, self.frame.size.width, 220);
            self.isTableViewInit = YES;
        }
        self.isVertical = NO;
        [self.tableViewCover reloadData];
    }
    else
    {
            self.frame = CGRectMake(0, 768, 1024, 220);
            self.bgImg.frame = CGRectMake(0, self.frame.size.height - 191, self.frame.size.width, 191);
            self.btnClose.frame = CGRectMake(self.frame.size.width/2 - self.btnClose.frame.size.width/2, 10, self.btnClose.frame.size.width, self.btnClose.frame.size.height);
            if (self.isTableViewInit == NO)
            {
                self.tableViewCover.frame = CGRectMake(0, self.frame.size.height - 191, self.frame.size.width, 220);
                self.isTableViewInit = YES;
            }
            self.isVertical = NO;
            [self.tableViewCover reloadData];
    }
}

-(void) changeToVertical
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            if (screenBounds.size.width > screenBounds.size.height)
            {
                screenBounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
            }
        }
        self.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, 220);
        self.bgImg.frame = CGRectMake(0, self.frame.size.height - 191, self.frame.size.width, 191);
        self.btnClose.frame = CGRectMake(self.frame.size.width/2 - self.btnClose.frame.size.width/2, 10, self.btnClose.frame.size.width, self.btnClose.frame.size.height);
        if (self.isTableViewInit == NO)
        {
            self.tableViewCover.frame = CGRectMake(0, self.frame.size.height - 191, self.frame.size.width, 220);
            self.isTableViewInit = YES;
        }
        self.isVertical = YES;
        [self.tableViewCover reloadData];
    }
    else
    {
            self.frame = CGRectMake(0, 1024, 768, 220);
            self.bgImg.frame = CGRectMake(0, self.frame.size.height - 191, self.frame.size.width, 191);
            self.btnClose.frame = CGRectMake(self.frame.size.width/2 - self.btnClose.frame.size.width/2, 10, self.btnClose.frame.size.width, self.btnClose.frame.size.height);
            if (self.isTableViewInit == NO)
            {
                self.tableViewCover.frame = CGRectMake(0, self.frame.size.height - 191, self.frame.size.width, 220);
                 self.isTableViewInit = YES;
            }
            self.isVertical = YES;
            [self.tableViewCover reloadData];
    }
}


-(void) popup
{
    if (self.isPoped == NO)
    {
        self.hidden = NO;
        [UIView beginAnimations:@"Move" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        CGRect rect = self.frame;
        self.frame = CGRectMake(rect.origin.x, rect.origin.y - rect.size.height, rect.size.width, rect.size.height);
        [UIView commitAnimations];
        self.isPoped = YES;
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.flipView.currentPageIndex inSection:0];
        [self.tableViewCover selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionMiddle];
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
        [self.flipView popDownControlPanel];
    }
    else
    {
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Line";
    HLLineCoverCell *cell = (HLLineCoverCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[HLLineCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	}
    NSString *snapresource = [self.snapshots objectAtIndex: [indexPath row] ];
    NSString *path = [self.rootpath stringByAppendingPathComponent:snapresource];
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    if ([self.snapTitles count] >[indexPath row])
    {
        cell.title.text  = [self.snapTitles objectAtIndex:[indexPath row]];
    }
    else
    {
        cell.title.text = @"";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSnapshot:path];
    if (self.isVertical == YES)
    {
        [cell changeToVertical];
    }
    else
    {
        [cell changeToHorizontal];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isVertical == YES)
    {
        return 150;
    }
    else
    {
        return 270;
    }    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.flipView gotoPage:[indexPath row] animate:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.snapshots count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc] init] autorelease];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc] init] autorelease];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *sub in self.subviews)
    {
        CGPoint tmp = [sub convertPoint:point fromView:self];
        if ([sub pointInside:tmp withEvent:event])
        {
            return YES;
        }
    }
    return NO;
}

-(void) refresh
{
    [self.tableViewCover reloadData];
}

- (void)dealloc
{
    [self.tableViewCover release];
    [self.bgImg removeFromSuperview];
    [self.bgImg release];
    [self.btnClose removeFromSuperview];
    [self.btnClose release];
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
