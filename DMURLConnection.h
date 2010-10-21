//
//  DMURLConnection.h
//  iPhoneStreamingPlayer
//
//  Created by Cory Alder on 10-07-15.
//  Copyright 2010 Davander Mobile.
//
//  License: Any use is fine, with two caviats,
//  -If you improve on the code, share.
//  -If you use it in something that ships, let me know.
//

// version 0.1 (forked for band app August 28th)

#import <Foundation/Foundation.h>

@protocol DMURLConnectionDelegate <NSObject>

-(void)connectionFinishedLoadingWithData:(NSMutableData *)rd;
-(void)connectionFailedWithError:(NSError *)error;

@end


@interface DMURLConnection : NSObject {
	NSMutableData *recData;
	id<DMURLConnectionDelegate> delegate;
}

@property (nonatomic, retain) id<DMURLConnectionDelegate> delegate;
@property (nonatomic, retain) NSMutableData *receivedData;

+(id)connectToRequest:(NSURLRequest *)req withDelegate:(id)del;

// NSURLConnect delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;


@end
