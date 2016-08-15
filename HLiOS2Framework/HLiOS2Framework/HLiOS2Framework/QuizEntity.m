//
//  QuizEntity.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/18/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "QuizEntity.h"
#import "QuestionEntity.h"
#import "AnswerEntity.h"

@implementation QuizEntity

- (id)init
{
    self = [super init];
    if (self)
    {
        self.questions = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}


- (void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool  = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *questions  = [EMTBXML childElementNamed:@"Questions"  parentElement:moduleData];
    TBXMLElement *question   = [EMTBXML childElementNamed:@"Question"  parentElement:questions];
    while (question != nil)
    {
        QuestionEntity *questionEntity = [[QuestionEntity alloc] init];
        if ([EMTBXML childElementNamed:@"SourceID"  parentElement:question])
        {
            questionEntity.sourceid        = [EMTBXML textForElement:[EMTBXML childElementNamed:@"SourceID"  parentElement:question]];
        }
        questionEntity.type            = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Type"  parentElement:question]];
        questionEntity.topic           = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Topic"  parentElement:question]];
        questionEntity.scroe           = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"Score"  parentElement:question]] intValue];
        questionEntity.imgid           = [EMTBXML textForElement:[EMTBXML childElementNamed:@"ImageSource"  parentElement:question]];
        questionEntity.audioid         = [EMTBXML textForElement:[EMTBXML childElementNamed:@"SoundSource"  parentElement:question]];
        TBXMLElement *answeritems      = [EMTBXML childElementNamed:@"AnswerItems"  parentElement:question];
        TBXMLElement *answeritem       = [EMTBXML childElementNamed:@"AnswerItem"  parentElement:answeritems];
        while (answeritem != nil)
        {
            AnswerEntity *answerEntity = [[AnswerEntity alloc] init];
            answerEntity.title         = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Title"  parentElement:answeritem]];
            [questionEntity.answers addObject:answerEntity];
            [answerEntity release];
            answeritem = [EMTBXML nextSiblingNamed:@"AnswerItem" searchFromElement:answeritem];
        }
        TBXMLElement *rightAnswers  = [EMTBXML childElementNamed:@"RightAnswers"  parentElement:question];
        TBXMLElement *index         = [EMTBXML childElementNamed:@"Index"  parentElement:rightAnswers];
        while (index != nil)
        {
            [questionEntity.rightAnswers addObject:[EMTBXML textForElement:index]];
            questionEntity.correctIndex = [[EMTBXML textForElement:index] intValue];
            index = [EMTBXML nextSiblingNamed:@"Index" searchFromElement:index];
        }
        [self.questions addObject:questionEntity];
        [questionEntity release];
        question = [EMTBXML nextSiblingNamed:@"Question" searchFromElement:question];
    }
    [pool release];
}

- (void)dealloc
{
    [self.questions removeAllObjects];
    [self.questions release];
    [super dealloc];
}

@end








