//
//  SingleChoiceView.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/25/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "SingleChoiceView.h"
#import "QuizComponent.h"
#import "AnswerWithText.h"
#import "AnswerEntity.h"

@implementation SingleChoiceView

@synthesize  qimg;
@synthesize  qimgbg;
@synthesize  qimgfg;
@synthesize  breakLine;
@synthesize  audioPlayer;
@synthesize  uianswers;
@synthesize  qe;
@synthesize  questionImg;
@synthesize  component;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
//        self.uianswers   = [[NSMutableArray alloc] initWithCapacity:4];
//        self.questionImg = [[UIImageView alloc] init];
//        self.qimg        = [[UIImageView alloc] init];
//        self.breakLine   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quiz_breakline.png"]];
//        [self addSubview:self.questionImg];
//        [self addSubview:self.qimg];
//        [self addSubview:self.breakLine];
    }
    return self;
}


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithReuseIdentifier:reuseIdentifier];
    self.uianswers   = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    self.questionImg = [[[UIImageView alloc] init] autorelease];
    self.qimg        = [[[UIImageView alloc] init] autorelease];
    self.breakLine   = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quiz_breakline.png"]] autorelease];
    self.audioPlayer = [[[QuizAudioPlayer alloc] initWithFrame:CGRectMake(0, 0, 50, 50)] autorelease];
   

    [self addSubview:self.questionImg];
    [self addSubview:self.qimg];
    [self addSubview:self.breakLine];
    return self;
}

-(void) beginView
{
    for (int i = 0; i < [self.uianswers count] ; i++)
    {
        AnswerWithText *at = [self.uianswers objectAtIndex:i];
        [at.selectBtn setImage:[UIImage imageNamed:@"quiz_sel_btn_ns.png"] forState:UIControlStateSelected];
    }
    [self.audioPlayer removeFromSuperview];
    
    if ([qe.audioid length] > 0 )
    {
        NSString *audioPath = [self.component.entity.rootPath stringByAppendingPathComponent:qe.audioid];
        [self.audioPlayer playMusic:audioPath];
        if ([qe.imgid length]>0)
        {
            self.audioPlayer.frame = CGRectMake(self.qimg.frame.origin.x - 60, self.qimg.frame.origin.y, 50, 50);
        }
        else
        {
            self.audioPlayer.frame = CGRectMake(self.component.uicomponent.frame.size.width - 55 , self.component.infoBtn.frame.origin.y +5, 50, 50);
        }
        [self addSubview:self.audioPlayer];
    }
    [self.audioPlayer stopPlayMusic];
}

-(void) stopView
{
    [self.audioPlayer removeFromSuperview];
    [self.audioPlayer stopPlayMusic];
}

-(void) loadQuestion:(QuestionEntity *)questionEntity rooPath:(NSString *)rootPath
{
    self.qe = questionEntity;
    NSString* imgPath  = [rootPath stringByAppendingPathComponent:qe.sourceid];
    NSString* imgPath2 = [rootPath stringByAppendingPathComponent:qe.imgid];
    UIImage *img  = [UIImage imageWithContentsOfFile:imgPath];
    UIImage *img2 = [UIImage imageWithContentsOfFile:imgPath2];
    [self.questionImg setImage:img];
    [self.qimg setImage:img2];
    self.questionImg.frame = CGRectMake(15,self.component.infoBtn.frame.origin.y + self.component.infoBtn.frame.size.height+15, img.size.width, img.size.height);
    int qimgWidth          = 200*self.component.uicomponent.frame.size.width/820;
    int qimgHeigth         = 150*self.component.uicomponent.frame.size.height/615;
    qimgHeigth             = self.qimg.image.size.height*qimgWidth/self.qimg.image.size.width;
    if (qimgHeigth > 150*self.component.uicomponent.frame.size.height/615)
    {
        qimgHeigth = 150*self.component.uicomponent.frame.size.height/615;
        qimgWidth  = self.qimg.image.size.width*qimgHeigth/self.qimg.image.size.height;
    }
    self.qimg.frame        = CGRectMake(self.component.uicomponent.frame.size.width - qimgWidth - 15, self.component.infoBtn.frame.size.height+15, qimgWidth, qimgHeigth);
    self.qimgbg.frame      = CGRectMake(self.qimg.frame.origin.x-5, self.qimg.frame.origin.y-5, qimgWidth+10, qimgHeigth+10);
    self.qimgfg.frame      = CGRectMake(self.qimgbg.frame.origin.x+self.qimgbg.frame.size.width - 25, self.qimgbg.frame.origin.y+self.qimgbg.frame.size.height-25, 22, 22);
    if((self.questionImg.frame.size.height > self.qimg.frame.size.height) || ([qe.imgid length]==0))
    {
        self.breakLine.frame = CGRectMake(5, self.questionImg.frame.origin.y + self.questionImg.frame.size.height+10, self.component.uicomponent.frame.size.width - 10, self.breakLine.image.size.height);
    }
    else
    {
        self.breakLine.frame = CGRectMake(5,self.qimg.frame.origin.y+ self.qimg.frame.size.height+10, self.component.uicomponent.frame.size.width - 10, self.breakLine.image.size.height);
    }
    int ay = self.breakLine.frame.origin.y + self.breakLine.frame.size.height+10;
    int ax = 5;
    for (int n = 0; n < [self.uianswers count]; n++)
    {
        UIView *vi = [self.uianswers objectAtIndex:n];
        [vi removeFromSuperview];
    }
    [self.uianswers removeAllObjects];
    for (int i = 0; i < [qe.answers count]; i++)
    {
        AnswerWithText *at = [[AnswerWithText alloc] initWithFrame:CGRectMake(ax, ay, 100, 50)];
        AnswerEntity *ae   = [qe.answers objectAtIndex:i];
        [at.selectBtn addTarget:self action:@selector(onBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [at setLabelText:ae.title];
        at.frame = CGRectMake(ax, ay, at.frame.size.width, at.frame.size.height);
        [self.uianswers addObject:at];
        ay = ay + at.frame.size.height + 15;
        [self addSubview:at];
        if (i == qe.currentAnswerIndex)
        {
            [at.selectBtn setSelected:YES];
        }
        [at release];
    }
}


-(void) checkAnswer
{
    if(qe.currentAnswerIndex == -1)
    {
        return;
    }
    if (qe.currentAnswerIndex == qe.correctIndex)
    {
        AnswerWithText *at = [self.uianswers objectAtIndex:qe.currentAnswerIndex];
        [at.selectBtn setImage:[UIImage imageNamed:@"quiz_sel_btn_s.png"] forState:UIControlStateSelected];
    }
    else
    {
        if (qe.currentAnswerIndex >= 0)
        {
            AnswerWithText *at = [self.uianswers objectAtIndex:qe.currentAnswerIndex];
            [at.selectBtn setImage:[UIImage imageNamed:@"quiz_sel_btn_w.png"] forState:UIControlStateSelected];
        }
    }
}

-(void) onBtnSelect:(UIButton*) sender
{
    for (int i = 0; i < [self.uianswers count] ; i++)
    {
        AnswerWithText *at = [self.uianswers objectAtIndex:i];
        [at.selectBtn setSelected:NO];
        if (at.selectBtn == sender)
        {
            qe.currentAnswerIndex = i;
        }
    }
    [sender setImage:[UIImage imageNamed:@"quiz_sel_btn_ns.png"] forState:UIControlStateSelected];
    [sender setSelected:YES];
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
    [self.qimg removeFromSuperview];
    [self.qimg release];
    [self.qimgbg removeFromSuperview];
    [self.qimgbg release];
    [self.qimgfg removeFromSuperview];
    [self.qimgfg release];
    [self.breakLine removeFromSuperview];
    [self.breakLine release];
    [self.questionImg removeFromSuperview];
    [self.questionImg release];
    [self.audioPlayer removeFromSuperview];
    [self.audioPlayer stopPlayMusic];
    [self.audioPlayer release];
    [self.uianswers removeAllObjects];
    [self.uianswers release];
    [super dealloc];
}

@end








