//
//  HLRequest.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 25/10/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMTBXML.h"

@interface HLRequest : NSObject

@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *requestType;
@property (nonatomic, strong) NSString *responseType;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *parameters;



- (void) decodeXML:(TBXMLElement *)xml;

- (void)resume;
- (void)cancel;

@end
