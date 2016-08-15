//
//  CounterComponent.m
//  MoueeiOS2Framework
//
//  Created by Pi Yi on 4/23/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "CounterComponent.h"
#import "CounterEntity.h"
#import "HLBehaviorEntity.h"
#import "HLContainer.h"
#import "HLPageController.h"

@implementation CounterComponent
@synthesize display;
@synthesize isGlobal;
@synthesize selfValue;
static int totalCount = -1;

- (id)initWithEntity:(HLContainerEntity *) entity
{
    CounterEntity * ce = (CounterEntity*)entity;
    self = [super init];
    if (self)
    {
        self.display = [[[UILabel alloc] init] autorelease];
        display.textAlignment = NSTextAlignmentLeft;
        [self.display setFont:[UIFont systemFontOfSize:ce.fontSize]];
        self.display.textColor  = [self colorWithHexString:ce.fontColor];
        self.display.backgroundColor = [UIColor clearColor];
        self.isGlobal = ce.isGlobal;
        if (self.isGlobal == YES)
        {
            if (totalCount == -1)
            {
                totalCount = ce.minValue;
            }
            [self.display setText:[NSString stringWithFormat:@"%d",totalCount]];
            
        }
        else
        {
            self.selfValue = ce.minValue;
            [self.display setText:[NSString stringWithFormat:@"%d",ce.minValue]];
            
        }
        self.uicomponent = self.display;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
        [self performSelector:@selector(delayToFit) withObject:nil afterDelay:.1];
    }
    return self;
}

- (void)delayToFit
{
    [self.display sizeToFit];
}

-(void) checkBehavior
{
    if (self.isGlobal) {
        NSLog(@"self.isGlobalCOunt = %@",self);
    }
    
    for (int i = 0 ; i < [self.container.entity.behaviors count];i++)
    {
        HLBehaviorEntity* be = [self.container.entity.behaviors objectAtIndex:i];
//        NSLog(@"BehaviorEntity = %@", be);
        int beValue = [be.behaviorValue intValue];
        if ([be.eventName isEqualToString:@"BEHAVIOR_ON_COUNTER_NUMBER"] )
        {
//             NSLog(@"BEHAVIOR_ON_COUNTER_NUMBER");
            if (self.isGlobal == YES)
            {
//                NSLog(@"self.isGlobal == YES");
                if (beValue == totalCount)
                {
                    
//                    NSLog(@"beValue == totalCount");
                    if ([self.container runBehaviorWithEntity:be]) {
                        
                        return;
                    }
                }
            }
            else
            {
                if (beValue == self.selfValue)
                {
                    
//                    NSLog(@"beValue == self.selfValue");
                    if ([self.container runBehaviorWithEntity:be]) {
                        return;
                    }
                }
            }
        }
    }
}

-(void) reset
{
    CounterEntity *ce = (CounterEntity *)self.container.entity;
    if (self.isGlobal == YES)
    {
        totalCount = ce.minValue;
        [self.display setText:[NSString stringWithFormat:@"%d",totalCount]];
    }
    else
    {
        self.selfValue = ce.minValue;
        [self.display setText:[NSString stringWithFormat:@"%d",ce.minValue]];
    }
    [self.display sizeToFit];
}

-(void) addCount:(int) value
{
    
    if (self.isGlobal == YES)
    {
        NSLog(@"beforeCount = %d",totalCount);
        totalCount += value;
        NSLog(@"AfterCount = %d",totalCount);
        if (totalCount > ((CounterEntity*)self.container.entity).maxValue)
        {
            totalCount = ((CounterEntity*)self.container.entity).maxValue;
        }
        
        NSLog(@"final = %d",totalCount);
        [self.display setText:[NSString stringWithFormat:@"%d",totalCount]];
        
    }
    else
    {
        self.selfValue += value;
        if (self.selfValue > ((CounterEntity*)self.container.entity).maxValue)
        {
            self.selfValue = ((CounterEntity*)self.container.entity).maxValue;
        }
        [self.display setText:[NSString stringWithFormat:@"%d",self.selfValue]];
    }
    [self.display sizeToFit];
    [self checkBehavior];
}

-(void) delCount:(int) value
{
   
    if (self.isGlobal == YES)
    {
        totalCount -= value;
        if (totalCount < ((CounterEntity*)self.container.entity).minValue)
        {
            totalCount = ((CounterEntity*)self.container.entity).minValue;
        }
        [self.display setText:[NSString stringWithFormat:@"%d",totalCount]];
        
    }
    else
    {
        self.selfValue -= value;
        if (self.selfValue < ((CounterEntity*)self.container.entity).minValue)
        {
            self.selfValue = ((CounterEntity*)self.container.entity).minValue;
        }
        [self.display setText:[NSString stringWithFormat:@"%d",self.selfValue]];
        
    }
    [self.display sizeToFit];
    [self checkBehavior];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor grayColor];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(void) resetGlobal
{
    totalCount = -1;
}

- (void)dealloc
{
    [self.display release];
    [self.uicomponent release];
    [super dealloc];
}
@end
