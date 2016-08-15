//
//  SlideCell.h
//  Core
//
//  Created by sun yongle on 12/08/12.
//  Copyright (c) 2012年 PEM. All rights reserved.
//

#import "GMGridViewCell.h"

@class SlideCell;

@protocol SlideCellDelegate <NSObject>

@optional
- (void)slideCell:(SlideCell*)cell CellClicked:(id)sender;

@end

@interface SlideCell : GMGridViewCell
{
    UIButton *backBtn;
}
@property (nonatomic, assign) id<SlideCellDelegate> delegate;

@property BOOL isSelected;
@property float cellWidth;
@property float cellHeight;
@property NSInteger index;

@property (nonatomic, retain) NSString *imageNormal;
@property (nonatomic, retain) NSString *imagePressed;

- (void)refreshInfo;

@end
