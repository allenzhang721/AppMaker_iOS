//
//  CatalogueTableViewCell.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-16.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "CatalogueTableViewCell.h"

@implementation CatalogueTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _titleImg = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 75)] autorelease];
        _titleImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_titleImg];
        
        _collectImg = [[[UIImageView alloc] initWithFrame:CGRectMake(285, 14, 14, 14)] autorelease];
        _collectImg.image = [UIImage imageNamed:@"Indesign_Cata_CollectImg.png"];
        [self addSubview:_collectImg];
        _collectImg.hidden = YES;
        
        _titleLab = [[[UILabel alloc] initWithFrame:CGRectMake(100, 30, 175, 15)] autorelease];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor whiteColor];
        [self addSubview:_titleLab];
        
        _descLab = [[[UILabel alloc] initWithFrame:CGRectMake(100, 50, 175, 15)] autorelease];
        _descLab.backgroundColor = [UIColor clearColor];
        _descLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _descLab.font = [UIFont systemFontOfSize:10];
        _descLab.textColor = [UIColor whiteColor];
        [self addSubview:_descLab];
        
    }
    return self;
}

- (void)setCellContent:(NSString *)picImg collected:(BOOL)collected title:(NSString *)title desc:(NSString *)desc
{
    
    [_titleImg setImage:[UIImage imageWithContentsOfFile:picImg]];
    _collectImg.hidden = !collected;
    _titleLab.text = title;
    _descLab.text = desc;
}



@end
