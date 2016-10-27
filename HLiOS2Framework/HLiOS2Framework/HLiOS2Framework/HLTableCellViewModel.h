//
//  HLTableCellViewModel.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMTBXML.h"
#import "HLTableCellSubViewModel.h"

struct TableLayout {
  float cellWidth;
  float cellheight;
  float horGap;
  float verGap;
  float top;
  float bottom;
  float left;
  float right;
};

@interface HLTableCellViewModel : NSObject

@property(nonatomic, assign) float cellWidth;
@property(nonatomic, assign) float cellheight;
@property(nonatomic, assign) float horGap;
@property(nonatomic, assign) float verGap;
@property(nonatomic, assign) float top;
@property(nonatomic, assign) float bottom;
@property(nonatomic, assign) float left;
@property(nonatomic, assign) float right;
@property(nonatomic, strong) NSArray<HLTableCellSubViewModel *> *subViewModels;

- (void) decodeXML:(TBXMLElement *)xml;

@end
