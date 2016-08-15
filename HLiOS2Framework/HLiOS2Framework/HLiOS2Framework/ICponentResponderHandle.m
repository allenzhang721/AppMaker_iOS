//
//  ICponentResponderHandle.m
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-11-5.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "ICponentResponderHandle.h"
#import "HLImage.h"
#import "HLScrollView.h"
#import "Component.h"
#import "ImageComponent.h"

#define kHLScrollView    ((HLScrollView *)self.responderView.superview)
#define kHLImage         ((HLImage *)self.responderView)

#define gap     30 //浮动半径
#define scale   0.05 //放大倍数

@interface ICponentResponderHandle ()
{
    UIView      *_curView;
    CGPoint     _p1;
    CGPoint     _p2;
    CGPoint     _startPoint;
    CGPoint     _distancePoint;
    float       k;                  //轨迹移动斜率;
    Boolean     _isStoryTelling;
    Boolean     _isMoveScale;       //MoueeImage点击，放大效果
    Component   *_com;
    float         dw;
    float         dh;
}

@end

@implementation ICponentResponderHandle

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //确定对象，image OR scrollView ?
    //container 是否能移动。若能移动，判断是否轨迹拖动
    if ([self.responderView.superview isKindOfClass:[HLScrollView class]])
    {
        _curView = kHLScrollView;
        _com      = kHLScrollView.com;
        _isMoveScale = kHLScrollView.isMoveScale;
        _isEnableMoveable = kHLScrollView.isEnableMoveable;
        
        //        if ([self.responderView isKindOfClass:[MoueeImage class]])
        //        {
        //            self.responderView.userInteractionEnabled = NO;     //取消imageView的手势
        //        }
    }
    else
    {
        _curView = kHLImage;
        _com     = kHLImage.com;
        _isMoveScale = kHLImage.isMoveScale;     //这里是scrollVIew？
        _isEnableMoveable = kHLImage.isEnableMoveable;
    }
    
    if (_isEnableMoveable == YES)
    {
        if (_isMoveScale == YES)
        {
            dw = 10;
            dh = 10;
            [self beganScaleWithWidth:dw Height:dh :_curView];
        }
        
        if ([_com.containerEntity.stroyTellPt count] > 0)
        {
            _isStoryTelling = YES;
            _startPoint = [[_com.containerEntity.stroyTellPt objectAtIndex:0] CGPointValue];
            _distancePoint = [[_com.containerEntity.stroyTellPt objectAtIndex:1] CGPointValue];
            k = (_distancePoint.y - _startPoint.y)/(_distancePoint.x - _startPoint.x);
        }
        
        UITouch *touch = [touches anyObject];
        _p1 = [touch locationInView:_curView.superview];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isEnableMoveable) {
        UITouch *touch = [touches anyObject];
        _p2 = [touch locationInView:_curView.superview];
        
        float dx = _p2.x - _p1.x;
        float dy = _p2.y - _p1.y;
        
        float moveX = 0;
        float moveY = 0;
        
        if (_isStoryTelling == YES)
        {
            CGPoint curPoint = _curView.center;
            // track move
            float maxX = MAX(_startPoint.x, _distancePoint.x);
            float maxY = MAX(_startPoint.y, _distancePoint.y);
            float minX = MIN(_startPoint.x, _distancePoint.x);
            float minY = MIN(_startPoint.y, _distancePoint.y);
            
            //浮动范围
            if (fabs(k) > 1)
            {
                maxY += gap;
                minY -= gap;
                if (k > 0)
                {
                    maxX += gap/k;
                    minX -= gap/k;
                }
                else
                {
                    maxX -= gap/k;
                    minX += gap/k;
                }
            }
            else
            {
                maxX += gap;
                minX -= gap;
                if(k > 0)
                {
                    maxY += gap*k;
                    minY -= gap*k;
                }
                else
                {
                    maxY -= gap*k;
                    minY += gap*k;
                }
            }
            
            //拖动
            if (fabs(k) > 1)
            {
                moveX = dy/k;
                moveY = dy;
                
                curPoint.x += dy/k;
                curPoint.y += dy;
            }
            else
            {
                moveX = dx;
                moveY = dx*k;
                
                curPoint.x += dx;
                curPoint.y += dx*k;
            }
            
            //移動範圍
            if (curPoint.x >= maxX)
            {
                moveX = 0;
                moveY = 0;
                curPoint.x = maxX;
            }
            else if (curPoint.x <= minX)
            {
                moveX = 0;
                moveY = 0;
                curPoint.x = minX;
            }
            
            if (curPoint.y >= maxY)
            {
                moveX = 0;
                moveY = 0;
                curPoint.y = maxY;
            }
            else if (curPoint.y <= minY)
            {
                moveX = 0;
                moveY = 0;
                curPoint.y = minY;
            }
            
            _curView.center = curPoint;
        }
        else
        {
            moveX = dx;
            moveY = dy;
            _curView.center = CGPointMake(_curView.center.x + dx, _curView.center.y + dy);
        }
        
        [self.com.container runLinkageContainerXY:moveX :moveY];
        _p1 = _p2;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isEnableMoveable == YES)
    {
        if (_isMoveScale == YES)
        {
            [self stopScaleWithWidth:dw Height:dh :_curView];
        }
        
        if (_isStoryTelling == YES)
        {
            float maxX = MAX(_startPoint.x, _distancePoint.x);
            float maxY = MAX(_startPoint.y, _distancePoint.y);
            float minX = MIN(_startPoint.x, _distancePoint.x);
            float minY = MIN(_startPoint.y, _distancePoint.y);
            
            [UIView animateWithDuration:0.2 animations:^
             {
                 
                 //移動範圍
                 CGPoint curPoint = _curView.center;
                 if (curPoint.x >= maxX)
                 {
                     curPoint.x = maxX;
                 }
                 else if (curPoint.x <= minX)
                 {
                     curPoint.x = minX;
                 }
                 
                 if (curPoint.y >= maxY)
                 {
                     curPoint.y = maxY;
                 }
                 else if (curPoint.y <= minY)
                 {
                     curPoint.y = minY;
                 }
                 _curView.center = curPoint;
                 
             }];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma runLink

-(void)runLinkageContainerWidth:(float)wchange Height :(float)hchange
{
    [self.com.container runLinkageContainerWidth:wchange Height:hchange];
}



#pragma mark - MoueeImage MoveScale Method

- (void) beganScaleWithWidth:(float)w Height:(float)h :(UIView *)imageView
{
    [UIView animateWithDuration:0.5 animations:^{
        
        imageView.transform = CGAffineTransformScale(imageView.transform, 1+scale, 1+scale);
    }];
    
}

- (void)stopScaleWithWidth:(float)dw Height:(float)dh :(UIView *)imageView
{
    //    imageView.transform = CGAffineTransformIdentity;  //有手指缩放和点击浮动放大，必须只还原点击浮动放大，不影响手指缩放
    [UIView animateWithDuration:0.5 animations:^{
        
        imageView.transform = CGAffineTransformScale(imageView.transform, 1/(1+scale), 1/(1+scale));
    }];
    
}

@end
