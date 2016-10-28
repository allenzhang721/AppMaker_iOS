//
//  HLTableCellSubViewModel.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableCellSubViewModel.h"

/*
 <ID>-1477370112840</ID>
 <Height>50</Height>
 <Width>50</Width>
 <Rotation>0</Rotation>
 <X>5</X>
 <Y>5</Y>
 <Alpha>1</Alpha>
 */

@implementation HLTableCellSubViewModel

- (void) decodeXML:(TBXMLElement *)cellContainer {
  
  TBXMLElement *I = [EMTBXML childElementNamed:@"ID" parentElement:cellContainer];
  if (I) {
    self.ID = [EMTBXML textForElement:I];
  }
  
  TBXMLElement *h = [EMTBXML childElementNamed:@"Height" parentElement:cellContainer];
  if (I) {
    self.height = [[EMTBXML textForElement:h] floatValue];
  }
  
  TBXMLElement *w = [EMTBXML childElementNamed:@"Width" parentElement:cellContainer];
  if (w) {
    self.width = [[EMTBXML textForElement:w] floatValue];
  }
  
  TBXMLElement *r = [EMTBXML childElementNamed:@"Rotation" parentElement:cellContainer];
  if (r) {
    self.rotation = [[EMTBXML textForElement:r] floatValue];
  }
  
  TBXMLElement *x = [EMTBXML childElementNamed:@"X" parentElement:cellContainer];
  if (x) {
    self.x = [[EMTBXML textForElement:x] floatValue];
  }
  
  TBXMLElement *y = [EMTBXML childElementNamed:@"Y" parentElement:cellContainer];
  if (y) {
    self.y = [[EMTBXML textForElement:y] floatValue];
  }
  
  TBXMLElement *a = [EMTBXML childElementNamed:@"Alpha" parentElement:cellContainer];
  if (a) {
    self.alpha = [[EMTBXML textForElement:a] floatValue];
  }
}

@end
