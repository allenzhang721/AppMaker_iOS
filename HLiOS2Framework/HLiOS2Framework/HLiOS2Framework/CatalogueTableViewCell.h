//
//  CatalogueTableViewCell.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-16.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatalogueTableViewCell : UITableViewCell
{
    UIImageView *_titleImg;
    UIImageView *_collectImg;
    UILabel *_titleLab;
    UILabel *_descLab;
}

- (void)setCellContent:(NSString *)picImg collected:(BOOL)collected title:(NSString *)title desc:(NSString *)desc;// adward 2.13

@end
