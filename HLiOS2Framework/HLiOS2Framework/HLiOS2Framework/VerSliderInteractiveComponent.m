//
//  VerSliderInteractiveComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-12.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "VerSliderInteractiveComponent.h"
#import "HLContainer.h"

@implementation VerSliderInteractiveComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.entity = (VerSliderInteractiveEntity *)entity;
        
        if (self.entity.itemArray.count == 0) {
            return self;
        }
        
        curScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        curScrollView.showsHorizontalScrollIndicator = NO;
        curScrollView.showsVerticalScrollIndicator = NO;
        curScrollView.delegate = self;
        
        NSString *path = [entity.rootPath stringByAppendingPathComponent :entity.dataid];
        float top = 0;
        for (int i = 0; i < self.entity.itemArray.count; i++)
        {
            NSString *imgName = [self.entity.itemArray objectAtIndex:i];
            NSString *imagePath = [path stringByAppendingPathComponent:imgName];
            UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
            float width = [self.entity.width intValue];
            float height = width / img.size.width * img.size.height;

            
            UIImageView *imgView = [[[UIImageView alloc] init] autorelease];
            imgView.frame = CGRectMake(0, top, width, height);
            [imgView setImage:img];
            [curScrollView addSubview:imgView];
            
            top += height;
        }
        
        curScrollView.frame = CGRectMake([self.entity.x floatValue], [self.entity.y floatValue], [self.entity.width intValue], [self.entity.height intValue]);
        curScrollView.contentSize = CGSizeMake(curScrollView.frame.size.width, top);
        
        [curScrollView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];
        
        self.uicomponent = curScrollView;
        lastOffset = -1;
    }
    return self;
}

//- (void)tapGesture
//{
//    [self.container runBehavior:@"BEHAVIOR_ON_CLICK"];
//    [self.container runBehavior:@"BEHAVIOR_ON_MOUSE_UP"];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int offset = scrollView.contentOffset.y;
    if (offset < 0)
    {
        offset = 0;
    }
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        NSString *behaviorStr = [NSString stringWithString:behavior.eventName];
        if ([behaviorStr isEqualToString:@"BEHAVIOR_ON_TEMPLATE_SLIDER_IN"] || [behaviorStr isEqualToString:@"BEHAVIOR_ON_TEMPLATE_SLIDER_OUT"])
        {
            NSString *valueStr = behavior.behaviorValue;
            NSArray *valueArr = [valueStr componentsSeparatedByString:@","];
            if (valueArr.count == 2)
            {
                int minValue = [[valueArr objectAtIndex:0] intValue];
                int maxValue = [[valueArr objectAtIndex:1] intValue];
                
                if ((lastOffset <= minValue || lastOffset >= maxValue) && (offset >= minValue && offset <= maxValue) &&
                    [behaviorStr isEqualToString:@"BEHAVIOR_ON_TEMPLATE_SLIDER_IN"])
                {
                    if ([self.container runBehaviorWithEntity:behavior])
                    {
                        return;
                    }
                }
                if ((offset <= minValue || offset >= maxValue) && (lastOffset >= minValue && lastOffset <= maxValue) &&
                    [behaviorStr isEqualToString:@"BEHAVIOR_ON_TEMPLATE_SLIDER_OUT"])
                {
                    if ([self.container runBehaviorWithEntity:behavior])
                    {
                        return;
                    }
                }
            }
        }
    }
    lastOffset = offset;
}

//- (void)setItemSelected:(int)index
//{
//    for (UIButton *btn in scrollView.subviews)
//    {
//        if([btn isKindOfClass:[UIButton class]])
//        {
//            btn.selected = NO;
//            if (btn.tag == index)
//            {
//                btn.selected = YES;
//            }
//        }
//    }
//    
//    float top = 0;
//    if (index > 0)
//    {
//        for (int i = 0; i < index; i++)
//        {
//            float height = [[[self.entity.itemArray objectAtIndex:i] objectForKey:@"ItemHeight"] floatValue];
//            top += height;
//        }
//    }
//    [scrollView setContentOffset:CGPointMake(0, top) animated:YES];
//}
//
//- (void)btnClicked:(UIButton *)sender
//{
//    [self setItemSelected:sender.tag];
//    
//    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
//    {
//        BehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
//        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CLICK"] == YES)
//        {
//            if (sender.tag == [behavior.behaviorValue intValue])
//            {
//                if ([self.container runBehaviorWithEntity:behavior])
//                {
//                    return;
//                }
//            }
//        }
//    }
//}
//
//-(void) change:(int)index
//{
//    [self setItemSelected:index];
//    
//    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
//    {
//        BehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
//        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CHANGE_COMPLETE"] == YES)
//        {
//            if (index == [behavior.behaviorValue intValue])
//            {
//                if ([self.container runBehaviorWithEntity:behavior])
//                {
//                    return;
//                }
//            }
//        }
//    }
//}

- (void)dealloc
{
    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
    [self.uicomponent release];
    [self.entity release];
    [super dealloc];
}

@end
