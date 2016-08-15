//
//  CustomSegmentedControl.h
//  tigermap
//
//  Created by tiger knows on 11-11-5.
//  Copyright (c) 2011年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSegmentedControl : UIView
{
	NSMutableArray *buttonArray;
    int numberButton;
    id aTarget;
    SEL aAction;
    int selectedSegmentIndex;
    int laseSelectedSegmentIndex;
    int hasNoSelectedStates;
    BOOL isVertical;
}

@property (nonatomic, getter = getSelectedSegmentIndex) int selectedSegmentIndex;
@property (nonatomic, assign) int hasNoSelectedStates;
@property NSInteger selState;


- (id)initWithVerticalFrame:(CGRect)frame numberButton:(int)parNumberButton;

- (id)initWithFrame:(CGRect)frame numberButton:(int)parNumberButton;
- (void)addTarget:(id)target action:(SEL)action;
- (void)buttonClicked:(id)sender;
- (void)selectButtonWithTag:(int)parTagNumber;
- (void)setButtonSelectedImage:(UIImage *)selectedImage
                   normalImage:(UIImage *)normalImage
                 withButtonTag:(int)buttonTag;
- (void)setSelectedSegmentIndex:(int)index;
- (void)setSegmentedcontrolEnabled:(BOOL)flag;
- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment;
- (void)setButtonDisabledImage:(UIImage *)disabledImage
                 withButtonTag:(int)buttonTag;
- (void)setButtonTitle:(NSString *)title withButtonTag:(int)buttonTag;
- (void)setAllUnselectedSegmentDisable;
- (void)setAllunselected;

-(void)setTitleSize:(CGFloat) size;

@end