//
//  HLMapComponent.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 27/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLMapComponent.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@implementation HLMapComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.entity    = (HLMapEntity *)entity;
        //        self.customHeight = true;
        [self p_setupUI];
    }
    return self;
}

// MARK: - Private Method
- (void)p_setupUI {
    
    MKMapView *v = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, _entity.width.floatValue, _entity.height.floatValue)];
    self.uicomponent = v;
    
    
    
    /*
     let center = CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074)
     let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
     let region = MKCoordinateRegion(center: center, span: span)
     mapView.setRegion(region, animated: true)
     
     
     let annotion = MKPointAnnotation()
     annotion.coordinate = center
     mapView.addAnnotation(annotion)
     */
    
    CLLocationCoordinate2D c = CLLocationCoordinate2DMake(_entity.lat, _entity.lng);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(c, span);
    [v setRegion:region];
    
    MKPointAnnotation *annotation0 = [[MKPointAnnotation alloc] init];
    [annotation0 setCoordinate:CLLocationCoordinate2DMake(_entity.lat, _entity.lng)];
    [annotation0 setTitle:_entity.address];
    annotation0.coordinate = c;
    [v addAnnotation:annotation0];
    
}

- (void)dealloc
{
    [self.entity release];
    [self.uicomponent removeFromSuperview]; //陈星宇，11.4
    [self.uicomponent release];
    
    [super dealloc];
}

@end
