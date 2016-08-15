//
//  AnswerEntity.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/20/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "AnswerEntity.h"

@implementation AnswerEntity
@synthesize title;

- (void)dealloc
{
    [self.title release];
    [super dealloc];
}
@end
