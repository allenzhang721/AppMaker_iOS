//
//  HLTableComponent.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "HLTableEntity.h"

@interface HLTableComponent : Component<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) HLTableEntity *entity;

@end
