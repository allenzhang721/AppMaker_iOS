//
//  CameraComponent.h
//  Core
//
//  Created by Mouee-iMac on 12-10-10.
//
//

#import "Component.h"
#import "CameraEntity.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraComponent : Component
{
    UIView *cameraView;
    UIButton *cameraSwitchBtn;
    UIButton *snapBtn;
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureSession *session;
    UIImageView *photoView;
    BOOL isUsingFrontFacingCamera;
}

+(void) setBookType:(NSString *)type;

@property (nonatomic, assign) CameraEntity *cameraEntity;
@property (nonatomic,retain)  UIImage *localImage;
@end
