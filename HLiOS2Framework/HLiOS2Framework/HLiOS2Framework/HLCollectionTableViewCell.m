//
//  CollectionTableViewCell.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-16.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLCollectionTableViewCell.h"
#import <CoreText/CoreText.h>

@implementation HLCollectionTableViewCell
@synthesize searchBarText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _titleImg = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 75)] autorelease];
        _titleImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_titleImg];
        
        _titleLab = [[[UILabel alloc] initWithFrame:CGRectMake(100, 30, 200, 15)] autorelease];
        _titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor whiteColor];
        [self addSubview:_titleLab];
        
        _descLab = [[[UILabel alloc] initWithFrame:CGRectMake(100, 50, 175, 15)] autorelease];
        _descLab.backgroundColor = [UIColor clearColor];
        _descLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _descLab.font = [UIFont systemFontOfSize:10];
        _descLab.textColor = [UIColor whiteColor];
        [self addSubview:_descLab];
    }
    return self;
}

- (void)setCellContent:(NSString *)picImg title:(NSString *)title desc:(NSString *)desc
{
    _titleLab.text = title;
    _descLab.text = desc;
    
    UIImage *image = [self imageWithPath:picImg drawInRect:_titleImg.bounds];
    
    [_titleImg setImage:image];
    
    
    if (self.searchBarText.length != 0)
    {
        //        NSRange foundTitleObj = [title rangeOfString:self.searchBarText options:NSLiteralSearch];//区分大小写2.13
        //        NSRange foundDesObj = [desc rangeOfString:self.searchBarText options:NSLiteralSearch];
        
        NSArray *titleArr = [NSArray array];
        NSArray *descArr = [NSArray array];
        
        titleArr = [self allSearchStringRangeInRange:title relaceString:self.searchBarText];
        descArr = [self allSearchStringRangeInRange:desc relaceString:self.searchBarText];
        
        NSMutableAttributedString *titleAttributeString =[[NSMutableAttributedString alloc]initWithString:title];
        NSMutableAttributedString *desAttributeString = [[NSMutableAttributedString alloc]initWithString:desc];
        
        for (int i = 0; i < titleArr.count; i ++)
        {
            NSRange range = [[titleArr objectAtIndex:i] rangeValue];
            [titleAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:range];
        }
        
        for (int i = 0; i < descArr.count; i ++)
        {
            NSRange range = [[descArr objectAtIndex:i] rangeValue];
            [desAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:range];
        }
        
        
        
        _titleLab.attributedText = titleAttributeString;
        _descLab.attributedText = desAttributeString;
    }
    
}
- (NSArray *)allSearchStringRangeInRange:(NSString *)searchString  relaceString:(NSString *)replace
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    NSRange searchRange = NSMakeRange(0, [searchString length]);
    NSRange aRange;
    
    do {
        NSRange range = [searchString rangeOfString:replace options:NSLiteralSearch range:searchRange];
        aRange = range;
        if (aRange.location != NSNotFound) {
            
            [mutableArray addObject:[NSValue valueWithRange:aRange]];
            searchRange = NSMakeRange(aRange.location + aRange.length, [searchString length]- (aRange.location + aRange.length));
        }
        
    } while (aRange.location != NSNotFound);
    
    return mutableArray;
    
}

//-(void)searchBarText:(NSNotification *)notif
//{
//    NSString *text = (NSString *)notif.object;
//    self.searchBarText = text;
//}

- (UIImage *)imageWithPath:(NSString *)path drawInRect:(CGRect)rect     //陈星宇，12.2，图片重绘，解决图片体积过大导致内存不足
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
