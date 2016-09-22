//
//  TextInputEntity.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 21/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"
#import <UIKit/UIKit.h>

@interface HLTextInputEntity : HLContainerEntity

@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) float fontSize;
@property (copy, nonatomic) NSString *fontColor;
@property (assign, nonatomic) NSTextAlignment alignment;
@property (assign, nonatomic) Boolean bordVisible;

@end
