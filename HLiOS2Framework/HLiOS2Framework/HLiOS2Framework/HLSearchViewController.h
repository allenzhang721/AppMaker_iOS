//
//  SearchViewController.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-14.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLPageEntity.h"

@interface HLSearchViewController : UIViewController <UISearchBarDelegate>
{
    NSMutableArray *showPageEntity;
}

@property (nonatomic, retain)NSArray *allPageEntityArr;
@property (nonatomic, retain)NSString *rootPath;

@end
