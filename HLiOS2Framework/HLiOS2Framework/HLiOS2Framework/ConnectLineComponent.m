//
//  ConnectLineComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-9.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "ConnectLineComponent.h"
#import "CALayer+WiggleAnimationAdditions.h"
#import "HLContainer.h"

#define kSapce 10
#define kBound 10
//#define kLineWidth 1 adward 13-11-22

@interface ConnectLineComponent ()
{
    UIView          *_imgView;
    UIImageView     *_beginImg;
    UIImageView     *_endImg;
    DrawLineView    *_curDrawLineView;
    NSMutableArray  *_selectTagImgArr;
    NSMutableArray  *_complentArr;
    
    float _canDrawMinX;
    float _canDrawMaxX;
    
    float _horSapce;
    
    int _rightCount;
}

@end

@implementation ConnectLineComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self != nil)
    {
        _rightCount = 0;
        self.uicomponent = [[UIView alloc] init];
        self.connectLineEntity = (ConnectLineEntity *)entity;
        self.imagePath = [entity.rootPath stringByAppendingPathComponent:entity.dataid];
    }
    return self;
}

- (void)initViewContent
{
    _selectTagImgArr = [[NSMutableArray alloc] init];
    _complentArr = [[NSMutableArray alloc] init];
    
    
    _imgView  = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.uicomponent.frame.size.width + kBound, self.uicomponent.frame.size.height + kBound)] autorelease];
    [self.uicomponent addSubview:_imgView];
    [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    
    for (int i = 0; i < _connectLineEntity.idArray.count; i++)
    {
        UIImageView *img = [[[UIImageView alloc] init] autorelease];
        img.tag = i;
        NSString *path = [self.imagePath stringByAppendingPathComponent:[_connectLineEntity.sourceArray objectAtIndex:i]];
        [img setImage:[UIImage imageWithContentsOfFile:path]];
        img.contentMode = UIViewContentModeScaleAspectFit;
        int row = _connectLineEntity.idArray.count / 2;
//        float height = (self.uicomponent.frame.size.height -  (row - 1) * _connectLineEntity.rowGap) / row;
//        float width  = (self.uicomponent.frame.size.width - _connectLineEntity.lineGap  - kSapce * 2) / 2;
//        _horSapce = width + kSapce * 2 + _connectLineEntity.lineGap;
//        img.frame = CGRectMake(kBound / 2 + _horSapce * (i % 2), kBound / 2 + (height + _connectLineEntity.rowGap) *(i / 2), width, height);
//        [_imgView addSubview:img];
        
        //modified by Adward 13-11-29 连线模版上覆盖图片有偏差
        float height = (self.uicomponent.frame.size.height -  (row - 1) * _connectLineEntity.rowGap) / row;
        float width  = (self.uicomponent.frame.size.width - _connectLineEntity.lineGap) / 2;
        _horSapce = width + _connectLineEntity.lineGap;
        if(i % 2 == 0)
        {
            img.frame = CGRectMake((_horSapce -kSapce) * (i % 2) - kSapce , (height + _connectLineEntity.rowGap) *(i / 2), width, height);
        }
        else
        {
            img.frame = CGRectMake(_horSapce* (i % 2) + kSapce, (height + _connectLineEntity.rowGap) *(i / 2), width, height);
        }
        [_imgView addSubview:img];
        
        UIImageView *selectTagImg = [[[UIImageView alloc] init] autorelease];
        selectTagImg.tag = 100 + i;
        [selectTagImg setImage:[UIImage imageNamed:@"ConnectLinePointUp.png"]];
        [selectTagImg setHighlightedImage:[UIImage imageNamed:@"ConnectLinePointDown.png"]];
        if (i % 2 == 0)
        {
            selectTagImg.frame = CGRectMake(img.frame.origin.x + img.frame.size.width + kSapce, img.frame.origin.y + (img.frame.size.height - 15) / 2, 15, 15);
        }
        else
        {
            selectTagImg.frame = CGRectMake(img.frame.origin.x - kSapce - 15, img.frame.origin.y + (img.frame.size.height - 15) / 2, 15, 15);
        }
        [_imgView addSubview:selectTagImg];
        [_selectTagImgArr addObject:selectTagImg];  
    }
    [self drawLine];
}

-(void) beginView
{
    [super beginView];
    [self initViewContent];
    [self play];
}

//开始按钮动画
- (void)beginImgAnimated
{
    ((UIImageView *)[_selectTagImgArr objectAtIndex:_beginImg.tag]).highlighted = YES;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _beginImg.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        
    }];
}

//开始按钮复原
- (void)beginImgRecovered
{
    ((UIImageView *)[_selectTagImgArr objectAtIndex:_beginImg.tag]).highlighted = NO;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _beginImg.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

//结束按钮动画
- (void)endImgAnimated
{
    ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = YES;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _endImg.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        
    }];
}

//结束按钮复原
- (void)endImgRecovered
{
    ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = NO;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _endImg.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

//结束按钮错误复原
- (void)endImgWrongRecovered
{
    _endImg.transform = CGAffineTransformMakeScale(1.0, 1.0);
    if ([_complentArr containsObject:[NSNumber numberWithInt:_endImg.tag]])
    {
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = YES;
    }
    else
    {
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = NO;
    }
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
//    self.wiggleLayer = _endImg.layer;
//    [_wiggleLayer bts_startWiggling];
}

- (void)drawLine
{
    DrawLineView *drawLineView = [[[DrawLineView alloc] initWithFrame:_imgView.frame] autorelease];
    //added by Adward 13-11-22
    drawLineView.lineWidth = self.connectLineEntity.lineWidth;
    drawLineView.lineColor = self.connectLineEntity.lineColor;
    drawLineView.lineAlpha = self.connectLineEntity.lineAlpha;
    
    drawLineView.delegate = self;
    _curDrawLineView = drawLineView;
    drawLineView.backgroundColor = [ UIColor clearColor];
    [_imgView addSubview:drawLineView];
}

//连线是否正确
- (BOOL)check
{
    if ([[_connectLineEntity.answerArray objectAtIndex:_beginImg.tag] isEqualToString:[_connectLineEntity.idArray objectAtIndex:_endImg.tag]])
    {
        _rightCount++;
        int index = _beginImg.tag / 2;
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_beginImg.tag]).highlighted = YES;
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = YES;
        [_complentArr addObject:[NSNumber numberWithInt:_beginImg.tag]];
        [_complentArr addObject:[NSNumber numberWithInt:_endImg.tag]];
        for (int i = 0; i < [self.container.entity.behaviors count]; i++)
        {
            HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_CONNECT_SIGLE"])
            {
                if (index == [behavior.behaviorValue intValue])
                {
                    [self.container runBehaviorWithEntity:behavior];
                }
            }
            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_CONNECT_ALL"] && _rightCount == self.connectLineEntity.sourceArray.count / 2)
            {
                [self.container runBehaviorWithEntity:behavior];
            }
        }
        return YES;
    }
    else
    {
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_beginImg.tag]).highlighted = NO;
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = NO;
        
        for (int i = 0; i < [self.container.entity.behaviors count]; i++)
        {
            HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_CONNECT_SIGLE_ERROR"])
            {
                [self.container runBehaviorWithEntity:behavior];
            }
        }
        return NO;
    }
}

#pragma mark - DrawLineViewDelegate

- (void)curTouchMoving:(CGPoint)point drawView:(DrawLineView *)drawView
{
    BOOL isTouchIn = NO;
    for (UIImageView *img in _imgView.subviews)
    {
        if ([img isKindOfClass:[UIImageView class]] &&  CGRectContainsPoint(img.frame, point) && img.tag < 100)
        {
            isTouchIn = YES;
            
            if (!_beginImg) //设置起点 
            {
                if (((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).highlighted)//已经练好线的不做响应
                {
                    break;
                }
                _beginImg = img;
                _canDrawMaxX = ((UIImageView *)[_selectTagImgArr objectAtIndex:1]).center.x - 2;
                _canDrawMinX = ((UIImageView *)[_selectTagImgArr objectAtIndex:0]).center.x + 2;
                
                [self beginImgAnimated];
                if (img.tag % 2  == 1) {
                    drawView.beginPoint = CGPointMake(((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.x - 1, ((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.y);
                }
                else
                {
                    drawView.beginPoint = CGPointMake(((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.x + 1, ((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.y);
                }
                drawView.endPoint = drawView.beginPoint;
            }
            else
            {
                if (fabs(img.frame.origin.x - _beginImg.frame.origin.x) < img.frame.size.width) //如果是同一侧
                {
                    break;
                }
                if (_beginImg != img && !_endImg)//设置终点
                {
                    _endImg = img;
                    [self endImgAnimated];
                }
                else
                {
                    if (_endImg && _endImg != img)//修改终点
                    {
                        [self endImgRecovered];
                        
                        if ([_complentArr containsObject:[NSNumber numberWithInt:_endImg.tag]])
                        {
                            ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = YES;
                        }
                        else
                        {
                            ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = NO;
                        }
                        _endImg = img;
                        [self endImgAnimated];
                    }
                }
                if (img.tag % 2  == 1) {
                    drawView.endPoint = CGPointMake(((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.x - 1, ((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.y);
                }
                else
                {
                    drawView.endPoint = CGPointMake(((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.x + 1, ((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.y);
                }
            }
            
            break;
        }
    }
    if (!isTouchIn && _endImg) {
        [self endImgRecovered];
        if ([_complentArr containsObject:[NSNumber numberWithInt:_endImg.tag]])
        {
            ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = YES;
        }
        else
        {
            ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = NO;
        }
        _endImg = nil;
    }
    if (_beginImg && point.x >= _canDrawMinX && point.x <= _canDrawMaxX) {
        drawView.endPoint = point;
    }
    if (_beginImg && !CGRectContainsPoint(CGRectMake(_imgView.frame.origin.x + kBound / 2, _imgView.frame.origin.y + kBound / 2, _imgView.frame.size.width - kBound, _imgView.frame.size.height - kBound), point))
    {
        drawView.endPoint = point;
    }
}

- (void)curTouchUp:(CGPoint)point
{
    BOOL isOnImg = NO;
    for (UIImageView *img in _imgView.subviews)
    {
        if ([img isKindOfClass:[UIImageView class]] &&  CGRectContainsPoint(img.frame, point))
        {
            isOnImg = YES;
            break;
        }
    }
    if (_beginImg)
    {
        [self beginImgRecovered];
        if (_endImg && isOnImg)//连线完整
        {
            if ([self check])//答案正确
            {
                [self endImgRecovered];
                ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = YES;
                _curDrawLineView.userInteractionEnabled = NO;
            }
            else//答案错误
            {
                [self endImgWrongRecovered];
                [_curDrawLineView removeFromSuperview];
            }
        }
        else//连线不完整
        {
            if (_endImg) {
                [self endImgRecovered];
            }
            [_curDrawLineView removeFromSuperview];
        }
        [self drawLine];
    }
    _beginImg = nil;
    _endImg = nil;
}

- (void)dealloc
{
    [_complentArr release];
    [_imgView removeFromSuperview];
    [_connectLineEntity release];
    [_selectTagImgArr release];
    [super dealloc];
}

@end
