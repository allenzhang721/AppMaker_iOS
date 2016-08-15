//
//  PuzzleViewContorller.m
//  puzzlePieces
//
//  Created by user on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PuzzleViewContorller.h"
#import "UIImageCategory.h"

#define kPieceViewHeight   100
#define kRowbtnspace       55
#define kRowbtnsizeW       112
#define kRowbtnsizeH       46
#define kRowbtnposX        865
#define kRowbtnposY        317

#define kStarbtnposX       kRowbtnposX
#define kStarbtnposY       520

#define kGobtnsizeW       150
#define kGobtnsizeH       150
#define kGobtnposX        847
#define kGobtnposY        128

#define kTimeposX         49
#define kTimeposY         190
#define kTimesizeW        106
#define kTimesizeH        45

#define kFinishposX        kTimeposX
#define kFinishposY        353

#define kBestposX         kTimeposX
#define kBestposY         482

#define kScrollHeight     136

#define kImageWidth       597
#define kImageHeight      441
#define kImagePosx        213
#define kImagePosy        123

#define kPiecesWidth      105
#define kPiecesHeight     90
#define kPiecesSpace      30
#define kPiecesYoffset    5



@implementation PuzzleViewContorller

@synthesize finishSound;
@synthesize startTime;
@synthesize mainTimer;
@synthesize imagePath;
@synthesize entityID;
@synthesize viewwidth;
@synthesize viewheight;


#pragma private methods
- (UIButton *)addBtn:(CGRect)frame withImage:(NSString *)image andtarget:(SEL)onBtn :(NSString*)pressImg;
{
    NSString *rootpath = [[NSBundle mainBundle] bundlePath];
    
    NSString *path = [rootpath stringByAppendingPathComponent:image];
    UIImage *backImage = [UIImage imageWithContentsOfFile:path];
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    [button addTarget:self action:onBtn forControlEvents:UIControlEventTouchUpInside];
    
    path = [rootpath stringByAppendingPathComponent:pressImg];
    backImage = [UIImage imageWithContentsOfFile:path];
    [button setBackgroundImage:backImage forState:UIControlStateSelected];
    [button setBackgroundImage:backImage forState:UIControlStateSelected | UIControlStateHighlighted];
    [button setBackgroundImage:backImage forState:UIControlStateHighlighted];
    
    
    [self.view addSubview:button];
    [button release];
    
    return button;
}
-(NSString*)getStringbyTimeInterval:(NSTimeInterval)interval
{
    
    NSString *timestr;
    NSInteger hour = 0, minute = 0, sec = 0;
    
    hour = interval / 3600;
    
    NSInteger temp = (NSInteger)interval % 3600;
    minute = temp / 60;
    
    sec = temp % 60;
    
    if (hour > 0) 
    {
        timestr = [NSString stringWithFormat:@"%d:%02d:%02d", hour, minute, sec];
    }
    else
    {
        timestr = [NSString stringWithFormat:@"%02d:%02d", minute, sec];
    }
    [timestr retain];
    return timestr;
}

-(void)setBestLabel
{
    NSTimeInterval interval = 0.0;
    switch (rowcount) 
    {
        case 2:
            interval = bestInterval1;
            break;
        case 3:
            interval = bestInterval2;
            break;
        case 4:
            interval = bestInterval3;
            break;
        default:
            break;
    }
    if (interval > 0) 
    {
        NSString *bestTime = [self getStringbyTimeInterval:interval];
        [labelBest setText:bestTime];
        [bestTime release];
    }
    else
    {
        [labelBest setText:@"--:--"];
    }
}

-(void)redrawLines:(int)rows :(int)column
{
    for (UIImageView* sep in lines) 
    {
        [sep removeFromSuperview];
    }
    [lines removeAllObjects];
    
    
    CGRect rect;
    for (int i=1; i<rows; ++i) 
    {
        CGFloat y = kImagePosy + kImageHeight / rows * i;
        rect = CGRectMake(kImagePosx, y, kImageWidth, 2);
        UIImageView *sep = [[UIImageView alloc] initWithFrame:rect];
        sep.image = lineh;
        [self.view addSubview:sep];
        [lines addObject:sep];
        [sep release];
    }
    
    for (int j=1; j<column; ++j) 
    {
        CGFloat x = kImagePosx + kImageWidth / column * j;
        rect = CGRectMake(x, kImagePosy, 2, kImageHeight);
        UIImageView *sep = [[UIImageView alloc] initWithFrame:rect];
        sep.image = linev;
        [self.view addSubview:sep];
        [lines addObject:sep];
        [sep release];
    }
}


-(void)prepareNewGame
{
    for (UIImageView* piece in imagePieces) {
        [piece removeFromSuperview];
    }
    //    NSInteger index = (++curIndex) % picPathArray.count;
    //    NSString *path = [picPathArray objectAtIndex:index];
    //    curIndex = index;
    //    
    //    if (curImage) 
    //    {
    //        [curImage release];
    //        curImage = nil;
    //    }
    //    curImage = [[UIImage alloc] initWithContentsOfFile:path];
    //    originImage.image = curImage;
    originImage.alpha = 1;
    
    rowcount = wantRow;
    columncount = wantColumn;
    [self redrawLines:rowcount :columncount];
    readyToPlay = YES;
    playing = NO;
    [labelTime setText:@"00:00"];
    [labelFinish setText:@"00:00"];
    [self setBestLabel];
}

- (CGAffineTransform)transformForOrientation {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
}

-(void)showPopup
{
    fullScreenWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    fullScreenWindow.windowLevel = UIWindowLevelStatusBar;
    fullScreenWindow.backgroundColor = [UIColor clearColor];
    CGPoint origin = CGPointMake((fullScreenWindow.frame.size.width-444)/2, (fullScreenWindow.frame.size.height-217) / 2);
    CGRect rect = CGRectMake(origin.x, origin.y, 444, 217);
    
    NSString *mainPath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [mainPath stringByAppendingPathComponent:@"puzzle-popup.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    alertView = [[UIView alloc] initWithFrame:rect];
    UIImageView *back = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 444, 217)];
    back.image = image;
    [alertView addSubview:back];
    [back release];
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(245, 135, 151, 45)];
    [cancel addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    path = [mainPath stringByAppendingPathComponent:@"puzzle-cancel.png"];
    image = [UIImage imageWithContentsOfFile:path];
    [cancel setBackgroundImage:image forState:UIControlStateNormal];
    
    path = [mainPath stringByAppendingPathComponent:@"puzzle-cencel-pressed.png"];
    image = [UIImage imageWithContentsOfFile:path];
    [cancel setBackgroundImage:image forState:UIControlStateSelected];
    [cancel setBackgroundImage:image forState:UIControlStateHighlighted];
    [cancel setBackgroundImage:image forState:UIControlStateSelected | UIControlStateHighlighted];
    [alertView addSubview:cancel];
    [cancel release];
    
    UIButton *ok = [[UIButton alloc] initWithFrame:CGRectMake(51, 135, 151, 45)];
    [ok addTarget:self action:@selector(okClicked:) forControlEvents:UIControlEventTouchUpInside];
    path = [mainPath stringByAppendingPathComponent:@"puzzle-ok.png"];
    image = [UIImage imageWithContentsOfFile:path];
    [ok setBackgroundImage:image forState:UIControlStateNormal];
    
    path = [mainPath stringByAppendingPathComponent:@"puzzle-ok-pressed.png"];
    image = [UIImage imageWithContentsOfFile:path];
    [ok setBackgroundImage:image forState:UIControlStateSelected];
    [ok setBackgroundImage:image forState:UIControlStateHighlighted];
    [ok setBackgroundImage:image forState:UIControlStateSelected | UIControlStateHighlighted];
    [alertView addSubview:ok];
    [ok release];
    
    [fullScreenWindow addSubview:alertView];
    [fullScreenWindow makeKeyAndVisible];
    
    alertView.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    alertView.transform = CGAffineTransformScale([self transformForOrientation], 1, 1);
    [UIView commitAnimations];
    
}

-(void)showFinishPopup:(NSString*)time :(NSString*)best
{
    fullScreenWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    fullScreenWindow.windowLevel = UIWindowLevelStatusBar;
    fullScreenWindow.backgroundColor = [UIColor clearColor];
    CGPoint origin = CGPointMake((fullScreenWindow.frame.size.width-457)/2, (fullScreenWindow.frame.size.height-325) / 2);
    CGRect rect = CGRectMake(origin.x, origin.y, 457, 325);
    
    NSString *mainPath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [mainPath stringByAppendingPathComponent:@"puzzle-finish-popup.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    alertView = [[UIView alloc] initWithFrame:rect];
    UIImageView *back = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 457, 325)];
    back.image = image;
    [alertView addSubview:back];
    
    UIButton *ok = [[UIButton alloc] initWithFrame:CGRectMake(153, 243, 151, 45)];
    [ok addTarget:self action:@selector(finishedOkClicked:) forControlEvents:UIControlEventTouchUpInside];
    path = [mainPath stringByAppendingPathComponent:@"puzzle-ok.png"];
    image = [UIImage imageWithContentsOfFile:path];
    [ok setBackgroundImage:image forState:UIControlStateNormal];
    
    path = [mainPath stringByAppendingPathComponent:@"puzzle-ok-pressed.png"];
    image = [UIImage imageWithContentsOfFile:path];
    [ok setBackgroundImage:image forState:UIControlStateSelected];
    [ok setBackgroundImage:image forState:UIControlStateHighlighted];
    [ok setBackgroundImage:image forState:UIControlStateSelected | UIControlStateHighlighted];
    [alertView addSubview:ok];
    [ok release];
    
    rect = CGRectMake(228, 114, 171, 43);
    UILabel *labelT = [[UILabel alloc] initWithFrame:rect];
    labelT.textAlignment = UITextAlignmentCenter;
    [labelT setTextColor:[UIColor whiteColor]];
    [labelT setText:time];
    [labelT setFont:[UIFont systemFontOfSize:22]];
    [labelT setBackgroundColor:[UIColor clearColor]];
    [alertView addSubview:labelT];
    [labelT release];
    
    
    
    rect = CGRectMake(228, 114+43+15, 171, 43);
    UILabel *labelB = [[UILabel alloc] initWithFrame:rect];
    labelB.textAlignment = UITextAlignmentCenter;
    [labelB setTextColor:[UIColor whiteColor]];
    [labelB setText:best];
    [labelB setFont:[UIFont systemFontOfSize:22]];
    [labelB setBackgroundColor:[UIColor clearColor]];
    [alertView addSubview:labelB];
    [labelB release];
    
    
    [fullScreenWindow addSubview:alertView];
    [fullScreenWindow makeKeyAndVisible];
    
    alertView.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    alertView.transform = CGAffineTransformScale([self transformForOrientation], 1, 1);
    [UIView commitAnimations];
}

-(void)startNewGame
{
    if (!playing)
    {
        if (rowcount == wantRow && columncount == wantColumn) 
        {
            //            NSInteger index = (++curIndex) % picPathArray.count;
            //            NSString *path = [picPathArray objectAtIndex:index];
            //            curIndex = index;
            //            
            //            if (curImage) 
            //            {
            //                [curImage release];
            //                curImage = nil;
            //            }
            //            curImage = [[UIImage alloc] initWithContentsOfFile:path];
            //            originImage.image = curImage;
            //            originImage.alpha = 1;
        }
        else
        {
            rowcount = wantRow;
            columncount = wantColumn;
            [self redrawLines:wantRow :wantColumn];
            [self setBestLabel];
        }
    }
    else
    {
        //show popup
        [self showPopup];
    }
}

-(void)cancelClicked:(id)sender
{
    [fullScreenWindow release];
    fullScreenWindow = nil;
    [alertView release];
}

-(void)okClicked:(id)sender
{
    [fullScreenWindow release];
    fullScreenWindow = nil;
    [alertView release];
    [UIView animateWithDuration:2.5 animations:^{[self prepareNewGame];}];
}

-(void)finishedOkClicked:(id)sender
{
    [fullScreenWindow release];
    fullScreenWindow = nil;
    [alertView release];
}

-(void)addPiecesToScroll
{
    NSInteger i = 0;
    for (MultiJigImageView* piece in imagePieces) 
    {
        if (!piece.isRightPuted) 
        {
            piece.frame = CGRectMake(i*(kPiecesWidth + kPiecesSpace), 0, kPiecesWidth, kPiecesHeight);
            piece.containerView = piecesContainer;
            [piecesContainer addSubview:piece];
            ++i;
        }
    }
}

-(void)fadeoutImage
{
    [UIView animateWithDuration:2.5 animations:^{originImage.alpha = 0;}];
}

-(void)mainTimerUpdate:(id)sender
{
    if (playing) 
    {
        NSDate *curdate = [NSDate date];
        NSTimeInterval interval = [curdate timeIntervalSinceDate:self.startTime];
        NSString *timestr = [self getStringbyTimeInterval:interval];
        [labelTime setText:timestr];
    }
}


-(void)saveRecords
{
    NSString *rootpath = [[NSBundle mainBundle] bundlePath];
    NSString *filename = [NSString stringWithFormat:@"puzzle-%@", self.entityID];
    NSString *path = [rootpath stringByAppendingPathComponent:filename];
    
    NSString *intervals = [NSString stringWithFormat:@"%lf\n%lf\n%lf", bestInterval1, bestInterval2, bestInterval3];
    [intervals writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


-(Boolean)checkDone
{
    Boolean done = YES;
    for (MultiJigImageView* view in imagePieces) 
    {
        if (!view.isRightPuted) 
        {
            done = NO;
        }
    }
    if (done) 
    {
        [finishSound play];
        
        NSDate *curdate = [NSDate date];
        NSTimeInterval interval = [curdate timeIntervalSinceDate:self.startTime];
        NSString *timestr = [self getStringbyTimeInterval:interval];
        [labelFinish setText:timestr];
        
        switch (rowcount) 
        {
            case 2:
                if (bestInterval1 < 0 || bestInterval1 > interval) 
                {
                    bestInterval1 = interval; 
                    [labelBest setText:timestr];
                }
                break;
            case 3:
                if (bestInterval2 < 0 || bestInterval2 > interval) 
                {
                    bestInterval2 = interval; 
                    [labelBest setText:timestr];
                }
                break;
            case 4:
                if(bestInterval3 < 0 || bestInterval3 > interval) 
                {
                    bestInterval3 = interval; 
                    [labelBest setText:timestr];
                }
                break;
            default:
                break;
        }
        
        for (MultiJigImageView*view in imagePieces) {
            [view removeFromSuperview];
        }
        [imagePieces removeAllObjects];
        originImage.alpha = 1;
        playing = NO;
        readyToPlay = YES;
        [self saveRecords];
    }
    
    return done;
}

-(void)resetContainerView
{
    CGRect rect;
    NSInteger count = 0;
    for (MultiJigImageView* view in imagePieces) 
    {
        if (!view.isRightPuted) 
        {
            ++count;
        }
    }
    if (count <= 0) 
    {
        return;
    }
    CGFloat width = (count-1) * (kPiecesWidth + kPiecesSpace) + kPiecesWidth;
    if (width < scrollPieces.frame.size.width) 
    {
        rect = CGRectMake((scrollPieces.frame.size.width - width) /2, kPiecesYoffset, width, kPiecesHeight);
    }
    else
    {
        rect = CGRectMake(0, kPiecesYoffset, width, kPiecesHeight);
    }
    piecesContainer.frame = rect;
    scrollPieces.contentSize = CGSizeMake(width, scrollPieces.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{[self addPiecesToScroll];}];
}

-(void)readRecords
{
    NSString *rootpath = [[NSBundle mainBundle] bundlePath];
    NSString *filename = [NSString stringWithFormat:@"puzzle-%@", self.entityID];
    NSString *path = [rootpath stringByAppendingPathComponent:filename];
    
    NSString *intervals = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //NSString *intervals = @"123\n222n\n333";
    if (!intervals || intervals.length <= 0) 
    {
        return;
    }
    NSArray *array = [intervals componentsSeparatedByString:@"\n"];
    if (array.count < 3) 
    {
        return;
    }
    NSString *value = [array objectAtIndex:0];
    bestInterval1 = [value doubleValue];
    
    value = [array objectAtIndex:1];
    bestInterval2 = [value doubleValue];
    
    value = [array objectAtIndex:2];
    bestInterval3 = [value doubleValue];
}


#pragma view life cycle

-(void)loadView
{
    [super loadView];
    scaleW = 1;
    scaleH = 1;
    rowcount = 1;
    columncount = 1;
    playing = NO;
    readyToPlay = NO;
    bestInterval1 = -1;
    bestInterval2 = -1;
    bestInterval3 = -1;
    
    NSString *mainPath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [mainPath stringByAppendingPathComponent:@"puzzle-lineh.png"];
    lineh = [[UIImage alloc] initWithContentsOfFile:path];
    
    path = [mainPath stringByAppendingPathComponent:@"puzzle-linev.png"];
    linev = [[UIImage alloc] initWithContentsOfFile:path];
    
    lines = [[NSMutableArray alloc] initWithCapacity:24];
    //picPathArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    //path = [mainPath stringByAppendingPathComponent:@"puzzle-test.png"];
    
    //[picPathArray addObject:path];
    //path = [picPathArray objectAtIndex:0];
//    curImage = [[UIImage alloc] initWithContentsOfFile:self.imagePath];
    curImage = [[UIImageCategory alloc] initWithContentsOfFile:self.imagePath];

}

-(void)viewDidLoad
{
    self.view.frame = CGRectMake(0, 0, 1024, 768);
    CGRect frame = self.view.frame; 
    
    NSString *rootpath = [[NSBundle mainBundle] bundlePath];
    
    NSString *path = [rootpath stringByAppendingPathComponent:@"puzzle-background.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    UIImageView *back = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:back];
    [back release];
    
    CGRect rect = CGRectMake(kRowbtnposX, kRowbtnposY, kRowbtnsizeW, kRowbtnsizeH);
    [self addBtn:rect withImage:@"puzzle-2-3.png" andtarget:@selector(btnClick2plus3:) :@"puzzle-2-3-pressed.png"];
    
    rect.origin.y += kRowbtnspace;
    [self addBtn:rect withImage:@"puzzle-3-4.png" andtarget:@selector(btnClick3plus4:) :@"puzzle-3-4-pressed.png"];
    
    rect.origin.y += kRowbtnspace;
    [self addBtn:rect withImage:@"puzzle-4-6.png" andtarget:@selector(btnClick4plus6:) :@"puzzle-4-6-pressed.png"];
    
    rect = CGRectMake(kStarbtnposX, kStarbtnposY, kRowbtnsizeW, kRowbtnsizeH);
    [self addBtn:rect withImage:@"puzzle-star.png" andtarget:@selector(btnClickShowImage:) :@"puzzle-star-pressed.png"];
    
    rect = CGRectMake(kGobtnposX, kGobtnposY, kGobtnsizeW, kGobtnsizeH);
    btnStart = [self addBtn:rect withImage:@"puzzle-start.png" andtarget:@selector(btnClickStart:) :@"puzzle-start-pressed.png"];
    
    rect = CGRectMake(kTimeposX, kTimeposY, kTimesizeW, kTimesizeH);
    labelTime = [[UILabel alloc] initWithFrame:rect];
    labelTime.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:labelTime];
    [labelTime release];
    [labelTime setText:@"00:00"];
    [labelTime setTextColor:[UIColor whiteColor]];
    [labelTime setFont:[UIFont systemFontOfSize:22]];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    
    rect = CGRectMake(kFinishposX, kFinishposY, kTimesizeW, kTimesizeH);
    labelFinish = [[UILabel alloc] initWithFrame:rect];
    labelFinish.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:labelFinish];
    [labelFinish release];
    [labelFinish setTextColor:[UIColor whiteColor]];
    [labelFinish setFont:[UIFont systemFontOfSize:22]];
    [labelFinish setText:@"00:00"];
    [labelFinish setBackgroundColor:[UIColor clearColor]];
    
    rect = CGRectMake(kBestposX, kBestposY, kTimesizeW, kTimesizeH);
    labelBest = [[UILabel alloc] initWithFrame:rect];
    labelBest.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:labelBest];
    [labelBest release];
    [labelBest setTextColor:[UIColor whiteColor]];
    
    [self readRecords];
    
    if (bestInterval1 > 0) 
    {
        NSString *bestTime = [self getStringbyTimeInterval:bestInterval1];
        [labelBest setText:bestTime];
        [bestTime release];
    }
    else
    {
        [labelBest setText:@"--:--"];
    }
    [labelBest setFont:[UIFont systemFontOfSize:22]];
    [labelBest setBackgroundColor:[UIColor clearColor]];
    
    rect.size.width = frame.size.width;
    rect.size.height = kScrollHeight;
    rect.origin.x = 0;
    rect.origin.y = frame.size.height - kScrollHeight;
    scrollPieces = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:scrollPieces];
    
    piecesContainer = [[UIView alloc] init];
    [scrollPieces addSubview:piecesContainer];
    
//    self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(mainTimerUpdate:) userInfo:nil repeats:YES];
    
    rect = CGRectMake(kImagePosx, kImagePosy, kImageWidth, kImageHeight);
    originImage = [[UIImageView alloc] initWithFrame:rect];
    originImage.image = curImage;
    [self.view addSubview:originImage];
    
    if (curImage) 
    {
        rowcount = 2;
        columncount = 3;
        [self redrawLines:rowcount :columncount];
        readyToPlay = YES;
    }
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/puzzle-finish.mp3", [[NSBundle mainBundle] bundlePath]]];
    self.finishSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL] autorelease];
    [self.finishSound prepareToPlay];
}

#pragma utility


-(Boolean)isRightGrid:(MultiJigImageView*)imageview
{
    CGPoint originPos;
    originPos.x = kImagePosx + kImageWidth / columncount * imageview.grid_x;
    originPos.y = kImagePosy + kImageHeight / rowcount * imageview.grid_y;
    
    CGSize gridSize = CGSizeMake(kImageWidth / columncount, kImageHeight/rowcount);
    
    CGRect judgeRect = CGRectMake(originPos.x + gridSize.width*0.15, originPos.y + gridSize.height*0.15, gridSize.width*0.7, gridSize.height*0.7);
    
    if (CGRectContainsPoint(judgeRect, imageview.center)) 
    {
        imageview.frame = CGRectMake(originPos.x, originPos.y, kImageWidth/columncount, kImageHeight/rowcount);
        imageview.isRightPuted = YES;
        
        for (UIImageView* line in lines) 
        {
            [self.view bringSubviewToFront:line];
        }
        
        if (![self checkDone]) 
        {
            [self resetContainerView];
        }
        else
        {
            [self showFinishPopup:labelFinish.text:labelBest.text];
        }
        return YES;
    }
    return NO;
}




#pragma button call

-(void)btnClick2plus3:(id)sender
{
    wantRow = 2;
    wantColumn = 3;
    [self startNewGame];
}
-(void)btnClick3plus4:(id)sender
{
    wantRow = 3;
    wantColumn = 4;
    [self startNewGame];
}
-(void)btnClick4plus6:(id)sender
{
    wantRow = 4;
    wantColumn = 6;
    [self startNewGame];
}

-(void)btnClickShowImage:(id)sender
{
    if (!playing) 
    {
        return;
    }
    
    [UIView animateWithDuration:0.8 animations:^{originImage.alpha = 1;}];
    [self performSelector:@selector(fadeoutImage) withObject:nil afterDelay:1];
}

-(void)btnClickStart:(id)sender
{
    if (!readyToPlay) 
    {
        return;
    }
    if (!self.mainTimer) 
    {
        self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(mainTimerUpdate:) userInfo:nil repeats:YES];
    }
    readyToPlay = NO;
    playing = YES;
    self.startTime = [NSDate date];
    
    NSMutableArray *images = [curImage getRectangularPuzzlePiecesWithRows:rowcount andColumns:columncount];
    NSMutableArray *pieces = [[NSMutableArray alloc] initWithCapacity:rowcount*columncount];
    int i=0, j;
    for(NSArray *row in images)
    {
        j=0;
        for(UIImage *image in row) 
        {            
            MultiJigImageView *view = [[MultiJigImageView alloc] init];
            view.image = image;
            view.grid_x = i;
            view.grid_y = j;
            view.mainView = self.view;
            view.scrollView = scrollPieces;
            view.controller = self;
            view.grid_size = CGSizeMake(kImageWidth/columncount, kImageHeight/rowcount);
            
            [pieces addObject:view];
            [view release];
            
            j++;
        }
        i++;
    }
    if (imagePieces) 
    {
        [imagePieces removeAllObjects];
        [imagePieces release];
        imagePieces = nil;
    }
    imagePieces = pieces;
    i = [imagePieces count];
    while (--i > 0)
    {
        j = rand() % (i+1);
        [imagePieces exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    CGRect rect;
    CGFloat width = ([imagePieces count] - 1) * (kPiecesWidth + kPiecesSpace) + kPiecesWidth;
    if (width < scrollPieces.frame.size.width) 
    {
        rect = CGRectMake((scrollPieces.frame.size.width - width) /2, kPiecesYoffset, width, kPiecesHeight);
    }
    else
    {
        rect = CGRectMake(0, kPiecesYoffset, width, kPiecesHeight);
    }
    piecesContainer.frame = rect;
    scrollPieces.contentSize = CGSizeMake(width, scrollPieces.frame.size.height);
    
    [UIView animateWithDuration:1 animations:^{[self addPiecesToScroll];  originImage.alpha = 0;}];
    
    [labelTime setText:@"00:00"];
    [labelFinish setText:@"00:00"];
    [self setBestLabel];
}

#pragma orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        return YES;
    }
    return NO;
}

-(void)onComponentStop
{
    playing = NO;
}

-(void)dealloc
{
    NSLog(@"PuzzleViewContorller dealloc");
    [piecesContainer release];
    [scrollPieces release];
    [lines removeAllObjects];
    [lines release];
    
    [lineh release];
    [linev release];
    
    [originImage release];
    [curImage release];
    
    [imagePieces removeAllObjects];
    [imagePieces release];
    
    [fullScreenWindow release];
    
    [alertView release];
    
    if (self.mainTimer && [self.mainTimer isValid]) 
    {
        [self.mainTimer invalidate];
    }
    
    [self.startTime release];
    [self.imagePath release];
    [self.entityID release];
    //[self.finishSound release];
    
    [super dealloc];
    
}


@end
