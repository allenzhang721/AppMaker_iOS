//
//  DrawLineView.h
//  DrawLineTest
//
//  Created by Mouee-iMac on 13-5-7.
//  Copyright (c) 2013年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectLineEntity.h"

@class DrawLineView;

@protocol DrawLineViewDelegate <NSObject>

- (void)curTouchMoving:(CGPoint)point drawView:(DrawLineView *)drawView;
- (void)curTouchUp:(CGPoint)point;

@end

@interface DrawLineView : UIView
{
}

@property int lineWidth;
//added by Adward 13-11-22
@property (nonatomic , retain) NSString *lineColor;
@property float lineAlpha;

@property (nonatomic, assign) id<DrawLineViewDelegate> delegate;

@property (nonatomic) CGPoint beginPoint;

@property (nonatomic) CGPoint endPoint;

@end
