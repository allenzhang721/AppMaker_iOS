//
//  QuestionEntity.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/18/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "QuestionEntity.h"

@implementation QuestionEntity
@synthesize type;
@synthesize sourceid;
@synthesize imgid;
@synthesize audioid;
@synthesize answers;
@synthesize scroe;
@synthesize correctIndex;
@synthesize rightAnswers;
@synthesize topic;

-(id) init
{
	self = [super init];
	if (self != nil)
	{
        self.answers      = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        self.rightAnswers = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        self.currentAnswerIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    self.type = nil;
    self.sourceid  = nil;
    self.imgid = nil;
    self.audioid = nil;
    self.topic = nil;
    [self.answers removeAllObjects];
    [self.answers release];
    [self.rightAnswers release];
    [super dealloc];
}
@end
