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
  
  
  
  TBXMLElement *containers = [EMTBXML childElementNamed:@"Cell" parentElement:xml];
  TBXMLElement *subViewModel  = [EMTBXML childElementNamed:@"CellContainer"  parentElement:containers];
  NSMutableArray<HLTableCellSubViewModel *> *subViewModels = [@[] mutableCopy];
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
  
  self.subViewModels = subViewModels;
  
}

@end
