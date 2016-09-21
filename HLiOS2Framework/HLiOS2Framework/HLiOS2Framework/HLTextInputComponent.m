//
//  HLTextInputComponent.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 21/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTextInputComponent.h"

@implementation HLTextInputComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.entity    = (HLTextInputEntity *)entity;
        self.customHeight = true;
        [self p_setupUI];
    }
    return self;
}

// MARK: - Private Method
- (void)p_setupUI {
    UITextField *textfiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, _entity.width.floatValue, 30)];
    
    textfiled.borderStyle = UITextBorderStyleRoundedRect;
    
    self.uicomponent = textfiled;
}

@end
