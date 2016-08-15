//
//  ComponentCreator.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-16.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "ComponentCreator.h"
#import "HLAudioComponent.h"
#import "VideoEntity.h"
#import "VideoComponent.h"
#import "GifEntity.h"
#import "GifComponent.h"
#import "ImageEntity.h"
#import "ImageComponent.h"
#import "RollingTextEntity.h"
#import "RollingTextComponent.h"
#import "WebEntity.h"
#import "WebComponent.h"
#import "PDFEntity.h"
#import "PDFComponent.h"
#import "ImageSliderEntity.h"
#import "ImageSliderComponent.h"
#import "SphereViewEntity.h"
#import "SphereViewComponent.h"
#import "CarouselEntity.h"
#import "CarouselComponent.h"
#import "PaintEntity.h"
#import "PaintComponent.h"
#import "PuzzlePiecesEntity.h"
#import "PuzzlePiecesComponent.h"
#import "PanoramaEntity.h"
#import "PanoramaComponent.h"
#import "DrawerEntity.h"
#import "DrawerComponent.h"
#import "SlideCellEntity.h"
#import "ImageEntity.h"
#import "ImageComponent.h"
#import "AudioEntity.h"
#import "ScrollImageComponent.h"
#import "QuizEntity.h"
#import "QuizComponent.h"
//#import "SWFPlayerEntity.h"
#import "SWFPlayerComponent.h"
#import "SlideCellComponent.h"
#import "CounterEntity.h"
#import "CounterComponent.h"
#import "TimerEntity.h"
#import "TimerComponent.h"
#import "CameraComponent.h"
#import "CameraEntity.h"
#import "Html5Component.h"
#import "HTML5Entity.h"
#import "iAdEntity.h"
#import "iAdComponent.h"
#import "ConnectLineEntity.h"
#import "ConnectLineComponent.h"
#import "FontSizeSliderComponent.h"
#import "FontSizeSliderEntity.h"
#import "SliceEntity.h"
#import "SliderSliceComponent.h"
#import "CaseEntity.h"
#import "PlayAudioCaseComponent.h"
#import "VerSliderSelectComponent.h"
#import "VerSliderSelectEntity.h"
#import "ScrollCatalogComponent.h"
#import "ScrollCatalogEntity.h"
#import "HorConnectLineComponent.h"
#import "HorConnectLineEntity.h"
#import "VerSliderInteractiveEntity.h"
#import "VerSliderInteractiveComponent.h"
#import "ButtonContainerEntity.h"
#import "ButtonComponet.h"
#import "PhotosResizeEntity.h"
#import "PhotosResizeComponent.h"
#import "AutoScrollableEntity.h"
#import "AutoScrollableComponent.h"
#import "LanternSlideComponent.h"
#import "LanternSlideEntity.h"

@implementation ComponentCreator


+(Component *) createComponent:(HLContainerEntity *) entity 
{
    Component *component;
    if ([entity isKindOfClass:[ImageEntity class]])
    {
        component = [[ImageComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[LanternSlideEntity class]])
    {
        component = [[LanternSlideComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[AutoScrollableEntity class]])
    {
        component = [[AutoScrollableComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[ButtonContainerEntity class]])
    {
        component = [[ButtonComponet alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[HorConnectLineEntity class]])
    {
        component = [[HorConnectLineComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[VerSliderInteractiveEntity class]])
    {
        component = [[VerSliderInteractiveComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[ScrollCatalogEntity class]])
    {
        component = [[ScrollCatalogComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[VerSliderSelectEntity class]])
    {
        component = [[VerSliderSelectComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[CaseEntity class]])
    {
        component = [[PlayAudioCaseComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[SliceEntity class]])
    {
        component = [[SliderSliceComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[FontSizeSliderEntity class]])
    {
        component = [[FontSizeSliderComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[ConnectLineEntity class]])
    {
        component = [[ConnectLineComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[AudioEntity class]])
    {   
        component = [[HLAudioComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[VideoEntity class]])
    {
        component = [[VideoComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[GifEntity class]])
    {
        component = [[GifComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[PhotosResizeEntity class]])
    {
        component = [[PhotosResizeComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[RollingTextEntity class]])
    {
        component = [[RollingTextComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[WebEntity class]])
    {
        component = [[WebComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[PDFEntity class]])
    {
        component = [[PDFComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[ImageSliderEntity class]])
    {
        component = [[ImageSliderComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[SphereViewEntity class]])
    {
        component = [[SphereViewComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[CarouselEntity class]])
    {
         component = [[CarouselComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[PaintEntity class]])
    {
        component = [[PaintComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[PuzzlePiecesEntity class]])
    {
        component = [[PuzzlePiecesComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[PanoramaEntity class]])
    {
        component = [[PanoramaComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[DrawerEntity class]])
    {
        component = [[DrawerComponent alloc] initWithEntity:entity];
        return component;
    }
//    if ([entity isKindOfClass:[SWFPlayerEntity class]])
//    {
//        component = [[SWFPlayerComponent alloc] initWithEntity:entity];
//        return component;
//    }
    if ([entity isKindOfClass:[SlideCellEntity class]])
    {
        component = [[SlideCellComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[ScrollImageEntity class]])
    {
        component = [[ScrollImageComponent alloc] initWithEntity:entity];
        return component;
        
    }
    if ([entity isKindOfClass:[ImageEntity class]])
    {
        component = [[ImageComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[QuizEntity class]])
    {
        component = [[QuizComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[CounterEntity  class]])
    {
        component = [[CounterComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[TimerEntity  class]])
    {
        component = [[TimerComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[CameraEntity class]])
    {
        entity.isPlayAudioOrVideoAtBegining = YES;
        component = [[CameraComponent alloc] initWithEntity:entity];
        return component;
    }
    if ([entity isKindOfClass:[HTML5Entity class]])
    {
        component = [[Html5Component alloc] initWithEntity:entity];
        return component;
    }
//    if ([entity isKindOfClass:[iAdEntity class]])
//    {
//        component = [[iAdComponent alloc] initWithEntity:entity];
//        return component;
//    }
    return nil;
}
@end

























