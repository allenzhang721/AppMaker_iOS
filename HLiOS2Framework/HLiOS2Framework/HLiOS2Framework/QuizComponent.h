//
//  QuizComponent.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/20/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "Component.h"
#import "NIDropDown.h"
#import "QuizEntity.h"  
#import "ASMediaFocusManager.h"
#import "QuizAudioPlayer.h"
#import "QuizPagingViewController.h"
#import "FlatPillButton.h"

@interface QuizComponent : Component<NIDropDownDelegate,ASMediasFocusDelegate>
{
    
}

@property (nonatomic,retain) NIDropDown *dropdown;
@property (nonatomic,retain) FlatPillButton   *infoBtn;
@property (nonatomic,retain) UIButton   *nextBtn;
@property (nonatomic,retain) UIButton   *preBtn;
@property (nonatomic,retain) FlatPillButton   *checkAnswer;
@property (nonatomic,assign) QuizEntity *entity;
@property (nonatomic,retain) ASMediaFocusManager *mediaFocusManager;
@property (nonatomic,retain) QuizPagingViewController *qpViewController;
@property int currentQuestionIndex;

-(void) onInfoTouch:(id)sender;
-(void) onIndexChange;
@end
