//
//  MagazinePopupViewController.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/28/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "MagazinePopupViewController.h"
#import "BaseControlPanelViewController.h"
#import "SharePopupViewController.h"

@interface MagazinePopupViewController ()

@end

@implementation MagazinePopupViewController
@synthesize listTableView;
@synthesize popupController;
@synthesize snappath;
@synthesize sharePopupViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 400, 280) style:UITableViewStyleGrouped] autorelease];
    [self setup];
	// Do any additional setup after loading the view.
}

-(void) setup
{
    self.view.frame      = CGRectMake(0, 0, 400, 280);
    self.listTableView.frame = CGRectMake(0, 0, 400, 280);
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.allowsSelection = YES;
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:listTableView];
    [self.listTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.listTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.popupController dismissPopup];
    SharePopupViewController *sp = [[[SharePopupViewController alloc] init] autorelease];
    sp.view.frame = CGRectMake(0, 0, 512, 260);
    sp.mpViewController = self;
    sp.snappath         = self.snappath;
    [sp setup];
    self.sharePopupViewController = sp;
    [self.popupController presentPopupViewController:sp animationType:MJPopupViewAnimationSlideBottomBottom];
}

-(void) closeWBSharePopup
{
    [self.popupController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Line2";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	}
    if ([indexPath section] == 0)
    {
        if ([indexPath row] == 0)
        {
            [cell.imageView setImage:[UIImage imageNamed:@"Weibo.png"]];
            cell.textLabel.text = @"分享到新浪微博";
        }
        else
        {
            if ([indexPath row] == 1)
            {
                cell.textLabel.text = @"分享到腾讯微博";
                [cell.imageView setImage:[UIImage imageNamed:@"tWeibo.png"]];
            }
        }
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.sharePopupViewController release];
    [self.listTableView release];
    [super dealloc];
}

@end
