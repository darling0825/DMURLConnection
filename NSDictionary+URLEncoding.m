//
//  NSDictionary+URLEncoding.m
//  EthicalBean
//
//  Created by Cory Alder on 10-09-07.
//  Copyright 2010 Ethical Bean Coffee Company. All rights reserved.
//

#import "NSDictionary+UrlEncoding.h"

// NOTE: dictionaries can't be multi-level deep. Dictionaries withen dictionaries get mangled.

// helper function: get the string form of any object
static NSString *toString(id object) {
	return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object) {
	NSString *string = toString(object);
	return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}


@implementation NSDictionary (URLEncoding)

-(NSString*) urlEncodedString {
	NSMutableArray *parts = [NSMutableArray array];
	for (id key in self) {
		id value = [self objectForKey: key];
		NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];
}

-(NSData *)urlEncodedDataUTF8 {
	return [[self urlEncodedString] dataUsingEncoding:NSUTF8StringEncoding];
}

@end