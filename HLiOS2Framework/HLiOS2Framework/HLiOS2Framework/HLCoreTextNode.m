//
//  MoueeCoreTextNode.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-19.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLCoreTextNode.h"

@implementation HLCoreTextNode

@synthesize text;
@synthesize font;
@synthesize color;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.color = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:0];
        self.alignment = kCTTextAlignmentLeft;
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    if (!data) //段换行
    {
        self.text = @"\n            ";
//        self.text = @"\n";
        return;
    }
    self.text = [EMTBXML textForElement:data];
    if (!self.text || [self.text isEqualToString:@""])
    {
        self.text = @"";
//        self.text = @"            ";
    }
    NSString *fontSize = [EMTBXML valueOfAttributeNamed:@"fontSize" forElement:data];
    NSString *fontStyle = [EMTBXML valueOfAttributeNamed:@"fontStyle" forElement:data];
    NSString *fontWeight = [EMTBXML valueOfAttributeNamed:@"fontWeight" forElement:data];
    if ([fontWeight isEqualToString:@"bold"])
    {
        self.font = [UIFont boldSystemFontOfSize:[fontSize floatValue]];
    }
    else
    {
         if ([fontStyle isEqualToString:@"italic"])
         {
             self.font = [UIFont italicSystemFontOfSize:[fontSize floatValue]];
         }
         else
         {
             self.font = [UIFont systemFontOfSize:[fontSize floatValue]];
         }
    }
    NSString *colorStr = [EMTBXML valueOfAttributeNamed:@"color" forElement:data];
    NSString *textDecoration = [EMTBXML valueOfAttributeNamed:@"textDecoration" forElement:data];
    if ([textDecoration isEqualToString:@"underline"])
    {
        self.isUnderLine = YES;
    }
    self.color = [self hexStringToColor:colorStr];
    
//    NSLog(@"%@", self.text);
}

//16进制颜色(html颜色值)字符串转为UIColor
- (UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)dealloc
{
    [color release];
    [font release];
    [text release];
    [super dealloc];
}

@end
