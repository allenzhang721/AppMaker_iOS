//
//  HLTableCellViewModel.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableCellViewModel.h"
#import "HLTableCellSubViewModel.h"
#import "HLTableCellSubViewImageModel.h"
#import "HLTableCellSubViewTextModel.h"

/*
 // table layout
 <CellWidth>1024</CellWidth>
 <CellHeight>60</CellHeight>
 <HorGap>10</HorGap>
 <VerGap>10</VerGap>
 <TopOff>0</TopOff>
 <BottomOff>0</BottomOff>
 <RightOff>0</RightOff>
 <LeftOff>0</LeftOff>
 */

/*
 cellWidth;
 cellheight;
 horGap;
 verGap;
 top;
 bottom;
 left;
 right;
 */

@implementation HLTableCellViewModel

- (void) decodeXML:(TBXMLElement *)xml {
  
  TBXMLElement *w = [EMTBXML childElementNamed:@"CellWidth" parentElement:xml];
  if (w) {
    _cellWidth = [[EMTBXML textForElement:w] floatValue];
  }
  
  TBXMLElement *h = [EMTBXML childElementNamed:@"CellHeight" parentElement:xml];
  if (h) {
    _cellheight = [[EMTBXML textForElement:h] floatValue];
  }
  
  TBXMLElement *hor = [EMTBXML childElementNamed:@"HorGap" parentElement:xml];
  if (hor) {
    _horGap = [[EMTBXML textForElement:hor] floatValue];
  }
  
  TBXMLElement *ver = [EMTBXML childElementNamed:@"VerGap" parentElement:xml];
  if (ver) {
    _verGap = [[EMTBXML textForElement:ver] floatValue];
  }
  
  TBXMLElement *t = [EMTBXML childElementNamed:@"TopOff" parentElement:xml];
  if (t) {
    _top = [[EMTBXML textForElement:t] floatValue];
  }
  
  TBXMLElement *b = [EMTBXML childElementNamed:@"BottomOff" parentElement:xml];
  if (b) {
    _bottom = [[EMTBXML textForElement:b] floatValue];
  }
  
  TBXMLElement *l = [EMTBXML childElementNamed:@"LeftOff" parentElement:xml];
  if (l) {
    _left = [[EMTBXML textForElement:l] floatValue];
  }
  
  TBXMLElement *r = [EMTBXML childElementNamed:@"RightOff" parentElement:xml];
  if (r) {
    _right = [[EMTBXML textForElement:r] floatValue];
  }
  
  TBXMLElement *containers = [EMTBXML childElementNamed:@"Cell" parentElement:xml];
  TBXMLElement *subViewModel  = [EMTBXML childElementNamed:@"CellContainer"  parentElement:containers];
  NSMutableArray<HLTableCellSubViewModel *> *subViewModels = @[];
  while (subViewModel != nil) {
    
    HLTableCellSubViewModel *subVM;
    TBXMLElement *cellCom = [EMTBXML childElementNamed:@"CellComponent" parentElement:subViewModel];
    TBXMLElement *cellComType = [EMTBXML childElementNamed:@"ComponentType" parentElement:cellCom];
    NSString *type = [EMTBXML textForElement:cellComType];
    if ([type isEqualToString:@"com.hl.flex.components.objects.hltableView.cell.component::HLTableCellImageComponent"]) {
      subVM = [[HLTableCellSubViewImageModel alloc] init];
//      [subVM decodeXML:subViewModel];
    } else {
      subVM = [[HLTableCellSubViewTextModel alloc] init];
    }
    
    [subVM decodeXML:subViewModel];
    [subViewModels addObject:subVM];
    
    subViewModel = [EMTBXML nextSiblingNamed:@"CellContainer" searchFromElement:subViewModel];
  }
  
  _subViewModels = subViewModels;
  
}

@end
