//
//  HLTableEntity.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableEntity.h"
#import "HLRequest.h"
#import "HLTableCellSubViewTextModel.h"


@implementation HLTableEntity

/*
 <CellWidth>1024</CellWidth>
 <CellHeight>60</CellHeight>
 <HorGap>10</HorGap>
 <VerGap>10</VerGap>
 <TopOff>0</TopOff>
 <BottomOff>0</BottomOff>
 <RightOff>0</RightOff>
 <LeftOff>0</LeftOff>
 */

-(void)decodeData:(TBXMLElement *)data {
  
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  /*
   // Request
   // CellXML: layout, subview
   // binding: between cell subview displayData and request data;
   */
  
  TBXMLElement *request = [EMTBXML childElementNamed:@"URLRequest"  parentElement:data];
  TBXMLElement *cell = [EMTBXML childElementNamed:@"CellXML"  parentElement:data];
  TBXMLElement *cellModel = [EMTBXML childElementNamed:@"CellModel" parentElement:data];
  
  self.request = [[HLRequest alloc] init];
  [_request decodeXML:request];
  
  self.cellViewModel = [[HLTableCellViewModel alloc] init];
  [_cellViewModel decodeXML:cell];
  
  TBXMLElement *w = [EMTBXML childElementNamed:@"CellWidth" parentElement:data];
  if (w) {
    self.cellViewModel.cellWidth = [[EMTBXML textForElement:w] floatValue];
  }
  
  TBXMLElement *h = [EMTBXML childElementNamed:@"CellHeight" parentElement:data];
  if (h) {
     self.cellViewModel.cellheight = [[EMTBXML textForElement:h] floatValue];
  }
  
  TBXMLElement *hor = [EMTBXML childElementNamed:@"HorGap" parentElement:data];
  if (hor) {
    self.cellViewModel.horGap = [[EMTBXML textForElement:hor] floatValue];
  }
  
  TBXMLElement *ver = [EMTBXML childElementNamed:@"VerGap" parentElement:data];
  if (ver) {
    self.cellViewModel.verGap = [[EMTBXML textForElement:ver] floatValue];
  }
  
  TBXMLElement *t = [EMTBXML childElementNamed:@"TopOff" parentElement:data];
  if (t) {
    self.cellViewModel.top = [[EMTBXML textForElement:t] floatValue];
  }
  
  TBXMLElement *b = [EMTBXML childElementNamed:@"BottomOff" parentElement:data];
  if (b) {
    self.cellViewModel.bottom = [[EMTBXML textForElement:b] floatValue];
  }
  
  TBXMLElement *l = [EMTBXML childElementNamed:@"LeftOff" parentElement:data];
  if (l) {
    self.cellViewModel.left = [[EMTBXML textForElement:l] floatValue];
  }
  
  TBXMLElement *r = [EMTBXML childElementNamed:@"RightOff" parentElement:data];
  if (r) {
    self.cellViewModel.right = [[EMTBXML textForElement:r] floatValue];
  }
  
  TBXMLElement *color = [EMTBXML childElementNamed:@"BackgroundColor" parentElement:data];
  if (color) {
    self.cellViewModel.BackgroundColor = [EMTBXML textForElement:color];
  }
  
  TBXMLElement *models = [EMTBXML childElementNamed:@"Models" parentElement:cellModel];
  TBXMLElement *model = [EMTBXML childElementNamed:@"Model" parentElement:models];
  
  TBXMLElement *modelParent = [EMTBXML childElementNamed:@"ModelParent" parentElement:cellModel];
  if (modelParent) {
    self.modelParent = [EMTBXML textForElement:modelParent];
  }
  
  NSMutableArray<HLTableCellSubBindingModel *> *bindModels = [@[] mutableCopy];
  while (model != NULL) {
    
    HLTableCellSubBindingModel *bindModel = [[HLTableCellSubBindingModel alloc] init];
    [bindModel decodeXML:model];
    [bindModels addObject:bindModel];
    model = [EMTBXML nextSiblingNamed:@"Model" searchFromElement:model];
  }
  
  self.bindingModels = bindModels;
  
  
  
  [pool release];
}

-(void)scale:(float)x y:(float)y {
  
  _cellViewModel.cellWidth *= x;
  _cellViewModel.cellheight *= y;
  
  for (HLTableCellSubViewModel * sm in _cellViewModel.subViewModels) {
    sm.x *= x;
    sm.y *= y;
    sm.width *= x;
    sm.height *= y;
    
    if ([sm isKindOfClass:[HLTableCellSubViewTextModel class]]) {
      ((HLTableCellSubViewTextModel *)sm).fontSize *= y;
    }
  }
  
}


@end
