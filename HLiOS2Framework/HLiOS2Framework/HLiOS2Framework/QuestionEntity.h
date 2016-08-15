//
//  QuestionEntity.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/18/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionEntity : NSObject
{
    
}

@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *sourceid;
@property (nonatomic,retain) NSString *imgid;
@property (nonatomic,retain) NSString *audioid;
@property (nonatomic,retain) NSString *topic;
@property (nonatomic,retain) NSMutableArray *answers;
@property (nonatomic,retain) NSMutableArray *rightAnswers;
@property int currentAnswerIndex;
@property int scroe;
@property int correctIndex;

@end
