//
//  HorConnectLineComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-8.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HorConnectLineComponent.h"
#import "CALayer+WiggleAnimationAdditions.h"
#import "HLContainer.h"

#define kSapce 10
#define kBound 10
//#define kLineWidth 1 adward 13-11-22

@interface HorConnectLineComponent ()
{
    UIView          *_imgView;
    UIImageView     *_beginImg;
    UIImageView     *_endImg;
    DrawLineView    *_curDrawLineView;
    NSMutableArray  *_selectTagImgArr;
    NSMutableArray  *_complentArr;
    
    float _canDrawMinY;
    float _canDrawMaxY;
    
    float _verSapce;
    
    int _rightCount;
}

@end

@implementation HorConnectLineComponent

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

        float width = (self.uicomponent.frame.size.width -  (row - 1) * _connectLineEntity.rowGap) / row;
//        float height  = (self.uicomponent.frame.size.height - _connectLineEntity.lineGap  - kSapce * 2) / 2;
        float height  = (self.uicomponent.frame.size.height - _connectLineEntity.lineGap) / 2;//modified by Adward 13-11-29

//        _verSapce = height + kSapce * 2 + _connectLineEntity.lineGap;
        _verSapce = height + _connectLineEntity.lineGap;//modified by Adward 13-11-29

//        img.frame = CGRectMake(kBound / 2 + (width + _connectLineEntity.rowGap) * (i / 2), kBound / 2 + _verSapce * (i % 2) , width, height);
        img.frame = CGRectMake((width + _connectLineEntity.rowGap) * (i / 2),  _verSapce * (i % 2) , width, height);//modified by Adward 13-11-29

        [_imgView addSubview:img];
     
        UIImageView *selectTagImg = [[[UIImageView alloc] init] autorelease];
        selectTagImg.tag = 100 + i;
        [selectTagImg setImage:[UIImage imageNamed:@"ConnectLinePointUp.png"]];
        [selectTagImg setHighlightedImage:[UIImage imageNamed:@"ConnectLinePointDown.png"]];
        if (i % 2 == 0)
        {
            selectTagImg.frame = CGRectMake(img.frame.origin.x + (img.frame.size.width - 15) / 2, img.frame.origin.y + img.frame.size.height + kSapce, 15, 15);
        }
        else
        {
            selectTagImg.frame = CGRectMake(img.frame.origin.x + (img.frame.size.width - 15) / 2, img.frame.origin.y - kSapce - 15, 15, 15);
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
- (void)connectEnd:(BOOL)correct {
    if (correct) {
        _rightCount++;
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_beginImg.tag]).highlighted = YES;
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = YES;
        [_complentArr addObject:[NSNumber numberWithInteger:_beginImg.tag]];
        [_complentArr addObject:[NSNumber numberWithInteger:_endImg.tag]];
        
    } else {
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_beginImg.tag]).highlighted = NO;
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = NO;
    }
}

- (int)connectCorrectIndex:(BOOL)correct {
    if (correct) {
        return _beginImg.tag % 2 == 0 ? _beginImg.tag / 2 : _endImg.tag / 2;
    } else {
        return -1;
    }
}

- (void)connectEndRunBehavior:(BOOL)correct atIndex:(int)index {
    if (index < 0) {
        return;
    }
    
    if (correct) {
        for (int i = 0; i < [container.entity.behaviors count]; i++) {
            HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
            
            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_CONNECT_SIGLE"]) {
                if (index == [behavior.behaviorValue intValue]) {
                    [self.container runBehaviorWithEntity:behavior];
                    return;
                }
            } else if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_CONNECT_ALL"] && _rightCount == self.connectLineEntity.sourceArray.count / 2) {
                [self.container runBehaviorWithEntity:behavior];
                return;
            }
        }
    } else {
        for (int i = 0; i < [self.container.entity.behaviors count]; i++) {
            HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_CONNECT_SIGLE_ERROR"]) {
                [self.container runBehaviorWithEntity:behavior];
                return;
            }
        }
    }
}

- (BOOL)connectCorrect {
    if ([[_connectLineEntity.answerArray objectAtIndex:_beginImg.tag] isEqualToString:[_connectLineEntity.idArray objectAtIndex:_endImg.tag]])
    {
//        _rightCount++;
//        int index = _beginImg.tag % 2 == 0 ? _beginImg.tag / 2 : _endImg.tag / 2;
//        ((UIImageView *)[_selectTagImgArr objectAtIndex:_beginImg.tag]).highlighted = YES;
//        ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = YES;
//        [_complentArr addObject:[NSNumber numberWithInteger:_beginImg.tag]];
//        [_complentArr addObject:[NSNumber numberWithInteger:_endImg.tag]];
//        for (int i = 0; i < [container.entity.behaviors count]; i++) {
//            HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
//            
//            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_CONNECT_SIGLE"]) {
//                if (index == [behavior.behaviorValue intValue]) {
//                    [self.container runBehaviorWithEntity:behavior];
//                }
//            }
//            
//            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_CONNECT_ALL"] && _rightCount == self.connectLineEntity.sourceArray.count / 2) {
//                [self.container runBehaviorWithEntity:behavior];
//            }
//        }
        return YES;
    } else {
//        ((UIImageView *)[_selectTagImgArr objectAtIndex:_beginImg.tag]).highlighted = NO;
//        ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = NO;
        
//        for (int i = 0; i < [self.container.entity.behaviors count]; i++)
//        {
//            HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
//            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_CONNECT_SIGLE_ERROR"])
//            {
//                [self.container runBehaviorWithEntity:behavior];
//            }
//        }
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
                _canDrawMaxY = ((UIImageView *)[_selectTagImgArr objectAtIndex:1]).center.y - 2;
                _canDrawMinY = ((UIImageView *)[_selectTagImgArr objectAtIndex:0]).center.y + 2;
                
                [self beginImgAnimated];
                if (img.tag % 2  == 1) {
                    drawView.beginPoint = CGPointMake(((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.x, ((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.y);// modified by Adward 13-12-05 连线有偏差
                }
                else
                {
                    drawView.beginPoint = CGPointMake(((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.x, ((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.y);
                }
                drawView.endPoint = drawView.beginPoint;
            }
            else
            {
                if (fabs(img.frame.origin.y - _beginImg.frame.origin.y) < img.frame.size.height) //如果是同一侧
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
                    drawView.endPoint = CGPointMake(((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.x , ((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.y);
                }
                else
                {
                    drawView.endPoint = CGPointMake(((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.x, ((UIImageView *)[_selectTagImgArr objectAtIndex:img.tag]).center.y);
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
    if (_beginImg && point.y >= _canDrawMinY && point.y <= _canDrawMaxY) {
        drawView.endPoint = point;
    }
    if (_beginImg && !CGRectContainsPoint(CGRectMake(_imgView.frame.origin.x + kBound / 2, _imgView.frame.origin.y + kBound / 2, _imgView.frame.size.width - kBound, _imgView.frame.size.height - kBound), point))
    {
        drawView.endPoint = point;
    }
}

- (void)curTouchUp:(CGPoint)point {
    BOOL isOnImg = NO;
    for (UIImageView *img in _imgView.subviews) {
        if ([img isKindOfClass:[UIImageView class]] &&  CGRectContainsPoint(img.frame, point)) {
            isOnImg = YES;
            break;
        }
    }
    [self beginImgRecovered];
    BOOL connectCorrect = [self connectCorrect];
    int index = [self connectCorrectIndex: connectCorrect];
    [self connectEnd: connectCorrect];
    if (_beginImg && _endImg && isOnImg && connectCorrect) { //连线完整
//        [self beginImgRecovered];
//        if (){
//            if ([self connectCorrect]) {//答案正确
        [self endImgRecovered];
        ((UIImageView *)[_selectTagImgArr objectAtIndex:_endImg.tag]).highlighted = YES;
        _curDrawLineView.userInteractionEnabled = NO;
//            } else {//答案错误
//                [self endImgWrongRecovered];
//                [_curDrawLineView removeFromSuperview];
//            }
//        } else {//连线不完整
//            
//        }
        
    } else {
        [self endImgRecovered];
        [_curDrawLineView removeFromSuperview];
    }
    
    [self drawLine];
    _beginImg = nil;
    _endImg = nil;
    
    [self connectEndRunBehavior: connectCorrect atIndex: index];
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
