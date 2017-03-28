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
//    UITextField *textfiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, _entity.width.floatValue, _entity.height.floatValue)];
  UITextField *textfiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, _entity.width.floatValue, 30)];

  
    textfiled.borderStyle = UITextBorderStyleRoundedRect;
    textfiled.returnKeyType = UIReturnKeyDone;
    textfiled.placeholder = _entity.placeholder;
    textfiled.text = _entity.text;
    textfiled.font = [UIFont systemFontOfSize:_entity.fontSize];
    textfiled.textAlignment = _entity.alignment;
    textfiled.textColor = [self colorWithHexString:_entity.fontColor];
    textfiled.borderStyle = _entity.bordVisible ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    textfiled.delegate = self;
    
    self.uicomponent = textfiled;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
//  
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEdit:) name:UITextFieldTextDidEndEditingNotification object:nil];
  
}

- (void)textDidChanged:(NSNotification *)noti {
    UITextField *target = (UITextField *)noti.object;
    UITextField *textField = self.uicomponent;
    
    if (target == textField) {
//        NSLog(textField.text);
        NSString *string = textField.text;
        
        if ([self onTextDidChanged:string]) {
//            [textField resignFirstResponder];
        }
    }
}

- (void)textDidEndEdit:(NSNotification *)noti {
  UITextField *target = (UITextField *)noti.object;
  UITextField *textField = self.uicomponent;
  
  if (target == textField) {
//    NSLog(textField.text);
    NSString *string = textField.text;
    
    if ([self onTextDidEndEdit:string]) {
//      [textField resignFirstResponder];
    }
  }
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    UITextField *target = (UITextField *)noti.object;
//    UITextField *textField = self.uicomponent;
    
        //    NSLog(textField.text);
        NSString *string = textField.text;
        if ([self onTextDidEndEdit:string]) {
            //      [textField resignFirstResponder];
        } else if ([self onTextDidChanged:string]) {
            
        }
    
}


- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
