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
  
  NSString *_header;
  NSString *_url;
  NSString *_requestType;
  NSString *_responseType;
  NSArray<NSDictionary<NSString *, NSString *> *> *_parameters;
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
    _header = [EMTBXML textForElement:header];
  }
  
  TBXMLElement *url = [EMTBXML childElementNamed:@"RequestURL" parentElement:xml];
  if (url) {
    _url = [EMTBXML textForElement:url];
  }
  
  TBXMLElement *requestType = [EMTBXML childElementNamed:@"RequestType" parentElement:xml];
  if (requestType) {
    _requestType = [EMTBXML textForElement:requestType];
  }
  
  TBXMLElement *responseType = [EMTBXML childElementNamed:@"ResponseType" parentElement:xml];
  if (responseType) {
    _responseType = [EMTBXML textForElement:responseType];
  }
  
  [pool release];
  
}

@end
