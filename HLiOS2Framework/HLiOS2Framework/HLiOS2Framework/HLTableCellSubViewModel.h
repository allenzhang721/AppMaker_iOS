//
//  HLTableCellSubViewModel.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMTBXML.h"

/*
 <ID>-1477370112675</ID>
 <Height>50</Height>
 <Width>50</Width>
 <Rotation>0</Rotation>
 <X>5</X>
 <Y>5</Y>
 <Alpha>1</Alpha>
 <CellComponent>
 <ComponentType>com.hl.flex.components.objects.hltableView.cell.component::HLTableCellImageComponent</ComponentType>
 <ID>-1477370112672</ID>
 <ComponentName>Image View</ComponentName>
 <ImageSrc/>
 <ImageSrcType/>
 </CellComponent>
 */

@interface HLTableCellSubViewModel : NSObject

@property(nonatomic, strong) NSString *ID;
@property(nonatomic, assign) float width;
@property(nonatomic, assign) float height;
@property(nonatomic, assign) float rotation;
@property(nonatomic, assign) float x;
@property(nonatomic, assign) float y;
@property(nonatomic, assign) float alpha;
@property(nonatomic, strong) NSString *comType;
@property(nonatomic, strong) NSString *comID;
@property(nonatomic, strong) NSString *comName;


- (void) decodeXML:(TBXMLElement *)cellContainer;

@end
