//
//  CatalogueTableView.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-16.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CatalogueDelegate <NSObject>

- (void)catalogueCellDidSelected:(int)index;

@end

@interface CatalogueTableView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *_bgImgView;
    UITableView *_tableView;
}

@property (nonatomic, assign) NSMutableArray *collectionArr;

@property (nonatomic, assign) id <CatalogueDelegate> catalogueDelegate;

@property (nonatomic, retain) NSArray *snapshotsArray;

@property (nonatomic, retain) NSArray *titleArray;

@property (nonatomic, retain) NSArray *descArray;//adward 2.13

@property (nonatomic, retain) NSString *rootPathStr;

- (void)reloadData;

@end
