//
//  PaintViewController.m
//  PaintApp
//
//  Created by user on 11-10-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PaintViewController.h"

#define kPanSpace       10
#define kPanWidth       95
#define kPanHeight      28
#define kPanCount       16

#define kEditPanelw     1024
#define kEditPanelh     768
#define kPaintVieww     648//adward 13-12-27 图片错位 656
#define kPaintViewh     488//494

#define kScreenWidth    1024
#define kScreenHeight    768

@implementation PaintViewController

@synthesize paintView;

@synthesize currentBtn;
@synthesize imageView;
@synthesize ma;
@synthesize imagePath;
@synthesize saveAlert;
@synthesize cleanAlert;
@synthesize mar;
@synthesize width;
@synthesize height;
@synthesize entity;

static void HSL2RGB(float h, float s, float l, float* outR, float* outG, float* outB)
{
	float			temp1,
    temp2;
	float			temp[3];
	int				i;
	
	// Check for saturation. If there isn't any just return the luminance value for each, which results in gray.
	if(s == 0.0) {
		if(outR)
			*outR = l;
		if(outG)
			*outG = l;
		if(outB)
			*outB = l;
		return;
	}
	
	// Test for luminance and compute temporary values based on luminance and saturation 
	if(l < 0.5)
    temp2 = l * (1.0 + s);
	else
		temp2 = l + s - l * s;
    temp1 = 2.0 * l - temp2;
	
	// Compute intermediate values based on hue
	temp[0] = h + 1.0 / 3.0;
	temp[1] = h;
	temp[2] = h - 1.0 / 3.0;
    
	for(i = 0; i < 3; ++i) {
		
		// Adjust the range
		if(temp[i] < 0.0)
			temp[i] += 1.0;
		if(temp[i] > 1.0)
			temp[i] -= 1.0;
		
		
		if(6.0 * temp[i] < 1.0)
			temp[i] = temp1 + (temp2 - temp1) * 6.0 * temp[i];
		else {
			if(2.0 * temp[i] < 1.0)
				temp[i] = temp2;
			else {
				if(3.0 * temp[i] < 2.0)
					temp[i] = temp1 + (temp2 - temp1) * ((2.0 / 3.0) - temp[i]) * 6.0;
				else
					temp[i] = temp1;
			}
		}
	}
	
	// Assign temporary values to R, G, B
	if(outR)
		*outR = temp[0];
	if(outG)
		*outG = temp[1];
	if(outB)
		*outB = temp[2];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) checkCurrentBtn
{
    if (self.currentBtn != nil)
    {
        if (self.currentBtn.frame.origin.x > 500)
        {
            self.ma.view = self.currentBtn;
            self.ma.isRevser = NO;
            [self.ma play];
        }
        else
        {
            self.mar.view = self.currentBtn;
            self.mar.isRevser = NO;
            [self.mar play];
        }
    }
    self.paintView.kBrushScale = 11 - self.entity.lineWidth / 2;//added by Adward 13-12-06线的粗细设置
}

-(void) onBtnRedColor: (id) sender
{
    if (self.currentBtn != btnRedColor)
    {
        [self checkCurrentBtn];
        self.ma.isRevser = YES;
        self.ma.view = btnRedColor;
        [self.ma play];
    }
    CGFloat					components[3];
 	HSL2RGB((CGFloat)354/360, 42, 0.9, &components[0], &components[1], &components[2]);
	[self.paintView setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
    self.currentBtn = btnRedColor;
}

-(void) onBtnGreenColor: (id) sender
{
    if (self.currentBtn != btnGreenColor)
    {
        [self checkCurrentBtn];
        self.ma.isRevser = YES;
        self.ma.view = btnGreenColor;
        [self.ma play];
    }
    CGFloat					components[3];
 	HSL2RGB((CGFloat)107/360, 88, 0.9, &components[0], &components[1], &components[2]);
	[self.paintView setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
    self.currentBtn = btnGreenColor;
}

-(void) onBtnBlackColor: (id) sender
{
    if (self.currentBtn != btnBlackColor)
    {
        [self checkCurrentBtn];
        self.ma.isRevser = YES;
        self.ma.view = btnBlackColor;
        [self.ma play];
    }
    CGFloat					components[3];
 	HSL2RGB((CGFloat)0/360, 0, 0, &components[0], &components[1], &components[2]);
	[self.paintView setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
    self.currentBtn = btnBlackColor;
}

-(void) onBtnOrangeColor: (id) sender
{
    if (self.currentBtn != btnOrangeColor)
    {
        [self checkCurrentBtn];
        self.mar.isRevser = YES;
        self.mar.view = btnOrangeColor;
        [self.mar play];
    }
	[self.paintView setBrushColorWithRed:1.0 green:0.647 blue:0.0];
    self.currentBtn = btnOrangeColor;
}

-(void) onBtnBrownColor: (id) sender
{
    if (self.currentBtn != btnBrownColor)
    {
        [self checkCurrentBtn];
        self.ma.isRevser = YES;
        self.ma.view = btnBrownColor;
        [self.ma play];
    }
    CGFloat					components[3];
 	HSL2RGB((CGFloat)16/360, 34, 0.97, &components[0], &components[1], &components[2]);
	[self.paintView setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
    self.currentBtn = btnBrownColor;
}

-(void) onBtnYellowColor: (id) sender
{
    if (self.currentBtn != btnYellowColor)
    {
        [self checkCurrentBtn];
        self.ma.isRevser = YES;
        self.ma.view = btnYellowColor;
        [self.ma play];
    }
    CGFloat					components[3];
 	HSL2RGB((CGFloat)60/360, 98, 0.9, &components[0], &components[1], &components[2]);
	[self.paintView setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
    self.currentBtn = btnYellowColor;
}

-(void) onBtnBuleColor: (id) sender
{
    if (self.currentBtn != btnBuleColor)
    {
        [self checkCurrentBtn];
        self.ma.isRevser = YES;
        self.ma.view = btnBuleColor;
        [self.ma play];
    }
    CGFloat					components[3];
 	HSL2RGB((CGFloat)249/360, 29, 0.66, &components[0], &components[1], &components[2]);
	[self.paintView setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
    self.currentBtn = btnBuleColor;
}


-(void) onBtnSkyColor: (id) sender
{
    if (self.currentBtn != btnSkyColor)
    {
        [self checkCurrentBtn];
        self.ma.isRevser = YES;
        self.ma.view = btnSkyColor;
        [self.ma play];
    }
    CGFloat					components[3];
 	HSL2RGB((CGFloat)211/360, 52, 0.9, &components[0], &components[1], &components[2]);
	[self.paintView setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
    self.currentBtn = btnSkyColor;
   
}

-(void) onBtnPurpleColor: (id) sender
{
    if (self.currentBtn != btnPurpleColor)
    {
        [self checkCurrentBtn];
        self.ma.isRevser = YES;
        self.ma.view = btnPurpleColor;
        [self.ma play];
    }
	[self.paintView setBrushColorWithRed:0.261 green:0.203 blue:0.605];
    self.currentBtn = btnPurpleColor;
}

-(void) onBtnEraser: (id) sender
{
    if (self.currentBtn != btnEraser)
    {
        [self checkCurrentBtn];
        self.ma.isRevser = YES;
        self.ma.view = btnEraser;
        [self.ma play];
    }
    self.paintView.kBrushScale = 5;
	[self.paintView setBrushColorWithRed:1 green:1 blue:1];
    self.currentBtn = btnEraser;
}

-(void) onBtnDarkPurpleColor: (id) sender
{
    if (self.currentBtn != darkPurpleColor)
    {
        [self checkCurrentBtn];
        self.mar.isRevser = YES;
        self.mar.view = darkPurpleColor;
        [self.mar play];
    }
	[self.paintView setBrushColorWithRed:0.705 green:0 blue:1.0];
    self.currentBtn = darkPurpleColor;
}

-(void) onBtnPinkColor: (id) sender
{
    if (self.currentBtn != btnPinkColor)
    {
        [self checkCurrentBtn];
        self.mar.isRevser = YES;
        self.mar.view = btnPinkColor;
        [self.mar play];
    }
	[self.paintView setBrushColorWithRed:1.0 green:0.713 blue:0.756];
    self.currentBtn = btnPinkColor;
}

-(void) onBtnGreyColor: (id) sender
{
    if (self.currentBtn != btnGreyColor)
    {
        [self checkCurrentBtn];
        self.mar.isRevser = YES;
        self.mar.view = btnGreyColor;
        [self.mar play];
    }
	[self.paintView setBrushColorWithRed:0.5 green:0.5 blue:0.5];
    self.currentBtn = btnGreyColor;
}

-(void) onBtnWhiteGreyColor: (id) sender
{
    if (self.currentBtn != btnWhiteGreyColor)
    {
        [self checkCurrentBtn];
        self.mar.isRevser = YES;
        self.mar.view = btnWhiteGreyColor;
        [self.mar play];
    }
	[self.paintView setBrushColorWithRed:0.741 green:0.717 blue:0.419];
    self.currentBtn = btnWhiteGreyColor;
}

-(void) onBtnLightBlueColor: (id) sender
{
    if (self.currentBtn != btnLightBlueColor)
    {
        [self checkCurrentBtn];
        self.mar.isRevser = YES;
        self.mar.view = btnLightBlueColor;
        [self.mar play];
    }
	[self.paintView setBrushColorWithRed:0.0 green:0.478 blue:1.0];
    self.currentBtn = btnLightBlueColor;
}

-(void) onBtnMudColor: (id) sender
{
    if (self.currentBtn != btnMudColor)
    {
        [self checkCurrentBtn];
        self.mar.isRevser = YES;
        self.mar.view = btnMudColor;
        [self.mar play];
    }
	[self.paintView setBrushColorWithRed:0.317 green:0.105 blue:0.023];
    self.currentBtn = btnMudColor;
}

-(void) onBtnLightGreenColor: (id) sender
{
    if (self.currentBtn != btnLightGreenColor)
    {
        [self checkCurrentBtn];
        self.mar.isRevser = YES;
        self.mar.view = btnLightGreenColor;
        [self.mar play];
    }
	[self.paintView setBrushColorWithRed:0.0 green:1.0 blue:0.972];
    self.currentBtn = btnLightGreenColor;
}

-(void) onBtnSave: (id) sender
{
    UIImage *img2 = [self.paintView snapshot:self.paintView];
    UIImage *img = [UIImage imageWithContentsOfFile:self.imagePath];
    UIGraphicsBeginImageContext(self.paintView.bounds.size);
    [img2 drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1];
    [img  drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1];
    UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.saveAlert show];
    UIImageWriteToSavedPhotosAlbum(combinedImage,self,@selector(saveComplete:didFinishSavingWithError:contextInfo:),NULL);
}

-(void) onBtnClean: (id) sender
{
    [self.cleanAlert show];
}


-(void)saveComplete:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self.saveAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 2) 
    {
        if (buttonIndex == 1) 
        {
           [self.paintView erase];
        }
    }
}

#pragma mark - Private methods

- (UIButton *)addBtn:(CGRect)frame withImage:(NSString *)image andtarget:(SEL)onBtn
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    NSString *paintImage = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], image];
    UIImage *img = [UIImage imageWithContentsOfFile:paintImage];
//    UIImage *img = [[UIImage alloc] initWithContentsOfFile:paintImage];     //11.25，陈星宇，
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button addTarget:self action:onBtn forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button release];
    
    return button;
}

- (void)initPans
{
    int totalHeight = (kPanSpace + kPanHeight) * (kPanCount/2 -1) + kPanHeight;
    totalHeight = totalHeight * scaleH;
    int starty = (self.view.frame.size.height - totalHeight) / 5 * 2;
    CGRect rect = CGRectMake(-30*scaleW, starty, kPanWidth * scaleW, kPanHeight * scaleH);
    
    //left side
    darkPurpleColor = [self addBtn:rect withImage:@"drpurple.png" andtarget:@selector(onBtnDarkPurpleColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnPinkColor = [self addBtn:rect withImage:@"pink.png" andtarget:@selector(onBtnPinkColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnGreyColor = [self addBtn:rect withImage:@"grey.png" andtarget:@selector(onBtnGreyColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnOrangeColor = [self addBtn:rect withImage:@"Orange.png" andtarget:@selector(onBtnOrangeColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnWhiteGreyColor = [self addBtn:rect withImage:@"whitegrey.png" andtarget:@selector(onBtnWhiteGreyColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnLightBlueColor = [self addBtn:rect withImage:@"lightblue.png" andtarget:@selector(onBtnLightBlueColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnMudColor = [self addBtn:rect withImage:@"mud.png" andtarget:@selector(onBtnMudColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnLightGreenColor = [self addBtn:rect withImage:@"LightGreen.png" andtarget:@selector(onBtnLightGreenColor:)];
    
    //right side
    rect.origin.x = self.view.frame.size.width - (kPanWidth - 30) * scaleW;
    rect.origin.y = starty;
    btnBlackColor = [self addBtn:rect withImage:@"black.png" andtarget:@selector(onBtnBlackColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnBrownColor = [self addBtn:rect withImage:@"brown.png" andtarget:@selector(onBtnBrownColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnYellowColor = [self addBtn:rect withImage:@"yellow.png" andtarget:@selector(onBtnYellowColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnGreenColor = [self addBtn:rect withImage:@"green.png" andtarget:@selector(onBtnGreenColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnBuleColor = [self addBtn:rect withImage:@"bule.png" andtarget:@selector(onBtnBuleColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnRedColor = [self addBtn:rect withImage:@"red.png" andtarget:@selector(onBtnRedColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnSkyColor = [self addBtn:rect withImage:@"sky.png" andtarget:@selector(onBtnSkyColor:)];
    
    rect.origin.y = rect.origin.y + (kPanSpace + kPanHeight) *scaleH;
    btnPurpleColor = [self addBtn:rect withImage:@"purple.png" andtarget:@selector(onBtnPurpleColor:)];
    
    //eraser
    rect.origin.y += 80 * scaleH;
    rect.size = CGSizeMake(93 * scaleW, 79 * scaleH);
    btnEraser = [self addBtn:rect withImage:@"eraser.png" andtarget:@selector(onBtnEraser:)];
    
    rect = CGRectMake(90 * scaleW, self.view.frame.size.height- (20 + 67)*scaleH, 70 * scaleW, 67 * scaleH);
    btnClean = [self addBtn:rect withImage:@"paintClean.png" andtarget:@selector(onBtnClean:)];
    
    rect = CGRectMake(self.view.frame.size.width-(90+65)*scaleW, self.view.frame.size.height- (20 + 67)*scaleH, 65 * scaleW, 67 * scaleH);
    btnSave = [self addBtn:rect withImage:@"paintSave.png" andtarget:@selector(onBtnSave:)];
    
    
    
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    scaleH = 1;
    scaleW = 1;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.view.frame      = CGRectMake(0, 0, width, height);
    scaleH = self.view.frame.size.height / kScreenHeight;
    scaleW = self.view.frame.size.width / kScreenWidth;
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString * path = nil;
    
#if TAIWAN == 1
    
    path = [NSString stringWithFormat:@"%@/%@", [bundle resourcePath], @"mainpaint.png"];
    
#else
    
    path = [NSString stringWithFormat:@"%@/%@", [bundle resourcePath], @"paintBackground.png"];
    
#endif
    
//    NSString * path = [NSString stringWithFormat:@"%@/%@", [bundle resourcePath], @"paintBackground.png"];
    //background
    UIImage *back = [UIImage imageWithContentsOfFile:path];
    //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    UIImageView *background = [[UIImageView alloc] initWithImage:back];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    [background release];
    
    //edit panel
    path = [NSString stringWithFormat:@"%@/%@", [bundle resourcePath], @"editPanel.png"];
    UIImageView *editpanel = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    //    CGFloat x = (self.view.frame.size.width - kEditPanelw * scaleW) / 2 + -2 * scaleW;
    //    CGFloat y = (self.view.frame.size.height - kEditPanelh * scaleH) / 2 + 13 * scaleH;
    
    CGFloat x = (self.view.frame.size.width - kEditPanelw * scaleW) / 2;
    CGFloat y = (self.view.frame.size.height - kEditPanelh * scaleH) / 2;
    editpanel.frame = CGRectMake(x, y, kEditPanelw * scaleW, kEditPanelh * scaleH);
    [self.view addSubview:editpanel];
    [editpanel release];
    
    //paintview
    x = (self.view.frame.size.width - kPaintVieww * scaleW) / 2 + 7*scaleW;
    y = (self.view.frame.size.height - kPaintViewh * scaleH) / 2 + 11 * scaleH;
    paintView = [[PaintingView alloc] initWithFrame:CGRectMake(x, y, kPaintVieww * scaleW, kPaintViewh * scaleH)];
    //paintView = [[PaintingView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    [self.view addSubview:paintView];
    
    self.ma = [[MoveAnimation alloc] init];
    self.mar = [[MoveAnimationReverse alloc] init];
    self.ma.scaleW = scaleW;
    self.mar.scaleW = scaleW;
    UIImage* img = [UIImage imageWithContentsOfFile:self.imagePath];
    self.imageView = [[UIImageView alloc] initWithImage:img];
//    [img release];                                    //11.25，陈星宇，不能释放，因为img本来就加入到自动释放池了，再release会造成提前释放
    [self.paintView addSubview:self.imageView];
    self.imageView.frame = CGRectMake(0, 0, self.paintView.frame.size.width,self.paintView.frame.size.height);
    self.paintView.kBrushScale = 10;
    
    NSString *safe = nil;
    NSString *clear = nil;
    NSString *cancel = nil;
    NSString *confirm = nil;
    
#if TAIWAN == 1
    safe = @"保存中...";
    clear = @"\n\n確定要清空嗎?";
    cancel ＝ @"取消";
    confirm ＝ @"確定";
#elif JAP == 1
    safe = @"保存中";
    clear = @"\n\nクリアしますか?";
//    cancel ＝ @"キャンセル";
//    confirm ＝ @"確定";
#elif SIMP == 1
    safe = @"保存中...";
    clear = @"\n\n确定要清空吗?";
    cancel = @"取消";
    confirm = @"確定";
#endif
    
    self.saveAlert  = [[UIAlertView alloc] initWithTitle:safe message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	self.cleanAlert = [[UIAlertView alloc] initWithTitle:clear message:@"\n\n" delegate:self cancelButtonTitle:cancel otherButtonTitles:confirm  , nil];
    self.cleanAlert.tag = 2;
    
    [saveAlert release];
    [cleanAlert release];
    
    //init pans
    [self initPans];
    
    //    [self onBtnBlackColor:nil];
    [self performSelector:@selector(onBtnBlackColor:) withObject:nil afterDelay:0.05];//应该有delay,避免crash adward 1.21
}

- (void) dealloc
{
    [self.paintView release];
    [self.imageView release];
    [self.ma release];
    [self.mar release];
    [self.saveAlert release];
    [self.cleanAlert release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        return YES;
    }
    return NO;
}

@end
