//
//  AnswerWithText.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/21/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "AnswerWithText.h"

@implementation AnswerWithText

@synthesize selectBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.selectBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)] autorelease];
        //self.selectBtn.backgroundColor = [UIColor greenColor];
        [self.selectBtn setImage:[UIImage imageNamed:@"quiz_sel_btn_n.png"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"quiz_sel_btn_h.png"] forState:UIControlStateHighlighted];
        [self.selectBtn setImage:[UIImage imageNamed:@"quiz_sel_btn_ns.png.png"] forState:UIControlStateSelected];
        self.label = [[[UILabel alloc] initWithFrame:CGRectMake(self.selectBtn.frame.size.width+5, 0, 100, 100)] autorelease];
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.selectBtn];
        [self addSubview:self.label];
    }
    return self;
}

-(void) setLabelText:(NSString *) text
{
    self.label.text = text;
    [self.label sizeToFit];
    if (self.label.frame.size.height > self.selectBtn.frame.size.height)
    {
        self.frame = CGRectMake(0, 0, self.label.frame.origin.x+self.label.frame.size.width, self.label.frame.size.height);

    }
    else
    {
         self.frame = CGRectMake(0, 0, self.label.frame.origin.x+self.label.frame.size.width, self.selectBtn.frame.size.height);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [self.label removeFromSuperview];
    [self.label release];
    [self.selectBtn removeFromSuperview];
    [self.selectBtn release];
    [super dealloc];
}

@end
