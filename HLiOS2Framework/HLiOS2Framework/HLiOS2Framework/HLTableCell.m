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

@end

@implementation HLTableCell

-(void)configWithViewModels:(HLTableCellViewModel *)viewModel {
  
  if (_viewModel == NULL) {
    
    for (UIView *subv in self.contentView.subviews) {
      [subv removeFromSuperview];
    }
    
    _viewModel = viewModel;
    
    for (HLTableCellSubViewModel *subViewModel in viewModel.subViewModels) {
      
      if ([subViewModel isKindOfClass:[HLTableCellSubViewImageModel class]]) {
        CGRect rect = CGRectMake(subViewModel.x, subViewModel.y, subViewModel.width, subViewModel.height);
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:rect];
        imgView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:imgView];
        imgView.tag = [subViewModel.comID integerValue];
      }
      
      if ([subViewModel isKindOfClass:[HLTableCellSubViewTextModel class]]) {
        CGRect rect = CGRectMake(subViewModel.x, subViewModel.y, subViewModel.width, subViewModel.height);
        UILabel *label = [[UILabel alloc]initWithFrame:rect];
        label.backgroundColor = [UIColor greenColor];
        label.font = [UIFont systemFontOfSize:((HLTableCellSubViewTextModel *)subViewModel).fontSize];
        [self.contentView addSubview:label];
        label.tag = [subViewModel.comID integerValue];
      }
    }
  }
}

-(void)configWithBindingModels:(NSArray<HLTableCellSubBindingModel *> *)bindingModel {
  
  self.bindingModels = bindingModel;
}

-(void)configWithData:(NSDictionary *)dic {
  
  if (dic != nil && _bindingModels.count > 0) {
    for (HLTableCellSubBindingModel *b in _bindingModels) {
      NSLog(@"%@ = %@", b.modelID, dic[b.modelKey]);
      
      UIView *v = [self.contentView viewWithTag:[b.modelID integerValue]];
      
      if ([v isKindOfClass:[UILabel class]]) {
        
        ((UILabel *)v).text = dic[b.modelKey];
      }
    }
  }
}

@end
