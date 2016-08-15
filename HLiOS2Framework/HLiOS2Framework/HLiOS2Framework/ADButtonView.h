//
//  ADButtonView.h
//  HLiOS2Framework
//
//  Created by Adward on 14-3-7.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADButtonView : UIImageView
@property (nonatomic, retain)UIImage *upImg;
@property (nonatomic, retain)UIImage *downImg;
-(void)setup;
@end
