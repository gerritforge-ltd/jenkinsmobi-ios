//
//  BeesClientBase.h
//  HudsonMobile
//
//  Created by simone on 5/28/11.
//  Copyright 2011 LMIT ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleHTTPGetter.h"
#import "IWSDataReceiver.h"


@interface BeesClientBase : NSObject {
 
    NSString* format;
	NSString* serverApiUrl;
	NSString* api_key;
	NSString* secret;
	NSString* version;
	NSString* sigVersion;
}

-(id)initWithApiUrl:(NSString*)_serverApiUrl andApiKey:(NSString*)_apiKey andSecret:(NSString*)_secret andFormat:(NSString*)_format andVersion:(NSString*)_version;

-(NSString*) getRequestUrl:(NSString*) method andMethodParams:(NSDictionary*)params;

-(NSDictionary*) defaultParameters;
-(NSString*) apiUrl:(NSString*) method;
-(NSString*) calculateSignature:(NSDictionary*) entries;
-(NSString*) getSignature:(NSString*) data :(NSString*) secret;
-(NSString*) md5:(NSString*) message;
-(void) executeRequest:(NSString*) url withReceiver:(id<IWSDataReceiver>)dateReceiver;
-(NSString*) calculateSignature:(NSDictionary*) entries;

@end
