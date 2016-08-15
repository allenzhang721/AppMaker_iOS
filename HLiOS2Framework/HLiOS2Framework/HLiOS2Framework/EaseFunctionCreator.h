//
//  EaseFunctionCreator.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 3/9/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLNSBKeyframeAnimationFunctions.h"
@interface EaseFunctionCreator : NSObject
+(NSBKeyframeAnimationFunction)animationFunctionForType:(NSString *) easeType;

@end
