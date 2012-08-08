//
//  DMURLConnection.m
//  iPhoneStreamingPlayer
//
//  Created by Cory Alder on 10-07-15.
//  Copyright 2010 Davander Mobile.
//
//  License: Any use is fine, with two caviats,
//  -If you improve on the code, share.
//  -If you use it in something that ships, let me know.
//

#import "DMURLConnection.h"


@implementation DMURLConnection

@synthesize request;
@synthesize delegate;
@synthesize receivedData;

#if NS_BLOCKS_AVAILABLE
@synthesize _stateChangeBlock;
#endif

+(id)connectToRequest:(NSURLRequest *)req withDelegate:(id)del {
	DMURLConnection *newCon = [[[self class] alloc] init];
	if (newCon) {
        newCon.request = req;
		newCon.delegate = del;
		[[NSURLConnection alloc] initWithRequest:req delegate:newCon startImmediately:YES];
	} else {
		NSError *err = [NSError errorWithDomain:@"com.davandermobile.dmurlconnection" code:101 userInfo:nil];
		if ([del respondsToSelector:@selector(connectionFailedWithError:)]) [del connectionFailedWithError:err];
	}
	return newCon;
}

#if NS_BLOCKS_AVAILABLE
+(id)connectToRequest:(NSURLRequest *)req withBlock:(StateChangeBlock)stateChanged {
	DMURLConnection *newCon = [[[self class] alloc] init];
	if (newCon) {
        newCon.request = req;
		if (stateChanged) newCon._stateChangeBlock = stateChanged;
		[[NSURLConnection alloc] initWithRequest:req delegate:newCon startImmediately:YES];
	}
	return newCon;
}
#endif

-(id)init {
	if (self = [super init]) {
		self._stateChangeBlock = nil;
		self.delegate = nil;
	}
	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSInteger responseCode = 666;
	if ([response respondsToSelector:@selector(statusCode)]) {
		responseCode = [(NSHTTPURLResponse *)response statusCode];
	}
	
	switch (responseCode) {
		case 404:
			[self connection:connection failWithCode:responseCode];
			break;
		default:
			self.receivedData = nil;
			break;
	}
}

-(void)connection:(NSURLConnection *)connection failWithCode:(NSInteger)responseCode {
	[connection cancel];
	
	NSError *err = [NSError errorWithDomain:@"com.davandermobile.dmurlconnection" code:responseCode userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"HTTP %i - %@",responseCode, [[self request] URL]] forKey:NSLocalizedDescriptionKey]];
	if ([self.delegate respondsToSelector:@selector(connectionFailedWithError:)]) [self.delegate connectionFailedWithError:err];
#if NS_BLOCKS_AVAILABLE
	_stateChangeBlock(nil,err);
#endif
	[connection release];
	[self autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (!self.receivedData) {
		self.receivedData = [[[NSMutableData alloc] initWithData:data] autorelease];
	} else {
		[self.receivedData appendData:data];
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	
#if NS_BLOCKS_AVAILABLE
	if (_stateChangeBlock) _stateChangeBlock(self.receivedData,nil);
#endif
	[delegate connectionFinishedLoadingWithData:self.receivedData];
	[connection release];
	[self autorelease];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
#if NS_BLOCKS_AVAILABLE
	if (_stateChangeBlock) {
		_stateChangeBlock(nil,error);
	}
#endif
	if ([delegate respondsToSelector:@selector(connectionFailedWithError:)]) [delegate connectionFailedWithError:error];
	[connection release];
	[self autorelease];
}

- (void) dealloc {
#if NS_BLOCKS_AVAILABLE
	if (_stateChangeBlock) {
		Block_release(_stateChangeBlock);
	}
#endif
	[receivedData release];
	self.delegate = nil;
    self.request = nil;
	[super dealloc];
}

@end
