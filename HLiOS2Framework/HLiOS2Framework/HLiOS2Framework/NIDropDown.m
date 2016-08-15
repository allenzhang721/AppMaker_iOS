//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"
#import "EWMultiColumnTableView.h"

@interface NIDropDown ()
@property(nonatomic, strong) EWMultiColumnTableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize currentSelectIndex;
@synthesize delegate;

- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr
{
    btnSender = b;
    self = [super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        //CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = 320;
        self.frame = CGRectMake(btn.origin.x-(screenWidth -btn.size.width)/2, btn.origin.y+btn.size.height, screenWidth, 0);
        self.list = [NSArray arrayWithArray:arr];
        self.layer.masksToBounds = NO;
        //self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
       // table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
        table = [[EWMultiColumnTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
        table.sectionHeaderEnabled = NO;
        //table.delegate = self;
        table.dataSource = self;
       // table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor whiteColor];
       // table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        //table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //table.separatorColor = [UIColor grayColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.frame = CGRectMake(btn.origin.x-(screenWidth -btn.size.width)/2, btn.origin.y+btn.size.height, screenWidth, *height);
        table.frame = CGRectMake(0, 0, screenWidth, *height);
        [UIView commitAnimations];
        
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b
{
    CGRect btn = b.frame;
    //CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = 320;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.frame = CGRectMake(btn.origin.x-(screenWidth-btn.size.width)/2, btn.origin.y+btn.size.height, screenWidth, 0);
    table.frame = CGRectMake(0, 0, screenWidth, 0);
    [UIView commitAnimations];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)numberOfSectionsInTableView:(EWMultiColumnTableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    UILabel *l = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40, 40.0f)] autorelease];
    l.numberOfLines = 0;
    l.lineBreakMode = NSLineBreakByWordWrapping;
    return l;
    
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    UILabel *l = (UILabel *)cell;
    l.text = [list objectAtIndex:indexPath.row];
    CGRect f = l.frame;
    f.size.width = [self tableView:tableView widthForColumn:col];
    l.frame = f;    
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForCellAtIndexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    return 40;
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView widthForColumn:(NSInteger)column
{
    if (column == 0)
    {
        return 167;
    }
    if(column == 1)
    {
        return 50;
    }
    return 50;
}

- (NSInteger)tableView:(EWMultiColumnTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}



- (NSInteger)numberOfColumnsInTableView:(EWMultiColumnTableView *)tableView
{
    return 3;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 40;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.list count];
//}   


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.textLabel.textAlignment = UITextAlignmentCenter;
//    }
//    cell.textLabel.text =[list objectAtIndex:indexPath.row];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    
//    UIView * v = [[UIView alloc] init];
//    v.backgroundColor = [UIColor grayColor];
//    cell.selectedBackgroundView = v;
//    
//    return cell;
//}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellForIndexPath:(NSIndexPath *)indexPath
{
    return [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)] autorelease];
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForHeaderCell:(UIView *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    l.textAlignment = NSTextAlignmentCenter;
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForHeaderCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}


- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellInSectionHeaderForSection:(NSInteger)section
{
    UILabel *l = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self widthForHeaderCellOfTableView:tableView], 30.0f)] autorelease];
    l.backgroundColor = [UIColor orangeColor];
    return l;
    
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForHeaderCellInSectionHeader:(UIView *)cell AtSection:(NSInteger)section
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@"Section %d", section];
}

- (CGFloat)widthForHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    return 50.0f;
}


- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellForColumn:(NSInteger)col
{
    UILabel *l =  [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)] autorelease];
    l.textAlignment = NSTextAlignmentCenter;
    if (col == 0)
    {
        l.text = @"问题";
        l.frame = CGRectMake(0, 0, 167, 30);
    }
    else
    {
        if (col == 1)
        {
            l.text = @"结果";
        }
        else
        {
            if (col == 2)
            {
                l.text = @"分数";
            }
        }
    }
    l.userInteractionEnabled = YES;
    return l;
}

- (UIView *)topleftHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    UILabel *l =  [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30)] autorelease];
    l.text = @"编号";
    l.textAlignment = NSTextAlignmentCenter;
    return l;
}

- (CGFloat)heightForHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    return 30.0f;
}

- (void)tableView:(EWMultiColumnTableView *)tableView swapDataOfColumn:(NSInteger)col1 andColumn:(NSInteger)col2
{
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
       
}

- (void)tableView:(EWMultiColumnTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.currentSelectIndex = [indexPath row];
    [self hideDropDown:btnSender];
    [self myDelegate];
}


//- (void)tableView:(EWMultiColumnTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self hideDropDown:btnSender];
//    //UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
//    //[btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
//    self.currentSelectIndex = [indexPath row];
//    [self myDelegate];
//}

- (void) myDelegate
{
    [self.delegate niDropDownDelegateMethod:self];   
}

-(void)dealloc {
    [super dealloc];
    [table release];
    [self release];
}

@end
