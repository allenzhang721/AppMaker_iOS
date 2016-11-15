//
//  ContainerCreator.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLContainerCreator.h"
#import "HLTextInputEntity.h"
#import "AudioEntity.h"
#import "VideoEntity.h"
#import "GifEntity.h"
#import "WebEntity.h"
#import "PDFEntity.h"
#import "RollingTextEntity.h"
#import "iAdEntity.h"
#import "ImageSliderEntity.h"
#import "SphereViewEntity.h"
#import "CarouselEntity.h"
#import "PaintEntity.h"
#import "PuzzlePiecesEntity.h"
#import "PanoramaEntity.h"
#import "GridViewEntity.h"
#import "DrawerEntity.h"
#import "SlideCellEntity.h"
#import "CameraEntity.h"
#import "ImageEntity.h"
#import "ScrollImageEntity.h"
#import "QuizEntity.h"
//#import "SWFPlayerEntity.h"
#import "CounterEntity.h"
#import "TimerEntity.h"
#import "HTML5Entity.h"
#import "ConnectLineEntity.h"
#import "FontSizeSliderEntity.h"
#import "SliceEntity.h"
#import "CaseEntity.h"
#import "VerSliderSelectEntity.h"
#import "ScrollCatalogEntity.h"
#import "HorConnectLineEntity.h"
#import "VerSliderInteractiveEntity.h"
#import "ButtonContainerEntity.h"
#import "PhotosResizeEntity.h"
#import "AutoScrollableEntity.h"
#import "LanternSlideEntity.h"
#import "HLYoutubeEntity.h"
#import "HLMapEntity.h"
#import "HLTableEntity.h"
@implementation HLContainerCreator
    
+ (HLContainerEntity *)createEntity:(NSString *)type moduleid:(NSString *)moduleid
    {
      
        // Feature - com.hl.flex.components.objects.hltableView::HLTableViewComponent - Emiaostein, 27 Sep 2016
        if ([type compare:@"HLTableViewComponent"]== NSOrderedSame)
        {
          return [[HLTableEntity alloc] init];
        }
      
        // Feature - Mapcom.hl.flex.components.objects.hlmap::HLGoogleMapComponent - Emiaostein, 27 Sep 2016
        if ([type compare:@"HLGoogleMapComponent"]== NSOrderedSame)
        {
            return [[HLMapEntity alloc] init];
        }
        
        // Feature - youtube - Emiaostein, 26 Sep 2016
        if ([type compare:@"HLYouTubeVideoComponent"]== NSOrderedSame)
        {
            return [[HLYoutubeEntity alloc] init];
        }
        
        // Feature - TextInputComponent - Emiaostein, 21 Sep 2016
        if ([type compare:@"TextInputComponent"]== NSOrderedSame)
        {
            return [[HLTextInputEntity alloc] init];
        }
        
        if ([type compare:@"PlayCase"]== NSOrderedSame)
        {
            return [[CaseEntity alloc] init];
        }
        if ([type compare:@"UIButtonComponent"]== NSOrderedSame)
        {
            return [[ButtonContainerEntity alloc] init];
        }
        if ([type compare:@"AUDIO"]== NSOrderedSame)
        {
            return [[AudioEntity alloc] init];
        }
        if ([type compare:@"VIDEO"]== NSOrderedSame)
        {
            return[[VideoEntity alloc] init];
        }
        if ([type compare:@"GIF"] == NSOrderedSame)
        {
            return [[GifEntity alloc] init];
        }
        if ([type compare:@"Web"] == NSOrderedSame)
        {
            return [[WebEntity alloc] init];
        }
        if ([type compare:@"Pdf"] == NSOrderedSame)
        {
            return [[PDFEntity alloc] init];
        }
        if ([type isEqualToString:@"RollingText"])
        {
            return [[RollingTextEntity alloc] init];
        }
        if ([type isEqualToString:@"iAd"])
        {
            return nil;
//            return [[iAdEntity alloc] init];
        }
//        if ([type isEqualToString:@"SWF"])
//        {
//            return [[SWFPlayerEntity alloc] init];
//        }
        if ([type isEqualToString:@"Counter"])
        {
            return [[CounterEntity alloc] init];
        }
        if ([type isEqualToString:@"Timer"])
        {
            return [[TimerEntity alloc] init];
        }
        if ([type isEqualToString:@"HTML5"])
        {
            return [[HTML5Entity alloc] init];
        }
        if ([type isEqualToString:@"TextFontChangeSlider"])
        {
            return [[FontSizeSliderEntity alloc] init];
        }
        if ([type isEqualToString:@"LanternSlide"])
        {
            return [[LanternSlideEntity alloc] init];
        }
        if ([type compare:@"Component"] == NSOrderedSame)
        {
            if ([moduleid compare:@"moduleuicomponent.photo.multipleleaf::HLMaskSliderImageUIComponent"] == NSOrderedSame)
            {
                return [[PhotosResizeEntity alloc] init];
            }
            if ([moduleid compare:@"moduleuicomponent.mousescroll::HLMouseVerInteractScrollUIComponent"] == NSOrderedSame)
            {
                return [[VerSliderInteractiveEntity alloc] init];
            }
            if ([moduleid compare:@"moduleuicomponent.connectline::HLConnectHorLineUIComponent"] == NSOrderedSame)
            {
                return [[HorConnectLineEntity alloc] init];
            }
            if ([moduleid compare:@"moduleuicomponent.mousescroll::HLMouseCatalogVScrollUIComponent"] == NSOrderedSame)
            {
                return [[ScrollCatalogEntity alloc] init];
            }
            if ([moduleid compare:@"moduleuicomponent.photo.multipleleaf::HLVerSlideImageSelectUIComponent"] == NSOrderedSame)
            {
                return [[VerSliderSelectEntity alloc] init];
            }
            if ([moduleid compare:@"moduleuicomponent.connectline::HLConnectLineUIComponent"] == NSOrderedSame)
            {
                return [[ConnectLineEntity alloc] init];
            }
            if ([moduleid compare:@"moduleuicomponent.sliderhand::HLSliderSliceComponent"] == NSOrderedSame)
            {
                return [[SliceEntity alloc] init];
            }
            if ([moduleid compare:@"moduleuicomponent.photo.multipleleaf::HLHorSliderImageUIComponent"] == NSOrderedSame)
            {
                return [[ImageSliderEntity alloc] init];
            }
            if ([moduleid compare:@"moduleuicomponent.photo.multipleleaf::HLVerSliderImageUIComponent"] == NSOrderedSame)
            {
                ImageSliderEntity *entity = [[ImageSliderEntity alloc] init];
                entity.isVertical = YES;
                return entity;
            }
            if ([moduleid isEqualToString:@"moduleuicomponent.photo.multipleleaf::HLHorSliderImageFromInternetUIComponent"])
            {
                ImageSliderEntity *entity = [[ImageSliderEntity alloc] init];
                entity.fromUrl = YES;
                return entity;
            }
            if ([moduleid compare:@"moduleuicomponent.module.taobao::HL360RotatingImageUIComponent"] == NSOrderedSame)
            {
                return [[SphereViewEntity alloc] init];
            }
            if ([moduleid compare:@"moduleuicomponent.module.realEstate::HLHorImageSequenceFrameUIComponent"] == NSOrderedSame)
            {
                SphereViewEntity *entity = [[SphereViewEntity alloc] init];
                entity.isLoop = NO;
                return entity;
            }
            if ([moduleid compare:@"moduleuicomponent.module.realEstate::HLVerImageSequenceFrameUIComponent"] == NSOrderedSame)
            {
                SphereViewEntity *entity = [[SphereViewEntity alloc] init];
                entity.isLoop = NO;
                entity.isVertical = YES;
                return entity;
            }
            if (([moduleid compare:@"moduleuicomponent.module.magazine::HLCarouselImageUIComponent"] == NSOrderedSame))
            {
                CarouselEntity *entity = [[CarouselEntity alloc] init];
                entity.type = moduleid;
                return entity;
            }
            if (([moduleid compare:@"moduleuicomponent.module.magazine::HLHorSlideshowImageUIComponent"] == NSOrderedSame))
            {
                AutoScrollableEntity *entity = [[AutoScrollableEntity alloc] init];
                entity.isVertical = NO;
                return entity;
            }
            if (([moduleid isEqualToString:@"moduleuicomponent.module.magazine::HLVerSlideshowImageUIComponent"]))
            {
                AutoScrollableEntity *entity = [[AutoScrollableEntity alloc] init];
                entity.isVertical = YES;
                return entity;
            }
            if ([moduleid compare:@"moduleuicomponent.photo.signleaf.paint::HLPaintingUIComponent"] == NSOrderedSame)
            {
                return [[PaintEntity alloc] init];
            }
            if ([moduleid compare:@"moduleuicomponent.multiMedia.game.puzzleGame::HLPuzzleGameUIComponent"] == NSOrderedSame)
            {
                return [[PuzzlePiecesEntity alloc] init];
            }
            if ([moduleid isEqualToString:@"moduleuicomponent.photo.signleaf.panoroma::HLPanoromaUIComponent"])
            {
                return [[PanoramaEntity alloc] init];
            }
            if ([moduleid isEqualToString:@"moduleuicomponent.bookshelf::HLBookShelfUIComponent"])
            {
                return [[GridViewEntity alloc] init];
            }
            if ([moduleid isEqualToString:@"moduleuicomponent.drawer::HLVerBottomUIComponent"] ||
                [moduleid isEqualToString:@"moduleuicomponent.drawer::HLHorRightUIComponent"])
            {
                return [[DrawerEntity alloc] init];
            }
            if ([moduleid isEqualToString:@"moduleuicomponent.mousescroll::HLMouseHorScrollUIComponent"])
            {
                SlideCellEntity *entity = [[SlideCellEntity alloc] init];
                entity.isVirtical = NO;
                return entity;
            }
            if ([moduleid isEqualToString:@"moduleuicomponent.mousescroll::HLMouseVerScrollUIComponent"])
            {
                SlideCellEntity *entity = [[SlideCellEntity alloc] init];
                entity.isVirtical = YES;
                return entity;
            }
            if([moduleid isEqualToString:@"moduleuicomponent.camera::HLCameraUIComponent"])
            {
                return [[CameraEntity alloc] init];
            }
            if ([moduleid isEqualToString:@"moduleuicomponent.mousescroll::HLMouseVerScrollNoSelectedComponent"])
            {
                return [[ScrollImageEntity alloc] init];
            }
            if ([moduleid isEqualToString:@"moduleuicomponent.exam::HLExamUIComponent"])
            {
                return [[QuizEntity alloc] init];
            }
            
            
        }
        return [[ImageEntity alloc] init];
    }
    
    @end
