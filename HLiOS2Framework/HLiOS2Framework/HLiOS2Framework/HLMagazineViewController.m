//
//  MagazineViewController.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/24/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLMagazineViewController.h"
#import "HLBookController.h"
#import "HLPageDecoder.h"

#define KNOTIFICATION_PAGECHANGE        @"PageChangeRefreshTag"

@interface HLMagazineViewController ()

@end

@implementation HLMagazineViewController
@synthesize popBtn;
@synthesize controlPanel;
@synthesize isPoped;
@synthesize shareBtn;
@synthesize returnBtn;
@synthesize popoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"IndesignCollectionArray"];
//    [[NSUserDefaults standardUserDefaults] synchronize];

    
    self.popBtn = [[[UIButton alloc] init] autorelease];
    UIImage *pn = [UIImage imageNamed:@"pop_btn_n.png"];
    [self.popBtn setImage:pn forState:UIControlStateNormal];
    self.popBtn.frame = CGRectMake(0, 0, pn.size.width, pn.size.height);
    [self.view addSubview:self.popBtn];
    [self.popBtn addTarget:self action:@selector(onPop) forControlEvents:UIControlEventTouchUpInside];
    
    self.controlPanel = [[[UIView alloc] init] autorelease];
    self.bgImg        = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mg_con_bg.png"]] autorelease];
    [self.controlPanel addSubview:self.bgImg];
    self.controlPanel.alpha = .9;
    [self.view addSubview:self.controlPanel];
    
    self.homeBtn      = [[[UIButton alloc] init] autorelease];
    UIImage *hn       = [UIImage imageNamed:@"mg_home_btn_n.png"];
    [self.homeBtn setImage:hn forState:UIControlStateNormal];
    self.homeBtn.frame = CGRectMake(0, 0, hn.size.width, hn.size.height);
    [self.controlPanel addSubview:self.homeBtn];
    [self.homeBtn addTarget:self action:@selector(onBtnHome) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareBtn     = [[[UIButton alloc] init] autorelease];
    UIImage *sn       = [UIImage imageNamed:@"mg_share_btn_n.png"];
    [self.shareBtn setImage:sn forState:UIControlStateNormal];
    self.shareBtn.frame = CGRectMake(0, 0, sn.size.width, sn.size.height);
    [self.controlPanel addSubview:self.shareBtn];
    [self.shareBtn addTarget:self action:@selector(onShareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.returnBtn    = [[[UIButton alloc] init] autorelease];
    UIImage *rn       = [UIImage imageNamed:@"mg_return_btn_n.png"];
    [self.returnBtn setImage:rn forState:UIControlStateNormal];
    self.returnBtn.frame = CGRectMake(0, 0, rn.size.width, rn.size.height);
    [self.controlPanel addSubview:self.returnBtn];
    
    [self.returnBtn addTarget:self action:@selector(onBtnExit) forControlEvents:UIControlEventTouchUpInside];
    
    self.popupViewController = [[HLMagazinePopupViewController alloc] init];
    self.popupViewController.popupController = self;
    self.isPoped = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.returnBtn.frame = self.shareBtn.frame;
        self.shareBtn.hidden = YES;
    }
    
    //收藏
    _collectionButton = [self getButtonWithFrame:CGRectMake(0, 0, rn.size.width, rn.size.height) normalImg:@"Magazine_ShowCoNorUp.png" selectedImg:@"Magazine_ShowCoNorDown.png" target:self action:@selector(collectionBtnClicked)];
    [self.controlPanel addSubview:_collectionButton];
    
    _collectionTableView = [[HLCollectionTableView alloc] initWithFrame:CGRectZero];
    _collectionTableView.alpha = 0;
    _collectionTableView.collectionDelegate = self;
    
    //隐藏返回按钮
    if (self.isHideBackBtn) {
        self.returnBtn.hidden = YES;
        [self.returnBtn removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChangeFromSlider) name:KNOTIFICATION_PAGECHANGE object:nil];
}

- (void)pageChangeFromSlider
{
    _curIndex = self.bookController.flipController.currentPageIndex;
    [self checkIsColleciton:_curIndex];
}

//收藏
- (void)collectionBtnClicked
{
    _collectionButton.selected = !_collectionButton.selected;
    
    _curIndex = self.bookController.flipController.currentPageIndex;
    _allCount = self.bookController.flipController.navView.snapshots.count;
    
    if (self.bookController.flipController.navView.allPageIdArr.count == 0)
    {
        return;
    }
    NSString *pageId = [[self.bookController.flipController.navView.allPageIdArr objectAtIndex:_curIndex] objectAtIndex:0];
  
    HLPageEntity *pageEntity = [HLPageDecoder decode:pageId path:self.bookController.flipController.navView.rootpath];
    NSString *imgName = pageEntity.cacheImageID;
    NSString *path = [self.bookController.flipController.navView.rootpath stringByAppendingPathComponent:imgName];
    
    if (pageEntity.linkPageID != nil && ![pageEntity.linkPageID isEqualToString:@""])
    {
        HLPageEntity *linkPageEntity = [HLPageDecoder decode:pageEntity.linkPageID path:self.bookController.flipController.navView.rootpath];
        NSString *linkImgName = linkPageEntity.cacheImageID;
        NSString *linkPath = [self.bookController.flipController.navView.rootpath stringByAppendingPathComponent:linkImgName];
        
        if (pageEntity.isVerticalPageType)
        {
            _collectionTableView.curVerPageId = pageEntity.entityid;
            _collectionTableView.curHorPageId = pageEntity.linkPageID;
            _collectionTableView.curHorImgPath = linkPath;
            _collectionTableView.curVerImgPath = path;
        }
        else
        {
            _collectionTableView.curHorPageId = pageEntity.entityid;
            _collectionTableView.curVerPageId = pageEntity.linkPageID;
            _collectionTableView.curHorImgPath = path;
            _collectionTableView.curVerImgPath = linkPath;
        }
    }
    else
    {
        _collectionTableView.curVerPageId = pageEntity.entityid;
        _collectionTableView.curHorPageId = pageEntity.entityid;
        _collectionTableView.curHorImgPath = path;
        _collectionTableView.curVerImgPath = path;
    }
    
    _collectionTableView.curPageTitle = pageEntity.title;
    [_collectionTableView getLocationList:self.bookController.entity.name];
    [_collectionTableView reloadData];
    
    if (_collectionButton.selected)
    {
        [self.view insertSubview:_collectionTableView belowSubview:controlPanel];
        _collectionTableView.frame = CGRectMake(_collectionTableView.frame.origin.x, 44, _collectionTableView.frame.size.width, _collectionTableView.frame.size.height);
        [UIView animateWithDuration:.3 animations:^{
            _collectionTableView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^{
            _collectionTableView.alpha = 0;
            _collectionTableView.frame = CGRectMake(_collectionTableView.frame.origin.x, 0, _collectionTableView.frame.size.width, _collectionTableView.frame.size.height);
        } completion:^(BOOL finished) {
            [_collectionTableView removeFromSuperview];
        }];
    }
}

-(void) onShareBtn
{
    if (self.popoverController == nil)
    {
        self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:self.popupViewController] autorelease];
    }
    [self.popoverController setPopoverContentSize:CGSizeMake(400, 280)];
    NSString *rootPath = self.bookController.rootPath;
    rootPath = [rootPath stringByAppendingPathComponent:[self.bookController.flipController.navView.snapshots objectAtIndex:self.bookController.flipController.currentPageIndex]];
    self.popupViewController.snappath = [rootPath copy];
    [self.popoverController presentPopoverFromRect:self.shareBtn.frame inView:self.view permittedArrowDirections:
     UIPopoverArrowDirectionAny animated:YES];
}

-(void) onPop
{
    if (_collectionButton.selected)
    {
        [self collectionBtnClicked];
    }
    if (self.isPoped == NO)
    {
        [UIView beginAnimations:@"Popup" context:nil];
        [UIView setAnimationDuration:0.20];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.controlPanel.frame = CGRectMake(0, 0, self.controlPanel.frame.size.width, self.controlPanel.frame.size.height);
        [UIView commitAnimations];
        self.isPoped = YES;
        self.popBtn.hidden = YES;
        [self.bookController.flipController disableAction];
    }
    else
    {
        [UIView beginAnimations:@"Popup" context:nil];
        [UIView setAnimationDuration:0.20];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.controlPanel.frame = CGRectMake(0, -self.controlPanel.frame.size.height, self.controlPanel.frame.size.width, self.controlPanel.frame.size.height);
        [UIView commitAnimations];
        self.isPoped = NO;
        self.popBtn.hidden = NO;
        [self.bookController.flipController enableAction];
    }
    if (self.bookController != nil)
    {
        [self.bookController.flipController onNav];
    }
}

-(void)onTouchInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (_collectionButton.selected)
    {
        [self collectionBtnClicked];
    }
    point = [self.bookController.flipController.navView convertPoint:point fromView:self.view];
    if ([self.bookController.flipController.navView pointInside:point withEvent:event] == NO)
    {
        if (self.isPoped == YES)
        {
            [UIView beginAnimations:@"Popup" context:nil];
            [UIView setAnimationDuration:0.20];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.controlPanel.frame = CGRectMake(0, -self.controlPanel.frame.size.height, self.controlPanel.frame.size.width, self.controlPanel.frame.size.height);
            [UIView commitAnimations];
            self.isPoped = NO;
            self.popBtn.hidden = NO;
            [self.bookController.flipController enableAction];
            if (self.bookController != nil)
            {
                [self.bookController.flipController popDownNav];
            }
        }
    }
}

-(void) popDown
{
    if (_collectionButton.selected)
    {
        [self collectionBtnClicked];
    }
    if (self.isPoped == NO)
    {
        [UIView beginAnimations:@"Popup" context:nil];
        [UIView setAnimationDuration:0.20];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.controlPanel.frame = CGRectMake(0, 0, self.controlPanel.frame.size.width, self.controlPanel.frame.size.height);
        [UIView commitAnimations];
        self.isPoped = YES;
        self.popBtn.hidden = YES;
        [self.bookController.flipController disableAction];
    }
    else
    {
        [UIView beginAnimations:@"Popup" context:nil];
        [UIView setAnimationDuration:0.20];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.controlPanel.frame = CGRectMake(0, -self.controlPanel.frame.size.height, self.controlPanel.frame.size.width, self.controlPanel.frame.size.height);
        [UIView commitAnimations];
        self.isPoped = NO;
        self.popBtn.hidden = NO;
        [self.bookController.flipController enableAction];
    }
}

-(void) setup:(CGRect )rect
{
    if (rect.size.width > rect.size.height) {
        _isVerOritation = NO;
    }
    else
    {
        _isVerOritation = YES;
    }
    _collectionTableView.isVerOritaiton = _isVerOritation;
    _collectionTableView.frame = CGRectMake(rect.size.width - 323, 0, 323, rect.size.height - 44 - 190);
    
    self.popBtn.frame = CGRectMake(rect.size.width/2-self.popBtn.frame.size.width/2, rect.size.height - self.popBtn.frame.size.height, self.popBtn.frame.size.width, self.popBtn.frame.size.height);
    
    self.bgImg.frame = CGRectMake(0, 0, rect.size.width, 44);
    if (self.isPoped == YES)
    {
        self.controlPanel.frame = CGRectMake(0, 0, rect.size.width, 44);
    }
    else
    {
        self.controlPanel.frame = CGRectMake(0, -44, rect.size.width, 44);
    }
    self.homeBtn.frame   = CGRectMake(20, self.controlPanel.frame.size.height/2 - self.homeBtn.frame.size.height/2, self.homeBtn.frame.size.width, self.homeBtn.frame.size.height);
  //  self.shareBtn.frame  = CGRectMake(self.controlPanel.frame.size.width - self.shareBtn.frame.size.width - 20, self.controlPanel.frame.size.height/2 - self.shareBtn.frame.size.height/2, self.shareBtn.frame.size.width, self.shareBtn.frame.size.height);
    self.returnBtn.frame  = CGRectMake(self.controlPanel.frame.size.width - (self.shareBtn.frame.size.width + 20) * 2, self.controlPanel.frame.size.height/2 - self.shareBtn.frame.size.height/2, self.shareBtn.frame.size.width, self.shareBtn.frame.size.height);
    _collectionButton.frame = CGRectMake(self.controlPanel.frame.size.width - _collectionButton.frame.size.width - 20, self.controlPanel.frame.size.height/2 - _collectionButton.frame.size.height/2, _collectionButton.frame.size.width, _collectionButton.frame.size.height);
    self.shareBtn.hidden = YES;
}

-(void) dismissPopup
{
    [self.popoverController dismissPopoverAnimated:YES];
}

-(void) onBtnHome
{
    if ([UIAccelerometer sharedAccelerometer].delegate)
    {
        [UIAccelerometer sharedAccelerometer].delegate = nil;
    }
    if (self.bookController != nil)
    {
        [self.bookController.flipController homePage];
    }
}

-(void) onBtnExit
{
    if (self.bookController != nil)
    {
        [self.bookController close];
    }
}

//是否已经收藏
- (void)checkIsColleciton:(int)index
{
    NSString *pageId = [[self.bookController.flipController.navView.allPageIdArr objectAtIndex:_curIndex] objectAtIndex:0];
    NSArray *collectionArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IndesignCollectionArray%@", self.bookController.entity.name]]];
    
    BOOL isExist = NO;
    for (NSDictionary *dic in collectionArray)
    {
        if ([[dic objectForKey:@"horId"] isEqualToString:pageId] || [[dic objectForKey:@"verId"] isEqualToString:pageId]) {
            [self addCollection:YES];
            [_collectionTableView setCollectBtnState:YES];
            isExist = YES;
            break;
        }
    }
    if (!isExist)
    {
        [self addCollection:NO];
        [_collectionTableView setCollectBtnState:NO];
    }
}

#pragma mark - CollectionDelegate

- (void)addCollection:(BOOL)add
{
    if (add)
    {
        [_collectionButton setImage:[UIImage imageNamed:@"Magazine_ShowCoSeleUp.png"] forState:UIControlStateNormal];
        [_collectionButton setImage:[UIImage imageNamed:@"Magazine_ShowCoSeleDown.png"] forState:UIControlStateSelected];
        
    }
    else
    {
        [_collectionButton setImage:[UIImage imageNamed:@"Magazine_ShowCoNorUp.png"] forState:UIControlStateNormal];
        [_collectionButton setImage:[UIImage imageNamed:@"Magazine_ShowCoNorDown.png"] forState:UIControlStateSelected];
    }
}

- (void)collectionCellDidSelected:(NSString *)pageId
{
    if (_collectionButton.selected)
    {
        [self collectionBtnClicked];
    }
    [self.bookController.flipController gotoPageWithPageID:pageId animate:YES];
    _curIndex = self.bookController.flipController.currentPageIndex;
    [self addCollection:YES];
    [_collectionTableView setCollectBtnState:YES];
}

- (UIButton *)getButtonWithFrame:(CGRect)frame normalImg:(NSString *)normalImg selectedImg:(NSString *)selectedImg target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedImg] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:selectedImg] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:selectedImg] forState:UIControlStateSelected | UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:frame];
    return button;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self.popupViewController release];
    [self.popoverController release];
    [super dealloc];
}

@end
