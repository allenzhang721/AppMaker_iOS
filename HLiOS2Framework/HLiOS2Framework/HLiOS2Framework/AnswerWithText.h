//
//  AnswerWithText.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/21/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerWithText : UIView
{}

@property (nonatomic,retain) UILabel  *label;
@property (nonatomic,retain) UIButton *selectBtn;

-(void) setLabelText:(NSString *) text;
@end
