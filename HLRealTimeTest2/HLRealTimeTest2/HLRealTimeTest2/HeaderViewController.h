//
//  HeaderViewController.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewControllerDelegate <NSObject>

-(void) onAddBtn;
-(void) onInfoBtn;
-(void) onSettingBtn:(id)sender;

@end

@interface HeaderViewController : UIViewController
{}

@property (nonatomic,assign) id<HeaderViewControllerDelegate> delegate;


-(IBAction)onAddBtn:(id)sender;
-(IBAction)onInfoBtn:(id)sender;
-(IBAction)onSettingBtn:(id)sender;
@end
