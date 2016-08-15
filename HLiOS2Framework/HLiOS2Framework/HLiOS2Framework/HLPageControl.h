//
//  MoueePageControl.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-22.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HLPageControlDelegate <NSObject>

- (void)pageControlValueChange:(int)index;

@end

@interface HLPageControl : UIView
{
    int _curIndex;
    int _count;
}

@property (assign, nonatomic)id <HLPageControlDelegate> deleage;

- (id)initWithFrame:(CGRect)frame pageCount:(int)pageCount isHorizon:(BOOL)isHorizon;

- (void)setCurIndex:(int)index;

@end
