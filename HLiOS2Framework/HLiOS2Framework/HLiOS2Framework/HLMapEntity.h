//
//  HLMapEntity.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"

@interface HLMapEntity : HLContainerEntity

/*
 <PlaceID>ChIJi73bYWusQjQRgqQGXK260bw</PlaceID>
 <Lat>25.0329636</Lat>
 <Lng>121.5654268</Lng>
 <Address>台北市</Address>
 */

@property (copy) NSString *placeID;
@property (assign) float lat;
@property (assign) float lng;
@property (copy) NSString *address;



@end
