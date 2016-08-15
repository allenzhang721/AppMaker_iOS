//
//  ADButtonView.m
//  HLiOS2Framework
//
//  Created by Adward on 14-3-7.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import "ADButtonView.h"

@implementation ADButtonView
@synthesize upImg,downImg;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setup
{
    self.image = upImg;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.image = self.downImg;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.image = self.upImg;
}

// Mr.chen, 14.3.14, button_recover
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.image = self.upImg;
}
@end
