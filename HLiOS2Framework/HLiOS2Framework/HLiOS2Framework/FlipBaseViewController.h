//
//  FlipBaseViewController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLBookEntity.h"

@class FlipBaseController;

@interface FlipBaseViewController : UIViewController

{
    
}

@property (nonatomic,assign) HLBookEntity *bookEntity;
@property (nonatomic,retain) FlipBaseController *flipController;



-(void) initStrategy:(NSString *) flipStrategy;

@end
