//
//  IndesignSearchTableView.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-14.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLPageEntity.h"

@protocol SearchDelegate <NSObject>

- (void)searchCellDidSelected:(NSString *)pageId;

@end

@interface IndesignSearchTableView : UIView <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    UIView *_headerView;
    UITableView *_tableView;
    UIImageView *_bgImgView;
    UIImageView *_headBgImgView;
    UISearchBar *curSearchBar;
    NSMutableArray *showPageEntity;
    NSMutableAttributedString *attributedStr;
}


@property (nonatomic, assign) id<SearchDelegate> searchDelegate;
@property (nonatomic, assign) BOOL isVerOritaiton;
@property (nonatomic, retain)NSArray *allPageEntityArr;
@property (nonatomic, retain)NSString *rootPath;
@property (nonatomic ,retain)NSString *searchBarText;
@property (nonatomic ,retain)NSMutableAttributedString *titleAttributeString;
@property (nonatomic ,retain)NSMutableAttributedString *desAttributeString;

- (void)reloadData;

@end
