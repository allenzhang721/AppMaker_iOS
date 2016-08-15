//
//  IndesignSearchTableView.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-14.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLIndesignSearchTableView.h"
#import "HLCollectionTableViewCell.h"
#import "HLPageDecoder.h"
#import <CoreText/CoreText.h>

@implementation HLIndesignSearchTableView

@synthesize isVerOritaiton, allPageEntityArr,titleAttributeString,desAttributeString,searchBarText;

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
        
        showPageEntity = [[NSMutableArray alloc] init];
        
        [self reloadData];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _headerView.frame = CGRectMake(4, 0, frame.size.width - 4, 33);
    _headBgImgView.frame = CGRectMake(0, 0, frame.size.width - 4, 44);
    _tableView.frame = CGRectMake(4, 33, frame.size.width - 4, frame.size.height - 33);
    _bgImgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    curSearchBar.frame = CGRectMake(8, 2, frame.size.width - 20, 40);
}

- (void)reloadData
{
    [showPageEntity removeAllObjects];
    [_tableView reloadData];
}

- (void)getTableViewHeaderView
{
    _headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 44)] autorelease];
    
    _headBgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Indesign_Colle_HeadBgImg.png"]] autorelease];
    [_headerView addSubview:_headBgImgView];
    
    curSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 2, 500, 40)];
    curSearchBar.placeholder = @"Search...";
    curSearchBar.delegate = self;
    curSearchBar.showsCancelButton = NO;
    curSearchBar.keyboardType = UIKeyboardTypeDefault;
    //searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    //searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //    [[curSearchBar.subviews objectAtIndex:0]removeFromSuperview]; //modified by Adward 开启搜索功能13-12-12
    [_headerView addSubview:curSearchBar];
    [self addSubview:_headerView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [showPageEntity removeAllObjects];
    [curSearchBar resignFirstResponder];
    if (![curSearchBar.text isEqualToString:@""])
    {
        for (int i = 0; i < allPageEntityArr.count; i++)
        {
            HLPageEntity *pageEntity = [allPageEntityArr objectAtIndex:i];
            if (pageEntity.isVerticalPageType != self.isVerOritaiton)
            {
                continue;
            }
            NSString *title = [NSString stringWithString:pageEntity.title];//adward 2.13搜索中添加标题关键字
            NSString *des = [NSString stringWithString:pageEntity.description];
            NSRange foundTitleObj = [title rangeOfString:searchBar.text options:NSLiteralSearch];//区分大小写2.13
            NSRange foundDesObj = [des rangeOfString:searchBar.text options:NSLiteralSearch];
            self.searchBarText = searchBar.text;
            
            //            [[NSUserDefaults standardUserDefaults] setObject:searchBar.text forKey:@"searchBarText"];
            
            if(foundTitleObj.length > 0 || foundDesObj.length > 0)
            {
                [showPageEntity addObject:pageEntity];
            }
        }
    }
    _tableView.contentOffset = CGPointMake(0, 0);
    [_tableView reloadData];
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
    
    if (showPageEntity.count == 0)
    {
        [cell setCellContent:nil title:@"   暂无搜寻结果" desc:nil];
    }
    else
    {
        HLPageEntity *pageEntity = (HLPageEntity *)[showPageEntity objectAtIndex:indexPath.row];
        NSString *imgName = pageEntity.cacheImageID;
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchBarContent" object:self.searchBarText];
        cell.searchBarText = self.searchBarText;
        [cell setCellContent:[self.rootPath stringByAppendingPathComponent:imgName] title:pageEntity.title desc:pageEntity.description];//adward 2.13
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (showPageEntity.count == 0)
    {
        return 1;
    }
    return showPageEntity.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (showPageEntity.count == 0)
    {
        return;
    }
    if ([_searchDelegate respondsToSelector:@selector(searchCellDidSelected:)])
    {
        [_searchDelegate searchCellDidSelected:((HLPageEntity *)[showPageEntity objectAtIndex:indexPath.row]).entityid];
    }
}

- (void)dealloc
{
    [showPageEntity release];
    [allPageEntityArr release];
    [super dealloc];
}

@end
