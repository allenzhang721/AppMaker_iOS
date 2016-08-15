//
//  LineCoverNav.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/24/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "NavView.h"
#import "iCarousel.h"
@interface LineCoverNav : NavView<UITableViewDelegate, UITableViewDataSource>
{}

@property (nonatomic,retain)  UITableView *tableViewCover;
@property (nonatomic,retain)  UIImageView *bgImg;
@property (nonatomic,retain)  UIButton *btnClose;
@property Boolean isTableViewInit;
@end
