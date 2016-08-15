//
//  CollectionTableView.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-16.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLCollectionTableView.h"
#import "HLCollectionTableViewCell.h"
#import "SnapshotEntity.h"

@implementation HLCollectionTableView

@synthesize isVerOritaiton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Indesign_Colle_BgImg.png"]] autorelease];
        [self addSubview:_bgImgView];
        
        _tableView = [[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain] autorelease];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:112 / 255.0 green:112 / 255.0 blue:112 / 255.0 alpha:1];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        [self getTableViewHeaderView];
        
        
        [self reloadData];
    }
    return self;
}

- (void)getLocationList:(NSString *)bookId
{
    self.bookId = bookId;
    _collectionArr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IndesignCollectionArray%@", self.bookId]]];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _headerView.frame = CGRectMake(4, 0, frame.size.width - 4, 33);
    _headBgImgView.frame = CGRectMake(0, 0, frame.size.width - 4, 33);
    _tableView.frame = CGRectMake(4, 33, frame.size.width - 4, frame.size.height - 33);
    _bgImgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)reloadData
{
    [_tableView reloadData];
}

- (void)getTableViewHeaderView
{
    _headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 44)] autorelease];
    
    _headBgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Indesign_Colle_HeadBgImg.png"]] autorelease];
    [_headerView addSubview:_headBgImgView];
    
    _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectionBtn.frame = CGRectMake(3, 4.5, 30, 25);
    [_collectionBtn setImage:[UIImage imageNamed:@"Indesign_CollectionBtnUp.png"] forState:UIControlStateNormal];
    [_collectionBtn setImage:[UIImage imageNamed:@"Indesign_CollectionBtnDown.png"] forState:UIControlStateSelected];
    [_collectionBtn addTarget:self action:@selector(collectionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_collectionBtn];
    [self addSubview:_headerView];
}

- (void)setCollectBtnState:(BOOL)selected
{
    _collectionBtn.selected = selected;
}

- (void)collectionBtnClicked
{
    _collectionBtn.selected = !_collectionBtn.selected;
    if (_collectionBtn.selected)
    {
        [self addCollection];
        if ([_collectionDelegate respondsToSelector:@selector(addCollection:)])
        {
            [_collectionDelegate addCollection:YES];
        }
    }
    else
    {
        [self removeCollection];
        if ([_collectionDelegate respondsToSelector:@selector(addCollection:)])
        {
            [_collectionDelegate addCollection:NO];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:_collectionArr forKey:[NSString stringWithFormat:@"IndesignCollectionArray%@", self.bookId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PageIsCollected" object:[NSNumber numberWithBool:_collectionArr.count == 0 ? NO : YES]];
    if (_collectionArr.count == 0)
    {
        [_tableView reloadData];
    }
}

- (void)addCollection
{
    [_collectionArr insertObject:[NSDictionary dictionaryWithObjectsAndKeys:self.curPageTitle, @"title", self.curHorPageId, @"horId", self.curVerPageId, @"verId", self.curHorImgPath, @"horPath", self.curVerImgPath, @"verPath", self.curPageDesc , @"desc" ,nil] atIndex:0];//adward 2.13
    
    if (_collectionArr.count > 1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [_tableView reloadData];
    }
}

- (void)removeCollection
{
    for (int i = 0; i < _collectionArr.count; i++)
    {
        if ([[[_collectionArr objectAtIndex:i] objectForKey:@"horId"] isEqualToString:self.curHorPageId] || [[[_collectionArr objectAtIndex:i] objectForKey:@"verId"] isEqualToString:self.curVerPageId])
        {
            [_collectionArr removeObjectAtIndex:i];
            
            if (_collectionArr.count == 0)
            {
                [_tableView reloadData];
            }
            else
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"CollectionTableViewCell";
    HLCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (!cell)
    {
        cell = [[[HLCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_collectionArr.count == 0)
    {
        [cell setCellContent:nil title:nil desc:nil];
    }
    else
    {
        if (self.isVerOritaiton)
        {
            [cell setCellContent:[[_collectionArr objectAtIndex:indexPath.row] objectForKey:@"verPath"] title:[[_collectionArr objectAtIndex:indexPath.row] objectForKey:@"title"]desc:[[_collectionArr objectAtIndex:indexPath.row] objectForKey:@"desc"]];//adward 2.13
        }
        else
        {
            [cell setCellContent:[[_collectionArr objectAtIndex:indexPath.row] objectForKey:@"horPath"] title:[[_collectionArr objectAtIndex:indexPath.row] objectForKey:@"title"]desc:[[_collectionArr objectAtIndex:indexPath.row] objectForKey:@"desc"]];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_collectionArr.count == 0)
    {
        return 1;
    }
    return _collectionArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_collectionDelegate respondsToSelector:@selector(collectionCellDidSelected:)])
    {
        if (self.isVerOritaiton)
        {
            [_collectionDelegate collectionCellDidSelected:[[_collectionArr objectAtIndex:indexPath.row] objectForKey:@"verId"]];
        }
        else
        {
            [_collectionDelegate collectionCellDidSelected:[[_collectionArr objectAtIndex:indexPath.row] objectForKey:@"horId"]];
        }
    }
}

- (void)dealloc
{
    [_collectionArr release];
    [super dealloc];
}

@end
