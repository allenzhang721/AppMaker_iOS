//
//  CollectionTableViewCell.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-16.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionTableViewCell : UITableViewCell
{
    UIImageView *_titleImg;
    UILabel *_titleLab;
    UILabel *_descLab;
}
@property (nonatomic ,retain)NSString *searchBarText;

- (void)setCellContent:(NSString *)picImg title:(NSString *)title desc:(NSString *)desc;//adward 2.13

@end
