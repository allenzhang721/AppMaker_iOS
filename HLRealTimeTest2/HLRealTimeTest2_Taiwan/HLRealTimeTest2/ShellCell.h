//
//  ShellCell.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "GMGridViewCell.h"
#import "ShelfBookEntity.h"
#import "MRCircularProgressView.h"
#import "DACircularProgressView.h"

@interface ShellCell : GMGridViewCell
{}

@property (nonatomic,retain) UIImageView *bgImg;
@property (nonatomic,retain) UIButton    *delBtn;
@property (nonatomic,retain) UIButton    *reDownloadBtn;
@property (nonatomic,retain) UIImageView *coverImg;
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UIImageView *maskImg;
@property (nonatomic,assign) ShelfBookEntity *entity;
@property (nonatomic,retain) DACircularProgressView *progressView;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,assign) BOOL isRedownload;

-(void) update;
-(void) setDelMode:(Boolean) state;
-(void) beginMove;
-(void) endMove;
@end
