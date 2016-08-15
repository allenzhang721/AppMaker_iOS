//
//  SlideCellComponent.m
//  Core
//
//  Created by sun yongle on 12/08/12.
//  Copyright (c) 2012年 PEM. All rights reserved.
//

#import "SlideCellComponent.h"
#import "HLContainer.h"
#import "SlideCell.h"
#import "GmGridView.h"
#import "GMGridViewLayoutStrategies.h"

@interface SlideCellComponent ()
{
    GMGridView *gridview;
    NSInteger curSelIndex;
    float cellWidth;
    float cellHeight;
    Boolean isClean;
}
@property (nonatomic, retain) SlideCellEntity *cellEntity;
@property (nonatomic, retain) NSString *imagePath;

@end

@implementation SlideCellComponent

@synthesize cellEntity;
@synthesize imagePath;

- (id)initWithEntity:(SlideCellEntity*)entity
{
    self = [super init];
    NSString *path = [entity.rootPath stringByAppendingPathComponent:entity.dataid];
    if (self) 
    {
        self.cellEntity = entity;
        self.imagePath = path;
        
//        UIView *view = [[[UIView alloc] initWithFrame: CGRectNull] autorelease];
//       [view addSubview:gridview];

        gridview = [[GMGridView alloc] initWithFrame:CGRectMake(0, 0, [self.cellEntity.width floatValue], [self.cellEntity.height floatValue])] ;
        
        self.uicomponent = gridview;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
        isClean          = NO;
    }

    return self;
}

- (void)beginView
{
    [super beginView];
    [self initGrid];
}
- (void)initGrid
{
    curSelIndex = -1;
//    gridview = [[GMGridView alloc] initWithFrame:CGRectMake(0, 0, [self.cellEntity.width floatValue], [self.cellEntity.height floatValue])] ;
    gridview.bounces = YES;
    gridview.clipsToBounds = YES;
    gridview.showsVerticalScrollIndicator = NO;
    gridview.showsHorizontalScrollIndicator = NO;
    gridview.style = GMGridViewStyleSwap;
    gridview.itemSpacing = 0;
    gridview.itemVerSpacing = 0;
    gridview.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    gridview.centerGrid = NO;
    gridview.ignoreLongPress = YES;
    gridview.actionDelegate = (id<GMGridViewActionDelegate>)self;
    if (!self.cellEntity.isVirtical) 
    {
        gridview.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal]; 
        cellWidth = self.cellEntity.cellWidth;
        cellHeight = [self.cellEntity.height intValue];
        gridview.alwaysBounceVertical = NO;
    }
    else 
    {
        cellWidth = [self.cellEntity.width intValue];
        cellHeight = self.cellEntity.cellHeight;
        gridview.alwaysBounceHorizontal = NO;
    }
    
    gridview.dataSource = (id<GMGridViewDataSource>)self;
    gridview.editing = NO;
//    [self.uicomponent addSubview:gridview];
}

- (void)stop
{
    isClean = YES;
//    [gridview reloadData];
}

-(void) clean
{
    isClean = YES;
//    [gridview reloadData];
}

- (void)dealloc
{
    [gridview removeFromSuperview];
    [gridview release];
    self.imagePath = nil;
    self.cellEntity = nil;
    self.uicomponent = nil;
    [super dealloc];
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    if (isClean == YES)
    {
        return 0;
    }
    else
    {
        return [self.cellEntity.normalImages count];
    }
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(cellWidth, cellHeight);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
//    NSLog(@"Creating view indx %d", index);
    
    if (!self.cellEntity.normalImages || index >= [self.cellEntity.normalImages count]) 
    {
        return nil;
    }
    SlideCell *cell = (SlideCell*)[gridView dequeueReusableCell];
    if (!cell) 
    {
        cell = [[[SlideCell alloc] init] autorelease];
        cell.cellWidth = cellWidth;
        cell.cellHeight = cellHeight;
        cell.delegate = (id<SlideCellDelegate>)self;
    }
    NSString *name = [self.cellEntity.normalImages objectAtIndex:index];
    NSString *path = [self.imagePath stringByAppendingPathComponent:name];
    
    cell.imageNormal = path;;
    if (index < [self.cellEntity.selImages count]) 
    {
        name = [self.cellEntity.selImages objectAtIndex:index];
        path = [self.imagePath stringByAppendingPathComponent:name];
        
        cell.imagePressed = path;
    }
    cell.isSelected = (curSelIndex == index);
    cell.index = index;
    [cell refreshInfo];
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
}


- (void)slideCell:(SlideCell*)cell CellClicked:(id)sender
{
    NSInteger position = cell.index;
    curSelIndex = position;
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CLICK"] && position == [behavior.behaviorValue intValue])
        {
            if ([self.container runBehaviorWithEntity:behavior])
            {
                return;
            }
        }
    }    
}



@end
