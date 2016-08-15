//
//  DrawerComponent.m
//  Core
//
//  Created by sun yongle on 25/07/12.
//  Copyright (c) 2012年 PEM. All rights reserved.
//

#import "DrawerComponent.h"
#import "HLCustomSegmentedControl.h"
#import "HLPageEntity.h"
#import "HLBookEntity.h"
#import "HLContainer.h"
#import "HLPageController.h"

#define KNOTIFICATION_PAGEVIEWTAP @"PageViewTap"

@interface DrawerComponent ()
{
    Boolean isVerticalMode;
    
    HLCustomSegmentedControl *menuView;
    UIButton *showMenu;
    
    BOOL menuShowed;
}
@property (nonatomic, retain) DrawerEntity *drawerEntity;
@property (nonatomic, retain) NSString *imagePath;


-(void)showMenuBtnClicked : (id)sender;

-(void)segAction : (id)sender;

@end

@implementation DrawerComponent

@synthesize drawerEntity;
@synthesize imagePath;

-(CGRect)getSideViewRect : (CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    CGSize point = self.container.page.frame.size;
//    
//    if (isVerticalMode)
//    {
//        rect = CGRectMake((point.width - size.width) /2, point.height - size.height, size.width, size.height);
//    }
//    else 
//    {
//        rect = CGRectMake(point.width - size.width, (point.height - size.height) / 2, size.width, size.height);
//    }
    return rect;
}

-(void)setShowMenuBtn
{
    showMenu = [[UIButton alloc] initWithFrame:CGRectNull];
    showMenu.backgroundColor = [UIColor clearColor];
    NSString *path = [self.imagePath stringByAppendingPathComponent:self.drawerEntity.btnPic];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [showMenu setBackgroundImage:image forState:UIControlStateNormal];
    
    path = [self.imagePath stringByAppendingPathComponent:self.drawerEntity.btnSelPic];
    image = [UIImage imageWithContentsOfFile:path];
    [showMenu setBackgroundImage:image forState:UIControlStateHighlighted];
    
    [showMenu addTarget:self action:@selector(showMenuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (isVerticalMode)//2013.04.22
    {
        showMenu.frame = CGRectMake(([self.drawerEntity.width floatValue] - image.size.width) / 2, ([self.drawerEntity.height floatValue] - image.size.height) , image.size.width, image.size.height);
    }
    else{
        showMenu.frame = CGRectMake([self.drawerEntity.width floatValue] - image.size.width, ([self.drawerEntity.height floatValue] - image.size.height) / 2, image.size.width, image.size.height);
    }
}

-(CGRect)getMenuRect : (BOOL) show
{
    CGSize size = CGSizeMake([self.drawerEntity.width floatValue], [self.drawerEntity.height floatValue]);
    CGRect rect = [self getSideViewRect:size];
    
    if (!show) 
    {
        if (isVerticalMode) 
        {
            rect.origin.y = rect.origin.y + rect.size.height;
        }
        else 
        {
            rect.origin.x = rect.origin.x + rect.size.width;
        }
    }
    return rect;
}

-(void)setMenuView
{
    CGRect rect = [self getMenuRect:NO];
    if (isVerticalMode) 
    {
        menuView = [[HLCustomSegmentedControl alloc] initWithFrame :rect numberButton:self.drawerEntity.segCount];
    }
    else 
    {
        menuView = [[HLCustomSegmentedControl alloc] initWithVerticalFrame:rect numberButton:self.drawerEntity.segCount];
    }
    menuView.selState = UIControlStateHighlighted;
    for (int i=0; i < self.drawerEntity.segBtnPics.count; ++i) 
    {
        NSString *path = [self.drawerEntity.segBtnPics objectAtIndex:i];
        path = [self.imagePath stringByAppendingPathComponent:path];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        path = [self.drawerEntity.segBtnSelPics objectAtIndex:i];
        path = [self.imagePath stringByAppendingPathComponent:path];
        UIImage *selImage = [UIImage imageWithContentsOfFile:path];
        [menuView setButtonSelectedImage:selImage normalImage:image withButtonTag:i];
    }
    [menuView setAllunselected];
    [menuView addTarget:self action:@selector(segAction:)];
}

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self != nil)
    {
        self.uicomponent = [[UIView alloc] init];
        self.drawerEntity = (DrawerEntity *)entity;
//        self.drawerEntity = (DrawerEntity*)self.containerEntity;
        self.imagePath = [entity.rootPath stringByAppendingPathComponent:entity.dataid];
        isVerticalMode = NO;
        menuShowed = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageViewTap) name:KNOTIFICATION_PAGEVIEWTAP object:nil];
    }
    return self;
}

-(void) beginView
{
    [super beginView];
    [self play];
}

//-(id) initWithEntity : (DrawerEntity *)entity path : (NSString *)path
//{
//    self = [super init];
//    if (self)
//    {
//        self.drawerEntity = entity;
//        self.imagePath = path;
//        isVerticalMode = NO;
//        menuShowed = NO;
//    }
//    return self;
//}

-(void)play
{
    if (!showMenu) 
    {
        //方向的判断 2013.04.22
        if (self.container.pageController.bookEntity.isVerHorMode)
        {
            if (self.container.pageController.currentPageEntity.isVerticalPageType)
            {
                isVerticalMode = YES;
            }
        }
        else if (self.container.pageController.bookEntity.isVerticalMode)
        {
            isVerticalMode = YES;
        }
        
        [self setMenuView];
        [self setShowMenuBtn];
    }
    menuView.frame = [self getMenuRect:NO];
    [self.uicomponent addSubview:menuView];
    menuView.hidden = YES;
    menuShowed = NO;
    [self.uicomponent addSubview:showMenu];
    
    [self.uicomponent bringSubviewToFront:menuView];
    [self.uicomponent bringSubviewToFront:showMenu];
}

-(void)stop
{
    [showMenu removeFromSuperview];
    [menuView removeFromSuperview];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_PAGEVIEWTAP object:nil];
    [self.uicomponent release];
    [self.drawerEntity release];
    [self.imagePath release];
    [showMenu release];
    [menuView release];
    [super dealloc];
}

-(void)showMenuBtnClicked:(id)sender
{
    [self showMenu:YES];
}

-(void)showMenu:(Boolean)show
{
    if (menuShowed == show) 
    {
        NSLog(@"menu already in state %d", show);
        return;
    }
    menuShowed = show;
    CGRect rect = [self getMenuRect:show];
    if (show) 
    {
        menuView.hidden = NO;
        showMenu.hidden = show;
        [UIView animateWithDuration:0.5 animations:^{
            menuView.frame = rect;
        }];
    }
    else 
    {
        [UIView animateWithDuration:0.5 animations:^{
            menuView.frame = rect;
        }completion:^(BOOL finished){
            menuView.hidden = YES;
            showMenu.hidden = show;
        }];
    }
}

-(void)segAction : (id)sender
{
    [self retain];
    [self.container retain];
    
    NSInteger index = [menuView getSelectedSegmentIndex];
    
    int count = [self.container.entity.behaviors count];
    for (int i = 0; i < count; i++)
    {
        if (i >= [self.container.entity.behaviors count]) 
        {
            NSLog(@"segAction: index out of range %d", i);
            break;
        }
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        NSArray *array  = [behavior.value componentsSeparatedByString:@";"];
        if ([array count] > 0 )
        {
            NSString *n = [array objectAtIndex:0];
            if ([n integerValue] == index)
            {
                if ([array count] > 1)
                {
                    [self.container runBehavior:behavior.eventName index:i];//2013.04.22
//                    [self.container.page runBehavior:behavior.functionObjectID :behavior.functionName : [array objectAtIndex:1]:self.container.entity.entityid];
                }
                else
                {
                    [self.container runBehavior:behavior.eventName index:i];
//                    [self.container.page runBehavior:behavior.functionObjectID :behavior.functionName : nil:self.container.entity.entityid];
                }
                
            }
        }
    }
    [menuView setAllunselected];
    
    [self performSelector:@selector(release) withObject:nil afterDelay:0.3f];
    [self.container performSelector:@selector(release) withObject:nil afterDelay:0.3f];
//    [self showMenu:NO];
}

-(BOOL)pointInside : (CGPoint) point
{
    if (menuShowed) 
    {
        return CGRectContainsPoint(menuView.frame, point);
    }
    return CGRectContainsPoint(showMenu.frame, point);
}

- (void)pageViewTap
{
    [self showMenu:NO];
}

@end
