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
#import "HLContainerEntity.h"
#import <WebImage/UIImageView+WebCache.h>

typedef void(^HLTableCellDelegateHandler)(NSString *key, NSString *value);

@interface HLTableCell : UICollectionViewCell

@property(nonatomic, copy) HLTableCellDelegateHandler handler;

-(void)configWithViewModels:(HLTableCellViewModel *)viewModel entity:(HLContainerEntity *)entity;
-(void)configWithBindingModels:(NSArray<HLTableCellSubBindingModel *> *)bindingModel;

-(NSString *)configWithData:(NSDictionary *)dic;

@end
