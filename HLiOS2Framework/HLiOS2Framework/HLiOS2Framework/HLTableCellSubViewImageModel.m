//
//  HLTableCellSubViewImageModel.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableCellSubViewImageModel.h"

/*
 <ComponentType>com.hl.flex.components.objects.hltableView.cell.component::HLTableCellImageComponent</ComponentType>
 <ID>-1477370112839</ID>
 <ComponentName>Image View</ComponentName>
 <ImageSrc/>
 <ImageSrcType/>
 */

@implementation HLTableCellSubViewImageModel

- (void) decodeXML:(TBXMLElement *)cellContainer {
  
  [super decodeXML:cellContainer];
  
  TBXMLElement *cellCom = [EMTBXML childElementNamed:@"CellComponent" parentElement:cellContainer];
  
  TBXMLElement *t = [EMTBXML childElementNamed:@"ComponentType" parentElement:cellCom];
  if (t) {
    self.comType = [EMTBXML textForElement:t];
  }
  
  TBXMLElement *ID = [EMTBXML childElementNamed:@"ComponentID" parentElement:cellCom];
  if (ID) {
    self.comID = [EMTBXML textForElement:ID];
  }
  
  TBXMLElement *name = [EMTBXML childElementNamed:@"ComponentName" parentElement:cellCom];
  if (name) {
    self.comName = [EMTBXML textForElement:name];
  }
  
  TBXMLElement *src = [EMTBXML childElementNamed:@"ImageSrc" parentElement:cellCom];
  if (src) {
    self.imageSrc = [EMTBXML textForElement:src];
  }
  
  TBXMLElement *srcType = [EMTBXML childElementNamed:@"ImageSrcType" parentElement:cellCom];
  if (srcType) {
    self.imageSrcType = [EMTBXML textForElement:srcType];
  }
}

@end
