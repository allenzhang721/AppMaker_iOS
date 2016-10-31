//
//  HLTableCell.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTableCellViewModel.h"
#import "HLTableCellSubBindingModel.h"
#import <WebImage/UIImageView+WebCache.h>

@interface HLTableCell : UICollectionViewCell

-(void)configWithViewModels:(HLTableCellViewModel *)viewModel;
-(void)configWithBindingModels:(NSArray<HLTableCellSubBindingModel *> *)bindingModel;

-(void)configWithData:(NSDictionary *)dic;

@end
