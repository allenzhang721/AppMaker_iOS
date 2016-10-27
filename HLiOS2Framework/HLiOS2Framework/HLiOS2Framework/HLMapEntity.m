//
//  HLMapEntity.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLMapEntity.h"

@implementation HLMapEntity

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    /*
     <PlaceID>ChIJi73bYWusQjQRgqQGXK260bw</PlaceID>
     <Lat>25.0329636</Lat>
     <Lng>121.5654268</Lng>
     <Address>台北市</Address>
     */
    
    TBXMLElement *placeID = [EMTBXML childElementNamed:@"placeID" parentElement:data];
    if (placeID) {
        self.placeID = [EMTBXML textForElement:placeID];
    }
    
    TBXMLElement *lat = [EMTBXML childElementNamed:@"Lat" parentElement:data];
    if (lat) {
        self.lat = [[EMTBXML textForElement:lat] floatValue];
    }
    
    TBXMLElement *lng = [EMTBXML childElementNamed:@"Lng" parentElement:data];
    if (lng) {
        self.lng = [[EMTBXML textForElement:lng] floatValue];
    }
    
    TBXMLElement *address = [EMTBXML childElementNamed:@"Address" parentElement:data];
    if (lng) {
        self.address = [EMTBXML textForElement:address];
    }
    
    [pool release];
}

@end

