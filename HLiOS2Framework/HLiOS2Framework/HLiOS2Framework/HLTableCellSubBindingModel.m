//
//  HLTableCellSubBindingModel.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableCellSubBindingModel.h"

/*
 <Model>
   <ModelID>-1477370112672</ModelID>
   <ModelName>Image View</ModelName>
   <ModelType>com.hl.flex.components.objects.hltableView.cell.component::HLTableCellImageComponent</ModelType>
   <ModelKey>nickName</ModelKey>
   <ModelParent>list</ModelParent>
 </Model>
 */

@implementation HLTableCellSubBindingModel

- (void) decodeXML:(TBXMLElement *)xml {
  
  TBXMLElement *I = [EMTBXML childElementNamed:@"ModelID" parentElement:xml];
  if (I) {
    self.modelID = [EMTBXML textForElement:I];
  }
  
  TBXMLElement *n = [EMTBXML childElementNamed:@"ModelName" parentElement:xml];
  if (n) {
    self.modelName = [EMTBXML textForElement:n];
  }
  
  TBXMLElement *t = [EMTBXML childElementNamed:@"ModelType" parentElement:xml];
  if (t) {
    self.modelType = [EMTBXML textForElement:t];
  }
  
  TBXMLElement *k = [EMTBXML childElementNamed:@"ModelKey" parentElement:xml];
  if (k) {
    self.modelKey = [EMTBXML textForElement:k];
  }
  
  TBXMLElement *p = [EMTBXML childElementNamed:@"ModelParent" parentElement:xml];
  if (p) {
    self.modelParent = [EMTBXML textForElement:p];
  }
  
  
}

@end
