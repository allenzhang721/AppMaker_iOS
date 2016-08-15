//
//  QuizComponent.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/20/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "QuizComponent.h"
#import "QuizEntity.h"
#import "QuestionEntity.h"
#import "HLContainer.h"
#import "HLPageController.h"
#import "AnswerWithText.h"
#import "AnswerEntity.h"
#import "SingleChoiceView.h"

@implementation QuizComponent
@synthesize dropdown; 
@synthesize infoBtn;
@synthesize nextBtn;
@synthesize preBtn;
@synthesize mediaFocusManager;
@synthesize qpViewController;

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
	if (self != nil)
	{
        self.entity      = (QuizEntity*)entity;
        self.uicomponent = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue])] autorelease];
        self.infoBtn  = [[[FlatPillButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)] autorelease];
        self.infoBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.preBtn   = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 28)] autorelease];
        self.nextBtn  = [[[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 29, 28)] autorelease];
        self.checkAnswer = [[[FlatPillButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] autorelease];
        self.qpViewController = [[[QuizPagingViewController alloc] init] autorelease];
        self.qpViewController.entity = self.entity;
        self.qpViewController.quizComponent = self;
        self.qpViewController.view.frame = CGRectMake(0, 0, self.uicomponent.frame.size.width, self.uicomponent.frame.size.height);
        [self.preBtn setImage:[UIImage imageNamed:@"quiz_pre.png"] forState:UIControlStateNormal];
        [self.nextBtn setImage:[UIImage imageNamed:@"quiz_next.png"] forState:UIControlStateNormal];
        [self.infoBtn setTitle:[NSString stringWithFormat:@"试题: %d of %d",1,[((QuizEntity*)entity).questions count]] forState:UIControlStateNormal];
        [self.checkAnswer setTitle:@"检查答案" forState:UIControlStateNormal];
        [self.infoBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.checkAnswer setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.infoBtn.backgroundColor = [UIColor clearColor];
        self.preBtn.backgroundColor  = [UIColor clearColor];
        self.nextBtn.backgroundColor = [UIColor clearColor];
        self.uicomponent.backgroundColor = [UIColor clearColor];
        [self.uicomponent addSubview:self.qpViewController.view];
        [self.uicomponent addSubview:self.infoBtn];
        [self.uicomponent addSubview:self.preBtn];
        [self.uicomponent addSubview:self.nextBtn];
        [self.uicomponent addSubview:self.checkAnswer];
        self.currentQuestionIndex = 0;
      //  [self.infoBtn addTarget:self action:@selector(onInfoTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.preBtn addTarget:self action:@selector(onPre) forControlEvents:UIControlEventTouchUpInside];
        [self.nextBtn addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        self.mediaFocusManager = [[[ASMediaFocusManager alloc] init] autorelease];
        self.mediaFocusManager.delegate = self;
        self.checkAnswer.backgroundColor = [UIColor clearColor];
        self.infoBtn.frame = CGRectMake((self.uicomponent.frame.size.width - self.infoBtn.frame.size.width)/2, 5, self.infoBtn.frame.size.width, self.infoBtn.frame.size.height);
        self.preBtn.frame  = CGRectMake(5, self.uicomponent.frame.size.height - self.preBtn.frame.size.height-8, self.preBtn.frame.size.width, self.preBtn.frame.size.height);
        self.nextBtn.frame = CGRectMake(self.uicomponent.frame.size.width - self.nextBtn.frame.size.width-5, self.uicomponent.frame.size.height - self.nextBtn.frame.size.height-8, self.nextBtn.frame.size.width, self.nextBtn.frame.size.height);
        self.checkAnswer.frame = CGRectMake((self.uicomponent.frame.size.width - self.checkAnswer.frame.size.width)/2, self.uicomponent.frame.size.height - self.checkAnswer.frame.size.height-5, self.checkAnswer.frame.size.width,self.checkAnswer.frame.size.height);
        [self.checkAnswer addTarget:self action:@selector(onCheckAnswer) forControlEvents:UIControlEventTouchUpInside];
        [self.qpViewController reloadData];
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
}



#pragma mark - ASMediaFocusDelegate
- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
{
    if([self.qpViewController getCurrentIndex] < [self.entity.questions count])
    {
        QuestionEntity *qe = [self.entity.questions objectAtIndex:[self.qpViewController getCurrentIndex]];
        NSString* imgPath  = [self.entity.rootPath stringByAppendingPathComponent:qe.imgid];
        UIImage *image     = [[UIImage imageWithContentsOfFile:imgPath] retain];
        return image;
    }
    return nil;
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
{
//    return self.container.pageController.pageViewController.view.bounds;
    return CGRectMake(0, 0, 200, 200);//modified by Adward 13-12-20 点击图标后铺满屏幕
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self.container.pageController.pageViewController;
}

- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaPathForView:(UIView *)view
{
    if([self.qpViewController getCurrentIndex] < [self.entity.questions count])
    {
        QuestionEntity *qe = [self.entity.questions objectAtIndex:[self.qpViewController getCurrentIndex]];
        NSString *path =  [self.entity.rootPath stringByAppendingPathComponent:qe.imgid];
        return path;
    }
    return nil;
}

-(void) onNext
{
    if ([self.qpViewController getCurrentIndex] < ([self.entity.questions count]))//最后一页始终是答题结果公布 也需要点击按钮响应
    {
        [self.qpViewController setCurrentPageIndex:[self.qpViewController getCurrentIndex]+1];
    }
}

-(void) onPre
{
    if ([self.qpViewController getCurrentIndex] > 0)
    {
        [self.qpViewController setCurrentPageIndex:[self.qpViewController getCurrentIndex]-1];
    }
}

-(void) onCheckAnswer
{
    if([self.qpViewController getCurrentIndex] < [self.entity.questions count])
    {
        [self.qpViewController checkAnswer];
    }
    else
    {
        for (int i = 0 ; i < [self.entity.questions count]; i++)
        {
            QuestionEntity *en = [self.entity.questions objectAtIndex:i];
            en.currentAnswerIndex = -1;
        }
        self.qpViewController.isAnswerChecking = NO;
        [self.qpViewController setCurrentPageIndex:0];
    }
}



-(void) onBtnSelect:(UIButton*) sender
{
//    QuestionEntity *qe = [self.entity.questions objectAtIndex:self.currentQuestionIndex];
//    for (int i = 0; i < [self.uianswers count] ; i++)
//    {
//        AnswerWithText *at = [self.uianswers objectAtIndex:i];
//        [at.selectBtn setSelected:NO];
//        if (at.selectBtn == sender)
//        {
//            qe.currentAnswerIndex = i;
//        }
//    }
//    [sender setSelected:YES];
}

-(void) onInfoTouch:(id)sender
{
    NSMutableArray * arr = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < [self.entity.questions count]; i++)
    {
        [arr addObject:((QuestionEntity*)[self.entity.questions objectAtIndex:i]).topic];
    }
    if(self.dropdown == nil) {
        CGFloat f = 200;
        self.dropdown = [[NIDropDown alloc] showDropDown:sender height:&f arr:arr];
        self.dropdown.delegate = self;
    }
    else
    {
        [self.dropdown hideDropDown:sender];
        [self rel];
    }

}

-(void) onIndexChange
{
    if([self.qpViewController getCurrentIndex] < [self.entity.questions count])
    {
        [self.infoBtn setTitle:[NSString stringWithFormat:@"试题: %d of %d",[self.qpViewController getCurrentIndex]+1,[self.entity.questions count]] forState:UIControlStateNormal];
        NSMutableArray *imgArrar = [[NSMutableArray alloc] initWithCapacity:1];
        [imgArrar addObject:((SingleChoiceView*)[self.qpViewController getCurrentView]).qimg];
        [self.mediaFocusManager installOnViews:imgArrar];
        [imgArrar removeAllObjects];
        [imgArrar release];
        [self.checkAnswer setTitle:@"检查答案" forState:UIControlStateNormal];
    }
    else
    {
         [self.checkAnswer setTitle:@"重新开始" forState:UIControlStateNormal];
    }
}



- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    
    [self.infoBtn setTitle:[NSString stringWithFormat:@"试题: %d of %d",sender.currentSelectIndex+1,[self.entity.questions count]] forState:UIControlStateNormal];
    self.currentQuestionIndex = sender.currentSelectIndex;
    [self rel];
}


-(void)rel
{
    [self.dropdown release];
    self.dropdown = nil;
}


- (void)dealloc
{
    [self.dropdown removeFromSuperview];
    [self.dropdown release];
    [self.nextBtn removeFromSuperview];
    [self.nextBtn release];
    [self.preBtn removeFromSuperview];
    [self.preBtn release];
    [self.infoBtn removeFromSuperview];
    [self.infoBtn release];
    [self.checkAnswer removeFromSuperview];
    [self.checkAnswer release];
    [self.mediaFocusManager release];
    [self.qpViewController.view removeFromSuperview];
    [self.qpViewController release];
    [self.uicomponent removeFromSuperview];
    [self.uicomponent release];
    [super dealloc];
}
@end






