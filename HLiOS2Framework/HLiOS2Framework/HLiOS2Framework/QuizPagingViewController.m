//
//  QuizPagingViewController.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 3/5/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "QuizPagingViewController.h"
#import "SYPageView.h"
#import "SingleChoiceView.h"
#import "QuizComponent.h"
#import "SYPaginatorView.h"
#import "ResultPageView.h"

@interface QuizPagingViewController ()

@end

@implementation QuizPagingViewController
@synthesize entity;
@synthesize quizComponent;
@synthesize isAnswerChecking;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];//modefied by Adward 13-12-18 试题模版透明颜色
	self.paginatorView.pageGapWidth = 30.0f;
    self.isAnswerChecking = NO;
}

- (NSInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginatorView
{
	return ([self.entity.questions count]+1);
}

- (SYPageView *)paginatorView:(SYPaginatorView *)paginatorView viewForPageAtIndex:(NSInteger)pageIndex
{
    
	static NSString *identifier = @"identifier";
	if(pageIndex < [self.entity.questions count])
    {
        SingleChoiceView *view = (SingleChoiceView *)[paginatorView dequeueReusablePageWithIdentifier:identifier];
        if (!view)
        {
            view = [[[SingleChoiceView alloc] initWithReuseIdentifier:identifier] autorelease];
        }
        view.component = self.quizComponent;
        [view loadQuestion:[self.entity.questions objectAtIndex:pageIndex] rooPath:self.entity.rootPath];
        if (self.isAnswerChecking == YES)
        {
            [view checkAnswer];
        }
        return view;
    }
    else
    {
        ResultPageView *view = [[[ResultPageView alloc] init] autorelease];
        view.qe        = self.entity;
        view.component = self.quizComponent;
        [view checkResult];
        self.isAnswerChecking = YES;
        return view;
    }
}

- (void)paginatorViewDidBeginPaging:(SYPaginatorView *)paginatorView;
{
    [[self getCurrentView] stopView];
}

- (void)paginatorView:(SYPaginatorView *)paginatorView didScrollToPageAtIndex:(NSInteger)pageIndex;
{
    [self.quizComponent onIndexChange];
    [[self getCurrentView] beginView];
    if ([self getCurrentIndex] < [self.entity.questions count])
    {
        if (self.isAnswerChecking == YES)
        {
            [(SingleChoiceView*)[self getCurrentView] checkAnswer];
        }
    }
}

-(int) getCurrentIndex
{
    return  self.paginatorView.currentPageIndex;
}

-(void) setCurrentPageIndex:(int) pageIndex
{
    [self.paginatorView setCurrentPageIndex:pageIndex animated:YES];
}

-(SYPageView *) getCurrentView
{
    return (SYPageView*)self.paginatorView.currentPage;
}

-(void) reloadData
{
    [self.paginatorView reloadData];
    [self.paginatorView setCurrentPageIndex:0];
    [[self getCurrentView] beginView];
}

-(void) checkAnswer
{
    if([[self getCurrentView] isKindOfClass:[SingleChoiceView class]])
    {
        [(SingleChoiceView*)[self getCurrentView] checkAnswer];
    }
}

-(void)paginatorView:(SYPaginatorView *)paginatorView
     willDisplayView:(UIView *)view
             atIndex:(NSInteger)pageIndex
{
   // NSLog(@"will display view at index: %i", pageIndex + 1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

@end
