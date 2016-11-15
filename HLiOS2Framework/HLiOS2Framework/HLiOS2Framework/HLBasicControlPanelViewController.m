//
//  BasicControlPanelViewController.m
//  MoueeIOS2Core
//
//  Created by Allen on 12-11-30.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLBasicControlPanelViewController.h"
#import "HLFlipBaseController.h"
#import "HLBookController.h"
#import "HLSliderFlipController.h"
#import "KGModal.h"
#import "PushHUD.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)        //陈星宇，11.27，适配


@interface HLBasicControlPanelViewController ()

@end

@implementation HLBasicControlPanelViewController

@synthesize btnNext;
@synthesize btnExit;
@synthesize btnPre;
@synthesize btnOpenBookSnapshots;



- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.orientation           = -1;
    self.btnOpenBookSnapshots  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnHome               = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnNext               = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnPre                = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnExit               = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBgMusic            = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSearch            = [UIButton buttonWithType:UIButtonTypeCustom];
    self.view.backgroundColor  = [UIColor clearColor];
    UIImage *bs = [UIImage imageNamed:@"ops.png"];
    UIImage *bh = [UIImage imageNamed:@"home.png"];
    UIImage *bn = [UIImage imageNamed:@"next.png"];
    UIImage *bp = [UIImage imageNamed:@"pre.png"];
    UIImage *be = [UIImage imageNamed:@"exit.png"];
    UIImage *bm = [UIImage imageNamed:@"bg_audio_hg.png"];
    UIImage *bse = [UIImage imageNamed:@"search_page.png"];
    
    UIImage *bsh = [UIImage imageNamed:@"ops_hg.png"];
    UIImage *bhh = [UIImage imageNamed:@"home_hg.png"];
    UIImage *bnh = [UIImage imageNamed:@"next_hg.png"];
    UIImage *bph = [UIImage imageNamed:@"pre_hg.png"];
    UIImage *beh = [UIImage imageNamed:@"exit_hg.png"];
    UIImage *bmh = [UIImage imageNamed:@"bg_audio.png"];
    UIImage *bseh = [UIImage imageNamed:@"search_page_hd.png"];
    
    [self.btnOpenBookSnapshots setBackgroundImage:bs forState:UIControlStateNormal];
    [self.btnOpenBookSnapshots setBackgroundImage:bsh forState:UIControlStateHighlighted];
    [self.btnHome setBackgroundImage:bh forState:UIControlStateNormal];
    [self.btnHome setBackgroundImage:bhh forState:UIControlStateHighlighted];
    [self.btnOpenBookSnapshots setContentMode:UIViewContentModeScaleToFill];
    [self.btnHome setContentMode:UIViewContentModeScaleToFill];
    [self.btnNext setImage:bn forState:UIControlStateNormal];
    [self.btnNext setImage:bnh forState:UIControlStateHighlighted];
    [self.btnPre  setImage:bp forState:UIControlStateNormal];
    [self.btnPre  setImage:bph forState:UIControlStateHighlighted];
    [self.btnExit setImage:be forState:UIControlStateNormal];
    [self.btnExit setImage:beh forState:UIControlStateHighlighted];
    [self.btnBgMusic setImage:bm forState:UIControlStateNormal];
    [self.btnBgMusic setImage:bmh forState:UIControlStateSelected];
    [self.btnSearch setImage:bse forState:UIControlStateNormal];
    [self.btnSearch setImage:bseh forState:UIControlStateHighlighted];
    
    self.btnOpenBookSnapshots.frame = CGRectMake(0, 0, bs.size.width, bs.size.height);
    self.btnHome.frame              = CGRectMake(0, 0, bh.size.width, bh.size.height);
    self.btnNext.frame              = CGRectMake(0, 0, bn.size.width, bn.size.height);
    self.btnPre.frame               = CGRectMake(0, 0, bp.size.width, bp.size.height);
    self.btnExit.frame              = CGRectMake(0, 0, be.size.width, be.size.height);
    self.btnBgMusic.frame           = CGRectMake(0, 0, bm.size.width, bm.size.height);
    self.btnSearch.frame            = CGRectMake(0, 0, bse.size.width, bse.size.height);

    [self.view addSubview:self.btnOpenBookSnapshots];
    [self.view addSubview:self.btnHome];
    [self.view addSubview:self.btnNext];
    [self.view addSubview:self.btnPre];
    [self.view addSubview:self.btnExit];
    [self.view addSubview:self.btnBgMusic];
//    [self.view addSubview:self.btnSearch];
    
    [self.btnOpenBookSnapshots addTarget:self action:@selector(onBtnShowSnapshots) forControlEvents:UIControlEventTouchUpInside];
    [self.btnHome addTarget:self action:@selector(onBtnHome) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNext addTarget:self action:@selector(onBtnNext) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPre  addTarget:self action:@selector(onBtnPre)  forControlEvents:UIControlEventTouchUpInside];
    [self.btnExit  addTarget:self action:@selector(onBtnExit)  forControlEvents:UIControlEventTouchUpInside];
    [self.btnBgMusic  addTarget:self action:@selector(onBtnBgMusic)  forControlEvents:UIControlEventTouchUpInside];
    [self.btnSearch  addTarget:self action:@selector(onBtnSearch)  forControlEvents:UIControlEventTouchUpInside];
    
	// Do any additional setup after loading the view.
    //隐藏返回按钮
    if (self.isHideBackBtn) {
        self.btnExit.hidden = YES;
        [self.btnExit removeFromSuperview];
    }
    if (!self.bookController.entity.isLoadNavi) {           //陈星宇，11.20，快速导航没有
        self.btnOpenBookSnapshots.hidden = YES;
        [self.btnOpenBookSnapshots removeFromSuperview];
    }
    if (self.isPDFType) {
        self.btnOpenBookSnapshots.hidden = YES;
        [self.btnOpenBookSnapshots removeFromSuperview];
        
        self.btnHome.hidden = YES;
        [self.btnHome removeFromSuperview];
        
        self.btnNext.hidden = YES;
        [self.btnNext removeFromSuperview];
        
        self.btnPre.hidden = YES;
        [self.btnPre removeFromSuperview];
    }
    
    allPageEntityArr = [[NSMutableArray alloc] init];
}

-(void) onBtnBgMusic
{
    if (!self.btnBgMusic.selected)
    {
        [self.bookController.flipBaseViewController.flipController pauseBackgroundMusic];
    }
    else
    {
        [self.bookController.flipBaseViewController.flipController playBackgroundMusic];
    }
}

-(void)onBtnSearch
{
    if (allPageEntityArr.count == 0) {
        NSArray *allPageId = self.bookController.flipController.navView.allPageIdArr;
        for (int i = 0; i < allPageId.count; i++)
        {
            if ([[allPageId objectAtIndex:i] isKindOfClass:[NSArray class]] && [[allPageId objectAtIndex:i] count] > 0)
            {
                
                NSString *pageId = [[allPageId objectAtIndex:i] objectAtIndex:0];
                HLPageEntity *pageEntity = [HLPageDecoder decode:pageId path:self.bookController.flipController.navView.rootpath];
                [allPageEntityArr addObject:pageEntity];
            }
            else
            {
                NSString *pageId = [allPageId objectAtIndex:i];
                HLPageEntity *pageEntity = [HLPageDecoder decode:pageId path:self.bookController.flipController.navView.rootpath];
                [allPageEntityArr addObject:pageEntity];
            }
        }
        searchViewController.allPageEntityArr = allPageEntityArr;
        searchViewController.rootPath = self.bookController.flipController.navView.rootpath;
    }
    
    [[KGModal sharedInstance] showWithContentView:searchViewController.view andAnimated:YES];
}

- (void)collectionCellDidSelected:(NSString *)pageId
{
    [self.bookController.flipController gotoPageWithPageID:pageId animate:YES];
    curIndex = self.bookController.flipController.currentPageIndex;
}

-(void) onBtnShowSnapshots
{
    if (self.bookController != nil)
    {
        [self.bookController.flipController onNav];
    }
}

-(void) onBtnHome
{
    if (self.bookController != nil)
    {
        [self.bookController.flipController homePage];
    }
}

-(void) onBtnNext
{
    if (self.bookController != nil)
    {
        [self.bookController.flipController nextPage];
    }
}

-(void) onBtnPre
{
    if (self.bookController != nil)
    {
        [self.bookController.flipController prePage];
    }
}

-(void) onBtnExit
{
    if (self.bookController != nil)
    {
        [self.bookController close];
    }
}

- (void)viewWillLayoutSubviews
{
    
}

-(void) setup:(CGRect )rect
{
    float rate = self.sx > self.sy ? self.sy : self.sx;
    
    //SnapShotButton
    {
        HLButtonEntity *btn =self.bookController.entity.snapBtn;
        if((self.bookController.entity.isVerHorMode == YES) && (self.orientation != -1))
        {
            if ((self.orientation == UIInterfaceOrientationPortrait) || (self.orientation == UIInterfaceOrientationPortraitUpsideDown))
            {
                btn = self.bookController.entity.vsnapBtn;
            }
            else
            {
                btn = self.bookController.entity.snapBtn;
            }
        }
        else
        {
            btn = self.bookController.entity.snapBtn;
        }
        self.btnOpenBookSnapshots.frame = CGRectMake(btn.x*self.sx, btn.y*self.sy, btn.width*rate, btn.height*rate);
        if(self.bookController.entity.snapBtn.isUserDef == YES)
        {
            NSString *hp = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnHighlightImg];
            NSString *np = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnImg];
            UIImage *npi = [UIImage imageWithContentsOfFile:np];
            UIImage *hgi = [UIImage imageWithContentsOfFile:hp];
            [self.btnOpenBookSnapshots setBackgroundImage:npi forState:UIControlStateNormal];
            [self.btnOpenBookSnapshots setBackgroundImage:hgi forState:UIControlStateHighlighted];
        }
        
        if (btn.isVisible == NO)
        {
            self.btnOpenBookSnapshots.layer.opacity = 0.0;
        }
        else
        {
            self.btnOpenBookSnapshots.layer.opacity = 1.0;
        }
    }
    
    
    {
        HLButtonEntity *btn = self.bookController.entity.exitBtn;
        
    }
    
    //  HomeButton
    {
        HLButtonEntity *btn = self.bookController.entity.homeBtn;
        if((self.bookController.entity.isVerHorMode == YES) && (self.orientation != -1))
        {
            if ((self.orientation == UIInterfaceOrientationPortrait) || (self.orientation == UIInterfaceOrientationPortraitUpsideDown))
            {
                btn = self.bookController.entity.vhomeBtn;
            }
            else
            {
                btn = self.bookController.entity.homeBtn;
            }
        }
        else
        {
            btn = self.bookController.entity.homeBtn;
        }
        self.btnHome.frame = CGRectMake(btn.x*self.sx, btn.y*self.sy, btn.width*rate, btn.height*rate);
        if (self.bookController.entity.homeBtn.isUserDef == YES)
        {
            NSString *hp = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnHighlightImg];
            NSString *np = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnImg];
            UIImage *npi = [UIImage imageWithContentsOfFile:np];
            UIImage *hgi = [UIImage imageWithContentsOfFile:hp];
            [self.btnHome setBackgroundImage:npi forState:UIControlStateNormal];
            [self.btnHome setBackgroundImage:hgi forState:UIControlStateHighlighted];
        }
        
        if (btn.isVisible == NO)
        {
            self.btnHome.layer.opacity = 0.0;
        }
        else
        {
            self.btnHome.layer.opacity = 1.0;
        }
    }
    
    //  RightButton
    {
        HLButtonEntity *btn = self.bookController.entity.rightBtn;
        if((self.bookController.entity.isVerHorMode == YES) && (self.orientation != -1))
        {
            if ((self.orientation == UIInterfaceOrientationPortrait) || (self.orientation == UIInterfaceOrientationPortraitUpsideDown))
            {
                btn = self.bookController.entity.vrightBtn;
            }
            else
            {
                btn = self.bookController.entity.rightBtn;
            }
        }
        else
        {
            btn = self.bookController.entity.rightBtn;
        }

        self.btnNext.frame = CGRectMake(btn.x*self.sx, btn.y*self.sy, btn.width*rate, btn.height*rate);
        if (self.bookController.entity.rightBtn.isUserDef == YES)
        {
            NSString *hp = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnHighlightImg];
            NSString *np = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnImg];
            UIImage *npi = [UIImage imageWithContentsOfFile:np];
            UIImage *hgi = [UIImage imageWithContentsOfFile:hp];
            [self.btnNext setImage:npi forState:UIControlStateNormal];
            [self.btnNext setImage:hgi forState:UIControlStateHighlighted];
        }
        
        if (btn.isVisible == NO)
        {
            self.btnNext.layer.opacity = 0.0;
        }
        else
        {
            self.btnNext.layer.opacity = 1.0;
        }
    }
    
    //  LeftButton
    {
        HLButtonEntity *btn = self.bookController.entity.leftBtn;
        if((self.bookController.entity.isVerHorMode == YES) && (self.orientation != -1))
        {
            if ((self.orientation == UIInterfaceOrientationPortrait) || (self.orientation == UIInterfaceOrientationPortraitUpsideDown))
            {
                btn = self.bookController.entity.vleftBtn;
            }
            else
            {
                btn = self.bookController.entity.leftBtn;
            }
        }
        else
        {
            btn = self.bookController.entity.leftBtn;
        }

        self.btnPre.frame = CGRectMake(btn.x*self.sx, btn.y*self.sy, btn.width*rate, btn.height*rate);
        if (self.bookController.entity.leftBtn.isUserDef == YES)
        {
            NSString *hp = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnHighlightImg];
            NSString *np = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnImg];
            UIImage *npi = [UIImage imageWithContentsOfFile:np];
            UIImage *hgi = [UIImage imageWithContentsOfFile:hp];
            [self.btnPre setImage:npi forState:UIControlStateNormal];
            [self.btnPre setImage:hgi forState:UIControlStateHighlighted];
        }
        
        if (btn.isVisible == NO)
        {
            self.btnPre.layer.opacity = 0.0;
        }
        else
        {
            self.btnPre.layer.opacity = 1.0;
        }
    }
//    self.btnExit.frame              = CGRectMake(CGRectGetMaxX(self.btnHome.frame), 0, CGRectGetWidth(self.btnHome.frame), CGRectGetHeight(self.btnHome.frame));
  CGFloat width = CGRectGetWidth(self.btnExit.frame) * rate;
  CGFloat height = CGRectGetHeight(self.btnExit.frame) * rate;
    self.btnExit.frame = CGRectMake(((CGRectGetWidth(rect) / 2 - width/2)), 0, width, height);
    
//    self.btnExit.frame = CGRectMake(rect.size.width/2 - CGRectGetWidth(self.btnExit.frame), 0, CGRectGetWidth(self.btnExit.frame) * rate, CGRectGetHeight(self.btnExit.frame) *rate);
    self.view.frame                 = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);          //陈星宇，11.27，适配

    
    //  BgMusicButton
    {
        HLButtonEntity *btn =self.bookController.entity.bgMusicBtn;
        if((self.bookController.entity.isVerHorMode == YES) && (self.orientation != -1))
        {
            if ((self.orientation == UIInterfaceOrientationPortrait) || (self.orientation == UIInterfaceOrientationPortraitUpsideDown))
            {
                btn = self.bookController.entity.bgMusicBtn;
            }
            else
            {
                btn = self.bookController.entity.bgMusicBtn;
            }
        }
        else
        {
            btn = self.bookController.entity.bgMusicBtn;
        }
        self.btnBgMusic.frame = CGRectMake(btn.x*self.sx, btn.y*self.sy, btn.width*rate, btn.height*rate);
        if(self.bookController.entity.snapBtn.isUserDef == YES)
        {
            NSString *hp = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnHighlightImg];
            NSString *np = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnImg];
            UIImage *npi = [UIImage imageWithContentsOfFile:np];
            UIImage *hgi = [UIImage imageWithContentsOfFile:hp];
            [self.btnBgMusic setImage:npi forState:UIControlStateNormal];
            [self.btnBgMusic setImage:hgi forState:UIControlStateSelected];
        }
        
        if (btn.isVisible == NO)
        {
            self.btnBgMusic.layer.opacity = 0.0;
        }
        else
        {
            self.btnBgMusic.layer.opacity = 1.0;
        }
    }
    
    
    //  SearchButton
    {
        HLButtonEntity *btn =self.bookController.entity.searchBtn;
        if  (btn)
        {
            searchViewController = [[HLSearchViewController alloc] init];
            searchViewController.view.frame = CGRectMake(0, 0, 500, 500);
        }
        if((self.bookController.entity.isVerHorMode == YES) && (self.orientation != -1))
        {
            if ((self.orientation == UIInterfaceOrientationPortrait) || (self.orientation == UIInterfaceOrientationPortraitUpsideDown))
            {
                btn = self.bookController.entity.searchBtn;
            }
            else
            {
                btn = self.bookController.entity.searchBtn;
            }
        }
        else
        {
            btn = self.bookController.entity.searchBtn;
        }
        self.btnSearch.frame = CGRectMake(btn.x*self.sx, btn.y*self.sy, btn.width*rate, btn.height*rate);
        if(self.bookController.entity.snapBtn.isUserDef == YES)
        {
            NSString *hp = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnHighlightImg];
            NSString *np = [self.bookController.rootPath stringByAppendingPathComponent:btn.btnImg];
            UIImage *npi = [UIImage imageWithContentsOfFile:np];
            UIImage *hgi = [UIImage imageWithContentsOfFile:hp];
            [self.btnSearch setImage:npi forState:UIControlStateNormal];
            [self.btnSearch setImage:hgi forState:UIControlStateSelected];
        }
        
        if (btn.isVisible == NO)
        {
            self.btnSearch.layer.opacity = 0.0;
        }
        else
        {
            self.btnSearch.layer.opacity = 1.0;
        }
        
        
        if (_activePushBtn) {
            // Feature - Push List Button - Emiaostein, Sep 2, 2016
            UIButton *list = [UIButton buttonWithType:(UIButtonTypeCustom)];
            UIImage *image = [UIImage imageNamed:@"notification"];
            list.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            [list setImage:[UIImage imageNamed:@"notification_selected"] forState:(UIControlStateHighlighted)];
            [list setImage:[UIImage imageNamed:@"notification"] forState:(UIControlStateNormal)];
            [list addTarget:self action:@selector(showList) forControlEvents:(UIControlEventTouchUpInside)];
            [self.view addSubview:list];
            CGRect f = self.btnOpenBookSnapshots.frame;
            f.origin.x -= f.size.width;
            list.frame = f;
            //        if (_isHideBackBtn) {
            //            CGRect f = self.btnOpenBookSnapshots.frame;
            //            list.frame = CGRectMake(CGRectGetMidX(rect) - CGRectGetWidth(self.btnExit.frame)/2, 0, CGRectGetWidth(f), CGRectGetHeight(f));
            //        } else {
            //            
            //        }
        }

        
    }
}

- (void) showList {
    [PushHUD showList];
}

-(void) refreshPanel:(int)index count:(int)count enableNav:(Boolean )enableNav
{
    self.btnNext.hidden = NO;
    self.btnPre.hidden  = NO;
    self.btnHome.hidden = NO;
    self.btnBgMusic.hidden = NO;
    self.btnSearch.hidden = NO;
    self.btnOpenBookSnapshots.hidden = NO;
    if (![self.btnHome superview])
    {
        [self.view addSubview:self.btnOpenBookSnapshots];
        [self.view addSubview:self.btnHome];
        [self.view addSubview:self.btnNext];
        [self.view addSubview:self.btnPre];
        [self.view addSubview:self.btnBgMusic];
//        [self.view addSubview:self.btnSearch];
    }
    
    if (enableNav == NO)
    {
        self.btnNext.hidden = YES;
        self.btnPre.hidden  = YES;
        self.btnHome.hidden = YES;
        self.btnOpenBookSnapshots.hidden = YES;
        self.btnBgMusic.hidden = YES;
        self.btnSearch.hidden = YES;
        
        [self.btnNext removeFromSuperview];
        [self.btnPre removeFromSuperview];
        [self.btnHome removeFromSuperview];
        [self.btnOpenBookSnapshots removeFromSuperview];
        [self.btnBgMusic removeFromSuperview];
//        [self.btnSearch removeFromSuperview];
    }
    else
    {
        if (index == 0)
        {
            self.btnPre.hidden = YES;
        }
        if ((index + 1) == count)
        {
            self.btnNext.hidden = YES;
        }
    }
    
    if ([self.bookController.flipController isKindOfClass:[HLSliderFlipController class]])
    {
        self.btnNext.hidden = YES;
        self.btnPre.hidden  = YES;
        if ([self.btnExit superview])
        {
            [self.btnNext removeFromSuperview];
            [self.btnPre removeFromSuperview];
        }
    }
}
-(void) enable
{
    self.btnSearch.enabled = YES;
    self.btnBgMusic.enabled = YES;
    self.btnHome.enabled = YES;
    self.btnNext.enabled = YES;
    self.btnExit.enabled = YES;
    self.btnOpenBookSnapshots.enabled = YES;
    self.btnPre.enabled = YES;
}
-(void) disable
{
    self.btnSearch.enabled = NO;
    self.btnBgMusic.enabled = NO;
    self.btnHome.enabled = NO;
    self.btnNext.enabled = NO;
    self.btnExit.enabled = NO;
    self.btnOpenBookSnapshots.enabled = NO;
    self.btnPre.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)dealloc
{
    [allPageEntityArr release];
    [searchViewController release];
    [self.btnSearch release];
    [self.btnBgMusic release];
    [self.btnExit release];
    [self.btnHome release];
    [self.btnNext release];
    [self.btnPre release];
    [self.btnOpenBookSnapshots release];
    [super dealloc];
}

@end
