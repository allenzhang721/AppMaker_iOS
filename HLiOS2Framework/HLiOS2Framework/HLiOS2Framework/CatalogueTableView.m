//
//  CatalogueTableView.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-16.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "CatalogueTableView.h"
#import "CatalogueTableViewCell.h"
#import "SnapshotEntity.h"

@implementation CatalogueTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Indesign_Cata_BgImg.png"]] autorelease];
        [self addSubview:_bgImgView];
        
        _tableView = [[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain] autorelease];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:112 / 255.0 green:112 / 255.0 blue:112 / 255.0 alpha:1];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _tableView.frame = CGRectMake(0, 0, frame.size.width - 4, frame.size.height);
    _bgImgView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width + 4, _tableView.frame.size.height);
}

- (void)reloadData
{
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"CatalogueCell";
    CatalogueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell) {
        cell = [[[CatalogueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([_snapshotsArray count] > 0)
    {
        NSString *imgName = [_snapshotsArray objectAtIndex:indexPath.row];
        NSString *path = [_rootPathStr stringByAppendingPathComponent:imgName];
        BOOL collected = NO;
        if ([_collectionArr containsObject:[NSNumber numberWithInt:indexPath.row]])
        {
            collected = YES;
        }
        NSString *title = [self.titleArray objectAtIndex:indexPath.row];
        NSString *desc = [self.descArray objectAtIndex:indexPath.row];//2.13
        [cell setCellContent:path collected:collected title:title desc:desc];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _snapshotsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_catalogueDelegate respondsToSelector:@selector(catalogueCellDidSelected:)]) {
        [_catalogueDelegate catalogueCellDidSelected:indexPath.row];
    }
}

- (void)dealloc
{
    [_rootPathStr release];
    [_titleArray release];
    [_snapshotsArray release];
    [super dealloc];
}

@end
