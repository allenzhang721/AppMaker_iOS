//
//  HLTableCellSubViewTextModel.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableCellSubViewTextModel.h"

/*
 <CellComponent>
 <ComponentType>com.hl.flex.components.objects.hltableView.cell.component::HLTableCellLabelComponent</ComponentType>
 <ID>-1477370113178</ID>
 <ComponentName>Label</ComponentName>
 <text/>
 <fontSize>16</fontSize>
 <fontColor>0x000000</fontColor>
 <fontAlig>left</fontAlig>
 </CellComponent>
 */

@implementation HLTableCellSubViewTextModel

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
  
  TBXMLElement *text = [EMTBXML childElementNamed:@"text" parentElement:cellCom];
  if (text) {
    self.text = [EMTBXML textForElement:text];
  }
  
  TBXMLElement *size = [EMTBXML childElementNamed:@"fontSize" parentElement:cellCom];
  if (size) {
    self.fontSize = [[EMTBXML textForElement:size] floatValue];
  }
  
  TBXMLElement *color = [EMTBXML childElementNamed:@"fontColor" parentElement:cellCom];
  if (color) {
    self.textColorHex = [EMTBXML textForElement:color];
  }
  
  TBXMLElement *ali = [EMTBXML childElementNamed:@"fontAlig" parentElement:cellCom];
  if (ali) {
    self.aligent = [EMTBXML textForElement:ali];
  }
  
}

@end
