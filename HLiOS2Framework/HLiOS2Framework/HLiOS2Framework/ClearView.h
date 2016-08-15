//
//  ClearView.h
//  MoueeIOS2Core
//
//  Created by Allen on 12-12-1.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClearViewDelegate <NSObject>
-(void) onTouchInside:(CGPoint)point withEvent:(UIEvent *)event;
@end

@interface ClearView : UIView
@property (nonatomic,assign) id<ClearViewDelegate> delegate;

@end
