//
//  NavView.h
//  Core
//
//  Created by user on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLFlipBaseController;

@interface HLNavView : UIView
{
    NSMutableArray  *snapshots;
    NSMutableArray  *snapTitles;
    NSString *rootpath;
    NSString *mode;
    HLFlipBaseController *flipView;
    Boolean  isPoped;
    int currentPageIndex;
    Boolean  isVertical;
}

@property (nonatomic ,retain) NSMutableArray *allSectionPageId;
@property (nonatomic ,retain) NSMutableArray *allPageIdArr;
@property (nonatomic ,retain) NSMutableArray *snapshotsIndesign;
@property (nonatomic ,retain) NSMutableArray *snapshots;
@property (nonatomic ,retain) NSMutableArray *snapTitles;
@property (nonatomic ,retain) NSString *rootpath;
@property (nonatomic ,retain) NSString *mode;
@property (nonatomic ,assign) HLFlipBaseController *flipView;
@property Boolean isPoped;
@property Boolean isVertical;
@property int currentPageIndex;
@property Boolean isSectionChange;
-(void) load;
-(void) popup;
-(void) popdown;
-(void) hide;
-(void) refresh;
-(void) changeToVertical;
-(void) changeToHorizontal;
@end
