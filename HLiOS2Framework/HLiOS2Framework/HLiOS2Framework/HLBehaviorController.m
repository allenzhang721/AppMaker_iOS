//
//  BehaviorController.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLBehaviorController.h"
#import "HLContainer.h"
#import "HLPageController.h"
#import "WebComponent.h"
#import "RollingTextComponent.h"
#import "HLFlipBaseController.h"
#import "HLBehaviorEntity.h"
#import "CounterComponent.h"
#import "ImageComponent.h"
#import "HLAudioComponent.h"

@implementation HLBehaviorController
@synthesize flipController;
@synthesize pageController;

- (void) callPhoneNumber:(NSString *)number {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel://%@", number]];
    [[UIApplication sharedApplication] openURL:url];
}

-(Boolean) runBehavior:(NSString *)containerid entity:(HLBehaviorEntity *)entity
{
    if (self.pageController != nil)
    {
        NSLog(@"eventName = %@\nfunctionName = %@\nfunctionObjID = %@\n\n",entity.eventName,entity.functionName,entity.functionObjectID);
        HLContainer *functionContainer = [self.pageController getContainerByID:entity.functionObjectID];
        
        if (functionContainer == nil)
        {
            functionContainer =  [self.pageController getContainerByID:containerid];
        }
        if (functionContainer != nil)
        {
            
            [functionContainer runCaseComponent:entity.functionName];
            if ([entity.functionName isEqualToString:@"FUNCTION_CALL_PHONENUMBER"])
            {
                if (entity.value != nil) {
                    [self callPhoneNumber:entity.value];
                }
                return NO;
            }
            
            if ([entity.functionName isEqualToString:@"FUNCTION_PRINT"])
            {
                if ([functionContainer.component isKindOfClass:[ImageComponent class]])
                {
                    [self.flipController print:functionContainer];
                }
                return NO;
            }
            if ([entity.functionName compare:@"FUNCTION_TEMPALTE_CHANGETO"] == NSOrderedSame)
            {
                [functionContainer change:[entity.value intValue]];
                return NO;
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_SHARETO_SINA"])
            {
                NSString *contentStr = entity.value;
//                [self.flipController showShareView:contentStr WBType:MEWBSina];
                [self.flipController showShareView:contentStr type:WeiboTypeSina];
                return NO;
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_SHARETO_QQ"])
            {
                NSString *contentStr = entity.value;
//                [self.flipController showShareView:contentStr WBType:MEWBTencent];
                [self.flipController showShareView:contentStr type:WeiboTypeTencent];
                return NO;
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_SHARETO_WEIXIN"])
            {
                NSString *contentStr = entity.value;
//                [self.flipController showShareView:contentStr WBType:MEWBWeixin];
                [self.flipController showShareView:contentStr type:WeiboTypeWeixin];
                return NO;
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_SHARETO_DOUBAN"])
            {
                NSString *contentStr = entity.value;
//                [self.flipController showShareView:contentStr WBType:MEWBDouban];
                [self.flipController showShareView:contentStr type:WeiboTypeDouban];
                return NO;
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_SHARETO_KONGJIAN"])
            {
                NSString *contentStr = entity.value;
//                [self.flipController showShareView:contentStr WBType:MEWBQzone];
                [self.flipController showShareView:contentStr type:WeiboTypeQQSpace];
                return NO;
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_SHARETO_RENREN"])
            {
                NSString *contentStr = entity.value;
//                [self.flipController showShareView:contentStr WBType:MEWBRenRen];
                [self.flipController showShareView:contentStr type:WeiboTypeRenren];
                return NO;
            }
            
            if ([entity.functionName compare:@"FUNCTION_PLAY_VIDEO_AUDIO"] == NSOrderedSame)
            {
//                NSLog(@"FUNCTION_PLAY_VIDEO_AUDIO");
                [functionContainer play];
                return NO;
            }
            
            if ([entity.functionName compare:@"FUNCTION_STOP_VIDEO_AUDIO"] == NSOrderedSame)
            {
                [functionContainer stop];
                return NO;
            }
            if ([entity.functionName compare:@"FUNCTION_PAUSE_VIDEO_AUDIO"] == NSOrderedSame)
            {
                [functionContainer pause];
                return NO;
            }
            
            if ([entity.functionName compare:@"FUNCTION_HIDE"] == NSOrderedSame)
            {
                [functionContainer hide];
                return NO;
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_PLAY_BACKGROUND_MUSIC"])
            {
                [self.flipController playBackgroundMusic];
                return NO;
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_PAUSE_BACKGROUND_MUSIC"])
            {
                [self.flipController pauseBackgroundMusic];
                return NO;
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_STOP_BACKGROUND_MUSIC"])
            {
                [self.flipController stopBackgroundMusic];
                return NO;
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_GOTO_LASETPAGE"])
            {
                return [self.flipController returnToLastPage:YES];
            }
            if ([entity.functionName isEqualToString:@"FUNCTION_BACK_LASTPAGE"])
            {
               return [self.flipController returnToLastPage:NO];
            }
            
            if ([entity.functionName isEqualToString:@"FUNCTION_CHANGE_URL"])
            {
                if ([functionContainer.component isKindOfClass:[WebComponent class]])
                {
                    [(WebComponent*)(functionContainer.component) changeUrl:entity.value];
                }
                return NO;
            }
            
            if ([entity.functionName isEqualToString:@"FUNCTION_COUNTER_PLUS"])
            {
                NSLog(@"FUNCTION_COUNTER_PLUS");
                if ([functionContainer.component isKindOfClass:[CounterComponent class]])
                {
                    NSLog(@"[entity.value intValue] = %d",[entity.value intValue]);
                    [(CounterComponent*)(functionContainer.component) addCount:[entity.value intValue]];
                }
                return NO;
            }
            
            if ([entity.functionName isEqualToString:@"FUNCTION_COUNTER_MINUS"])
            {
                if ([functionContainer.component isKindOfClass:[CounterComponent class]])
                {
                    [(CounterComponent*)(functionContainer.component) delCount:[entity.value intValue]];
                }
                return NO;
            }
            
            if ([entity.functionName isEqualToString:@"FUNCTION_COUNTER_RESET"])
            {
                if ([functionContainer.component isKindOfClass:[CounterComponent class]])
                {
                    [(CounterComponent*)(functionContainer.component) reset];
                }
                return NO;
            }
            
            if ([entity.functionName isEqualToString:@"FUNCTION_CHANGE_SIZE"])
            {
                if ([functionContainer.component isKindOfClass:[RollingTextComponent class]])
                {
                    [((RollingTextComponent*)functionContainer.component) changeFontSize:entity.value];
                }
                return NO;
            }
            
            if ([entity.functionName compare:@"FUNCTION_SHOW"] == NSOrderedSame)
            {
                [functionContainer show];
                return NO;
            }
            
            if ([entity.functionName compare:@"FUNCTION_PLAY_ANIMATION"] == NSOrderedSame)
            {
                [functionContainer playAnimation:YES];
                return NO;
            }
            if ([entity.functionName compare:@"FUNCTION_PLAY_ANIMATION_AT"] == NSOrderedSame)
            {
                [functionContainer playSingleAnimation: [entity.value intValue]];
                return NO;
            }
            
            if ([entity.functionName compare:@"FUNCTION_PAUSE_ANIMATION"] == NSOrderedSame)
            {
                [functionContainer pauseAnimation];
                return NO;
            }
            
            if ([entity.functionName compare:@"FUNCTION_STOP_ANIMATION"] == NSOrderedSame)
            {
                [functionContainer stopAnimation];
                return NO;
            }
            
            if ([entity.functionName compare:@"FUNCTION_GOTO_PAGE"] == NSOrderedSame)
            {
                
                
                return [self.flipController gotoPageWithPageID:entity.value animate:YES];
            }
            
            if ([entity.functionName compare:@"FUNCTION_PAGE_CHANGE"] == NSOrderedSame)
            {
                NSArray *array  = [entity.value componentsSeparatedByString:@";"];
                if (array.count > 1)
                {
                    return [self.flipController gotoPageWithPageID:[array objectAtIndex:1] animate:NO];
                }
                else
                {
                    return [self.flipController gotoPageWithPageID:entity.value animate:NO];
                }
            }
            if ([entity.functionName compare:@"FUNCTION_GOTO_URL"] == NSOrderedSame)
            {
                [self.flipController popWebview:entity.value];
                return NO;
            }
            
            if ([entity.functionName compare:@"FUNCTION_AUTO_PLAY_BOOK"] == NSOrderedSame)
            {
                [self.flipController setAutoPlay:YES];
                return NO;
            }
            
            if ([entity.functionName compare:@"FUNCTION_DISABLE_AUTO_PLAY_BOOK"] == NSOrderedSame)
            {
                [self.flipController setAutoPlay:NO];
                return NO;
            }
            if ([entity.functionName compare:@"FUNCTION_PLAY_GROUP"] == NSOrderedSame)
            {
                [self.pageController playGroup: [NSNumber numberWithInt:[entity.value intValue]]];
                return NO;
            }
            if ([entity.functionName compare:@"FUNCTION_STOP_GROUP_AT_INDEX"] == NSOrderedSame)
            {
                [self.pageController stopGroup:[entity.value intValue]];
                return NO;
            }
        }
        else
        {
            NSLog(@"Contain is Null");
        }
    }
    return NO;
}

-(void) nextPage
{
    if (self.flipController != nil)
    {
        [self.flipController nextPage];
    }
}

-(void) prePage
{
    if (self.flipController != nil)
    {
        [self.flipController prePage];
    }
}

- (void)dealloc
{
    [super dealloc];
}
@end
























