//
//  IndesignControlPanelViewController.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-8.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "IndesignControlPanelViewController.h"
#import "HLBookController.h"
#import "HLSliderFlipController.h"
#import "SnapshotEntity.h"

#define kShowSearch         YES //modified by Adward 开启搜索功能13-12-12
#define kScrollScale        .34
#define kContentScale       .9
#define kScrPicCount        4

#define KNOTIFICATION_PAGEVIEWTAP       @"PageViewTap"
#define KNOTIFICATION_PAGEDRAGGING      @"PageBeginDragging"
#define KNOTIFICATION_PAGECHANGE        @"PageChangeRefreshTag"
#define KNOTIFICATION_SUBPAGECHANGE     @"SliderPageSubPageChange"

@interface IndesignControlPanelViewController ()

@end

@implementation IndesignControlPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.clipsToBounds = YES;      //Mr.chen , 1.23
    
    UIPanGestureRecognizer *panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)] autorelease];
    
    _topScrollView = [[UIScrollView alloc] init];
    [_topScrollView addGestureRecognizer:panGestureRecognizer];
    _topScrollView.backgroundColor = [UIColor colorWithRed:101 / 255.0 green:101 / 255.0 blue:101 / 255.0 alpha:1];
    _topScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.delegate = self;
    _topScrollView.hidden = YES;
    _topScrollView.scrollEnabled = NO;
    
    //标题背景
    _titleBgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Indesign_TitleBgImg.png"]];
    _titleBgImg.alpha = 0;
    _titleBgImg.frame = CGRectMake(0, 0, 1024, 187);
    
    _topControlPanel = [[[UIView alloc] init] autorelease];
    _topControlPanel.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_topControlPanel];
    
    UIImageView *topNavBackground = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)] autorelease];
    [topNavBackground setImage:[UIImage imageNamed:@"Indesign_TopNavBgImg.png"]];
    [_topControlPanel addSubview:topNavBackground];
    
    //主页
    UIButton *homeButton = [self getButtonWithFrame:CGRectMake(0, 0, 44, 44) normalImg:@"Indesign_NavHomeBtnUp.png" selectedImg:@"Indesign_NavHomeBtnDown.png" target:self action:@selector(homeClicked)];
    [_topControlPanel addSubview:homeButton];
    
    UIButton *backButton = [self getButtonWithFrame:CGRectMake(44, 0, 44, 44) normalImg:@"Indesign_NavBackBtnUp.png" selectedImg:@"Indesign_NavBackBtnDown.png" target:self action:@selector(backClicked)];
    [_topControlPanel addSubview:backButton];
    
    if (self.bookController.entity.isVerHorMode)
    {
        backButton.frame = CGRectMake(44, 0, 0, 0);
        backButton.hidden = YES;
    }
    
    //目录
    _catalogueButton = [self getButtonWithFrame:CGRectMake(backButton.frame.origin.x + backButton.frame.size.width, 0, 44, 44) normalImg:@"Indesign_NavCataBtnUp.png" selectedImg:@"Indesign_NavCataBtnDown.png" target:self action:@selector(catalogueBtnClicked)];
    [_topControlPanel addSubview:_catalogueButton];
    
    _catalogueTableView = [[CatalogueTableView alloc] initWithFrame:CGRectZero];
    _catalogueTableView.alpha = 0;
    _catalogueTableView.catalogueDelegate = self;
    
    _bookTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(142, 13, 500, 20)] autorelease];
    _bookTitleLabel.backgroundColor = [UIColor clearColor];
    _bookTitleLabel.textColor = [UIColor whiteColor];
    _bookTitleLabel.font = [UIFont systemFontOfSize:15];
    [_topControlPanel addSubview:_bookTitleLabel];
    _bookTitleLabel.hidden = YES;
    
    //收藏
    _collectionButton = [self getButtonWithFrame:CGRectMake(0, 0, 44, 44) normalImg:@"Indesign_ShowCoNorUp.png" selectedImg:@"Indesign_ShowCoNorDown.png" target:self action:@selector(collectionBtnClicked)];
    [_topControlPanel addSubview:_collectionButton];
    [self checkIsColleciton:0];
    
    /******************************
     ***********搜索功能************
     ******************************/
    BOOL isShowSearch = kShowSearch;
    if (isShowSearch)
    {
        _searchButton = [self getButtonWithFrame:CGRectMake(0, 0, 44, 44) normalImg:@"Indesign_SearchBtnUp.png" selectedImg:@"Indesign_SearchBtnDown.png" target:self action:@selector(searchBtnClicked)];
        [_topControlPanel addSubview:_searchButton];
        
        _indesignSearchTableView = [[IndesignSearchTableView alloc] initWithFrame:CGRectZero];
        _indesignSearchTableView.alpha = 0;
        _indesignSearchTableView.searchDelegate = self;
    }
    
    if (!self.isHideBackBtn)
    {
        _backToShelfButton = [self getButtonWithFrame:CGRectMake(0, 1, 44, 43) normalImg:@"Indesign_BackBtnUp.png" selectedImg:@"Indesign_BackBtnDown.png" target:self action:@selector(backToShelfBtnClicked)];
        [_topControlPanel addSubview:_backToShelfButton];
    }
    
    if (!self.isHideWeiboBtn)
    {
        _shareBtn = [self getButtonWithFrame:CGRectMake(0, 1, 44, 43) normalImg:@"Indesign_ShareBtnUp.png" selectedImg:@"Indesign_ShareBtnDown.png" target:self action:@selector(shareBtnClicked)];
        [_topControlPanel addSubview:_shareBtn];
    }
    
    _collectionTableView = [[CollectionTableView alloc] initWithFrame:CGRectZero];
    _collectionTableView.alpha = 0;
    _collectionTableView.collectionDelegate = self;
    
    _bottomControlPanel = [[[UIView alloc] init] autorelease];
    _bottomControlPanel.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bottomControlPanel];
//    _bottomControlPanel.hidden = YES;
    
    //下导航条
    _bottomNavBackground = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)] autorelease];
    [_bottomNavBackground setImage:[UIImage imageNamed:@"Indesign_BottomNavBgImg.png"]];
    [_bottomControlPanel addSubview:_bottomNavBackground];
    
    _sliderView = [[[IndesignSliderView alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)] autorelease];
    _sliderView.delegate = self;
    [_bottomControlPanel addSubview:_sliderView];
    
    _minImgArray = [[NSMutableArray alloc] init];
    _curShowImgArray = [[NSMutableArray alloc] init];
    _minImgOffsetArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChangeFromSlider) name:KNOTIFICATION_PAGECHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageTap) name:KNOTIFICATION_PAGEVIEWTAP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginDragging) name:KNOTIFICATION_PAGEDRAGGING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderPageSubPageChange:) name:KNOTIFICATION_SUBPAGECHANGE object:nil];
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
    _indesignSearchTableView.isVerOritaiton = _isVerOritation;
    _catalogueTableView.rootPathStr = nil;
    if (_indesignSearchTableView)
    {
        _indesignSearchTableView.allPageEntityArr = nil;
    }
    
    if (_collectionButton.selected)
    {
        [self collectionBtnClicked];
    }
    if (_searchButton.selected)
    {
        [self searchBtnClicked];
    }
    if (_catalogueButton.selected)
    {
        [self catalogueBtnClicked];
    }
    
    [self toolBarControl];
    
    if (_isMinView)
    {
        [_curShowImgArray removeAllObjects];
        [_minImgArray removeAllObjects];
        [_miniView removeFromSuperview];
        _miniView = nil;
        [self changeToFullView:_curIndex];
    }
    
    _scrHeight = rect.size.height;
    _scrWidth = rect.size.width;
    
    NSString *name = self.bookController.entity.name;
    _bookTitleLabel.text = name;
    
    _popBtn.frame = CGRectMake((rect.size.width - _popBtn.frame.size.width) / 2, rect.size.height - _popBtn.frame.size.height, _popBtn.frame.size.width, _popBtn.frame.size.height);
    if (_isPoped)
    {
        _topControlPanel.frame = CGRectMake(0, 0, rect.size.width, 44);
        _bottomControlPanel.frame = CGRectMake(0, rect.size.height - 44, rect.size.width, 44);
    }
    else
    {
        _topControlPanel.frame = CGRectMake(0, -44, rect.size.width, 44);
        _bottomControlPanel.frame = CGRectMake(0, rect.size.height, rect.size.width, 44);
    }
    
    _sliderView.frame = CGRectMake(0, 0, rect.size.width, 44);
    _bottomNavBackground.frame = CGRectMake(0, 0, rect.size.width, 44);
    
    _catalogueTableView.frame = CGRectMake(0, 0, 323, rect.size.height - 44);
    _collectionTableView.frame = CGRectMake(rect.size.width - 323, 0, 323, rect.size.height - 44);
    _collectionButton.frame = CGRectMake(rect.size.width - 44, _collectionButton.frame.origin.y, _collectionButton.frame.size.width, _collectionButton.frame.size.height);
    
    if (_searchButton)
    {
        _searchButton.frame = CGRectMake(_collectionButton.frame.origin.x - 44, _searchButton.frame.origin.y, _searchButton.frame.size.width, _searchButton.frame.size.height);
        _indesignSearchTableView.frame = CGRectMake(rect.size.width - 323, 0, 323, rect.size.height - 44);
    }
    
    if (!self.isHideWeiboBtn)
    {
        if (_searchButton)
        {
            _shareBtn.frame = CGRectMake(_searchButton.frame.origin.x - 44, _shareBtn.frame.origin.y, _shareBtn.frame.size.width, _shareBtn.frame.size.height);
        }
        else
        {
            _shareBtn.frame = CGRectMake(_collectionButton.frame.origin.x - 44, _shareBtn.frame.origin.y, _shareBtn.frame.size.width, _shareBtn.frame.size.height);
        }
        
    }
    
    if (!self.isHideBackBtn)
    {
        if (!self.isHideWeiboBtn)
        {
            _backToShelfButton.frame = CGRectMake(_shareBtn.frame.origin.x - 44, _backToShelfButton.frame.origin.y, _backToShelfButton.frame.size.width, _backToShelfButton.frame.size.height);
        }
        else
        {
            if (_searchButton)
            {
                _backToShelfButton.frame = CGRectMake(_searchButton.frame.origin.x - 44, _backToShelfButton.frame.origin.y, _backToShelfButton.frame.size.width, _backToShelfButton.frame.size.height);
            }
            else
            {
                _backToShelfButton.frame = CGRectMake(_collectionButton.frame.origin.x - 44, _backToShelfButton.frame.origin.y, _backToShelfButton.frame.size.width, _backToShelfButton.frame.size.height);
            }
        }
    }
    
    _topScrollView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    _titleBgImg.frame = CGRectMake(0, 17, rect.size.width, 187);
    
    _miniPicSpace = rect.size.width * kScrollScale * (1 - kContentScale);
    _miniPicWidth = rect.size.width * kScrollScale * kContentScale;
    _miniPicHeight = rect.size.height * kScrollScale * kContentScale;
    _miniOffset = 2;
    
    //    if (rect.size.width >768 || rect.size.width > 320)
    //    {
    //        [_bottomNavBackground setImage:[UIImage imageNamed:@"Indesign_BottomNavBgImg.png"]];
    //        [_titleBgImg setImage:[UIImage imageNamed:@"Indesign_TitleBgImg.png"]];
    //        _miniScrollTop = - 55;
    //    }
    //    else
    //    {
    //        [_bottomNavBackground setImage:[UIImage imageNamed:@"Indesign_BottomNavBgImgPro.png"]];
    //        [_titleBgImg setImage:[UIImage imageNamed:@"Indesign_TitleBgImgPro.png"]];
    //        _miniScrollTop = -135;
    //    }
    
    if (rect.size.width == 1024)
    {
        [_bottomNavBackground setImage:[UIImage imageNamed:@"Indesign_BottomNavBgImg.png"]];
        [_titleBgImg setImage:[UIImage imageNamed:@"Indesign_TitleBgImg.png"]];
        _miniScrollTop = - 55;
    }
    else if (rect.size.width == 768)
    {
        [_bottomNavBackground setImage:[UIImage imageNamed:@"Indesign_BottomNavBgImgPro.png"]];
        [_titleBgImg setImage:[UIImage imageNamed:@"Indesign_TitleBgImgPro.png"]];
        _miniScrollTop = -135;
    }
    else if (rect.size.width == 320)//Ver
    {
        _bookTitleLabel.frame = CGRectMake(142, 13, 150, 20);
        
        if (rect.size.height == 480)//4 Ver
        {
            [_bottomNavBackground setImage:[UIImage imageNamed:@"Indesign_BottomNavBgImgPro4Ver.png"]];
            [_titleBgImg setImage:[UIImage imageNamed:@"Indesign_TitleBgImg4Ver.png"]];
            _titleBgImg.frame = CGRectMake(0, 17, rect.size.width, 122);
            _miniScrollTop = -24;
        }
        else//5 Ver
        {
            [_bottomNavBackground setImage:[UIImage imageNamed:@"Indesign_BottomNavBgImgPro4Ver.png"]];
            [_titleBgImg setImage:[UIImage imageNamed:@"Indesign_TitleBgImg5Ver.png"]];
            _titleBgImg.frame = CGRectMake(0, 17, rect.size.width, 155);
            _miniScrollTop = -21;
        }
    }
    else//Hor
    {
        _bookTitleLabel.frame = CGRectMake(142, 13, 200, 20);
        _titleBgImg.frame = CGRectMake(0, 17, rect.size.width, 120);
        
        if (rect.size.width == 480)
        {
            [_bottomNavBackground setImage:[UIImage imageNamed:@"Indesign_BottomNavBgImgPro4Hor.png"]];
            [_titleBgImg setImage:[UIImage imageNamed:@"Indesign_TitleBgImg4Hor.png"]];
        }
        else
        {
            [_bottomNavBackground setImage:[UIImage imageNamed:@"Indesign_BottomNavBgImgPro5Hor.png"]];
            [_titleBgImg setImage:[UIImage imageNamed:@"Indesign_TitleBgImg5Hor.png"]];
        }
        _miniScrollTop = 30;
    }
    _pageTitleLab = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 500, 100)] autorelease];//adward 2.17
    _pageTitleLab.center = _titleBgImg.center;
    _pageTitleLab.textColor = [UIColor whiteColor];
    _pageTitleLab.textAlignment = NSTextAlignmentCenter;
    [_titleBgImg addSubview:_pageTitleLab];
    [self beginDragging];
}

#pragma mark - NSNotification

- (void)sliderPageSubPageChange:(NSNotification *)notification
{
    int offset = [notification.object intValue] + 1;
    _curIndex = self.bookController.flipController.currentPageIndex;
    _allCount = self.bookController.flipController.navView.snapshots.count;
    if (_minImgOffsetArray.count == 0)
    {
        for (int i = 0; i < _allCount; i++)
        {
            [_minImgOffsetArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    [_minImgOffsetArray replaceObjectAtIndex:_curIndex withObject:[NSNumber numberWithInt:offset]];
}

- (void)pageChangeFromSlider
{
    [_minImgOffsetArray removeAllObjects];
    _isPageChange = YES;
    _curIndex = self.bookController.flipController.currentPageIndex;
    _allCount = self.bookController.flipController.navView.snapshots.count;
    [self checkIsColleciton:_curIndex];
}

- (void)beginDragging
{
    if (_isPoped)
    {
        [self pageTap];
    }
}

- (void)pageTap
{
    if (_collectionButton.selected)
    {
        [self collectionBtnClicked];
        return;
    }
    if (_searchButton.selected)
    {
        [self searchBtnClicked];
        return;
    }
    if (_catalogueButton.selected)
    {
        [self catalogueBtnClicked];
        return;
    }
    [self toolBarControl];
}

- (void)toolBarControl
{
    if (!_isPoped)
    {
        _allCount = self.bookController.flipController.navView.snapshots.count;
        [self changeSliderValue:NO];
    }
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (_isPoped)
        {
            _topControlPanel.frame = CGRectMake(_topControlPanel.frame.origin.x, _topControlPanel.frame.origin.y - _topControlPanel.frame.size.height, _topControlPanel.frame.size.width, _topControlPanel.frame.size.height);
            _bottomControlPanel.frame = CGRectMake(_bottomControlPanel.frame.origin.x, _bottomControlPanel.frame.origin.y + _bottomControlPanel.frame.size.height, _bottomControlPanel.frame.size.width, _bottomControlPanel.frame.size.height);
            _isPoped = NO;
            _popBtn.hidden = NO;
        }
        else
        {
            _topControlPanel.frame = CGRectMake(_topControlPanel.frame.origin.x, _topControlPanel.frame.origin.y + _topControlPanel.frame.size.height, _topControlPanel.frame.size.width, _topControlPanel.frame.size.height);
            _bottomControlPanel.frame = CGRectMake(_bottomControlPanel.frame.origin.x, _bottomControlPanel.frame.origin.y - _bottomControlPanel.frame.size.height, _bottomControlPanel.frame.size.width, _bottomControlPanel.frame.size.height);
            _isPoped = YES;
            _popBtn.hidden = YES;
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIButtonClicked

- (void)backToShelfBtnClicked
{
    if (self.bookController) {
        [self.bookController close];
    }
}

- (void)shareBtnClicked
{
    _curIndex = self.bookController.flipController.currentPageIndex;
    _allCount = self.bookController.flipController.navView.snapshots.count;
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.bookController.flipController.navView.rootpath, [self.bookController.flipController.navView.snapshots objectAtIndex:_curIndex]];
    NSString *content = @"应用分享";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareToWeibo" object:[NSDictionary dictionaryWithObjectsAndKeys: path, @"path", content, @"content", [NSNumber numberWithInt:WeiboTypeDefault], @"type", nil]];
}

//点击返回书架
- (void)homeClicked
{
    [self.bookController.flipController homePage];
}

- (void)backClicked
{
    [self.bookController.flipController returnToLastPage:YES];
}

//目录
- (void)catalogueBtnClicked
{
    
    _catalogueTableView.rootPathStr = self.bookController.flipController.navView.rootpath;
    _catalogueTableView.snapshotsArray = self.bookController.flipController.navView.snapshots;
    _catalogueTableView.titleArray = self.bookController.flipController.navView.snapTitles;

    _catalogueTableView.collectionArr = _collectionTableView.collectionArr;
    [_catalogueTableView reloadData];
    if (_isMinView)
    {
        int offset = [[_minImgOffsetArray objectAtIndex:_curIndex] intValue];
        NSString *pageId = [[self.bookController.flipController.navView.allPageIdArr objectAtIndex:_curIndex] objectAtIndex:offset];
        [self.bookController.flipController gotoPageWithPageID:pageId animate:NO];
        [self changeToFullView:_curIndex];
    }
    if (_collectionButton.selected)
    {
        [self collectionBtnClicked];
    }
    if (_searchButton.selected)
    {
        [self searchBtnClicked];
    }
    _catalogueButton.selected = !_catalogueButton.selected;
    if (_catalogueButton.selected)
    {
        [self.view insertSubview:_catalogueTableView belowSubview:_topControlPanel];
        _catalogueTableView.frame = CGRectMake(_catalogueTableView.frame.origin.x, 44, _catalogueTableView.frame.size.width, _catalogueTableView.frame.size.height);
        [UIView animateWithDuration:.3 animations:^{
            _bottomControlPanel.alpha = 0;
            _catalogueTableView.alpha = 1;
        } completion:^(BOOL finished) {
            _bottomControlPanel.hidden = YES;
        }];
    }
    else
    {
        _bottomControlPanel.hidden = NO;
        [UIView animateWithDuration:.3 animations:^{
            _bottomControlPanel.alpha = 1;
            _catalogueTableView.alpha = 0;
            _catalogueTableView.frame = CGRectMake(_catalogueTableView.frame.origin.x, 0, _catalogueTableView.frame.size.width, _catalogueTableView.frame.size.height);
        } completion:^(BOOL finished) {
            [_catalogueTableView removeFromSuperview];
        }];
    }
    if (_catalogueTableView.descArray.count == 0) {//添加页面描述 3.3 adward
        [_catalogueTableView reloadData];
        //        NSArray *allPageId = self.bookController.flipController.navView.allPageIdArr;
        NSArray *allSectionPageId = self.bookController.flipController.navView.allSectionPageId;
        NSMutableArray *descArray = [NSMutableArray array];
        for (int s = 0; s < allSectionPageId.count; s++)
        {
            NSMutableArray *allPageId = [allSectionPageId objectAtIndex:s];
            for (int i = 0; i < [allPageId count]; i++)
            {
                if ([[allPageId objectAtIndex:i] isKindOfClass:[NSArray class]] && [[allPageId objectAtIndex:i] count] > 0)
                {
                    NSString *pageId = [[allPageId objectAtIndex:i] objectAtIndex:0];
                    HLPageEntity *pageEntity = [HLPageDecoder decode:pageId path:self.bookController.flipController.navView.rootpath];
                    NSString *pageDesc = pageEntity.description;
                    [descArray addObject:pageDesc];
                }
            }
        }
        if (descArray)
        {
            _catalogueTableView.descArray = descArray;
        }
    }
}

//收藏
- (void)collectionBtnClicked
{
    _curIndex = self.bookController.flipController.currentPageIndex;
    _allCount = self.bookController.flipController.navView.snapshots.count;
    if (_minImgOffsetArray.count == 0)
    {
        for (int i = 0; i < _allCount; i++)
        {
            [_minImgOffsetArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    int offset = [[_minImgOffsetArray objectAtIndex:_curIndex] intValue];
    NSString *pageId = [[self.bookController.flipController.navView.allPageIdArr objectAtIndex:_curIndex] objectAtIndex:offset];
    
    if (_isMinView)
    {
        [self.bookController.flipController gotoPageWithPageID:pageId animate:NO];
        [self changeToFullView:_curIndex];
    }
    if (_catalogueButton.selected)
    {
        [self catalogueBtnClicked];
    }
    if (_searchButton.selected)
    {
        [self searchBtnClicked];
    }
    
    _collectionButton.selected = !_collectionButton.selected;
    
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
    _collectionTableView.curPageDesc = pageEntity.description;//adward 2.13
    
    [_collectionTableView getLocationList:self.bookController.entity.name];
    [_collectionTableView reloadData];
    
    if (_collectionButton.selected)
    {
        [self.view insertSubview:_collectionTableView belowSubview:_topControlPanel];
        _collectionTableView.frame = CGRectMake(_collectionTableView.frame.origin.x, 44, _collectionTableView.frame.size.width, _collectionTableView.frame.size.height);
        [UIView animateWithDuration:.3 animations:^{
            _bottomControlPanel.alpha = 0;
            _collectionTableView.alpha = 1;
        } completion:^(BOOL finished) {
            _bottomControlPanel.hidden = YES;
        }];
    }
    else
    {
        _bottomControlPanel.hidden = NO;
        [UIView animateWithDuration:.3 animations:^{
            _bottomControlPanel.alpha = 1;
            _collectionTableView.alpha = 0;
            _collectionTableView.frame = CGRectMake(_collectionTableView.frame.origin.x, 0, _collectionTableView.frame.size.width, _collectionTableView.frame.size.height);
        } completion:^(BOOL finished) {
            [_collectionTableView removeFromSuperview];
        }];
    }
}

//搜索
- (void)searchBtnClicked
{
    _curIndex = self.bookController.flipController.currentPageIndex;
    _allCount = self.bookController.flipController.navView.snapshots.count;
    if (_minImgOffsetArray.count == 0)
    {
        for (int i = 0; i < _allCount; i++)
        {
            [_minImgOffsetArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    int offset = [[_minImgOffsetArray objectAtIndex:_curIndex] intValue];
    NSString *pageId = [[self.bookController.flipController.navView.allPageIdArr objectAtIndex:_curIndex] objectAtIndex:offset];
    
    if (_isMinView)
    {
        [self.bookController.flipController gotoPageWithPageID:pageId animate:NO];
        [self changeToFullView:_curIndex];
    }
    if (_catalogueButton.selected)
    {
        [self catalogueBtnClicked];
    }
    if (_collectionButton.selected)
    {
        [self collectionBtnClicked];
    }
    _searchButton.selected = !_searchButton.selected;
    
    if (_indesignSearchTableView.allPageEntityArr.count == 0) {
        [_indesignSearchTableView reloadData];
        //        NSArray *allPageId = self.bookController.flipController.navView.allPageIdArr;
        NSArray *allSectionPageId = self.bookController.flipController.navView.allSectionPageId;
        NSMutableArray *allPageEntityArr = [NSMutableArray array];
        for (int s = 0; s < allSectionPageId.count; s++)
        {
            NSMutableArray *allPageId = [allSectionPageId objectAtIndex:s];
            for (int i = 0; i < [allPageId count]; i++)
            {
                if ([[allPageId objectAtIndex:i] isKindOfClass:[NSArray class]] && [[allPageId objectAtIndex:i] count] > 0)
                {
                    NSString *pageId = [[allPageId objectAtIndex:i] objectAtIndex:0];
                    HLPageEntity *pageEntity = [HLPageDecoder decode:pageId path:self.bookController.flipController.navView.rootpath];
                    [allPageEntityArr addObject:pageEntity];
                }
            }
        }
        
        _indesignSearchTableView.allPageEntityArr = allPageEntityArr;
        _indesignSearchTableView.rootPath = self.bookController.flipController.navView.rootpath;
    }
    
    
    if (_searchButton.selected)
    {
        [self.view insertSubview:_indesignSearchTableView belowSubview:_topControlPanel];
        _indesignSearchTableView.frame = CGRectMake(_indesignSearchTableView.frame.origin.x, 44, _indesignSearchTableView.frame.size.width, _indesignSearchTableView.frame.size.height);
        [UIView animateWithDuration:.3 animations:^{
            _bottomControlPanel.alpha = 0;
            _indesignSearchTableView.alpha = 1;
        } completion:^(BOOL finished) {
            _bottomControlPanel.hidden = YES;
        }];
    }
    else
    {
        _bottomControlPanel.hidden = NO;
        [UIView animateWithDuration:.3 animations:^{
            _bottomControlPanel.alpha = 1;
            _indesignSearchTableView.alpha = 0;
            _indesignSearchTableView.frame = CGRectMake(_indesignSearchTableView.frame.origin.x, 0, _indesignSearchTableView.frame.size.width, _indesignSearchTableView.frame.size.height);
        } completion:^(BOOL finished) {
            [_indesignSearchTableView removeFromSuperview];
        }];
    }
}


//点击小视图的某个缩略图
- (void)selectBtnClicked:(UIButton *)sender
{
    int index = (sender.tag - sender.tag % 100) / 100;
    int offset = [[_minImgOffsetArray objectAtIndex:index] intValue];
    NSString *pageId = [[self.bookController.flipController.navView.allPageIdArr objectAtIndex:index] objectAtIndex:offset];
    [self.bookController.flipController gotoPageWithPageID:pageId animate:YES];//animate == yes adward 1.22 避免触发切页动画
    [self checkIsColleciton:index];
    [self changeToFullView:index];
    [self pageTap];
    [self changeSliderValue:YES];
}

//大小视图切换的缩放按钮
- (void)miniViewButtonClicked
{
    
    _curIndex = self.bookController.flipController.currentPageIndex;
    [self checkIsColleciton:_curIndex];
    if (self.bookController.flipController.navView.isSectionChange) {
        self.bookController.flipController.navView.isSectionChange = NO;
        [_minImgArray removeAllObjects];
        [_curShowImgArray removeAllObjects];
        [_miniView removeFromSuperview];
        _miniView = nil;
    }
    if (!_miniView)
    {
        _miniView = [[[UIView alloc] init] autorelease];
        //            _miniView.backgroundColor = [UIColor grayColor];
        [_topScrollView addSubview:_miniView];
        
        for (int i = 0; i < _allCount; i++)
        {//所有的缩略图
            NSArray *snapsArray = [self.bookController.flipController.navView.snapshotsIndesign objectAtIndex:i];
            NSMutableArray *miniArr = [NSMutableArray array];
            for (int j = 0; j < snapsArray.count; j++)
            {
                @autoreleasepool {      //陈星宇， 11.27，内存
                    int offset = 0;
                    if (_minImgOffsetArray.count < _allCount)
                    {
                        [_minImgOffsetArray addObject:[NSNumber numberWithInt:0]];
                    }
                    else
                    {
                        offset = [[_minImgOffsetArray objectAtIndex:i] intValue];
                    }
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    button.tag = i*100 + j;
                    button.frame = CGRectMake(_topScrollView.frame.size.width * i, _topScrollView.frame.size.height * kContentScale * (j - offset), _topScrollView.frame.size.width, _topScrollView.frame.size.height);
                    button.backgroundColor = [UIColor grayColor];
                    //                if (i < (int)(kScrPicCount / 2) + 1) //只加载屏幕内的图片
                    //                {
                    //                    NSString *snapresource = [snapsArray objectAtIndex:j];
                    //                    NSString *path = [self.bookController.flipController.navView.rootpath stringByAppendingPathComponent:snapresource];
                    //                    [button setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
                    //                    [_curShowImgArray addObject:button];
                    //                }
                    button.adjustsImageWhenHighlighted = NO;
                    [_miniView addSubview:button];
                    [miniArr addObject:button];
                }
            }
            [_minImgArray addObject:miniArr];
        }
        //        [self loadImgAtIndex:_curIndex animation:NO];
        _topScrollView.contentSize = CGSizeMake(_topScrollView.frame.size.width * _allCount + (_miniPicWidth + _miniPicSpace) * 2, _topScrollView.frame.size.height);
        _miniView.frame = CGRectMake(0, 0, _topScrollView.contentSize.width, _topScrollView.contentSize.height);
    }
    else
    {
        for (int i = 0; i < _minImgOffsetArray.count; i++)
        {
            int offset = [[_minImgOffsetArray objectAtIndex:i] intValue];
            if (i != _curIndex || _isPageChange)
            {
                _isPageChange = NO;
                offset = 0;
                [_minImgOffsetArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:offset]];
            }
            NSArray *minImgArr = [_minImgArray objectAtIndex:i];
            for (int j = 0; j < minImgArr.count; j++)
            {
                UIButton *button = [minImgArr objectAtIndex:j];
                button.frame = CGRectMake(button.frame.origin.x, button.frame.size.height * kContentScale * (j - offset), button.frame.size.width, button.frame.size.height);
            }
        }
        //        [self loadImgAtIndex:_curIndex animation:NO];
    }
    [self changeToMiniView];
}

#pragma mark - CatalogueDelegate

- (void)catalogueCellDidSelected:(int)index
{
    if (_catalogueButton.selected)
    {
        [self catalogueBtnClicked];
    }
    [self beginDragging];
    [_minImgOffsetArray removeAllObjects];
    [self.bookController.flipController gotoPageWithPageID:[self.bookController.flipController.sectionPages objectAtIndex:index] animate:YES];
    [self checkIsColleciton:index];
    [self changeSliderValue:YES];
}

#pragma mark - SearchDelegate

- (void)searchCellDidSelected:(NSString *)pageId
{
    if (_searchButton.selected)
    {
        [self searchBtnClicked];
    }
    [self beginDragging];
    [_minImgOffsetArray removeAllObjects];
    [self.bookController.flipController gotoPageWithPageID:pageId animate:YES];
    _curIndex = self.bookController.flipController.currentPageIndex;
    _allCount = self.bookController.flipController.navView.snapshots.count;
    [self changeSliderValue:YES];
}

#pragma mark - CollectionDelegate

- (void)collectionCellDidSelected:(NSString *)pageId
{
    if (_collectionButton.selected)
    {
        [self collectionBtnClicked];
    }
    [self beginDragging];
    [_minImgOffsetArray removeAllObjects];
    [self.bookController.flipController gotoPageWithPageID:pageId animate:YES];
    _curIndex = self.bookController.flipController.currentPageIndex;
    _allCount = self.bookController.flipController.navView.snapshots.count;
    [self addCollection:YES];
    [_collectionTableView setCollectBtnState:YES];
    [self changeSliderValue:YES];
}

- (void)addCollection:(BOOL)add
{
    if (add)
    {
        [_collectionButton setImage:[UIImage imageNamed:@"Indesign_ShowCoSeleUp.png"] forState:UIControlStateNormal];
        [_collectionButton setImage:[UIImage imageNamed:@"Indesign_ShowCoSeleDown.png"] forState:UIControlStateSelected];
        
    }
    else
    {
        [_collectionButton setImage:[UIImage imageNamed:@"Indesign_ShowCoNorUp.png"] forState:UIControlStateNormal];
        [_collectionButton setImage:[UIImage imageNamed:@"Indesign_ShowCoNorDown.png"] forState:UIControlStateSelected];
    }
}

//是否已经收藏
- (void)checkIsColleciton:(int)index
{
    if (_minImgOffsetArray.count == 0)
    {
        _allCount = self.bookController.flipController.navView.snapshots.count;
        if (_allCount != 0)
        {
            for (int i = 0; i < _allCount; i++)
            {
                [_minImgOffsetArray addObject:[NSNumber numberWithInt:0]];
            }
        }
        else
        {
            return;
        }
    }
    //    _curIndex = self.bookController.flipController.currentPageIndex;
    //    _allCount = self.bookController.flipController.navView.snapshots.count;
    int offset = [[_minImgOffsetArray objectAtIndex:index] intValue];
    NSString *pageId = [[self.bookController.flipController.navView.allPageIdArr objectAtIndex:index] objectAtIndex:offset];
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

#pragma mark - SliderViewDelegate

- (void)sliderValueChanged:(float)value
{
    
    if (!_isMinView)
    {
        [self miniViewButtonClicked];
    }
    else
    {
        if (_isDecelerating)
        {
            return;
        }
        [UIView animateWithDuration:.2 animations:^{
            if (value == 1)
            {
                _topScrollView.contentOffset = CGPointMake((_allCount - 1) * (_miniPicWidth + _miniPicSpace), 0);
            }
            else
            {
                int curIndex = _allCount * value;
                
                _topScrollView.contentOffset = CGPointMake(curIndex * (_miniPicWidth + _miniPicSpace), 0);
                _curIndex = curIndex;
                [self checkIsColleciton:_curIndex];
                NSMutableArray *titles = self.bookController.flipController.navView.snapTitles;
                _pageTitleLab.text = [titles objectAtIndex:_curIndex];//显示标题 adward 2.17
            }
        }];
        [self loadImgAtIndex:_curIndex animation:YES];
    }
    
    //    NSLog(@"%f", value);
}

//手势
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:self.view];
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _lastOffsizeX = point.x;
            if (_topScrollView.contentOffset.x <= 0 || _topScrollView.contentOffset.x >= (_allCount - 1) * (_miniPicWidth + _miniPicSpace))
            {
                _lastOffsizeX = point.x / 4;
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (_topScrollView.contentOffset.x <= 0 || _topScrollView.contentOffset.x >= (_allCount - 1) * (_miniPicWidth + _miniPicSpace))
            {
                point = CGPointMake(point.x / 4, point.y / 4);
            }
            _topScrollView.contentOffset = CGPointMake(_topScrollView.contentOffset.x - (point.x - _lastOffsizeX), 0);
            _moveDir = point.x - _lastOffsizeX;
            _lastOffsizeX = point.x;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:     //松手后
        {
            //            NSLog(@"(%f)",_topScrollView.contentOffset.x);
            //出界后反弹
            if (_topScrollView.contentOffset.x <= 0 || _topScrollView.contentOffset.x >= (_allCount - 1) * (_miniPicWidth + _miniPicSpace))
            {
                [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if (_topScrollView.contentOffset.x <= 0)
                    {
                        [_topScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                    }
                    else if (_topScrollView.contentOffset.x >= (_allCount - 1) * (_miniPicWidth + _miniPicSpace))
                    {
                        [_topScrollView setContentOffset:CGPointMake((_allCount - 1) * (_miniPicWidth + _miniPicSpace), 0) animated:NO];
                    }
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
                double dis = fabs(_moveDir) * 10;
                int curIndex;
                if (point.x < 0) //向左滑动
                {
                    curIndex = (_topScrollView.contentOffset.x + dis) / (_miniPicWidth + _miniPicSpace) + 1;
                }
                else
                {
                    curIndex = (_topScrollView.contentOffset.x - dis) / (_miniPicWidth + _miniPicSpace);
                }
                if (curIndex < 0)
                {
                    curIndex = 0;
                }
                if (curIndex > _allCount - 1)
                {
                    curIndex = _allCount - 1;
                }
                _curIndex = curIndex;
                [self checkIsColleciton:_curIndex];
                self.bookController.flipController.currentPageIndex = _curIndex;
                [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [_topScrollView setContentOffset:CGPointMake(curIndex * (_miniPicWidth + _miniPicSpace), 0) animated:NO];
                } completion:^(BOOL finished) {
                    [self loadImgAtIndex:curIndex animation:YES];       //陈星宇，12.2
                }];
            }
            break;
        }
        default:
            break;
    }
    [self changeSliderValue:YES];
}

//加载屏幕内的图片
- (void)loadImgAtIndex:(int)curIndex animation:(BOOL)animation
{
    
    int start = curIndex - 2 < 0 ? 0 : curIndex - 2;
    int end = (curIndex - 2 + kScrPicCount > _allCount - 1) ? (_allCount - 1) : (curIndex - 2 + kScrPicCount);
    
    NSLog(@"start = %d , end = %d ",start,end);
    
    [self removeImgFromShow:start endIndex:end];        //陈星宇，12.2，
    
    for (int i = start; i <= end; i++)
    {
        NSArray *snapsArray = [self.bookController.flipController.navView.snapshotsIndesign objectAtIndex:i];
        //        NSLog(@"snapsArray = %@",snapsArray);       //11.27
        for (int j = 0; j < snapsArray.count; j++)
        {
            UIButton *button = [[_minImgArray objectAtIndex:i] objectAtIndex:j];
            if (![_curShowImgArray containsObject:button])
            {
                NSString *snapresource = [snapsArray objectAtIndex:j];
                NSString *path = [self.bookController.flipController.navView.rootpath stringByAppendingPathComponent:snapresource];
                if (animation)
                {
                    CATransition *animation = [CATransition animation];
                    animation.duration = 0.5;
                    animation.type = kCATransitionFade;
                    [button.layer addAnimation:animation forKey:@"imageFade"];
                }
                UIImage *image = [self imageWithPath:path drawInRect:button.bounds];
                [button setBackgroundImage:image forState:UIControlStateNormal];     //陈星宇，12.2，内存问题出在这
                
                [_curShowImgArray addObject:button];
            }
        }
    }
    
    NSLog(@"load=_curShowImgArray = %d",_curShowImgArray.count);
}

- (UIImage *)imageWithPath:(NSString *)path drawInRect:(CGRect)rect     //陈星宇，12.2，图片重绘，解决图片体积过大导致内存不足
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//移除屏幕意外的图片
- (void)removeImgFromShow:(int)startIndex endIndex:(int)endIndex
{
    
    
    for (UIButton *btn in _curShowImgArray)
    {
        if (btn.tag < startIndex * 100 || btn.tag > (endIndex + 1) * 100)
        {
            //            UIImage *image = btn.currentBackgroundImage;
            //            [image release];                                                    //12.2
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
            [_curShowImgArray removeObject:btn];
            NSLog(@"remove=_curShowImgArray = %d",_curShowImgArray.count);
            [self removeImgFromShow:startIndex endIndex:endIndex];
            break;
        }
    }
}

#pragma mark -

//变为小视图
- (void)changeToMiniView
{
    
    [self loadImgAtIndex:_curIndex animation:NO];
    _isDecelerating = YES;
    _isMinView = YES;
    [self.view insertSubview:_titleBgImg belowSubview:_topControlPanel];
    _topScrollView.hidden = NO;
    [self.view insertSubview:_topScrollView belowSubview:_titleBgImg];
    _topScrollView.contentSize = CGSizeMake(_topScrollView.frame.size.width * self.bookController.flipController.navView.snapshots.count * kScrollScale + (_miniPicWidth + _miniPicSpace) * 2, _topScrollView.frame.size.height);
    _topScrollView.contentOffset = CGPointMake(_topScrollView.frame.size.width * _curIndex, 0);
    [UIView animateWithDuration:.3 animations:^{
        for (UIButton *button in _miniView.subviews)
        {
            button.transform = CGAffineTransformMakeScale(kContentScale, kContentScale);
        }
        _miniView.transform = CGAffineTransformMakeScale(kScrollScale, kScrollScale);
        _miniView.frame = CGRectMake(_miniPicWidth + _miniPicSpace * .75 - _miniOffset, _miniView.frame.origin.y + _miniScrollTop, _miniView.frame.size.width, _miniView.frame.size.height);
        _topScrollView.contentOffset = CGPointMake(_topScrollView.frame.size.width * _curIndex * kScrollScale, 0);
        _titleBgImg.alpha = .9;
    } completion:^(BOOL finished) {
        _isDecelerating = NO;
        _miniView.frame = CGRectMake(_miniView.frame.origin.x, _miniView.frame.origin.y, _miniView.frame.size.width, _miniView.frame.size.height * 3);
    }];
}

//变为大视图
- (void)changeToFullView:(int)index
{
    
    _isMinView = NO;
    _topScrollView.contentSize = CGSizeMake(_topScrollView.frame.size.width * self.bookController.flipController.navView.snapshots.count, _topScrollView.frame.size.height);
    _miniView.frame = CGRectMake(_miniView.frame.origin.x, _miniView.frame.origin.y, _miniView.frame.size.width, _miniView.frame.size.height / 3);
    [UIView animateWithDuration:.31 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        for (UIButton *button in _miniView.subviews)
        {
            button.transform = CGAffineTransformIdentity;
        }
        _miniView.transform = CGAffineTransformIdentity;
        _miniView.frame = CGRectMake(0, _miniView.frame.origin.y - _miniScrollTop, _miniView.frame.size.width, _miniView.frame.size.height);
        _topScrollView.contentOffset = CGPointMake(_topScrollView.frame.size.width * index, 0);
        _titleBgImg.alpha = 0;
    } completion:^(BOOL finished) {
        [_titleBgImg removeFromSuperview];
        _topScrollView.hidden = YES;
        [_topScrollView removeFromSuperview];
    }];
}

- (void)changeSliderValue:(BOOL)animation
{
    float value = (float)_curIndex / (_allCount - 1);    //_topScrollView.contentOffset.x / (_topScrollView.contentSize.width - _scrWidth);
    [_sliderView setSliderValue:value animated:animation];
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
/*
 UIButton    *_searchButton;
 UIButton    *_catalogueButton;
 UIButton    *_collectionButton;
 UIButton    *_backToShelfButton;
 UIButton    *_popBtn;
 UIButton    *_shareBtn;
 UIView      *_topControlPanel;
 UIView      *_bottomControlPanel;
 UIView      *_miniView;
 UIImageView *_titleBgImg;
 UIImageView *_bottomNavBackground;
 UIScrollView        *_topScrollView;
 IndesignSliderView  *_sliderView;
 CatalogueTableView  *_catalogueTableView;
 CollectionTableView *_collectionTableView;
 IndesignSearchTableView *_indesignSearchTableView;
 NSMutableArray *_minImgArray;
 NSMutableArray *_curShowImgArray;
 NSMutableArray *_minImgOffsetArray;
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_PAGEVIEWTAP object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_PAGECHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_PAGEDRAGGING object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_SUBPAGECHANGE object:nil];
    if (_catalogueTableView)
    {
        [_catalogueTableView removeFromSuperview];
        [_catalogueTableView release];
    }
    if (_collectionTableView)
    {
        [_collectionTableView removeFromSuperview];
        [_collectionTableView release];
    }
    if (_indesignSearchTableView)
    {
        [_indesignSearchTableView removeFromSuperview];
        [_indesignSearchTableView release];
    }
    [_titleBgImg removeFromSuperview];
    [_topScrollView removeFromSuperview];
    [_minImgArray removeAllObjects];
    [_curShowImgArray removeAllObjects];
    [_minImgOffsetArray removeAllObjects];
    
    
    [_minImgOffsetArray release];
    [_curShowImgArray release];
    [_minImgArray release];
    [_titleBgImg release];
    [_topScrollView release];
    
    [super dealloc];
}

@end
