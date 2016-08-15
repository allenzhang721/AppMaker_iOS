//
//  SliderPageContainerController.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-9.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "SliderPageContainerController.h"

@implementation SliderPageContainerController

@synthesize scrollSpace;

- (id)init
{
    self = [super init];
    if (self)
    {
        lastOffsetY = 0;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    curOffsetY = scrollView.contentOffset.y;
    //    BOOL isLeftScroll = curOffsetY - lastOffsetY > 0 ? YES : NO;
    //    NSLog(@"scrollview.x = %f, %d", scrollView.contentOffset.x, curPageIndex);
    
    if (!self.page1Controller.currentPageEntity.isUseSlide)
    {
        return;
    }
    if (curOffsetY == 0 || curOffsetY == scrollSpace || curOffsetY == scrollSpace * 2)
    {
        return;
    }
    if (fabs(self.beginDragY - curOffsetY) > scrollSpace) {
        if (self.beginDragY > curOffsetY) {
            curOffsetY = self.beginDragY - scrollSpace + 0.1;
        }
        else
        {
            curOffsetY = self.beginDragY + scrollSpace - 0.1;
        }
    }
    if (self.curPageController == self.page1Controller)
    {
        if (!_isInitPos)
        {
            [self initFrame:self.page1Controller isCurPage:YES isRight:NO];
            [self initFrame:self.page2Controller isCurPage:NO isRight:NO];
            _isInitPos = YES;
        }
        if (curOffsetY >= 0)
        {
            [self resetFrame:self.page1Controller posChange:CenterToRight];
            [self resetFrame:self.page2Controller posChange:LeftToCenter];
        }
        else
        {
            [self resetFrame:self.page1Controller posChange:CenterToLeft];
            [self resetFrame:self.page2Controller posChange:CenterToLeft];
        }
    }
    else if (self.curPageController == self.page3Controller)
    {
        if (!_isInitPos)
        {
            [self initFrame:self.page2Controller isCurPage:NO isRight:YES];
            [self initFrame:self.page3Controller isCurPage:YES isRight:NO];
            _isInitPos = YES;
        }
        if (curOffsetY >= scrollSpace * 2)
        {
            [self resetFrame:self.page3Controller posChange:CenterToRight];
        }
        else
        {
            [self resetFrame:self.page3Controller posChange:CenterToLeft];
            [self resetFrame:self.page2Controller posChange:RightToCenter];
        }
    }
    else
    {
        if (!_isInitPos)
        {
            [self initFrame:self.page1Controller isCurPage:NO isRight:NO];
            [self initFrame:self.page2Controller isCurPage:YES isRight:NO];
            [self initFrame:self.page3Controller isCurPage:NO isRight:NO];
            _isInitPos = YES;
        }
        
        if (curOffsetY >= scrollSpace)
        {
            [self resetFrame:self.page2Controller posChange:CenterToRight];
            [self resetFrame:self.page3Controller posChange:LeftToCenter];
        }
        else
        {
            [self resetFrame:self.page2Controller posChange:CenterToLeft];
            [self resetFrame:self.page1Controller posChange:RightToCenter];
        }
    }
    lastOffsetY = curOffsetY;
}

- (void)initFrame:(PageController *)curPageController isCurPage:(BOOL)isCurPage isRight:(BOOL)isRight
{
    for (Container *container in curPageController.objects) {
        if (container.entity.isUseSlide && !container.entity.isPageInnerSlide)
        {
            if (curPageController == self.page1Controller)
            {
                if (isCurPage)
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue], [container.entity.y floatValue], [container.entity.width floatValue], [container.entity.height floatValue]);
                }
                else
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue] + ([container.entity.x floatValue] - [container.entity.sliderX floatValue]),
                                                                       [container.entity.y floatValue] + ([container.entity.y floatValue] - [container.entity.sliderY floatValue]),
                                                                       [container.entity.sliderWidth floatValue], [container.entity.sliderHeight floatValue]);
                }
            }
            else if (curPageController == self.page2Controller)
            {
                if (isCurPage)
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue], [container.entity.y floatValue], [container.entity.width floatValue], [container.entity.height floatValue]);
                }
                else
                {
                    if (isRight)
                    {
                        container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue] + ([container.entity.x floatValue] - [container.entity.sliderX floatValue]),
                                                                           [container.entity.y floatValue] + ([container.entity.y floatValue] - [container.entity.sliderY floatValue]),
                                                                           [container.entity.sliderWidth floatValue], [container.entity.sliderHeight floatValue]);
                    }
                    else
                    {
                        container.component.uicomponent.frame = CGRectMake([container.entity.sliderX floatValue], [container.entity.sliderY floatValue], [container.entity.sliderWidth floatValue], [container.entity.sliderHeight floatValue]);
                    }
                }
                
            }
            else
            {
                if (isCurPage)
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue], [container.entity.y floatValue], [container.entity.width floatValue], [container.entity.height floatValue]);
                }
                else
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.sliderX floatValue], [container.entity.sliderY floatValue], [container.entity.sliderWidth floatValue], [container.entity.sliderHeight floatValue]);
                }
            }
        }
    }
}

- (void)resetFrame:(PageController *)curPageController posChange:(AnimationEndPos)posChange
{
    for (Container *container in curPageController.objects)
    {
        if (container.entity.isUseSlide && !container.entity.isPageInnerSlide)
        {
            float offsetAlpha = [container.entity.alpha floatValue] - [container.entity.sliderAlpha floatValue];
            float offsetX = [container.entity.x floatValue] - [container.entity.sliderX floatValue];
            float offsetY = [container.entity.y floatValue] - [container.entity.sliderY floatValue];
            float offsetWidth = [container.entity.width floatValue] - [container.entity.sliderWidth floatValue];
            float offsetHeight = [container.entity.height floatValue] - [container.entity.sliderHeight floatValue];
            float scale = 0;
            float curX = 0;
            
            if (self.curPageController == self.page1Controller)
            {
                if (curOffsetY < 0)
                {
                    curX = - curOffsetY;
                }
                else
                {
                    curX = curOffsetY;
                }
            }
            else if (self.curPageController == self.page3Controller)
            {
                if (curOffsetY < scrollSpace * 2)
                {
                    curX = scrollSpace - ((int)curOffsetY % (int)scrollSpace + (curOffsetY - (int)curOffsetY));
                }
                else
                {
                    curX = curOffsetY - scrollSpace * 2;
                }
            }
            else
            {
                if (curOffsetY > scrollSpace) {
                    curX = (int)curOffsetY % (int)scrollSpace + curOffsetY - (int)curOffsetY;
                }
                else
                {
                    curX = scrollSpace - curOffsetY;
                }
            }
            
            scale = curX / scrollSpace;
            float disAlpha = scale * offsetAlpha;
            float disX = scale * offsetX;
            float disY = scale * offsetY;
            float disWidth = scale * offsetWidth;
            float disHeight = scale * offsetHeight;
            
            
            switch (posChange)
            {
                case LeftToCenter:
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.sliderX floatValue] + disX, [container.entity.sliderY floatValue] + disY, [container.entity.sliderWidth floatValue] + disWidth, [container.entity.sliderHeight floatValue] + disHeight);
                    container.component.uicomponent.layer.opacity = [container.entity.sliderAlpha floatValue] + disAlpha;
                    break;
                }
                case CenterToRight:
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue] + disX, [container.entity.y floatValue] + disY, [container.entity.width floatValue] - disWidth, [container.entity.height floatValue] - disHeight);
                    container.component.uicomponent.layer.opacity = [container.entity.alpha floatValue] - disAlpha;
                    break;
                }
                case CenterToLeft:
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue] - disX, [container.entity.y floatValue] - disY, [container.entity.width floatValue] - disWidth, [container.entity.height floatValue] - disHeight);
                    container.component.uicomponent.layer.opacity = [container.entity.alpha floatValue] - disAlpha;
                    break;
                }
                case RightToCenter:
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue] + ([container.entity.x floatValue] - [container.entity.sliderX floatValue]) - disX,
                                                                       [container.entity.y floatValue] + ([container.entity.y floatValue] - [container.entity.sliderY floatValue]) - disY,
                                                                       [container.entity.sliderWidth floatValue] + disWidth, [container.entity.sliderHeight floatValue] + disHeight);
                    container.component.uicomponent.layer.opacity = [container.entity.sliderAlpha floatValue] + disAlpha;
                    break;
                }
                    
                    
                    
                default:
                    break;
            }
        }
    }
}

@end
