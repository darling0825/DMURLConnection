//
//  DMURLConnection.m
//  iPhoneStreamingPlayer
//
//  Created by Cory Alder on 10-07-15.
//  Copyright 2010 Davander Mobile. All rights reserved.
//

#import "DMURLConnection.h"


@implementation DMURLConnection

@synthesize delegate;
@synthesize receivedData;

+(id)connectToRequest:(NSURLRequest *)req withDelegate:(id)del {
	DMURLConnection *newCon = [[[self class] alloc] init];
	if (newCon) {
		newCon.delegate = del;
		[[NSURLConnection alloc] initWithRequest:req delegate:newCon startImmediately:YES];
	} else {
		NSError *err = [NSError errorWithDomain:@"com.davandermobile.dmurlconnection" code:101 userInfo:nil];
		[del connectionFailedWithError:err];
	}
	return newCon;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (!self.receivedData) {
		self.receivedData = [[[NSMutableData alloc] initWithData:data] autorelease];
	} else {
		[self.receivedData appendData:data];
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[delegate connectionFinishedLoadingWithData:self.receivedData];
	[connection release];
	[self autorelease];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[delegate connectionFailedWithError:error];
	[connection release];
	[self autorelease];
}

- (void) dealloc {
	[super dealloc];
	[receivedData release];
	[delegate autorelease];
}

@end
