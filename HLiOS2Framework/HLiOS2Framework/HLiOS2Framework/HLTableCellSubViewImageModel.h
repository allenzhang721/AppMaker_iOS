//
//  HLTableCellSubViewImageModel.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableCellSubViewModel.h"

/*
 <ComponentType>com.hl.flex.components.objects.hltableView.cell.component::HLTableCellImageComponent</ComponentType>
 <ID>-1477370112839</ID>
 <ComponentName>Image View</ComponentName>
 <ImageSrc/>
 <ImageSrcType/>
 */

@interface HLTableCellSubViewImageModel : HLTableCellSubViewModel

@property(nonatomic, strong) NSString *imageSrc;
@property(nonatomic, strong) NSString *imageSrcType;

@end
