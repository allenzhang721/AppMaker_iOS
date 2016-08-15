//
//  BookViewController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLBookController.h"
#import "HLBookMaskView.h"

@class HLBookController;

@interface HLBookViewController : UIViewController
{
    
}
@property (nonatomic,assign)     HLBookController     *bookController;
@property (nonatomic,retain)     UILabel            *maskLable;
@property (readonly , nonatomic) HLBookMaskView       *maskView;      // Mr.chen , 2.7
@property (nonatomic, assign)     UIImageView        *publicCoverBackGroundImageView;
@property CGRect hrect;
-(void) addMask:(CGRect) rect;
- (void)addTaiwanMask:(CGRect)rect;     //陈星宇，11.18，台湾版提示文字
- (void)addFreeMaskView:(CGRect)rect;   //添加水印
@end
