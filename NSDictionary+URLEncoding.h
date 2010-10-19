//
//  NSDictionary+URLEncoding.h
//  EthicalBean
//
//  Created by Cory Alder on 10-09-07.
//  Copyright 2010 Ethical Bean Coffee Company. All rights reserved.
//

#import <Foundation/Foundation.h>

// file "NSDictionary+UrlEncoding.h"

@interface NSDictionary (URLEncoding)

-(NSString*)urlEncodedString;
-(NSData *)urlEncodedDataUTF8;

@end