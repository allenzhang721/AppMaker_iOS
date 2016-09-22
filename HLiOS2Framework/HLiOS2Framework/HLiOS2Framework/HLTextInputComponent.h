//
//  HLTextInputComponent.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 21/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "HLTextInputEntity.h"

@interface HLTextInputComponent : Component<UITextFieldDelegate>

@property (nonatomic, retain)HLTextInputEntity   *entity;

@end
