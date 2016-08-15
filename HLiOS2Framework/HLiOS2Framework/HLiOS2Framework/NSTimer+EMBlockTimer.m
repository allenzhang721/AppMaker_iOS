//
//  NSTimer+EMBlockTimer.m
//  EMTimer
//
//  Created by 星宇陈 on 14/7/23.
//  Copyright (c) 2014年 Emiaostein. All rights reserved.
//

#import "NSTimer+EMBlockTimer.h"

@implementation NSTimer (EMBlockTimer)

+ (instancetype)EM_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats {
    
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(EM_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)EM_blockInvoke:(NSTimer *)timer {
    
    void (^block)() = timer.userInfo;
    
    if (block) {
        
        block();
    }
}

@end
