//
//  PageViewController.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLPageViewController.h"
#import "ComponentCreator.h"
#import "HLPageController.h"
#import "HLContainerDecoder.h"
#import "ClearView.h"   // 1.2,
#import "HLClearScrollView.h"
#import "HLIAPPurchseHandle.h"
#import "HLDefaultRecord.h"

#define kBounceSapce 10
#define kSpeed 4.0

#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 1136.0), [[UIScreen mainScreen] currentMode].size)|| CGSizeEqualToSize(CGSizeMake(1136.0, 640.0), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhoneHeight (isIPhone5 ? 568.0 : 480.0)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface HLPageViewController ()
{
    BOOL isInit;
    NSTimer *timer;
    int     direction;
    float   lastY;
    float   ay;
    float   velocity;
    
    BOOL    isBounce;
    BOOL    isFirst;
    BOOL    isSecAdd;
    BOOL    isSecSubtract;
    BOOL    isThirdAdd;
    BOOL    isThirdSubtract;
    BOOL    isClear;        //1.2  穿透视图
}

@property (nonatomic, retain) UIButton *PurseButton;

@end

@implementation HLPageViewController

@synthesize pageEntity;
@synthesize pageController;
@synthesize rightSwipe;
@synthesize leftSwip;
@synthesize curContainerArr;

#pragma mark -
#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        curContainerArr = [[NSMutableArray alloc] init];
        isClear = NO;
    }
    return self;
}

//      >>>>>   2014.1.2 是否为穿透视图
- (id)initWithClear:(BOOL)clear
{
    if ([super init])
    {
        isClear = clear;
    }
    return self;
}

- (void)loadView
{
    if (isClear == YES)
    {
        self.view = [[ClearView alloc] init];
    }
    else
    {
        self.view = [[UIView alloc] init];
    }
    
    self.view.autoresizingMask = 63;
}
//      <<<<<
-(void) loadPageEntity:(HLPageEntity *) entity
{
//    NSLog(@"%@",@"LoadPageEntity");
    CGRect rect        = [self.pageController.behaviorController.flipController getPageRect];
    CGFloat pageWidth  = [entity.width floatValue];
    CGFloat pageHeight = [entity.height floatValue];
    CGFloat insetX     = (CGRectGetWidth(rect) - pageWidth)/2;
    CGFloat insetY     = (CGRectGetHeight(rect) - pageHeight)/2;
    CGRect pageRect    = CGRectMake(insetX, insetY, pageWidth, pageHeight);

    self.pageEntity                  = entity;
    self.curScrollView.frame         = pageRect;
    self.curScrollView.contentSize   = CGSizeMake(entity.contentWidth, entity.contentHeight);
    
    //      >>>>>        //Mr.chen, reason, 14.04.02, Record PageOffset
    if (entity.entityid) {
        
        NSArray *contentOffsetArray = [[HLDefaultRecord shareRecord] objectForKey:entity.entityid];
        
        if (contentOffsetArray) {
            
            self.curScrollView.contentOffset = CGPointMake([contentOffsetArray[0] floatValue], [contentOffsetArray[1] floatValue]);
            
        } else {
            
            self.curScrollView.contentOffset = CGPointMake(0, 0);
        }
        
    } else {
        
        self.curScrollView.contentOffset = CGPointMake(0, 0);
    }
    //      <<<<<

    if (self.PurchseView) {
        
        if (self.pageEntity.state == pageEntityStateNormal) {
            
            self.PurchseView.frame           = pageRect;
            self.PurseButton.frame = CGRectMake(pageWidth/2.0 - 270/2.0, pageHeight / 2.0 - 60, 270, 124);
            
            [self showPurchse];
        } else {
            
            [self.PurchseView removeFromSuperview];
        }
        
        
    }
    

    isInit                           = NO;

    [curContainerArr removeAllObjects];
    [UIAccelerometer sharedAccelerometer].delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isClear == YES)
    {
        self.curScrollView = [[HLClearScrollView alloc] init];        //1.2
    }
    else
    {
        self.curScrollView = [[UIScrollView alloc] init];
    }
    
    self.curScrollView.delegate = self;
    lastY                       = 0;
    isFirst                     = YES;
    velocity                    = kSpeed;
    [self.view addSubview:self.curScrollView];
    
    
    
        self.PurchseView = [[UIView alloc] init];
        self.PurchseView.backgroundColor = [UIColor lightGrayColor];
        self.PurchseView.alpha = 0.95;
        [self.view addSubview:self.PurchseView];
        
        self.PurseButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.PurseButton setTitle:@"购买" forState:UIControlStateNormal];
    [self.PurseButton setImage:[UIImage imageNamed:@"Purchase_Book@2x1"] forState:UIControlStateNormal];
        [self.PurseButton setTitleColor:[UIColor colorWithRed:0.482 green:0.675 blue:0.859 alpha:1] forState:UIControlStateNormal];
        self.PurseButton.backgroundColor = [UIColor clearColor];
    [self.PurseButton addTarget:self action:@selector(purchseActionWithAlertView:) forControlEvents:UIControlEventTouchUpInside];
        [self.PurchseView addSubview:self.PurseButton];
    
    
    
//    if (self.pageEntity.isNeedPay == YES) {

//

//        if (paid == NO) {

//            NSLog(@"No Paid");
//
//         UIView *payView = [[UIView alloc] initWithFrame:self.view.bounds];
//            payView.backgroundColor = [UIColor lightGrayColor];
//            payView.alpha = 0.9;
//            [self.view addSubview:payView];         //Mr.chen, reason, 14.03.30
//        } else {
//
//
//        }
//
//    } else {
//        
//        
//         NSLog(@"Has Paid");
//    }
}

- (void)purchseBook
{
//Mr.chen, Modify Purchse , 14.03.30

                NSString *attion = nil;
                NSString *PurchseOrNot = nil;
                NSString *cancel = nil;
                NSString *purchse = nil;
    
    attion = kAttention;
    PurchseOrNot = kConfirmPurching;
    cancel = kCancel;
    purchse = kPurchse;

//#if SIMP == 1
//                attion = @"提醒";
//                PurchseOrNot = @"此页为付费页，确定要购买吗？";
//                cancel = @"取消";
//                purchse = @"购买";
//
//#elif TAIWAN == 1
//                attion = @"提醒";
//                PurchseOrNot = @"將要看到的內容爲付費頁，確定購買嗎？";
//                cancel = @"取消";
//                purchse = @"購買";
//#elifJAP == 1
//                attion = @"情報";
//                PurchseOrNot = @"ここからは有料となります。購入しますか？";
//                cancel = @"キャンセル";
//                purchse = @"購入";
//#endif

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:attion message:PurchseOrNot delegate:self cancelButtonTitle:nil otherButtonTitles:purchse, nil];

                alert.tag = 1;
                [alert show];
                [alert release];
}

- (void)buyBook
{
    self.PurchseView.hidden = YES;
}

//陈星宇,10.24,支付
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)
    {
        //陈星宇,Purchse and Next page
        [self purchseActionWithAlertView:alertView];
    }
}

- (void)purchseActionWithAlertView:(UIAlertView *)alertView
{
    NSString *bookID = self.pageController.bookEntity.bookid;
    
    __block typeof(self) weakSelf = self;
    
    HLIAPPurchseHandle *purchseHandle = [HLIAPPurchseHandle shareInstance];//用单例，添加观察者
    if ([purchseHandle canMakePayment])
    {
        [purchseHandle getProductInfoWithPoductID:bookID];
    }
    else
    {
        NSString *attion = nil;
        NSString *ForbidPurchsing = nil;
        NSString *cancel = nil;
        NSString *confirm = nil;
        
        attion = kAttention;
        ForbidPurchsing = kUserForbidPurchsing;
        cancel = kCancel;
        confirm = kConfire;
        
//#if SIMP == 1
//        attion = @"提醒";
//        ForbidPurchsing = @"您已禁止应用内购买";
//        cancel = @"取消";
//        confirm = @"确定";
//        
//#elif TAIWAN == 1
//        attion = @"提醒";
//        ForbidPurchsing = @"您已禁止應用內購買";
//        cancel = @"取消";
//        confirm = @"確定";
//#elifJAP == 1
//        attion = @"情報";
//        ForbidPurchsing = @"アプリ内購入が拒否されました。";
//        cancel = @"キャンセル";
//        confirm = @"确定";
//#endif
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:attion message:ForbidPurchsing delegate:Nil cancelButtonTitle:confirm otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
    }
    
    purchseHandle.compeleteTransactionBlock = ^(SKPaymentTransaction * transaction)     //交易完成
    {
        self.pageController.bookEntity.isPaid = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:bookID];  //陈星宇，支付成功待议
        
        [weakSelf showPurchse];
        [weakSelf.pageController beginView];
        
//        if (alertView.tag == 0)
//        {
//            [self confireGotoPage:indexPage animate:animatePage];
//        }
//        else if (alertView.tag == 1)
//        {
//            [self confireGotoPageWithPageID:pageID animate:animatePage];
//        }
    };
    
    purchseHandle.restoredTransactionBlock = ^(SKPaymentTransaction * transaction)      //已内购恢复
    {
        weakSelf.pageController.bookEntity.isPaid = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:bookID];  //陈星宇，支付成功待议
        
        [weakSelf showPurchse];
        [weakSelf.pageController beginView];
    };
    
    purchseHandle.failedTransactionBlock = ^(SKPaymentTransaction * transaction)        //交易失败
    {
        
        if(transaction.error.code != SKErrorPaymentCancelled) {
            
            NSString *attion = nil;
            NSString *failGet = nil;
            NSString *cancel = nil;
            NSString *confirm = nil;
            
            attion = kAttention;
            failGet = kPurchseFail;
            cancel = kCancel;
            confirm = kConfire;
            
//#if SIMP == 1
//            attion = @"提醒";
//            failGet = @"购买失败";
//            cancel = @"取消";
//            confirm = @"确定";
//            
//#elif TAIWAN == 1
//            attion = @"提醒";
//            failGet = @"購買失敗";
//            cancel = @"取消";
//            confirm = @"確定";
//#elifJAP == 1
//            attion = @"情報";
//            failGet = @"購入失敗。";
//            cancel = @"キャンセル";
//            confirm = @"确定";
//#endif
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:attion message:failGet delegate:nil cancelButtonTitle:confirm otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
        } else {
            NSLog(@"用户取消交易");
        }
    };
}

- (void)showPurchse
{
    BOOL hidden = YES;
    
    if (self.pageEntity.isNeedPay) {
        
        NSString *bookID = self.pageController.bookEntity.bookid;
        
        Boolean paid = [[NSUserDefaults standardUserDefaults] boolForKey:bookID];
        
        if (paid == NO) {
            
            hidden = NO;
            
        } else {
            
            hidden = YES;
        }
    }
    
    self.PurchseView.hidden = hidden;
}


-(void) setupGesture
{
    self.rightSwipe             = [[[UISwipeGestureRecognizer alloc] init] autorelease];
    rightSwipe.direction        = UISwipeGestureRecognizerDirectionRight;
    [rightSwipe addTarget:self action:@selector(onSwipeRight)];
    [self.view addGestureRecognizer:rightSwipe];

    self.leftSwip               = [[[UISwipeGestureRecognizer alloc] init] autorelease];
    leftSwip.direction          = UISwipeGestureRecognizerDirectionLeft;
    [leftSwip addTarget:self action:@selector(onSwipeLeft)];
    [self.view addGestureRecognizer:leftSwip];

    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] init] autorelease];
    tap.delegate                = self;//2013.04.22
    [tap addTarget:self action:@selector(onTap)];
    [self.view addGestureRecognizer:tap];
}

-(void) addComponent:(Component*)component
{
    [self.curScrollView addSubview:component.uicomponent];
}

#pragma mark -
#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (HLContainer *container in self.pageController.objects)
    {
        if (container.entity.isUseSlide && container.entity.isPageInnerSlide)
        {
            float offsetRateX = [container.entity.sliderHorRate floatValue];
            float offsetRateY = ([container.entity.sliderVerRate floatValue] - 1.0);
            //adward 14-1-6
            float disX        = scrollView.contentOffset.y * offsetRateX;
            float disY        = scrollView.contentOffset.y * offsetRateY;
            
            container.component.uicomponent.frame = CGRectMake([container.entity.x floatValue] - disX, [container.entity.y floatValue] - disY, [container.entity.width floatValue], [container.entity.height floatValue]);
            container.component.uicomponent.layer.opacity = [container.entity.alpha floatValue];
        }
    }
    
    //      >>>>>
    CGPoint contentOffset = scrollView.contentOffset;
    NSString *pageID      = self.pageEntity.entityid;
    [[HLDefaultRecord shareRecord] setObject:@[@(contentOffset.x), @(contentOffset.y)] ForKey:pageID];
    //      <<<<<        //Mr.chen, Record the ContentOffset of ScrollView, 14.04.02
}

#pragma mark -
#pragma mark - Gesture Recognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // [self.pageController touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

//解决ios5按钮和手势冲突问题 2013.04.22
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    
    for (HLContainer *container in self.pageController.objects)
    {
        if (container.entity.behaviors && container.entity.behaviors > 0)
        {
            CGPoint point = [touch locationInView:self.view];
            if (CGRectContainsPoint(container.component.uicomponent.frame, point))
            {
                return NO;
            }
        }
    }
    
    return YES;
}

-(void) onTap
{
    [self.pageController onTap];
}

-(void) onSwipeLeft
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    [curContainerArr removeAllObjects];
    [self.pageController onSwipLeft];
}

-(void) onSwipeRight
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    [curContainerArr removeAllObjects];
    [self.pageController onSwipRight];
}

- (void)timerUpdate
{
    if (curContainerArr.count > 0 && [UIAccelerometer sharedAccelerometer].delegate)
    {
        for (int i = 0; i < curContainerArr.count; i++)
        {
            UIView *moveImg = ((HLContainer *)[curContainerArr objectAtIndex:i]).component.uicomponent;
            if (moveImg)
            {
                [moveImg setFrame:CGRectMake(moveImg.frame.origin.x - velocity * self.acceleration.y * direction + kBounceSapce * ay, moveImg.frame.origin.y, moveImg.frame.size.width, moveImg.frame.size.height)];
            }
        }
    }
}

#pragma mark - UIAccelerometer Delegate

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    /********************
     ****只支持横向屏幕*****
     ********************/
    if (isInit && curContainerArr.count == 0)
    {
        return;
    }
    if (!isInit)
    {
        NSMutableArray *containerEntityArr = [NSMutableArray array];
        for (HLContainerEntity *containerEntity in self.pageController.currentPageEntity.containers)
        {
            if (containerEntity.isEnableGyroHor)
            {
                [containerEntityArr addObject:containerEntity];
            }
        }
        
        for (HLContainer *container in self.pageController.objects)
        {
            if ([containerEntityArr containsObject:container.entity])
            {
                [curContainerArr addObject:container];
            }
        }
    }
    
    if (curContainerArr.count == 0)
    {
        [UIAccelerometer sharedAccelerometer].delegate = nil;
        return;
    }
    
    self.acceleration = acceleration;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    if (!UIInterfaceOrientationIsLandscape(orientation))
    {
        //not support
        //        direction = 1;
    }
    else
    {
        if (UIInterfaceOrientationLandscapeRight == orientation)
        {
            direction = 1;//home btn right
        }
        else
        {
            direction = -1;
        }
    }
    
    
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    }
    
    ay = (self.acceleration.y - lastY) * -1 * direction;//acceleration.y 右高正
    int startX = -100;
    int endX = 1124;
    
    for (int i = 0; i < curContainerArr.count; i++)
    {
        UIView *moveImg = ((HLContainer *)[curContainerArr objectAtIndex:i]).component.uicomponent;
        if (moveImg)
        {
            if (moveImg.frame.origin.x > startX + kBounceSapce && moveImg.frame.origin.x < endX - moveImg.frame.size.width - kBounceSapce)
            {
                isBounce = NO;
            }
            
            if (moveImg.frame.origin.x < startX)
            {
                [self bounceAnimation:YES];
            }
            else if (moveImg.frame.origin.x > endX - moveImg.frame.size.width)
            {
                [self bounceAnimation:NO];
            }
            else
            {
                isFirst = YES;
                isSecAdd = NO;
                isSecSubtract = NO;
                isThirdAdd = NO;
                isThirdSubtract = NO;
                velocity = kSpeed;
                isBounce = NO;
            }
        }
    }
    
    lastY = self.acceleration.y;
    isInit = YES;
}

#pragma mark -
#pragma mark - Caculate


- (void)resetAnimationValue
{
    velocity = kSpeed;
    isFirst = YES;
    isSecAdd = NO;
    isSecSubtract = NO;
    isThirdAdd = NO;
    isThirdSubtract = NO;
    isBounce = YES;
}

- (void)bounceAnimation:(BOOL)left
{
    if (!left && self.acceleration.y * direction > 0)
    {
        [self resetAnimationValue];
    }
    else if(left && self.acceleration.y * direction < 0)
    {
        [self resetAnimationValue];
    }
    else
    {
        if (!isBounce)
        {
            if (isFirst)
            {
                velocity = velocity - 0.5;
                if (velocity == 0)
                {
                    isFirst = NO;
                    isSecAdd = YES;
                }
            }
            else if (isSecAdd || isSecSubtract)
            {
                if (isSecAdd)
                {
                    velocity = velocity - 0.25;
                    if (velocity == -1.5)
                    {
                        isSecAdd = NO;
                        isSecSubtract = YES;
                    }
                }
                else
                {
                    velocity = velocity + 0.25;
                    if (velocity == 0)
                    {
                        isThirdAdd = YES;
                        isSecSubtract = NO;
                    }
                }
                
            }
            else if (isThirdAdd || isThirdSubtract)
            {
                if (isThirdAdd)
                {
                    velocity = velocity + 0.1;
                    if (velocity == .5) {
                        isThirdSubtract = YES;
                        isThirdAdd = NO;
                    }
                }
                else
                {
                    velocity = velocity - 0.1;
                    if ((int)(velocity * 10) == (int)(0.1 * 10))
                    {
                        velocity = 0;
                        isThirdSubtract = NO;
                        isFirst = YES;
                        isBounce = YES;
                    }
                }
            }
        }
    }
}

- (void)dealloc
{
    [UIAccelerometer sharedAccelerometer].delegate = nil;
    [_acceleration release];
    [curContainerArr removeAllObjects];
    [curContainerArr release];
    [pageEntity release];
    [rightSwipe release];
    [leftSwip release];
    [_curScrollView removeFromSuperview];   //陈星宇，10.30
    [_curScrollView release];
    
    [_PurseButton removeFromSuperview];
    [_PurseButton release];
    [_PurchseView removeFromSuperview];
    [_PurchseView release];
    [super dealloc];
}


@end
