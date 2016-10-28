//
//  HLRequest.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLRequest.h"
#import "EMTBXML.h"

@implementation HLRequest {

}

/*
 <URLRequest>
 <RequestHeader>http://</RequestHeader>
 <RequestURL>cta.curiosapp.com/publish/newPublishList</RequestURL>
 <RequestType>POST</RequestType>
 <ResponseType>JSON</ResponseType>
 <RequestParameters>
   <RequestParameter>
   <ParamName><![CDATA[data]]></ParamName>
   <ParamValue><![CDATA[{"userID":"","start":0,"size":10}]]></ParamValue>
   <Color><![CDATA[4408131]]></Color>
   <Type><![CDATA[Edit]]></Type>
   </RequestParameter>
 </RequestParameters>
 <RequestHeaderParameters/>
 </URLRequest>
 */


- (void) decodeXML:(TBXMLElement *)xml {
  
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  /*
   <PlaceID>ChIJi73bYWusQjQRgqQGXK260bw</PlaceID>
   <Lat>25.0329636</Lat>
   <Lng>121.5654268</Lng>
   <Address>台北市</Address>
   */
  
  TBXMLElement *header = [EMTBXML childElementNamed:@"RequestHeader" parentElement:xml];
  if (header) {
    self.header = [EMTBXML textForElement:header];
  }
  
  TBXMLElement *url = [EMTBXML childElementNamed:@"RequestURL" parentElement:xml];
  if (url) {
    self.url = [EMTBXML textForElement:url];
  }
  
  TBXMLElement *requestType = [EMTBXML childElementNamed:@"RequestMethod" parentElement:xml];
  if (requestType) {
    self.requestType = [EMTBXML textForElement:requestType];
  }
  
  TBXMLElement *responseType = [EMTBXML childElementNamed:@"ResponseType" parentElement:xml];
  if (responseType) {
    self.responseType = [EMTBXML textForElement:responseType];
  }
  
  NSMutableArray<NSDictionary<NSString *, NSString *> *> *paras = [@[] mutableCopy];
  
  TBXMLElement *parameters = [EMTBXML childElementNamed:@"RequestParameters" parentElement:xml];
  TBXMLElement *parameter = [EMTBXML childElementNamed:@"RequestParameter" parentElement:parameters];
  
  while (parameter != nil) {
    
    NSMutableDictionary<NSString *, NSString *> *para = [@{} mutableCopy];
    
    TBXMLElement *paraName = [EMTBXML childElementNamed:@"ParamName" parentElement:parameter];
    TBXMLElement *paramValue = [EMTBXML childElementNamed:@"ParamValue" parentElement:parameter];
    if (paraName != nil && paramValue != nil) {
      NSString *n = [EMTBXML textForElement:paraName];
      NSString *v = [EMTBXML textForElement:paramValue];
      
      [para setObject:v forKey:n];
      [paras addObject:para];
    }
    parameter = [EMTBXML nextSiblingNamed:@"RequestParameter" searchFromElement:parameter];
  }
  
  _parameters = paras;
  
  
  [pool release];
  
}

@end
