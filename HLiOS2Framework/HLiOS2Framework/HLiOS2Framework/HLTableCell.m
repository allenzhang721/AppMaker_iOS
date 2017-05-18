//
//  HLTableCell.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableCell.h"
#import "HLTableCellSubViewImageModel.h"
#import "HLTableCellSubViewTextModel.h"



@interface HLTableCell ()

@property(nonatomic, assign) HLTableCellViewModel *viewModel;
@property(nonatomic, assign) NSArray<HLTableCellSubBindingModel *> *bindingModels;
@property(nonatomic, retain) NSDictionary<NSString*, NSNumber *>*bingings;

@end

@implementation HLTableCell

-(void)configWithViewModels:(HLTableCellViewModel *)viewModel entity:(HLContainerEntity *)entity {
  
  if (_viewModel == NULL) {
    
    for (UIView *subv in self.contentView.subviews) {
      [subv removeFromSuperview];
    }
    
    _viewModel = viewModel;
    
    for (HLTableCellSubViewModel *subViewModel in viewModel.subViewModels) {
      
      /*
       self.imagePath             = [entity.rootPath stringByAppendingPathComponent:entity.dataid];
       HLImage *imageView         = nil;
       UIImage *image             = [UIImage imageWithContentsOfFile:self.imagePath];
       */
      
      if ([subViewModel isKindOfClass:[HLTableCellSubViewImageModel class]]) {
        HLTableCellSubViewImageModel *s = (HLTableCellSubViewImageModel *)subViewModel;
        CGRect rect = CGRectMake(subViewModel.x, subViewModel.y, subViewModel.width, subViewModel.height);
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:rect];
//        imgView.backgroundColor = [UIColor greenColor];
        if (s.imageSrc != nil) {
          NSString *imgPath = [entity.rootPath stringByAppendingPathComponent:s.imageSrc];
          imgView.image = [UIImage imageWithContentsOfFile:imgPath];
        }
        [self.contentView addSubview:imgView];
        imgView.tag = [[subViewModel.comID substringFromIndex:subViewModel.comID.length - 6] integerValue];
      }
      
      if ([subViewModel isKindOfClass:[HLTableCellSubViewTextModel class]]) {
        HLTableCellSubViewTextModel *s = (HLTableCellSubViewTextModel *)subViewModel;
        CGRect rect = CGRectMake(subViewModel.x, subViewModel.y, subViewModel.width, subViewModel.height);
        UITextView *label = [[UITextView alloc]initWithFrame:rect];
        label.text = s.text;
        label.scrollEnabled = false;
        label.editable = false;
        label.textContainerInset = UIEdgeInsetsZero;
        label.backgroundColor = [UIColor clearColor];
          
        label.font = [UIFont systemFontOfSize:((HLTableCellSubViewTextModel *)subViewModel).fontSize];
        label.textColor = [self colorWithHexString:((HLTableCellSubViewTextModel *)subViewModel).textColorHex];
        if (s.aligent == @"center") {
          label.textAlignment = NSTextAlignmentCenter;
        } else if (s.aligent == @"right") {
          label.textAlignment = NSTextAlignmentRight;
        }
        [self.contentView addSubview:label];
        label.tag = [[subViewModel.comID substringFromIndex:subViewModel.comID.length - 6]  integerValue];
      }
    }
  }
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor grayColor];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
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

-(void)configWithBindingModels:(NSArray<HLTableCellSubBindingModel *> *)bindingModel {
  
  self.bindingModels = bindingModel;
}

-(NSString *)configWithData:(NSDictionary *)dic {
    NSMutableString *content = [@"Good" mutableCopy];
    
  if (dic != nil && _bindingModels.count > 0) {
      
    for (HLTableCellSubBindingModel *b in _bindingModels) {
      NSLog(@"%@ = %@", b.modelID, dic[b.modelKey]);
      if (b.modelKey == nil) {
        continue;
      }
      
//        [content appendFormat:@"\nmodelID = %@",[b.modelID substringFromIndex:b.modelID.length - 6]];
      
      UIView *v = [self.contentView viewWithTag:[[b.modelID substringFromIndex:b.modelID.length - 6]  integerValue]];
      
      if ([v isKindOfClass:[UITextView class]]) {
        UITextView *label = (UITextView *)v;
        if (dic != nil && (b.modelKey != nil && ![b.modelKey isEqualToString:@""])) {
          label.text = [NSString stringWithFormat:@"%@", dic[b.modelKey]];
//            [content appendFormat:@"%@", [NSString stringWithFormat:@"\nlable = %@", label.text]];
        } else {
//            [content appendFormat:@"%@", [NSString stringWithFormat:@"\ntextView modelKey not exist"]];
        }
      } else if ([v isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView *)v;
        NSURL *url = [NSURL URLWithString:dic[b.modelKey]];
//          [content appendFormat:@"%@",[NSString stringWithFormat:@"\nimg = %@", url.path]];
        [imgView sd_setImageWithURL:url placeholderImage:imgView.image];
      } else {
//          [content appendFormat:@"%@",[NSString stringWithFormat:@"\n v is, %@ not textView and ImageVIew", NSStringFromClass([v class])]];
      }
    }
  } else {
//     [content appendFormat:@"%@",@"no bindingModels"];
  }
//    [content appendFormat:@"\n--------"];
    return content;
}

@end
