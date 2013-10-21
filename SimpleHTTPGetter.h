// Copyright (C) 2012 LMIT Limited
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License.

#import <Foundation/Foundation.h>
#import "IWSDataReceiver.h"
#import "B64Encoder.h"
#import "Logger.h"

#define GET_REQUEST 0
#define POST_REQUEST 1
#define GET_REQUEST_NO_AUTH 2
#define POST_REQUEST_NO_AUTH 3

@interface SimpleHTTPGetter : NSObject {

	NSMutableData* receivedData;
	id<IWSDataReceiver> receiver;
	bool checkOnlyStatusCode;
	bool authChallengeAlreadyReceived;
	bool forceNotUseCredentials;
	bool receiveingData;
    bool ignore404Error;
	NSURLConnection* currentConnection;
	NSTimer* timeoutTimer;
	NSString* normalizedUrl;
    NSHTTPCookie* lastReceivedHttpCookie;
    NSDictionary* allHeaderFields;
}

@property (nonatomic,retain) NSMutableData* receivedData;
@property (nonatomic,retain) id<IWSDataReceiver> receiver;
@property (nonatomic,retain) NSDictionary* allHeaderFields;
@property (assign) bool checkOnlyStatusCode;
@property (assign) bool forceNotUseCredentials;
@property (assign) bool ignore404Error;

+(int)getLastHttpStatusCode;

+(NSString*)getLastHttpStatusMsg;

-(BOOL)isHostAlive:(NSString*)host;

- (NSUInteger) httpGET:(NSString*)url:(id <IWSDataReceiver>)caller;

- (NSUInteger) httpPOST:(NSString*)url:(id <IWSDataReceiver>) caller andParams:(NSString*)params;

- (NSUInteger) httpPOST:(NSString*)url withUsername:(NSString*)user andPassword:(NSString*)password andDataReceiver:(id <IWSDataReceiver>) caller andParams:(NSString*)params;

- (NSUInteger) httpGETNoAuth:(NSString*)url:(id <IWSDataReceiver>)caller;

- (NSUInteger) httpPOSTNoAuth:(NSString*)url:(id <IWSDataReceiver>) caller andParams:(NSString*)params;

- (NSUInteger) httpGET:(NSString*)url withUsername:(NSString*)user andPassword:(NSString*)password andDataReceiver:(id <IWSDataReceiver>) caller;

- (NSUInteger) httpGET:(NSString*)url withUsername:(NSString*)user andPassword:(NSString*)password andDataReceiver:(id <IWSDataReceiver>) caller andHeaders:(NSDictionary*)headers;

- (NSUInteger) httpGenericRequest:(int)reqType toURL:(NSString*)url withUsername:(NSString*)user andPassword:(NSString*)password andParams:(NSString*)params  andHeaders:(NSDictionary*)headers andDataReceiver:(id <IWSDataReceiver>) caller;

-(void)cancelConnecton:(NSURLConnection*)connection;

-(void)stop;

@end
