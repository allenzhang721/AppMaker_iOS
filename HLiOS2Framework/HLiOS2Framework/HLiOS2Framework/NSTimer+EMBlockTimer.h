//
//  NSTimer+EMBlockTimer.h
//  EMTimer
//
//  Created by 星宇陈 on 14/7/23.
//  Copyright (c) 2014年 Emiaostein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (EMBlockTimer)

+ (instancetype)EM_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;

@end
