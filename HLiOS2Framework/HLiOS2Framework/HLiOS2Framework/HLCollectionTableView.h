//
//  CollectionTableView.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-16.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionDelegate <NSObject>

- (void)addCollection:(BOOL)add;

- (void)collectionCellDidSelected:(NSString *)pageId;

@end

@interface HLCollectionTableView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UIView *_headerView;
    UITableView *_tableView;
    UIButton *_collectionBtn;
    UIImageView *_bgImgView;
    UIImageView *_headBgImgView;
}

@property (nonatomic, assign) BOOL isVerOritaiton;

@property (nonatomic, assign) NSMutableArray *collectionArr;

@property (nonatomic, assign) id<CollectionDelegate> collectionDelegate;

@property (nonatomic, retain) NSString *curHorImgPath;

@property (nonatomic, retain) NSString *bookId;

@property (nonatomic, retain) NSString *curVerImgPath;

@property (nonatomic, retain) NSString *curHorPageId;

@property (nonatomic, retain) NSString *curVerPageId;

@property (nonatomic, retain) NSString *curPageTitle;

@property (nonatomic ,retain) NSString *curPageDesc;//adward 2.13

- (void)setCollectBtnState:(BOOL)selected;

- (void)reloadData;

- (void)getLocationList:(NSString *)bookId;

@end
