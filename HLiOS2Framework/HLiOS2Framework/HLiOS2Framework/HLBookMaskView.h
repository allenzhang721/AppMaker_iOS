//
//  BookMaskView.h
//  HLiOS2Framework
//
//  Created by 星宇陈 on 14-2-7.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLEnumConstant.h"

@interface HLBookMaskView : UIView

@property (readonly , nonatomic) UIImage  *maskImage;
@property (readonly , nonatomic) NSString *attentionContent;

- (instancetype)initWithFrame:(CGRect)frame labelText:(NSString *)string labelPostion:(HLBookEntityBookMarkPostion)postion showLabelText:(BOOL)text showBookMask:(BOOL)show;

@end
