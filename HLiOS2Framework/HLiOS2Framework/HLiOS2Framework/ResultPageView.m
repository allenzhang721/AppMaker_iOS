//
//  ResultPageView.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 3/6/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "ResultPageView.h"
#import "QuestionEntity.h"
#import "QuizEntity.h"
#import "AnswerEntity.h"
#import "QuizComponent.h"

@implementation ResultPageView

@synthesize qe;
@synthesize component;
@synthesize pvController;
@synthesize resultLable;
@synthesize infoLable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void) beginView
{
    [self checkResult];
}

-(void) checkResult
{
    if (self.resultLable == nil)
    {
        self.resultLable = [[[UILabel alloc] init] autorelease];
        [self addSubview:self.resultLable];
    }
    if (self.infoLable == nil)
    {
        self.infoLable = [[[UILabel alloc] init] autorelease];
        self.infoLable.text = @"返回检查错误或重新开始。";
        self.infoLable.font = [UIFont systemFontOfSize:20];
        [self.infoLable sizeToFit];
        [self addSubview:self.infoLable];
    }
    int rightAnswer = 0;
    for (int i = 0 ; i < [self.qe.questions count]; i++)
    {
        QuestionEntity *entity = [self.qe.questions objectAtIndex:i];
        if(entity.currentAnswerIndex == entity.correctIndex)
        {
            rightAnswer++;
        }
    }
    
    self.resultLable.text = [NSString stringWithFormat:@"%d题中答对%d题",[self.qe.questions count],rightAnswer];
    self.resultLable.font = [UIFont systemFontOfSize:30];
    [self.resultLable sizeToFit];
    self.resultLable.frame = CGRectMake(self.component.uicomponent.frame.size.width/2 - self.resultLable.frame.size.width/2, self.component.uicomponent.frame.size.height/2-self.resultLable.frame.size.height/2, self.resultLable.frame.size.width, self.resultLable.frame.size.height);
    self.infoLable.frame = CGRectMake(self.component.uicomponent.frame.size.width/2 - self.infoLable.frame.size.width/2, self.resultLable.frame.origin.y + self.resultLable.frame.size.height+self.infoLable.frame.size.height+10, self.infoLable.frame.size.width, self.infoLable.frame.size.height);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [self.infoLable removeFromSuperview];
    [self.infoLable release];
    [self.resultLable removeFromSuperview];
    [self.resultLable release];
    [super dealloc];
}


@end








