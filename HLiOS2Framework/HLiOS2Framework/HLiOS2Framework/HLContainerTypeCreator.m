//
//  ContainerTypeCreator.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLContainerTypeCreator.h"

@implementation HLContainerTypeCreator
+(NSString *) getContainerType:(NSString *) className
    {
        // Feature - TextInputComponent - Emiaostein, 21 Sep 2016
        if ([className compare:@"com.hl.flex.components.objects.hlTextInput::HLTextInputComponent"] == NSOrderedSame)
        {
            return @"TextInputComponent";
        }
        
        if ([className compare:@"com.hl.flex.components.objects.hlButton::HLLocalButtonComponent"] == NSOrderedSame)
        {
            return @"UIButtonComponent";
        }
        if ([className compare:@"com.hl.flex.components.objects.effect::HLSliderEffectComponent"] == NSOrderedSame)
        {
            return @"LanternSlide";
        }
        if ([className compare:@"com.hl.flex.components.objects.textslider::HLTextSliderComponent"] == NSOrderedSame)
        {
            return @"TextFontChangeSlider";
        }
        if ([className compare:@"com.hl.flex.components.objects.hlAudio::HLMp3Component"] == NSOrderedSame)
        {
            return @"AUDIO";
        }
        if ([className compare:@"com.hl.flex.components.objects.hlVideo::HLLocalVideoComponent"] == NSOrderedSame)
        {
            return @"VIDEO";
        }
        if ([className compare:@"com.hl.flex.components.objects.hlImage::HLGIFComponent"] == NSOrderedSame)
        {
            return @"GIF";
        }
        if ([className compare:@"com.hl.flex.components.objects.swf::HLSWFComponent"] == NSOrderedSame)
        {
            return @"GIF";
        }
        if ([className compare:@"com.hl.flex.components.objects.docs.painting::HLPaintingComponent"] == NSOrderedSame)
        {
            return @"PAINT";
        }
        if ([className compare:@"com.hl.flex.components.objects.html::HLHtmlComponent"] == NSOrderedSame)
        {
            return @"Web";
        }
        if ([className compare:@"com.hl.flex.components.objects.hlSwf::HLLocalPDFComponent"] == NSOrderedSame)
        {
            return @"Pdf";
        }
        if ([className compare:@"com.hl.flex.components.objects.hlText.hlEnglishRollingText::HLEnglishRollingTextComponent"] == NSOrderedSame)
        {
            return @"RollingText";
        }
        if ([className compare:@"com.hl.flex.components.objects.hlText.hlRollingText::HLRollingTextComponent"] == NSOrderedSame)
        {
            return @"RollingText";
        }
        if ([className compare:@"com.hl.flex.components.objects.template::HLTemplateComponent"] == NSOrderedSame)
        {
            return @"Component";
        }
        if ([className isEqualToString:@"com.hl.flex.components.objects.HLAdBannerView::HLAdBannerViewComponent"])
        {
            return @"iAd";
        }
        if ([className isEqualToString:@"com.hl.flex.components.objects.swf::HLSWFFileComponent"])
        {
            return @"SWF";
        }
        if ([className isEqualToString:@"com.hl.flex.components.objects.counter::HLCounterComponent"])
        {
            return @"Counter";
        }
        if ([className isEqualToString:@"com.hl.flex.components.objects.hltimer::HLTimerComponent"])
        {
            return @"Timer";
        }
        if ([className isEqualToString:@"com.hl.flex.components.objects.html::HLHtml5Component"])
        {
            return @"HTML5";
        }
        if ([className isEqualToString:@"com.hl.flex.components.objects.caseComponent::PlayCaseComponent"])
        {
            return @"PlayCase";
        }
        return @"IMAGE";
    }
    @end
