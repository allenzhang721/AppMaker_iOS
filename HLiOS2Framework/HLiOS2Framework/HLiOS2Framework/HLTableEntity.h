//
//  HLTableEntity.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"

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

@interface HLTableEntity : HLContainerEntity

@end
