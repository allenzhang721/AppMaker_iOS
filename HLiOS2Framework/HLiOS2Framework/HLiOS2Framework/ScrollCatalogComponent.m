//
//  ScrollCatalogComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-29.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "ScrollCatalogComponent.h"
#import "HLContainer.h"

@implementation ScrollCatalogComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super initWithEntity:entity];
    if (self)
    {
        self.entity = (ScrollCatalogEntity *)entity;
        UIView *bgView = [[[UIView alloc] initWithFrame:CGRectMake([entity.x floatValue], [entity.y floatValue], [entity.width floatValue], [entity.height floatValue])] autorelease];
        
        NSString *path = [entity.rootPath stringByAppendingPathComponent :entity.dataid];
        
        leftScrollView = [[[RootSliderScrollView alloc] initWithFrame:CGRectMake(0, 0,  [entity.width floatValue] / 3.0, [entity.height floatValue])] autorelease];
        leftScrollView.loopDelegate = self;
        leftScrollView.delegate = self;
        leftScrollView.tag = 1;
        leftScrollView.isVertical = YES;
        [leftScrollView initViewContent:self.entity.leftArray path:path];
        [bgView addSubview:leftScrollView];
        
        centerScrollView = [[[RootSliderScrollView alloc] initWithFrame:CGRectMake([entity.width floatValue] / 3.0, 0,  [entity.width floatValue] / 3.0, [entity.height floatValue])] autorelease];
        centerScrollView.loopDelegate = self;
        centerScrollView.delegate = self;
        centerScrollView.tag = 2;
        centerScrollView.isVertical = YES;
        [centerScrollView initViewContent:self.entity.centerArray path:path];
        [bgView addSubview:centerScrollView];
        
        rightScrollView = [[[RootSliderScrollView alloc] initWithFrame:CGRectMake([entity.width floatValue] / 3.0 * 2, 0,  [entity.width floatValue] / 3.0, [entity.height floatValue])] autorelease];
        rightScrollView.loopDelegate = self;
        rightScrollView.delegate = self;
        rightScrollView.tag = 3;
        rightScrollView.isVertical = YES;
        [rightScrollView initViewContent:self.entity.rightArray path:path];
        [bgView addSubview:rightScrollView];
        
        self.uicomponent = bgView;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
}

-(void) beginView
{
    [super beginView];
    
    leftScrollView.contentOffset = CGPointMake(leftScrollView.contentOffset.x, leftScrollView.contentSize.height - leftScrollView.frame.size.height - 1);
    rightScrollView.contentOffset = CGPointMake(rightScrollView.contentOffset.x, rightScrollView.contentSize.height - rightScrollView.frame.size.height - 1);
    centerScrollView.contentOffset = CGPointMake(centerScrollView.contentOffset.x, centerScrollView.contentSize.height - centerScrollView.frame.size.height - 1);
    
    [self performSelector:@selector(leftDelayAnimation) withObject:nil afterDelay:.2];
    [self performSelector:@selector(centerDelayAnimation) withObject:nil afterDelay:.5];
    [self performSelector:@selector(rightDelayAnimation) withObject:nil afterDelay:.8];
}

- (void)leftDelayAnimation
{
    [UIView animateWithDuration:1.2 animations:^{
        leftScrollView.contentOffset = CGPointMake(leftScrollView.contentOffset.x, 0);
    }];
}

- (void)centerDelayAnimation
{
    [UIView animateWithDuration:1.2 animations:^{
        centerScrollView.contentOffset = CGPointMake(centerScrollView.contentOffset.x, 0);
    }];
}

- (void)rightDelayAnimation
{
    [UIView animateWithDuration:1.2 animations:^{
        rightScrollView.contentOffset = CGPointMake(rightScrollView.contentOffset.x, 0);
    }];
}

- (void)clickedAtIndex:(int)index loopSliderScrollView:(RootSliderScrollView *)view
{
    int idIndex = 0;
    if (view.tag == 1)
    {
        idIndex = [[self.entity.leftIndexArray objectAtIndex:index] intValue];
    }
    else if (view.tag == 2)
    {
        idIndex = [[self.entity.centerIndexArray objectAtIndex:index] intValue];
    }
    else
    {
        idIndex = [[self.entity.rightIndexArray objectAtIndex:index] intValue];
    }
    
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if (idIndex == [behavior.behaviorValue intValue])
        {
            if ([self.container runBehaviorWithEntity:behavior])
            {
                return;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _curScrollIndex = scrollView.tag;
    beginDrag = YES;
    lastTop = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    [self killScroll:leftScrollView];
//    [self killScroll:centerScrollView];
//    [self killScroll:rightScrollView];
}

- (void)killScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [scrollView setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [scrollView setContentOffset:offset animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float dic = scrollView.contentOffset.y - lastTop;
    float centerSpeed = 1;
    float rightSpeed = 1;
    float leftSpeed = 1;
    
    if (scrollView.tag == 1 && _curScrollIndex == 1)
    {
        if (beginDrag)
        {
            beginDrag = NO;
            [self killScroll:centerScrollView];
            [self killScroll:rightScrollView];
        }
        centerSpeed = 2;
        rightSpeed = 1.6;
        if (abs(dic) > leftScrollView.frame.size.height)
        {
            if (lastTop > scrollView.contentOffset.y)
            {
                dic = leftScrollView.loopContentHeight - lastTop + scrollView.contentOffset.y;
            }
            else
            {
                dic = -(leftScrollView.loopContentHeight - scrollView.contentOffset.y + lastTop);
            }
        }
        int centerOffset = 0;
        if (centerScrollView.contentOffset.y + dic * centerSpeed > centerScrollView.loopContentHeight)
        {
            centerOffset = centerScrollView.contentOffset.y + dic * centerSpeed - centerScrollView.loopContentHeight;
        }
        else if (centerScrollView.contentOffset.y + dic * centerSpeed < 0)
        {
            centerOffset = centerScrollView.loopContentHeight + centerScrollView.contentOffset.y + dic * centerSpeed;
        }
        else
        {
            centerOffset = centerScrollView.contentOffset.y + dic * centerSpeed;
        }
        centerScrollView.contentOffset = CGPointMake(centerScrollView.contentOffset.x, centerOffset);
        
        int rightOffset = 0;
        if (rightScrollView.contentOffset.y + dic * rightSpeed > rightScrollView.loopContentHeight)
        {
            rightOffset = rightScrollView.contentOffset.y + dic * rightSpeed - rightScrollView.loopContentHeight;
        }
        else if (rightScrollView.contentOffset.y + dic * rightSpeed < 0)
        {
            rightOffset = rightScrollView.loopContentHeight + rightScrollView.contentOffset.y + dic * rightSpeed;
        }
        else
        {
            rightOffset = rightScrollView.contentOffset.y + dic * rightSpeed;
        }
        rightScrollView.contentOffset = CGPointMake(rightScrollView.contentOffset.x, rightOffset);
    }
    else if (scrollView.tag == 2 && _curScrollIndex == 2)
    {
        if (beginDrag)
        {
            beginDrag = NO;
            [self killScroll:leftScrollView];
            [self killScroll:rightScrollView];
        }
        leftSpeed = 1.6;
        rightSpeed = 1.3;
        if (abs(dic) > centerScrollView.frame.size.height)
        {
            if (lastTop > scrollView.contentOffset.y)
            {
                dic = centerScrollView.loopContentHeight - lastTop + scrollView.contentOffset.y;
            }
            else
            {
                dic = -(centerScrollView.loopContentHeight - scrollView.contentOffset.y + lastTop);
            }
        }
        int leftOffset = 0;
        if (leftScrollView.contentOffset.y + dic * leftSpeed > leftScrollView.loopContentHeight)
        {
            leftOffset = leftScrollView.contentOffset.y + dic * leftSpeed - leftScrollView.loopContentHeight;
        }
        else if (leftScrollView.contentOffset.y + dic * leftSpeed < 0)
        {
            leftOffset = leftScrollView.loopContentHeight + leftScrollView.contentOffset.y + dic * leftSpeed;
        }
        else
        {
            leftOffset = leftScrollView.contentOffset.y + dic * leftSpeed;
        }
        leftScrollView.contentOffset = CGPointMake(leftScrollView.contentOffset.x, leftOffset);
        
        
        int rightOffset = 0;
        if (rightScrollView.contentOffset.y + dic * rightSpeed > rightScrollView.loopContentHeight)
        {
            rightOffset = rightScrollView.contentOffset.y + dic * rightSpeed - rightScrollView.loopContentHeight;
        }
        else if (rightScrollView.contentOffset.y + dic * rightSpeed < 0)
        {
            rightOffset = rightScrollView.loopContentHeight + rightScrollView.contentOffset.y + dic * rightSpeed;
        }
        else
        {
            rightOffset = rightScrollView.contentOffset.y + dic * rightSpeed;
        }
        rightScrollView.contentOffset = CGPointMake(rightScrollView.contentOffset.x, rightOffset);
    }
    else if (scrollView.tag == 3 && _curScrollIndex == 3)
    {
        if (beginDrag)
        {
            beginDrag = NO;
            [self killScroll:centerScrollView];
            [self killScroll:leftScrollView];
        }
        centerSpeed = 1.9;
        leftSpeed = 1.5;
        if (abs(dic) > rightScrollView.frame.size.height)
        {
            if (lastTop > scrollView.contentOffset.y)
            {
                dic = rightScrollView.loopContentHeight - lastTop + scrollView.contentOffset.y;
            }
            else
            {
                dic = -(rightScrollView.loopContentHeight - scrollView.contentOffset.y + lastTop);
            }
        }
        
        int leftOffset = 0;
        if (leftScrollView.contentOffset.y + dic * leftSpeed > leftScrollView.loopContentHeight)
        {
            leftOffset = leftScrollView.contentOffset.y + dic * leftSpeed - leftScrollView.loopContentHeight;
        }
        else if (leftScrollView.contentOffset.y + dic * leftSpeed < 0)
        {
            leftOffset = leftScrollView.loopContentHeight + leftScrollView.contentOffset.y + dic * leftSpeed;
        }
        else
        {
            leftOffset = leftScrollView.contentOffset.y + dic * leftSpeed;
        }
        leftScrollView.contentOffset = CGPointMake(leftScrollView.contentOffset.x, leftOffset);
        
        int centerOffset = 0;
        if (centerScrollView.contentOffset.y + dic * centerSpeed > centerScrollView.loopContentHeight)
        {
            centerOffset = centerScrollView.contentOffset.y + dic * centerSpeed - centerScrollView.loopContentHeight;
        }
        else if (centerScrollView.contentOffset.y + dic * centerSpeed < 0)
        {
            centerOffset =centerScrollView.loopContentHeight + centerScrollView.contentOffset.y + dic * centerSpeed;
        }
        else
        {
            centerOffset = centerScrollView.contentOffset.y + dic * centerSpeed;
        }
        centerScrollView.contentOffset = CGPointMake(centerScrollView.contentOffset.x, centerOffset);
    }
    
    lastTop = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    leftScrollView.scrollEnabled = YES;
//    rightScrollView.scrollEnabled = YES;
//    centerScrollView.scrollEnabled = YES;
}

- (void)dealloc
{
    [self.entity release];
    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
    [self.uicomponent release];
    
    [super dealloc];
}

@end
