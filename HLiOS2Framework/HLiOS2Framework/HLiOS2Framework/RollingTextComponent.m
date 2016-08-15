//
//  RollingTextComponent.m
//  Core
//
//  Created by Mouee-iMac on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RollingTextEntity.h"
#import "RollingTextComponent.h"
#import "EGOTextView.h"

@implementation RollingTextComponent

@synthesize rollingEntity;

-(UIColor*)getColorFromStr:(NSString *)colorStr andAlpha:(float)alpha
{
    UIColor *retColor = [UIColor clearColor];
    float balpha = 0;
    float r = 0, g = 0, b = 0;
    if (alpha > 0 && alpha < 1.001) 
    {
        balpha = alpha;
    }
    if (colorStr) 
    {
        NSArray *list = [colorStr componentsSeparatedByString:@";"];
        if ([list count] == 3) 
        {
            NSString *str = [list objectAtIndex:0];
            r = [str floatValue];
            
            str = [list objectAtIndex:1];
            g = [str floatValue];
            
            str = [list objectAtIndex:2];
            b = [str floatValue];
        }
        retColor = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:balpha];
    }
    return retColor;
}

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.rollingEntity = (RollingTextEntity*)entity;
        UIFont *font = [UIFont systemFontOfSize:self.rollingEntity.fontSize];
        if (rollingEntity.fontFamily)
        {
            UIFont *tmpFont= [UIFont fontWithName:self.rollingEntity.fontFamily size:self.rollingEntity.fontSize];
            if (tmpFont)
            {
                font = tmpFont;
            }
        }
        if (!self.rollingEntity.enableNote)
        {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [rollingEntity.width floatValue], [rollingEntity.height floatValue])];
            
            if (!self.rollingEntity.isNewTextStyle)
            {
                CGSize size = [self.rollingEntity.text sizeWithFont:font constrainedToSize:CGSizeMake([self.rollingEntity.width floatValue], 5000)];
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                label.numberOfLines = 0;
                label.lineBreakMode = UILineBreakModeCharacterWrap;
                label.text = rollingEntity.text;
                label.textColor = [self getColorFromStr:self.rollingEntity.textColor andAlpha:1];
                label.font = font;
                label.textAlignment = UITextAlignmentLeft;
                if ([self.rollingEntity.textAlign isEqualToString:@"center"])
                {
                    label.textAlignment = UITextAlignmentCenter;
                }
                else if ([self.rollingEntity.textAlign isEqualToString:@"right"])
                {
                    label.textAlignment = UITextAlignmentRight;
                }
                label.userInteractionEnabled = NO;
                label.backgroundColor = [UIColor clearColor];
                [scrollView addSubview:label];
                scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, size.height);
                [label release];

            }
            else
            {
                coreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectMake(0, 0, [self.rollingEntity.width floatValue], 0)];
                coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                coreTextView.nodeArray = self.rollingEntity.textNodeArray;
                // set delegate
                //            [coreTextView setDelegate:self];
                
                [coreTextView fitToSuggestedHeight];
                
                [scrollView addSubview:coreTextView];
                [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetHeight(coreTextView.frame))];
            }
            
            
            self.uicomponent = scrollView;
            [scrollView release];
            if (self.rollingEntity.borderVisible)//added by Adward 13-12-12
            {
                self.uicomponent.layer.borderWidth = 1.0f;
                self.uicomponent.layer.borderColor = [self getColorFromStr:self.rollingEntity.borderColor andAlpha:1].CGColor;
            }
            self.uicomponent.backgroundColor = [self getColorFromStr:self.rollingEntity.backColor andAlpha:self.rollingEntity.backAlpha];
        }
        else
        {
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontSizeChangeFromeSlider:) name:@"FontSizeChangeFromSlider" object:nil];
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
}

- (void)fontSizeChangeFromeSlider:(NSNotification *)notification
{
    [self changeFontSize:notification.object];
}

- (void)changeFontSize:(NSString *)size
{
    if (!size)
    {
        return;
    }
    float fontSize = [size floatValue];
    if (self.rollingEntity.isStatic)
    {
        [self.rollingEntity setStaticFontSize:fontSize];
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    if (rollingEntity.fontFamily)
    {
        UIFont *tmpFont= [UIFont fontWithName:self.rollingEntity.fontFamily size:fontSize];
        if (tmpFont)
        {
            font = tmpFont;
        }
    }
    if (!self.rollingEntity.enableNote)
    {
        CGSize labelSize = [self.rollingEntity.text sizeWithFont:font constrainedToSize:CGSizeMake([self.rollingEntity.width floatValue], 5000)];
        label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
        label.font = font;
        ((UIScrollView *)self.uicomponent).contentSize = labelSize;
        ((UIScrollView *)self.uicomponent).frame = CGRectMake(((UIScrollView *)self.uicomponent).frame.origin.x, ((UIScrollView *)self.uicomponent).frame.origin.y, labelSize.width, ((UIScrollView *)self.uicomponent).frame.size.height);//因为字体不同 会导致width有变化 防止左右晃动
    }
    else
    {
        if (egoText)
        {
            egoText.font = font;
            egoText.text = egoText.text;
        }
    }
}

-(void)dealloc
{
    [coreTextView  release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FontSizeChangeFromSlider" object:nil];
    [self.rollingEntity release];
    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
    [self.uicomponent release];
    [super dealloc];
}

@end
