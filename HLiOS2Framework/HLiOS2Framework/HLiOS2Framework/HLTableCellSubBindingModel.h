//
//  HLTableCellSubBindingModel.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMTBXML.h"

/*
 <Model>
 <ModelID>-1477370112672</ModelID>
 <ModelName>Image View</ModelName>
 <ModelType>com.hl.flex.components.objects.hltableView.cell.component::HLTableCellImageComponent</ModelType>
 <ModelKey>nickName</ModelKey>
 <ModelParent>list</ModelParent>
 </Model>
 */

@interface HLTableCellSubBindingModel : NSObject

@property(nonatomic, strong) NSString *modelID;
@property(nonatomic, strong) NSString *modelName;
@property(nonatomic, strong) NSString *modelType;
@property(nonatomic, strong) NSString *modelKey;
@property(nonatomic, strong) NSString *modelParent;

- (void) decodeXML:(TBXMLElement *)xml;

@end
