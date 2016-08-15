//
//  PuzzleViewContorller.h
//  puzzlePieces
//
//  Created by user on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MultiJigImageView.h"
#import "UIImageCategory.h"


@interface PuzzleViewContorller : UIViewController<PuzzleMoveDelegate>
{
    CGFloat scaleW;
    CGFloat scaleH;
    
    UIButton *btnStart;
    UILabel *labelTime;
    UILabel *labelFinish;
    UILabel *labelBest;
    
    UIScrollView *scrollPieces;
    UIView *piecesContainer;
    UIImageView *originImage;
//    UIImage *curImage;
    UIImageCategory *curImage;
    
    UIWindow *fullScreenWindow;
    UIView *alertView;
    
    NSMutableArray *imagePieces;
    NSMutableArray *lines;
    
    UIImage *lineh;
    UIImage *linev;
    
    NSInteger rowcount;
    NSInteger columncount;
    NSInteger wantRow;
    NSInteger wantColumn;
    
    Boolean  playing;
    Boolean  readyToPlay;
    
    //NSMutableArray *picPathArray;
    NSTimeInterval bestInterval1;
    NSTimeInterval bestInterval2;
    NSTimeInterval bestInterval3;
}
@property (nonatomic, retain) AVAudioPlayer *finishSound;
@property(nonatomic, retain)NSDate* startTime;
@property(nonatomic, retain)NSTimer* mainTimer;

@property (nonatomic , retain) NSString *imagePath;
@property (nonatomic , retain) NSString *entityID;


@property (nonatomic) GLfloat viewwidth;
@property (nonatomic) GLfloat viewheight;

-(void)btnClick2plus3:(id)sender;
-(void)btnClick3plus4:(id)sender;
-(void)btnClick4plus6:(id)sender;
-(void)btnClickShowImage:(id)sender;
-(void)btnClickStart:(id)sender;

-(Boolean)isRightGrid:(MultiJigImageView*)imageview;

-(void)onComponentStop;

@end
