//
//  HLTableCellSubViewTextModel.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableCellSubViewModel.h"

/*
 <CellComponent>
 <ComponentType>com.hl.flex.components.objects.hltableView.cell.component::HLTableCellLabelComponent</ComponentType>
 <ID>-1477370113409</ID>
 <ComponentName>Label</ComponentName>
 <text/>
 <fontSize>16</fontSize>
 <fontColor>0x000000</fontColor>
 <fontAlig>left</fontAlig>
 </CellComponent>
 */

@interface HLTableCellSubViewTextModel : HLTableCellSubViewModel

@property(nonatomic, strong) NSString *text;
@property(nonatomic, assign) float fontSize;
@property(nonatomic, strong) NSString *textColorHex;
@property(nonatomic, strong) NSString *aligent;

@end
