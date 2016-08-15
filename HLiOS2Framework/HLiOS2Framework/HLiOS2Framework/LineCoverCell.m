//
//  LineCoverCell.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/25/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "LineCoverCell.h"

@implementation LineCoverCell
@synthesize bgImg;
@synthesize snapImg;
@synthesize title;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.bgImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lc_bg_n.png"]] autorelease];
        self.bgImg.frame = CGRectMake(0, 5, 130, 180);
        self.snapImg = [[[UIImageView alloc] init] autorelease];
        self.snapImg.frame = CGRectMake(0, 14, 100, 100);
        self.title = [[[UILabel alloc] init] autorelease];
        self.title.textColor = [UIColor whiteColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgImg];
        [self addSubview:self.snapImg];
        [self addSubview:self.title];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected == YES)
    {
        [self.bgImg setImage:[UIImage imageNamed:@"lc_bg_h.png"]];
    }
    else
    {
        [self.bgImg setImage:[UIImage imageNamed:@"lc_bg_n.png"]];
    }
    // Configure the view for the selected state
}

-(void) changeToVertical
{
    self.bgImg.frame = CGRectMake(0, 5, 130, 180);
    self.snapImg.frame = CGRectMake(10, 14, 110, 140);
    self.title.frame   = CGRectMake(10, 154, 110, 20);
}
-(void) changeToHorizontal
{
    self.snapImg.frame = CGRectMake(19, 14, 212, 140);
    self.bgImg.frame   = CGRectMake(0, 5, 250, 180);
    self.title.frame   = CGRectMake(19, 157, 212, 20);
    
}



-(void) setSnapshot:(NSString *) snapPath
{
    [self.snapImg setImage: [UIImage imageWithContentsOfFile:snapPath]];
}

@end
