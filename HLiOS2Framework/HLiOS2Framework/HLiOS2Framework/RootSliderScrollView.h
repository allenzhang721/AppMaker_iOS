//
//  RootSliderScrollView.h
//  TheBeijingNews
//
//  Created by 清软 时代 on 12-11-13.
//  Copyright (c) 2012年 清软 时代. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootSliderScrollView;

@protocol RootSliderScrollViewDelegate <NSObject>

- (void)clickedAtIndex:(int)index loopSliderScrollView:(RootSliderScrollView *)view;

@end

@interface RootSliderScrollView : UIScrollView
{
    int _lastHeight;
}

@property (nonatomic, assign) id<RootSliderScrollViewDelegate> loopDelegate;
@property (nonatomic, assign)BOOL isVertical;
@property (nonatomic, assign)BOOL isCanClicked;
@property int loopContentHeight;

- (void)initViewContent:(NSArray *)imageArray path:(NSString *)path;

- (void)unloadData;

@end