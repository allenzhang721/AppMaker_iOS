//
//  IndesignControlPanelViewController.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-8.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControlPanelViewController.h"
#import "IndesignSliderView.h"
#import "CatalogueTableView.h"
#import "CollectionTableView.h"
#import "IndesignSearchTableView.h"

@interface IndesignControlPanelViewController : BaseControlPanelViewController <UIScrollViewDelegate, SliderViewDelegate, CollectionDelegate, CatalogueDelegate, SearchDelegate>
{
    BOOL        _isPoped;
    BOOL        _isDecelerating;
    BOOL        _isDragging;
    BOOL        _isMinView;
    BOOL        _isPageChange;
    BOOL        _isVerOritation;
    
    UILabel     *_bookTitleLabel;
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
    UILabel     *_pageTitleLab;//adward
    IndesignSliderView  *_sliderView;
    CatalogueTableView  *_catalogueTableView;
    CollectionTableView *_collectionTableView;
    IndesignSearchTableView *_indesignSearchTableView;
    
    float                   _scrWidth;
    float                   _scrHeight;
    float                   _lastOffsizeX;
    float                   _speed;
    float                   _moveDir;
    float                   _miniPicWidth;
    float                   _miniPicHeight;
    float                   _miniPicSpace;
    float                   _miniOffset;
    float                   _miniScrollTop;
    
    int _curIndex;
    int _allCount;
    
    NSMutableArray *_minImgArray;
    NSMutableArray *_curShowImgArray;
    NSMutableArray *_minImgOffsetArray;
}

@property BOOL isHideBackBtn;

@property BOOL isHideWeiboBtn;

@end
