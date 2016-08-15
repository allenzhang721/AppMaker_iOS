//
//  FlowCoverNav.h
//  Core
//
//  Created by user on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLNavView.h"
#import "FlowCoverView.h"

@interface HLFlowCoverNavigationView : HLNavView<FlowCoverViewDelegate>
{
    UIImageView   *backGround;
    UIButton      *btnClose;
    UILabel       *navLabel;
    FlowCoverView *flowCoverView;
  
}

@property (nonatomic ,retain) UIImageView   *backGround;
@property (nonatomic ,retain) FlowCoverView *flowCoverView;
@property (nonatomic ,retain) UIButton      *btnClose;
@property (nonatomic ,retain) UILabel       *navLabel;


-(void) closeSnapshot;

@end
