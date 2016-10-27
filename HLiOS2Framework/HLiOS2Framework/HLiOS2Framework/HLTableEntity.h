//
//  HLTableEntity.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"
#import "HLRequest.h"
#import "HLTableCellViewModel.h"
#import "HLTableCellSubBindingModel.h"
//#import "HLTableCellEntity.h"

@interface HLTableEntity : HLContainerEntity

@property(nonatomic, strong) HLRequest *request;
@property(nonatomic, strong) HLTableCellViewModel *cellViewModel;
@property(nonatomic, strong) NSArray<HLTableCellSubBindingModel *> *bindingModels;

@end
