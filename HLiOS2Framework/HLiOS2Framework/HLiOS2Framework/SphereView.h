//
//  SphereView.h
//  Core
//
//  Created by mac on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PIXSOWHOLECIRCLE    60

@protocol SphereViewDelegate <NSObject>

-(void)didShowPicIndex : (NSInteger) index;

@end

@interface SphereView : UIView<UIScrollViewDelegate>
{
    NSMutableArray *patharr;
    UIImageView *aniview;
    UIScrollView *scrview;
    int			currentOffset;
    int			imageIndex;
    int         sequenceSize;
    int         imageSpacing;
    NSTimer     *_timer;
}

@property Boolean isClockWise;
@property Boolean isAutoRotation;
@property Boolean isLoop;
@property Boolean isVertical;
@property Boolean isAllowZoom;
@property int speed;
@property (nonatomic, assign) id<SphereViewDelegate> delegate;

- (void)setPatharray:(NSMutableArray *)arr;
- (void)stopTimer;

@end
