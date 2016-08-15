//
//  MoueeImage.h
//  MoueeTest
//
//  Created by Pi Yi on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class ImageComponent;
@class Component;

@interface HLImage : UIImageView
{
    CGPoint p1;
    CGPoint p2;
    CGPoint downPoint;
    Boolean isEnableMoveable;// 是否随手指移动
    
    CGPoint distancePoint;
    //    ImageComponent *com;
    
    
    
    float k;
    float kx;   //陈星宇，10.25
}

@property (nonatomic, assign) BOOL      scaled;        //Mr.chen, reason, 14.03.31 
@property (nonatomic, assign) Boolean   isMoveScale;
@property (nonatomic, assign) Boolean   isEnableMoveable;
@property (nonatomic, assign) Component *com;
@property (nonatomic, assign) float     dw;
@property (nonatomic, assign) float     dh;
@property (nonatomic, assign) BOOL      isCanGotoPage;
@property (nonatomic, assign) CGPoint   startPoint;//陈星宇，10.25
//@property (nonatomic , assign) ImageComponent *com;

- (void)didGesture;


+ (UIImage *)scaledImage:(UIImage*)image width:(float)width height:(float)height;

- (id)initWithImage:(UIImage *)image width:(float)width height:(float)height;

@end
