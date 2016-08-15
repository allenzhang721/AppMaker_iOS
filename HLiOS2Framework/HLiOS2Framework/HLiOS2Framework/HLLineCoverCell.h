//
//  LineCoverCell.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/25/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLLineCoverCell : UITableViewCell
{}
@property (nonatomic,retain) UIImageView *bgImg;
@property (nonatomic,retain) UIImageView *snapImg;
@property (nonatomic,retain) UILabel *title;


-(void) changeToVertical;
-(void) changeToHorizontal;
-(void) setSnapshot:(NSString *) snapPath;

@end
