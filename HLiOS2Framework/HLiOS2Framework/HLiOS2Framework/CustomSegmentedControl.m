//
//  CustomSegmentedControl.m
//  tigermap
//
//  Created by tiger knows on 11-11-5.
//  Copyright (c) 2011年 company. All rights reserved.
//

#import "CustomSegmentedControl.h"

@implementation CustomSegmentedControl

@synthesize selectedSegmentIndex;
@synthesize hasNoSelectedStates;
@synthesize selState;

- (id)initWithVerticalFrame:(CGRect)frame numberButton:(int)parNumberButton
{
    self = [super initWithFrame:frame];
    if (self) {
        selState = UIControlStateSelected;
        isVertical = YES;
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor clearColor];
        numberButton = parNumberButton < 1 ? 1 : parNumberButton;
        buttonArray = [[NSMutableArray alloc] initWithCapacity:numberButton];
        int i;
        UIButton *button = nil;        
        int buttonHeight = self.frame.size.height / numberButton;
        for (i = 0; i < numberButton; i++) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, i * buttonHeight, frame.size.width,
                                      buttonHeight);
            button.tag = i;
            [self addSubview:button];
            [buttonArray addObject:button];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame numberButton:(int)parNumberButton
{
    self = [super initWithFrame:frame];
    if (self) {
        selState = UIControlStateSelected;
        isVertical = NO;
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor clearColor];
        numberButton = parNumberButton < 1 ? 1 : parNumberButton;
        buttonArray = [[NSMutableArray alloc] initWithCapacity:numberButton];
        int i;
        UIButton *button = nil;        
        int buttonWidth = self.frame.size.width / numberButton;
        for (i = 0; i < numberButton; i++) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i * buttonWidth, 0.0f, buttonWidth,
                                      self.frame.size.height);
            button.tag = i;
            [self addSubview:button];
            [buttonArray addObject:button];
        }
    }
    return self;
}

- (void)setButtonTitle:(NSString *)title withButtonTag:(int)buttonTag
{
    if (!title || buttonTag < 0 || buttonTag >= [buttonArray count]) {
        return;
    }
    UIButton *button = (UIButton *)[buttonArray objectAtIndex:buttonTag];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
}

- (void)setButtonSelectedImage:(UIImage *)selectedImage
                   normalImage:(UIImage *)normalImage
                 withButtonTag:(int)buttonTag
{
    if (!normalImage
        || buttonTag >= [buttonArray count]
        || numberButton <= 0) {
        return;
    }

    UIButton *button = (UIButton *)[buttonArray objectAtIndex:buttonTag];
    if (button) {
        [button setBackgroundImage:normalImage
                          forState:UIControlStateNormal];
        if (selectedImage) {
            [button setBackgroundImage:selectedImage
                              forState:selState];
        }
        [button addTarget:self 
                   action:@selector(buttonClicked:) 
         forControlEvents:UIControlEventTouchUpInside];
    }    
}

- (void)setButtonDisabledImage:(UIImage *)disabledImage
                 withButtonTag:(int)buttonTag
{
    if (!disabledImage
        || buttonTag >= [buttonArray count]
        || numberButton <= 0) {
        return;
    }
    
    UIButton *button = (UIButton *)[buttonArray objectAtIndex:buttonTag];
    if (button) {
        [button setBackgroundImage:disabledImage
                          forState:UIControlStateDisabled];
    }    
}

- (void)addTarget:(id)target action:(SEL)action
{
    if (!target || !action) {
        return;
    }
    aTarget = target;
    aAction = action;
}

- (void)dealloc
{
    [buttonArray release];
    [super dealloc];
}

- (void)buttonClicked:(id)sender
{
    int tagNumber = [sender tag];
    if (!hasNoSelectedStates) {
        if (tagNumber == selectedSegmentIndex) {
            return;
        }
        [self selectButtonWithTag:tagNumber];
    }else{
        selectedSegmentIndex = tagNumber;
        laseSelectedSegmentIndex = selectedSegmentIndex;
    }
    if (aTarget && aAction) {
        [aTarget performSelector:aAction withObject:self];
    }
    return;
}

- (void)selectButtonWithTag:(int)parTagNumber
{
    if ((parTagNumber >= 0) 
        || (parTagNumber < numberButton)
        || laseSelectedSegmentIndex == parTagNumber) {
        [[buttonArray objectAtIndex:laseSelectedSegmentIndex] setSelected:NO];
        [[buttonArray objectAtIndex:parTagNumber] setSelected:YES];
        selectedSegmentIndex = parTagNumber;
        laseSelectedSegmentIndex = selectedSegmentIndex;
    }
}

- (void)setSelectedSegmentIndex:(int)index
{
    if (index < 0 || index >= numberButton) {
        return;
    }
    [self selectButtonWithTag:index];
}

- (void)setSegmentedcontrolEnabled:(BOOL)flag
{
    for (int i = 0; i < numberButton; i++) {
        [[buttonArray objectAtIndex:i] setEnabled:flag];
    }
}

- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment
{
    UIButton *button = nil;
    if (buttonArray && [buttonArray count] > segment) {
        button = (UIButton *)[buttonArray objectAtIndex:segment];
        if (button) {
            [button setEnabled:enabled];
        }
    }
}

- (void)setAllUnselectedSegmentDisable
{
    for (int i = 0; i < numberButton; i++) {
        if (i != selectedSegmentIndex) {
            [[buttonArray objectAtIndex:i] setEnabled:NO];
        }
    }
}

- (void)setAllunselected
{
    for (int i = 0; i < numberButton; i++) {
        [[buttonArray objectAtIndex:i] setSelected:NO];
    }
    hasNoSelectedStates = 1;
}

-(void)setTitleSize:(CGFloat) size
{
    for (int i = 0; i < numberButton; i++) 
    {
        [[buttonArray objectAtIndex:i] setSelected:NO];
        UIButton *btn = [buttonArray objectAtIndex:i];
        btn.titleLabel.font = [UIFont systemFontOfSize:size];
    }
}


@end

