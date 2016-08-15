//
//  ShellCell.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "ShellCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation ShellCell

@synthesize bgImg;
@synthesize coverImg;
@synthesize nameLabel;
@synthesize delBtn;
@synthesize progressView;
@synthesize indicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.isRedownload = NO;
    }
    return self;
}
-(void) update
{
    self.deleteButtonIcon = [UIImage imageNamed:@"ipad_close.png"];

    if (self.coverImg == nil)
    {
        self.coverImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defalut_cover.png"]] autorelease];
        self.coverImg.frame = CGRectMake(20, 20, self.coverImg.frame.size.width, self.coverImg.frame.size.height);
        [self addSubview:self.coverImg];
    }
    if (self.maskImg == nil)
    {
        self.maskImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"download_mask.png"]] autorelease];
        self.maskImg.frame = CGRectMake(20, 20, self.coverImg.frame.size.width, self.coverImg.frame.size.height);
        [self addSubview:self.maskImg];
    }
    if (self.delBtn == nil)
    {
        self.delBtn = [[[UIButton alloc] initWithFrame:CGRectMake(125, 5, 30, 30)] autorelease];
        [self.delBtn setImage:[UIImage imageNamed:@"ipad_close.png"] forState:UIControlStateNormal];
        [self.delBtn setImage:[UIImage imageNamed:@"ipad_close_down.png"] forState:UIControlStateHighlighted];
        self.delBtn.hidden = YES;
        [self addSubview:self.delBtn];
    }
    if(self.progressView == nil)
    {
        self.progressView = [[[DACircularProgressView alloc] init] autorelease];
//        [self.progressView setTintColor:[UIColor whiteColor]];
        self.progressView.progress = 0.0;
        self.progressView.frame    = CGRectMake(53 - 5 , 75 - 5, 60, 60);
        [self addSubview:self.progressView];
    }
    
    if (self.reDownloadBtn == nil)
    {
        self.reDownloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(55, 75, 44, 44)];
        [self.reDownloadBtn setImage:[UIImage imageNamed:@"reDownload_normal.png"] forState:UIControlStateNormal];
        [self.reDownloadBtn setImage:[UIImage imageNamed:@"reDownload_down.png"] forState:UIControlStateHighlighted];
        [self.reDownloadBtn addTarget:self action:@selector(reDownload) forControlEvents:UIControlEventTouchUpInside];
        self.reDownloadBtn.hidden = YES;
        [self addSubview:self.reDownloadBtn];
    }

    if (self.nameLabel == nil)
    {
        self.nameLabel = [[[UILabel alloc] init] autorelease];
        
        self.nameLabel.text = @"appMaker";
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor colorWithRed:0.43f green:0.43 blue:0.43 alpha:1];
        self.nameLabel.frame = CGRectMake(12, 183, 130, 20);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font  = [UIFont systemFontOfSize:19];
        [self addSubview:self.nameLabel];
    }
    if (indicator == nil)
    {
        self.indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        self.indicator.frame = CGRectMake(70, 100, self.indicator.frame.size.width, self.indicator.frame.size.height);
        self.indicator.hidden = YES;
        [self addSubview:self.indicator];
    }
    
    [self.indicator stopAnimating];
    self.coverImg.image = [UIImage imageNamed:@"defalut_cover.png"];
    self.maskImg.hidden = YES;
    [self.entity refreshBookName];      //Mr.chen, 2.25,
    [self.entity refreshCover];
    
    if (self.entity != nil)
    {
        if (self.entity.isDownloaded == YES)
        {
            self.reDownloadBtn.hidden = YES;
            self.progressView.hidden  = YES;
            
        }
        else
        {
            self.maskImg.hidden = NO;
            self.reDownloadBtn.hidden = YES;
            self.progressView.hidden = NO;
        }
        if (self.entity.isFail == YES)
        {
            self.reDownloadBtn.hidden = NO;
            self.progressView.hidden  = YES;
            self.maskImg.hidden = NO;
        }
    }
}

-(void) beginMove
{
    CGAffineTransform t = CGAffineTransformScale (self.transform, 1.1,1.1);
    [UIView animateWithDuration:0.3 animations:^
    {
        //self.transform = t;
        self.transform = t;
    }
        completion:^(BOOL finished)
    {
       // self.transform = t;
    }
    ];
}

-(void) endMove
{
    
}

-(void) setDelMode:(Boolean) state
{
    
}

- (void)reDownload
{
    if (!self.isRedownload) {
        
        self.isRedownload = YES;
        
        NSDictionary *dic = @{@"*downloadurl": self.entity.downloadurl,
                              @"coverurl": self.entity.coverurl,
                              @"booknameurl": self.entity.bookNameUrl};     //Mr.chen, 2.25,
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bookRedownloadNotification" object:self.entity userInfo:dic];
    }
}

- (void)dealloc
{
    [self.bgImg removeFromSuperview];
    [self.bgImg release];
    [self.coverImg removeFromSuperview];
    [self.coverImg release];
    [self.nameLabel removeFromSuperview];
    [self.nameLabel release];
    [self.delBtn removeFromSuperview];
    [self.delBtn release];
    [self.reDownloadBtn removeFromSuperview];
    [self.reDownloadBtn release];
    [self.progressView removeFromSuperview];
    [self.progressView release];
    [self.indicator removeFromSuperview];
    [self.indicator release];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bookRedownloadNotification" object:self.entity];
    [super dealloc];
}

@end
