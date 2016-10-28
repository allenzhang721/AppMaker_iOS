//
//  HLTableEntity.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableEntity.h"
#import "HLRequest.h"


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
  
  _request = [[HLRequest alloc] init];
  [_request decodeXML:request];
  
  _cellViewModel = [[HLTableCellViewModel alloc] init];
  [_cellViewModel decodeXML:cell];
  
  TBXMLElement *w = [EMTBXML childElementNamed:@"CellWidth" parentElement:data];
  if (w) {
    _cellViewModel.cellWidth = [[EMTBXML textForElement:w] floatValue];
  }
  
  TBXMLElement *h = [EMTBXML childElementNamed:@"CellHeight" parentElement:data];
  if (h) {
     _cellViewModel.cellheight = [[EMTBXML textForElement:h] floatValue];
  }
  
  TBXMLElement *hor = [EMTBXML childElementNamed:@"HorGap" parentElement:data];
  if (hor) {
    _cellViewModel.horGap = [[EMTBXML textForElement:hor] floatValue];
  }
  
  TBXMLElement *ver = [EMTBXML childElementNamed:@"VerGap" parentElement:data];
  if (ver) {
    _cellViewModel.verGap = [[EMTBXML textForElement:ver] floatValue];
  }
  
  TBXMLElement *t = [EMTBXML childElementNamed:@"TopOff" parentElement:data];
  if (t) {
    _cellViewModel.top = [[EMTBXML textForElement:t] floatValue];
  }
  
  TBXMLElement *b = [EMTBXML childElementNamed:@"BottomOff" parentElement:data];
  if (b) {
    _cellViewModel.bottom = [[EMTBXML textForElement:b] floatValue];
  }
  
  TBXMLElement *l = [EMTBXML childElementNamed:@"LeftOff" parentElement:data];
  if (l) {
    _cellViewModel.left = [[EMTBXML textForElement:l] floatValue];
  }
  
  TBXMLElement *r = [EMTBXML childElementNamed:@"RightOff" parentElement:data];
  if (r) {
    _cellViewModel.right = [[EMTBXML textForElement:r] floatValue];
  }
  
  
  
  
  TBXMLElement *models = [EMTBXML childElementNamed:@"Models" parentElement:cellModel];
  TBXMLElement *model = [EMTBXML childElementNamed:@"Model" parentElement:models];
  NSMutableArray<HLTableCellSubBindingModel *> *bindModels = [@[] mutableCopy];
  while (model != NULL) {
    
    HLTableCellSubBindingModel *bindModel = [[HLTableCellSubBindingModel alloc] init];
    [bindModel decodeXML:model];
    [bindModels addObject:bindModel];
    model = [EMTBXML nextSiblingNamed:@"Model" searchFromElement:model];
  }
  
  _bindingModels = bindModels;
  
  [pool release];
}


@end
