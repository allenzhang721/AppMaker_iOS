//
//  HLEnumConstant.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 14-1-8.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#ifndef MoueeiOS2Framework_HLEnumConstant_h
#define MoueeiOS2Framework_HLEnumConstant_h



#endif


typedef enum

{
    relativeDirectionleft = 0,
    relativeDirectionRight,
    relativeDirectionUp,
    relativeDirectionDown
    
} relativeDirection;


typedef NS_ENUM(NSInteger, HLBookEntityLabelHorPostion) {
    
    HLBookEntityLabelHorPostionTop = 1,
    HLBookEntityLabelHorPostionCenter = 2,
    HLBookEntityLabelHorPostionBottom = 3
    
};

typedef NS_ENUM(NSInteger, HLBookEntityLabelVerPostion) {
    
    HLBookEntityLabelVerPostionLeft = 11,
    HLBookEntityLabelVerPostionCenter = 22,
    HLBookEntityLabelVerPostionRight = 33
};

typedef struct {
    
    HLBookEntityLabelHorPostion horPostion;
    HLBookEntityLabelVerPostion verPostion;
    float horGap;
    float verGap;
    
    
}HLBookEntityBookMarkPostion;