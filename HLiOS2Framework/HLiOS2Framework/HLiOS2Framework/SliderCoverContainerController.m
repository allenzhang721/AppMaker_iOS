//
//  SliderCoverContainerController.m
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 14-1-3.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import "SliderCoverContainerController.h"

@implementation SliderCoverContainerController

@synthesize scrollSpace;

- (id)init
{
    self = [super init];
    if (self) {
        
        lastOffsetX = 0;
    }
    return self;
}


//视差滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"SliderContainerController.scrollViewDidScroll");
    curOffsetX = scrollView.contentOffset.x;
//    NSLog(@"curOffsetX = %f",curOffsetX);
    //    BOOL isLeftScroll = curOffsetX - lastOffsetX > 0 ? YES : NO;
    //    NSLog(@"scrollview.x = %f, %d", scrollView.contentOffset.x, curPageIndex);
    
//    if (!self.page1Controller.currentPageEntity.isUseSlide)
//    {
//        return;
//    }
    if (curOffsetX == 0 || curOffsetX == scrollSpace || curOffsetX == scrollSpace * 2)
    {
        return;
    }
    if (fabs(self.beginDragX - curOffsetX) > scrollSpace) {
        if (self.beginDragX > curOffsetX) {
            curOffsetX = self.beginDragX - scrollSpace + 0.1;
        }
        else
        {
            curOffsetX = self.beginDragX + scrollSpace - 0.1;
        }
    }
    if (self.curCoverController == self.page1Controller)
    {
        if (!_isInitPos)
        {
            [self initFrame:self.page1Controller isCurPage:YES isRight:NO];
            [self initFrame:self.page2Controller isCurPage:NO isRight:NO];
            _isInitPos = YES;
        }
        if (curOffsetX >= 0)
        {
            [self resetFrame:self.page1Controller posChange:TCenterToRight];
            [self resetFrame:self.page2Controller posChange:TLeftToCenter
             ];
        }
        else
        {
            [self resetFrame:self.page1Controller posChange:TCenterToLeft];
            [self resetFrame:self.page2Controller posChange:TCenterToLeft];
        }
    }
    else if (self.curCoverController == self.page3Controller)
    {
        if (!_isInitPos)
        {
            [self initFrame:self.page2Controller isCurPage:NO isRight:YES];
            [self initFrame:self.page3Controller isCurPage:YES isRight:NO];
            _isInitPos = YES;
        }
        if (curOffsetX >= scrollSpace * 2)
        {
            [self resetFrame:self.page3Controller posChange:TCenterToRight];
        }
        else
        {
            [self resetFrame:self.page3Controller posChange:TCenterToLeft];
            [self resetFrame:self.page2Controller posChange:TRightToCenter];
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
        
        if (curOffsetX >= scrollSpace)
        {
            [self resetFrame:self.page2Controller posChange:TCenterToRight];
            [self resetFrame:self.page3Controller posChange:TLeftToCenter];
        }
        else
        {
            [self resetFrame:self.page2Controller posChange:TCenterToLeft];
            [self resetFrame:self.page1Controller posChange:TRightToCenter];
        }
    }
    lastOffsetX = curOffsetX;
}


- (void)initFrame:(PageViewController *)curPageController isCurPage:(BOOL)isCurPage isRight:(BOOL)isRight
{
    for (Container *container in curPageController.pageController.objects) {
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

- (void)resetFrame:(PageViewController *)curPageController posChange:(TAnimationEndPos)posChange
{
    //    NSLog(@"resetFrame");
    for (Container *container in curPageController.pageController.objects)
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
            
            if (curPageController == self.page1Controller)
            {
                if (curOffsetX < 0)
                {
                    curX = - curOffsetX;
                }
                else
                {
                    curX = curOffsetX;
                }
            }
            else if (curPageController == self.page3Controller)
            {
                if (curOffsetX < scrollSpace * 2)
                {
                    curX = scrollSpace - ((int)curOffsetX % (int)scrollSpace + (curOffsetX - (int)curOffsetX));
                }
                else
                {
                    curX = curOffsetX - scrollSpace * 2;
                }
            }
            else
            {
                if (curOffsetX > scrollSpace) {
                    curX = (int)curOffsetX % (int)scrollSpace + curOffsetX - (int)curOffsetX;
                }
                else
                {
                    curX = scrollSpace - curOffsetX;
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
                case TLeftToCenter:
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.sliderX floatValue] + disX, [container.entity.sliderY floatValue] + disY, [container.entity.sliderWidth floatValue] + disWidth, [container.entity.sliderHeight floatValue] + disHeight);
                    container.component.uicomponent.layer.opacity = [container.entity.sliderAlpha floatValue] + disAlpha;
                    break;
                }
                case TCenterToRight:
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue] + disX, [container.entity.y floatValue] + disY, [container.entity.width floatValue] - disWidth, [container.entity.height floatValue] - disHeight);
                    container.component.uicomponent.layer.opacity = [container.entity.alpha floatValue] - disAlpha;
                    break;
                }
                case TCenterToLeft:
                {
                    container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue] - disX, [container.entity.y floatValue] - disY, [container.entity.width floatValue] - disWidth, [container.entity.height floatValue] - disHeight);
                    container.component.uicomponent.layer.opacity = [container.entity.alpha floatValue] - disAlpha;
                    break;
                }
                case TRightToCenter:
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
