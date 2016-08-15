//
//  VideoComponent.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "Component.h"
#import "VideoEntity.h"

@interface VideoComponent : Component<UIAlertViewDelegate>
{
    MPMoviePlayerController *player;
    bool busy;
    Boolean showControlBar;
    BOOL isFirstTime;
    UIImageView *videoCoverImg;
    UIButton *videoPlayBtn;
    BOOL isFirstDelay;
    BOOL isOnlineVideo;//added by Adward 13-11-07
    BOOL isExistenceNetwork;
    NSURL *localURL;
    UIView *superView;
}

@property (nonatomic , retain) VideoEntity *entity;
@property (nonatomic , retain) NSString *filepath;
@property (nonatomic , retain) MPMoviePlayerController *player;
@property bool busy;
//added by Adward 13-11-07
@property BOOL isOnlineVideo;
@property int tag;

-(void) change:(NSNotification*)aNotification;
-(void) playFinished;
-(float)playerDuration;//adward 13-12-30
@property (nonatomic ,retain) UIView *superView;//added by Adward 13-12-06
@end
