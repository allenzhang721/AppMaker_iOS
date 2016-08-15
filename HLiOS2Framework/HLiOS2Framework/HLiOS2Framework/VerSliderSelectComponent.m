//
//  VerSliderSelectComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-22.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "VerSliderSelectComponent.h"
#import "HLContainer.h"

@implementation VerSliderSelectComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.entity = (VerSliderSelectEntity *)entity;
        
        if (self.entity.itemArray.count == 0) {
            return self;
        }
        
        scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        NSString *path = [entity.rootPath stringByAppendingPathComponent :entity.dataid];
        float top = 0;
        for (int i = 0; i < self.entity.itemArray.count; i++)
        {
            float width = [[[self.entity.itemArray objectAtIndex:i] objectForKey:@"ItemWidth"] floatValue];
            float height = [[[self.entity.itemArray objectAtIndex:i] objectForKey:@"ItemHeight"] floatValue];
            NSString *imgName = [[self.entity.itemArray objectAtIndex:i] objectForKey:@"SourceID"];
            NSString *selectImgName = [[self.entity.itemArray objectAtIndex:i] objectForKey:@"SelectedSourceID"];
            NSString *imagePath = [path stringByAppendingPathComponent:imgName];
            NSString *selectImagePath = [path stringByAppendingPathComponent:selectImgName];
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.contentMode = UIViewContentModeScaleToFill; 
            btn.frame = CGRectMake(0, top, width, height);
            [btn setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithContentsOfFile:selectImagePath] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageWithContentsOfFile:selectImagePath] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithContentsOfFile:selectImagePath] forState:UIControlStateSelected | UIControlStateHighlighted];
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:btn];
            
            top += height;
        }
        
        float lastItemHeight = [[[self.entity.itemArray objectAtIndex:self.entity.itemArray.count - 1] objectForKey:@"ItemHeight"] floatValue];
        scrollView.frame = CGRectMake([self.entity.x floatValue], [self.entity.y floatValue], [self.entity.width intValue], [self.entity.height intValue]);
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, top + scrollView.frame.size.height - lastItemHeight);
        
        self.uicomponent = scrollView;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6

        [self setItemSelected:0];
    }
    return self;
}

- (void)setItemSelected:(int)index
{
    for (UIButton *btn in scrollView.subviews)
    {
        if([btn isKindOfClass:[UIButton class]])
        {
            btn.selected = NO;
            if (btn.tag == index)
            {
                btn.selected = YES;
            }
        }
    }
    
    float top = 0;
    if (index > 0)
    {
        for (int i = 0; i < index; i++)
        {
            float height = [[[self.entity.itemArray objectAtIndex:i] objectForKey:@"ItemHeight"] floatValue];
            top += height;
        }
    }
    [scrollView setContentOffset:CGPointMake(0, top) animated:YES];
}

- (void)btnClicked:(UIButton *)sender
{
    [self setItemSelected:sender.tag];
    
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CLICK"] == YES)
        {
            if (sender.tag == [behavior.behaviorValue intValue])
            {
                if ([self.container runBehaviorWithEntity:behavior])
                {
                    return;
                }
            }
        }
    }
}

-(void) change:(int)index
{
    [self setItemSelected:index];
    
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CHANGE_COMPLETE"] == YES)
        {
            if (index == [behavior.behaviorValue intValue])
            {
                if ([self.container runBehaviorWithEntity:behavior])
                {
                    return;
                }
            }
        }
    }
}

- (void)dealloc
{
    [self.entity release];
    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
    [self.uicomponent release];
    
    [super dealloc];
}

@end
