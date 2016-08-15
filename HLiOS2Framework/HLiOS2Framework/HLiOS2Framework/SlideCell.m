//
//  SlideCell.m
//  Core
//
//  Created by sun yongle on 12/08/12.
//  Copyright (c) 2012年 PEM. All rights reserved.
//

#import "SlideCell.h"
#import "HLImage.h"

@implementation SlideCell

@synthesize delegate;
@synthesize isSelected;
@synthesize cellWidth;
@synthesize cellHeight;
@synthesize index;
@synthesize imageNormal;
@synthesize imagePressed;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)prepareForReuse
{
    [super prepareForReuse];
    [backBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [backBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    self.isSelected = NO;
}

-(void)refreshInfo
{
    backBtn.frame = CGRectMake(0, 0, cellWidth, cellHeight);
//    if (self.isSelected) 
//    {
//        UIImage *image = [UIImage imageWithContentsOfFile:self.imagePressed];
//        [backBtn setBackgroundImage:image forState:UIControlStateSelected];
//        backBtn.selected = YES;
//    }
//    else 
//    {
    UIImage *image = [UIImage imageWithContentsOfFile:self.imageNormal];
    UIImage *scaledImage = [HLImage scaledImage:image width:cellWidth height:cellHeight];
    [backBtn setBackgroundImage:scaledImage forState:UIControlStateNormal];
        
    image = [UIImage imageWithContentsOfFile:self.imagePressed];
    scaledImage = [HLImage scaledImage:image width:cellWidth height:cellHeight];
    [backBtn setBackgroundImage:scaledImage forState:UIControlStateHighlighted];
//    }
}

-(void)dealloc
{
    self.delegate = nil;
    [self.imageNormal release];
    [self.imagePressed release];
    [super dealloc];
}

- (void)BtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(slideCell:CellClicked:)]) 
    {
        [self.delegate slideCell:self CellClicked:nil];
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

@end
