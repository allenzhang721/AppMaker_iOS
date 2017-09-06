//
//  CameraComponent.m
//  Core
//
//  Created by Mouee-iMac on 12-10-10.
//
//

#import "CameraComponent.h"
#import "HLFileUtility.h"
#import <AssertMacros.h>

@implementation CameraComponent

@synthesize cameraEntity;

static NSString *currentBookType = @"";
//static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.cameraEntity = (CameraEntity*)entity;
        self.uicomponent = [[UIView alloc] init];
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
    
}

-(void) play
{
    cameraView = [[UIView alloc] init] ;
    UIImage *camImg  = [UIImage imageNamed:@"camera.png"] ;
    UIImage *camdImg = [UIImage imageNamed:@"camerad.png"] ;
    UIImage *camsImg = [UIImage imageNamed:@"cameraswitch.png"] ;
    UIImage *camsdImg = [UIImage imageNamed:@"cameraswitchd.png"] ;
    UIImage *camss   = [UIImage imageNamed:@"camerastop.png"];
    cameraSwitchBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    snapBtn         = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [snapBtn setImage:camImg forState:UIControlStateNormal];
    [snapBtn setImage:camdImg forState:UIControlStateHighlighted];
    [snapBtn setImage:camss forState:UIControlStateSelected];
    [cameraSwitchBtn setImage:camsImg forState:UIControlStateNormal];
    [cameraSwitchBtn setImage:camsdImg forState:UIControlStateHighlighted];
    cameraSwitchBtn.frame = CGRectMake(0, 0, 62, 62);
    snapBtn.frame         = CGRectMake([cameraEntity.width intValue]  / 2 - 62 /2,[cameraEntity.height intValue] - 62,62,62);
    [cameraSwitchBtn addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [snapBtn addTarget:self action:@selector(snap) forControlEvents:UIControlEventTouchUpInside];
    cameraView.frame = CGRectMake(0, 0, [cameraEntity.width intValue], [cameraEntity.height intValue]);
    
    [self.uicomponent addSubview:cameraView];
    [self.uicomponent addSubview:cameraSwitchBtn];
    [self.uicomponent addSubview:snapBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teardownAVCapture) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLayer) name:AVCaptureSessionDidStartRunningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    NSString *imgFile = [self.cameraEntity.rootPath stringByAppendingPathComponent:self.cameraEntity.entityid];
    if([HLFileUtility checkFileAtPaht:imgFile] == YES)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:imgFile];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults valueForKey:self.cameraEntity.entityid] != nil)
        {
            NSInteger or = [userDefaults integerForKey:self.cameraEntity.entityid];
            UIImage * flippedImage = [UIImage imageWithCGImage:img.CGImage scale:photoView.image.scale orientation:or] ;
            photoView = [[UIImageView alloc] initWithImage:flippedImage];
        }
        else
        {
            photoView = [[UIImageView alloc] initWithImage:img];
        }
        photoView.frame = CGRectMake(0, 0, [cameraEntity.width intValue], [cameraEntity.height intValue]);
        [self.uicomponent addSubview:photoView];
        snapBtn.selected = YES;
    }
    [self.uicomponent bringSubviewToFront:snapBtn];
    [self.uicomponent bringSubviewToFront:cameraSwitchBtn];
    
    NSError *error = nil;
    session = [AVCaptureSession new];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
//    require( error == nil, bail );
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [session setSessionPreset:AVCaptureSessionPresetMedium];
    }
    else
    {
        [session setSessionPreset:AVCaptureSessionPresetMedium];
    }
    if ( [session canAddInput:deviceInput] )
    {
        [session addInput:deviceInput];
    }
    stillImageOutput = [AVCaptureStillImageOutput new];
    if ( [session canAddOutput:stillImageOutput] )
    {
        [session addOutput:stillImageOutput];
    }
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [previewLayer setVideoGravity:AVLayerVideoGravityResize];
    CALayer *rootLayer = [cameraView layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:previewLayer];
    [session startRunning];
    isUsingFrontFacingCamera = NO;
    [self setLayer];
    [self performSelector:@selector(setLayer) withObject:nil afterDelay:0.5];
bail:
    [session release];
    if (error)
    {
        session = nil;
        [self teardownAVCapture];
    }
}

+(void) setBookType:(NSString *)type
{
    currentBookType = type;
}

-(void) snap
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: nil message:NSLocalizedString(@"Camera not avilable!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:NSLocalizedString(@"Cancel",nil) , nil];
        [alert show];
        return;
    }
    if (snapBtn.selected == YES)
    {
        [photoView removeFromSuperview];
        snapBtn.selected = NO;
        [self setLayer];
        return;
    }
    AVCaptureConnection *stillImageConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    AVCaptureVideoOrientation avcaptureOrientation = previewLayer.orientation;
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey]];
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         if (error)
         {
             
         }
         else
         {
             NSData *jpegData =  [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer] ;
             UIImage *localImage = [UIImage imageWithData:jpegData] ;
             if (photoView == nil)
             {
                 photoView = [[UIImageView alloc] initWithImage:localImage];
             }
             else
             {
                 photoView.image = localImage;
             }
             photoView.frame = CGRectMake(0, 0, self.uicomponent.frame.size.width, self.uicomponent.frame.size.height);
             if (isUsingFrontFacingCamera == YES)
             {
                 
                 if (previewLayer.orientation == AVCaptureVideoOrientationLandscapeRight)
                 {
                     UIImage * flippedImage = [UIImage imageWithCGImage:photoView.image.CGImage scale:photoView.image.scale orientation:UIImageOrientationDownMirrored] ;
                     photoView.image = flippedImage;
                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                     [userDefaults setInteger:UIImageOrientationDownMirrored forKey:self.cameraEntity.entityid];
                     
                 }
                 if (previewLayer.orientation  == AVCaptureVideoOrientationLandscapeLeft)
                 {
                     UIImage * flippedImage = [UIImage imageWithCGImage:photoView.image.CGImage scale:photoView.image.scale orientation:UIImageOrientationUpMirrored];
                     photoView.image = flippedImage;
                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                     [userDefaults setInteger:UIImageOrientationUpMirrored forKey:self.cameraEntity.entityid];
                 }
                 if (previewLayer.orientation  == AVCaptureVideoOrientationPortraitUpsideDown)
                 {
                     
                     UIImage * flippedImage = [UIImage imageWithCGImage:photoView.image.CGImage scale:photoView.image.scale orientation:UIImageOrientationRightMirrored];
                     photoView.image = flippedImage;
                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                     [userDefaults setInteger:UIImageOrientationRightMirrored forKey:self.cameraEntity.entityid];
                 }
                 if (previewLayer.orientation  == AVCaptureVideoOrientationPortrait)
                 {
                     UIImage * flippedImage = [UIImage imageWithCGImage:photoView.image.CGImage scale:photoView.image.scale orientation:UIImageOrientationLeftMirrored];
                     photoView.image = flippedImage;
                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                     [userDefaults setInteger:UIImageOrientationLeftMirrored forKey:self.cameraEntity.entityid];
                 }
             }
             else
             {
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                 [userDefaults removeObjectForKey:self.cameraEntity.entityid];
             }
             [self.uicomponent addSubview:photoView];
             NSString *imgFile = [self.cameraEntity.rootPath stringByAppendingPathComponent:self.cameraEntity.entityid];
             [jpegData writeToFile:imgFile atomically:YES];
             [self.uicomponent bringSubviewToFront:snapBtn];
             [self.uicomponent bringSubviewToFront:cameraSwitchBtn];
             snapBtn.selected = YES;
             UIImageWriteToSavedPhotosAlbum(photoView.image, nil, nil, nil);
         }
     }
     ];
}

-(void) switchCamera
{
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera)
        desiredPosition = AVCaptureDevicePositionBack;
    else
        desiredPosition = AVCaptureDevicePositionFront;
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
    {
        if ([d position] == desiredPosition)
        {
            [[previewLayer session] beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in [[previewLayer session] inputs])
            {
                [[previewLayer session] removeInput:oldInput];
            }
            [[previewLayer session] addInput:input];
            [[previewLayer session] commitConfiguration];
            break;
        }
    }
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}


-(void) setLayer
{
    UIInterfaceOrientation   orientation =  [[UIApplication  sharedApplication] statusBarOrientation];
    if (orientation ==  UIInterfaceOrientationLandscapeLeft)
    {
        previewLayer.orientation = AVCaptureVideoOrientationLandscapeLeft;
        return;
    }
    else if (orientation ==  UIInterfaceOrientationLandscapeRight)
    {
        previewLayer.orientation = AVCaptureVideoOrientationLandscapeRight;
        return;
    }
    if (orientation == UIInterfaceOrientationPortrait)
    {
        previewLayer.orientation = AVCaptureVideoOrientationPortrait;
        return;
    }
    if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        previewLayer.orientation = AVCaptureVideoOrientationPortraitUpsideDown;
        return;
    }
    return;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [cameraView removeFromSuperview];
    [cameraSwitchBtn removeFromSuperview];
    [snapBtn removeFromSuperview];
    
    [session stopRunning];
    [stillImageOutput release];
    [previewLayer removeFromSuperlayer];
    [previewLayer release];
    [snapBtn removeTarget:self action:@selector(snap) forControlEvents:UIControlEventTouchUpInside];
    [cameraSwitchBtn removeTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [photoView release];
    [cameraSwitchBtn release];
    [snapBtn release];
    [cameraView release];
    self.uicomponent = nil;
    [super dealloc];
}

- (void) didRotate:(NSNotification *)notification
{
    [self setLayer];
    
}

-(void) teardownAVCapture
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(play) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [cameraView removeFromSuperview];
    [cameraSwitchBtn removeFromSuperview];
    [snapBtn removeFromSuperview];
    
    [snapBtn removeTarget:self action:@selector(snap) forControlEvents:UIControlEventTouchUpInside];
    [cameraSwitchBtn removeTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    
    [cameraSwitchBtn release];
    cameraSwitchBtn = nil;
    [snapBtn release];
    snapBtn = nil;
    [cameraView release];
    cameraView = nil;
    [photoView removeFromSuperview];
    [photoView release];
    photoView = nil;
    if ([session isRunning])
    {
        [session stopRunning];
    }
    [stillImageOutput release];
    stillImageOutput = nil;
    [previewLayer removeFromSuperlayer];
    [previewLayer release];
    previewLayer = nil;
}
@end

