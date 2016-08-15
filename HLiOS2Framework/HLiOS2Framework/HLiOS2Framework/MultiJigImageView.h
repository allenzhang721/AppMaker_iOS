//
//  MultiJigImageView.h
//  MultiJig
//
//  Created by Senn, Matthew on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MultiJigImageView;

@protocol PuzzleMoveDelegate

-(Boolean)isRightGrid:(MultiJigImageView*)imageview;

@end

@interface MultiJigImageView : UIImageView
{
    CGPoint p1;
    CGPoint p2;
    CGPoint originCenter;
}
@property (nonatomic) Boolean isRightPuted;
@property (nonatomic) NSInteger grid_x;
@property (nonatomic) NSInteger grid_y;
@property (nonatomic) CGSize grid_size;
@property (nonatomic, assign) UIView *containerView;
@property (nonatomic, assign) UIView *mainView;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) id<PuzzleMoveDelegate> controller;


- (void)didGesture;

@end


