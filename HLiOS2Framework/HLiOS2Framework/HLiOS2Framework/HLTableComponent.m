//
//  HLTableComponent.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTableComponent.h"
#import "HLTableCell.h"

@implementation HLTableComponent
- (id)initWithEntity:(HLContainerEntity *) entity
{
  self = [super init];
  if (self)
  {
    self.entity    = (HLTableEntity *)entity;
    //        self.customHeight = true;
    [self p_setupUI];
  }
  return self;
}

- (void)p_setupUI {
  
  CGRect r = CGRectMake([_entity.x floatValue], [_entity.y floatValue], [_entity.width floatValue], [_entity.height floatValue]);
  
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  
  UICollectionView *v = [[UICollectionView alloc] initWithFrame:r collectionViewLayout:flowLayout];
  [v registerClass:[HLTableCell class] forCellWithReuseIdentifier:@"TableCell"];
  v.delegate = self;
  v.dataSource = self;
  
  v.backgroundColor = [UIColor blackColor];
  
  self.uicomponent = v;
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  return 3;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  HLTableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TableCell" forIndexPath:indexPath];
  
  cell.contentView.backgroundColor = [UIColor redColor];
  
  [cell configWithViewModels:_entity.cellViewModel];
  
  
  
  
  return cell;
}

#pragma MARK: CollectionView flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  return CGSizeMake(_entity.cellViewModel.cellWidth, _entity.cellViewModel.cellheight);
  
}

@end
