//
//  PaintViewController.h
//  PaintApp
//
//  Created by user on 11-10-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintingView.h"
#import "MoveAnimation.h"
#import "MoveAnimationReverse.h"
#import "PaintEntity.h"
#import "LocalizationDefine.h"


@interface PaintViewController : UIViewController
{
    PaintingView *paintView;
    UIButton     *btnRedColor;
    UIButton     *btnGreenColor;
    UIButton     *btnBlackColor;
    UIButton     *btnOrangeColor;
    UIButton     *btnBrownColor;
    UIButton     *btnYellowColor;
    UIButton     *btnBuleColor;
    UIButton     *btnSkyColor;
    UIButton     *btnPurpleColor;
    UIButton     *btnEraser;
    UIButton     *darkPurpleColor;
    UIButton     *btnPinkColor;
    UIButton     *btnGreyColor;
    UIButton     *btnWhiteGreyColor;
    UIButton     *btnLightBlueColor;
    UIButton     *btnMudColor;
    UIButton     *btnLightGreenColor;
    UIButton     *btnSave;
    UIButton     *btnClean;
    MoveAnimation *ma;
    MoveAnimationReverse *mar;
    UIButton     *currentBtn;
    UIImageView  *imageView;
    NSString     *imagePath;
    UIAlertView  *saveAlert;
    UIAlertView  *cleanAlert;
    
    CGFloat      scaleW;
    CGFloat      scaleH;
    GLfloat      width;
    GLfloat      height; 
}

@property (nonatomic , retain) PaintingView *paintView;
@property (nonatomic , retain) UIAlertView           *saveAlert;
@property (nonatomic , retain) UIAlertView           *cleanAlert;
@property (nonatomic , retain) NSString *imagePath;
@property (nonatomic , assign) UIButton *currentBtn;
@property (nonatomic , retain) MoveAnimation *ma;
@property (nonatomic , retain) MoveAnimationReverse *mar;
@property (nonatomic , retain) UIImageView *imageView;
@property (nonatomic , retain) PaintEntity *entity;//added by Adward 13-12-06
@property (nonatomic) GLfloat width;
@property (nonatomic) GLfloat height;

-(void) checkCurrentBtn;
-(void)saveComplete:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
-(void) onBtnRedColor: (id) sender;
-(void) onBtnGreenColor: (id) sender;
-(void) onBtnBlackColor: (id) sender;
-(void) onBtnOrangeColor: (id) sender;
-(void) onBtnBrownColor: (id) sender;
-(void) onBtnYellowColor: (id) senderr;
-(void) onBtnBuleColor: (id) sender;
-(void) onBtnSkyColor: (id) sender;
-(void) onBtnPurpleColor: (id) sender;
-(void) onBtnEraser: (id) sender;
-(void) onBtnDarkPurpleColor: (id) sender;
-(void) onBtnPinkColor: (id) sender;
-(void) onBtnGreyColor: (id) sender;
-(void) onBtnWhiteGreyColor: (id) sender;
-(void) onBtnLightBlueColor: (id) sender;
-(void) onBtnMudColor: (id) sender;
-(void) onBtnLightGreenColor: (id) sender;
-(void) onBtnSave: (id) sender;
-(void) onBtnClean: (id) sender;

@end
