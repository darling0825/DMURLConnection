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

// version 0.2 (forked for band app August 28th)

#import <Foundation/Foundation.h>

#define DEBUG_DMURLConnection 1

@protocol DMURLConnectionDelegate <NSObject>

-(void)connectionFinishedLoadingWithData:(NSMutableData *)rd;
-(void)connectionFailedWithError:(NSError *)error;

@end

#if NS_BLOCKS_AVAILABLE
typedef void (^StateChangeBlock)(id,NSError *);
#endif

@interface DMURLConnection : NSObject {
	NSMutableData *recData;
	id<DMURLConnectionDelegate> delegate;
#if NS_BLOCKS_AVAILABLE
	StateChangeBlock _stateChangeBlock;
#endif
}

@property (nonatomic, retain) id<DMURLConnectionDelegate> delegate;
@property (nonatomic, retain) NSMutableData *receivedData;
#if NS_BLOCKS_AVAILABLE
@property (nonatomic,copy) StateChangeBlock _stateChangeBlock;
+(id)connectToRequest:(NSURLRequest *)req withBlock:(StateChangeBlock)stateChanged;
#endif

+(id)connectToRequest:(NSURLRequest *)req withDelegate:(id)del;

-(void)connection:(NSURLConnection *)connection failWithCode:(NSInteger)responseCode;


// NSURLConnect delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;


@end
