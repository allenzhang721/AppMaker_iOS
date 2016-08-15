//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EWMultiColumnTableView.h"

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end 

@interface NIDropDown : UIView <EWMultiColumnTableViewDataSource>

@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property int currentSelectIndex;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr;
@end
