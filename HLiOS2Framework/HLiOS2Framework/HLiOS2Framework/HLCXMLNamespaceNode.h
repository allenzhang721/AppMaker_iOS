//
//  CXMLNamespaceNode.h
//  TouchXML
//

#import <Foundation/Foundation.h>
#import "HLCXMLNode.h"
#import "HLCXMLElement.h"

@interface HLCXMLNamespaceNode : HLCXMLNode {

	NSString *_prefix;
	NSString *_uri;
	HLCXMLElement *_parent;
}

- (id) initWithPrefix:(NSString *)prefix URI:(NSString *)uri parentElement:(HLCXMLElement *)parent;

@end
